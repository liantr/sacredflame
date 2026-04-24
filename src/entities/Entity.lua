Entity = Class{}

function Entity:init(def, world, startX, startY, bodyType)

    -- dimensions
    self.width = def.width
    self.height = def.height

    -- create entity body
    self.body = love.physics.newBody(world, startX, startY, bodyType)
    self.body:setFixedRotation(true)
    self.shape = love.physics.newCircleShape(math.max(self.width/2, self.height/2))
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(0)
    self.fixture:setFriction(0)

    self.animations = createAnimations(def.animations)
    self.moveSpeed = def.moveSpeed

    self.direction = 'right'

    self.dead = false
    self.health = def.health

    -- flags for flashing the entity when hit
    self.invulnerable = false
    self.invulnerableDuration = 0
    self.invulnerableTimer = 0

    -- timer for turning transparency on and off, flashing
    self.flashTimer = 0
end

function Entity:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Entity:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Entity:damage(dmg)
    self.health = self.health - dmg
end

function Entity:goInvulnerable(duration)
    self.invulnerable = true
    self.invulnerableDuration = duration
end

function Entity:update(dt)
    if self.invulnerable then
        self.flashTimer = self.flashTimer + dt
        self.invulnerableTimer = self.invulnerableTimer + dt

        if self.invulnerableTimer > self.invulnerableDuration then
            self.invulnerable = false
            self.invulnerableTimer = 0
            self.invulnerableDuration = 0
            self.flashTimer = 0
        end
    end

    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

function Entity:collides(entity)
    local x, y = self.body:getPosition()
    local entityX, entityY = entity.body:getPosition()
    return not (x > entityX + entity.width or entityX > x + self.width or
                y > entityY + entity.height or entityY > y + self.height)
end

-- function Entity:processAI(params, dt)
--     self.stateMachine:processAI(params, dt)
-- end

function Entity:render()

    local x, y = self:getPosition()

    -- ? debug rectangle
    love.graphics.setColor(1,1,1,1)
    love.graphics.circle('line', x, y, self.shape:getRadius())

    if self.currentAnimation then
        local texture = self.currentAnimation.texture
        love.graphics.draw(gTextures[texture], gFrames[texture][self.currentAnimation:getCurrentFrame()],
            math.floor(x), math.floor(y) + (self.offsetY or 0),
            0, self.direction == 'right' and 1 or -1, 1,
            TILE_SIZE / 2, TILE_SIZE / 2)
    end
end

function Entity:getPosition()
    return self.body:getPosition()
end