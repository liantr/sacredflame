Room = Class{}

function Room:init(def, world, playState, name)
    self.playState = playState
    self.world = world
    self.map = STI(def.map)
    self.background = def.background
    self.connectedRooms = def.connectedRooms
    self.spawnX = def.spawnX
    self.spawnY = def.spawnY
    self.collidable = {}
    self:addCollisionBodies()
    self.player = nil
    self.flame = nil
    self.name = name
    self.music = def.music

    self.def = def
    self.enemies = {}
    self.objects = {}
    self.attacks = {}
end

function Room:enter()
    for _, tile in pairs(self.collidable) do
        tile.body:setActive(true)
    end

    if #self.enemies == 0 then
        self:spawnEnemies()
    else
        for _, enemy in pairs(self.enemies) do
            enemy.body:setActive(true)
        end
    end

    if #self.objects == 0 then
        self:spawnObjects()
    else
         for _, object in pairs(self.objects) do
            object.body:setActive(true)
        end
    end
end

function Room:exit()

    for _, tile in pairs(self.collidable) do
        tile.body:setActive(false)
    end

    for _, enemy in pairs(self.enemies) do
        enemy.body:setActive(false)
    end

    for _, object in pairs(self.objects) do
        object.body:setActive(false)
    end

    self.player = nil
end

function Room:spawnEnemies()
    if self.def.enemies then
        for _, roomDefEnemy in pairs(self.def.enemies) do
            local enemyDef = ENTITY_DEFS[roomDefEnemy.type]
            local enemy
            if roomDefEnemy.type ~= 'boss' then
                enemy = Entity(enemyDef, self.world, roomDefEnemy.spawnX, roomDefEnemy.spawnY, self)
                enemy.stateMachine = StateMachine {
                    ['idle'] = function() return EntityIdleState(enemy) end,
                    ['walk'] = function() return EntityWalkState(enemy) end,
                    ['chase'] = function() return EnemyChaseState(enemy) end,
                    ['attack'] = function() return EnemyAttackState(enemy) end,
                    ['death'] = function() return EnemyDeathState(enemy) end
                }
                enemy.fixture:setUserData({type='enemy', entity = enemy})
                enemy:changeState('idle')
            end
            table.insert(self.enemies, enemy)
        end
    end
end

function Room:spawnBoss()
    if self.def.boss then
        local bossDef = ENTITY_DEFS['boss']
        local boss = Boss(bossDef, self.world, self.def.boss.spawnX, self.def.boss.spawnY, self)
        boss.stateMachine = StateMachine {
            ['idle'] = function() return BossIdleState(boss) end,
            ['walk'] = function() return BossWalkState(boss) end,
            ['chase'] = function() return BossChaseState(boss, self) end,
            ['attack1'] = function() return BossAttackState(boss) end,
            ['attack2'] = function() return BossAttackState(boss) end,
            ['attack3'] = function() return BossAttackState(boss) end,
            ['appear'] = function() return BossAppearState(boss, self) end,
            ['disappear'] = function() return BossDisappearState(boss) end,
            ['death'] = function() return EnemyDeathState(boss) end
        }
        boss.fixture:setUserData({type='boss', entity = boss})
        boss.body:setActive(true)
        boss:changeState('appear')
        table.insert(self.enemies, boss)
    end
end

function Room:spawnObjects()
    if self.def.objects then
        for _, roomObjectDef in pairs(self.def.objects) do
            local object
            local objectDef = OBJECT_DEFS[roomObjectDef.type]
            if objectDef.type == 'torch' then
                object = Torch(objectDef, self.world, roomObjectDef.spawnX, roomObjectDef.spawnY, self)
                object.stateMachine = StateMachine {
                    ['unlit'] = function() return TorchUnlitState(object) end,
                    ['lit'] = function() return TorchLitState(object) end
                }
                object:changeState('unlit')
            elseif objectDef.type == 'powerup' then
                object = Powerup(objectDef, self.world, roomObjectDef.spawnX, roomObjectDef.spawnY, self)
            elseif objectDef.type == 'door' then
                object = Door(objectDef, self.world, roomObjectDef.spawnX, roomObjectDef.spawnY, self)
                object.stateMachine = StateMachine {
                    ['closed'] = function() return DoorClosedState(object) end,
                    ['open'] = function() return DoorOpenState(object) end
                }
                object:changeState('closed')
            end

            table.insert(self.objects, object)
        end
    end
end

--[[
    Each map has a collisions layer with types: ground, wall and ceiling.
    These are created as static Box2D bodies.
]]
function Room:addCollisionBodies()
    local layer = self.map.layers["collisions"]

    if layer and layer.objects then
        for _, object in pairs(layer.objects) do

            -- ignore objects with no type assigned 
            if object.type ~= "" then
                local bodyX = object.x + ( object.width / 2)
                local bodyY = object.y + ( object.height / 2)

                local body = love.physics.newBody(self.world, bodyX, bodyY, 'static')

                -- start as inactive until the room is entered otherwise
                -- bodies from other rooms the player isn't currently in will be collidable
                body:setActive(false)

                local shape = love.physics.newRectangleShape(object.width, object.height)
                local fixture = love.physics.newFixture(body, shape)
                fixture:setRestitution(0)
                fixture:setFriction(2)
                fixture:setUserData({type=object.type})
                table.insert(self.collidable, {
                    body = body,
                    shape = shape
                })
            end
        end
    end
end

function Room:update(dt)
    for i = #self.attacks, 1, -1 do
        local attack = self.attacks[i]
        attack:update(dt)
        if attack.complete then
            table.remove(self.attacks, i)
        end
    end

    for i = #self.objects, 1, -1 do
        local o = self.objects[i]
        if o.consumed then
            o.body:destroy()
            table.remove(self.objects, i)
        else
            o:update(dt)
        end
    end

    for i = #self.enemies, 1, -1  do
        local enemy = self.enemies[i]
        if enemy.dead then
            enemy.body:destroy()
            table.remove(self.enemies, i)
        end
    end
end

function Room:render()

    self:renderBackground()

    if self.flame then
        self.flame:render()
    end
    for _, enemy in pairs(self.enemies) do
        enemy:render()
    end

    for _,attack in pairs(self.attacks) do
        attack:render()
    end

    if self.player then
        self.player:render()
    end

    self:renderForeground()

    for _, object in pairs(self.objects) do
        object:render()
    end

    self:renderDarkness()

    if DEBUG then
        love.graphics.setColor(1, 0, 0, 1) -- Red outline
        love.graphics.setLineWidth(1)
        for _,o in pairs(self.collidable) do
            love.graphics.polygon('line', o.body:getWorldPoints(o.shape:getPoints()))
        end
        love.graphics.setColor(1,1,1,1)
    end
end

--[[
    Creates a darkness overlay on the screen.
    Once the room torch is lit, the stencil will punch a hole in the darkness
    the size of the current light radius which is expanding effectively lighting the room
]]
function Room:renderDarkness()
    love.graphics.stencil(function()
        for _, object in pairs(self.objects) do
            if object.lit then
                local tx, ty = object.body:getPosition()
                love.graphics.setColor(0, 0 ,0, 0)
                love.graphics.circle('fill', tx, ty, object.lightRadius)
            end
        end
    end)

    love.graphics.setStencilTest('notequal', 1)
    love.graphics.setColor(0, 0, 0, 0.4) -- TODO 0..07 TODO

    local w = self.map.width * TILE_SIZE
    local h = self.map.height * TILE_SIZE
    love.graphics.rectangle('fill', 0, 0, w, h)
    love.graphics.setStencilTest()
    love.graphics.setColor(1, 1, 1, 1)
end

function Room:renderForeground()
    if self.map.layers['foreground'] then
        self.map:drawLayer(self.map.layers['foreground'])
    end
end

function Room:renderBackground()
    if self.map.layers['background'] then
        self.map:drawLayer(self.map.layers['background'])
    end

    if self.map.layers['midground'] then
        self.map:drawLayer(self.map.layers['midground'])
    end
end