Object = Class{}

function Object:init(def, world, x, y)
    self.def = def
    self.type = def.type
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.texture = def.texture

    -- create entity body
    self.bodyType = def.bodyType or 'static'
    self.body = love.physics.newBody(world, x, y, self.bodyType)
    self.body:setFixedRotation(true)

    -- setting circle shape, rectangle doesn't detect the ground
    self.shape = love.physics.newCircleShape(math.max(self.width/2, self.height/2))
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(0)
    self.fixture:setFriction(1)
    self.fixture:setCategory(def.category)

end

function Object:update(dt)
end

function Object:render()
    local x, y = self.body:getPosition()
    -- ? debug rectangle
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line',x-self.width/2, y - self.height/2, self.width, self.height)

    love.graphics.draw(
        gTextures[def.texture],
        quad,
        math.floor(self.x),
        math.floor(self.y) + self.height/2,
        0,
        1,
        self.width / 2,
        self.height)
end