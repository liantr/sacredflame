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