Room = Class{}

function Room:init(def, world)
    self.world = world
    self.map = STI(def.map)
    self.background = def.background
    self.connectedRooms = def.connectedRooms
    self.spawnX = def.spawnX
    self.spawnY = def.spawnY
    self.collidable = {}
    self:addCollision()
    self.player = nil
    self.flame = nil

    self.def = def
    self.enemies = {}
    self.objects = {}
    self.attacks = {}
end

function Room:spawnEnemies()
    if self.def.enemies then
        for _, roomDefEnemy in pairs(self.def.enemies) do
            local enemyDef = ENTITY_DEFS[roomDefEnemy.type]
            local enemy = Entity(enemyDef, self.world, roomDefEnemy.spawnX, roomDefEnemy.spawnY, self)

            enemy.stateMachine = StateMachine {
                ['idle'] = function() return EntityIdleState(enemy) end,
                ['walk'] = function() return EntityWalkState(enemy) end,
                ['chase'] = function() return EnemyChaseState(enemy) end,
                ['attack'] = function() return EnemyAttackState(enemy) end
            }
            enemy:changeState('idle')
            enemy.fixture:setUserData({type='enemy', entity = enemy})


            table.insert(self.enemies, enemy)
        end
    end
end

function Room:spawnObjects()
    if self.def.objects then
        for _, defObject in pairs(self.def.objects) do
            local roomObject = Torch(OBJECT_DEFS[defObject.type], self.world, defObject.spawnX, defObject.spawnY)
        
            if defObject.type == 'torch' then
                roomObject.stateMachine = StateMachine {
                    ['unlit'] = function() return TorchUnlitState(roomObject) end,
                    ['lit'] = function() return TorchLitState(roomObject) end
                }
                roomObject:changeState('unlit')
            end
            table.insert(self.objects, roomObject)
        end
    end
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
    end
end

function Room:exit()

    for _, tile in pairs(self.collidable) do
        tile.body:setActive(false)
    end

    for _, enemy in pairs(self.enemies) do
        enemy.body:setActive(false)
    end

    self.player = nil
end

function Room:update(dt)
    for i=#self.attacks,1,-1 do
        local attack = self.attacks[i]
        attack:update(dt)
        if attack.complete then
            table.remove(self.attacks, i)
        end
    end

    for _,o in pairs(self.objects) do
        o:update(dt)
    end
end

function Room:addCollision()
    local collisionLayers = {
        ['collision-ground'] = 'ground',
        ['collision-wall'] = 'wall',
        ['collision-ceiling'] = 'ceiling'
    }
    for name, collisionType in pairs(collisionLayers) do
        local layer = self.map.layers[name]
        if layer then
            for y = 1, self.map.height do
                for x = 1, self.map.width do
                    local tile = layer.data[y][x]
                    if tile and tile ~= 0 then
                        local body = love.physics.newBody(self.world, (x-1)*TILE_SIZE+ TILE_SIZE/2,(y-1)*TILE_SIZE + TILE_SIZE/2, 'static')
                        body:setActive(false)
                        local shape = love.physics.newRectangleShape(TILE_SIZE, TILE_SIZE)
                        local fixture = love.physics.newFixture(body, shape)
                        fixture:setRestitution(0)
                        fixture:setFriction(0)
                        fixture:setUserData({type=collisionType})
                        table.insert(self.collidable, {body=body,shape=shape})
                    end
                end
            end
        end
    end
end

function Room:render()

    self:renderBackground()
    if self.player then
        self.player:render()
    end
    if self.flame then
        self.flame:render()
    end
    for _, enemy in pairs(self.enemies) do
        enemy:render()
    end

    for _,attack in pairs(self.attacks) do
        attack:render()
    end

    for _, object in pairs(self.objects) do
        object:render()
    end
    self:renderForeground()
    self:renderDarkness()
end

function Room:renderDarkness()
    love.graphics.stencil(function()
        for _, object in pairs(self.objects) do
            if object.lit then
                local tx, ty = object.body:getPosition()
                love.graphics.setColor(0,0,0,0)
                love.graphics.circle('fill', tx, ty, object.lightRadius)  -- light radius
            end
        end
    end)

    love.graphics.setStencilTest('notequal', 1)
    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
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