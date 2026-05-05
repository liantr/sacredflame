Object = Class{}

function Object:init(def, world, x, y)
    self.def = def
    self.type = def.type
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.texture = def.texture

    -- create body
    self.bodyType = def.bodyType or 'static'
    self.body = love.physics.newBody(world, x, y, self.bodyType)
    self.body:setFixedRotation(true)

    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(0)
    self.fixture:setFriction(1)
    self.fixture:setCategory(def.category)
end

function Object:update(dt)
end

function Object:render()
    local x, y = self.body:getPosition()

    if DEBUG then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle(
            'line',
            x - self.width / 2,
            y - self.height / 2,
            self.width,
            self.height)
    end

    -- fallback to frame 1 is no animation is active
    local frame = self.currentAnimation and self.currentAnimation:getCurrentFrame() or 1

    love.graphics.draw(
        gTextures[self.texture],
        gFrames[self.texture][frame],
        math.floor(x),
        math.floor(y) + self.height / 2,
        0,
        1,
        1,
        self.width / 2,
        self.height)
end