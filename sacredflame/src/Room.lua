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
end

function Room:spawnEnemies()
    assert(self.def.enemies, "Room enemies is nil!")
    for _, enemy in pairs(self.def.enemies) do
        local enemyDef = ENTITY_DEFS[enemy.type]
        local enemy = Entity(enemyDef, self.world, enemy.spawnX, enemy.spawnY, enemyDef.bodyType)

        enemy.stateMachine = StateMachine {
            ['idle'] = function() return EntityIdleState(enemy) end,
            ['walk'] = function() return EntityWalkState(enemy) end
        }
        enemy:changeState('idle')

        enemy.fixture:setMask(PLAYER_CATEGORY)
        enemy.fixture:setUserData({type='enemy', entity = enemy})

        table.insert(self.enemies, enemy)
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

    self:renderForeground()
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