Entity = Class{}

function Entity:init(def, world, startX, startY,room)
    self.room = room
    -- dimensions
    self.width = def.width
    self.height = def.height

    self.hitBoxes = def.hitBoxes

    self.category = def.category

    -- create entity body (this is the hurt box)
    self.bodyType = def.bodyType or 'static'
    self.body = love.physics.newBody(world, startX, startY, self.bodyType)
    self.body:setFixedRotation(true)
    -- setting circle shape, rectangle doesn't detect the ground
    self.shape = love.physics.newRectangleShape(self.width, self.height)
    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setRestitution(0)
    self.fixture:setFriction(0)
    self.fixture:setCategory(def.category)

    self.animations = createAnimations(def.animations)
    self.moveSpeed = def.moveSpeed
    self.chaseSpeed = def.chaseSpeed or self.moveSpeed
    self.attackDistance = def.attackDistance or 0
    self.rangedAttack = def.rangedAttack
    
    self.direction = 'right'

    self.dead = false
    self.health = def.health
    self.canAttack = true

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

function Entity:damage()
    self.health = self.health - 1
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

    if self.health == 0 and not self.dead then
        self:changeState('death')
    end
end

function Entity:collides(hitBox)
    local x, y = self.body:getPosition()
    local ex = x - self.width/2
    local ey = y - self.height/2
    return not (ex > hitBox.x + hitBox.width or hitBox.x > ex + self.width or
                ey > hitBox.y + hitBox.height or hitBox.y > ey + self.height)
end

function Entity:processAI(params, dt)
    self.stateMachine:processAI(params, dt)
end

function Entity:spawnRangedAttack(targetX, targetY)
    if self.rangedAttack then
        local attack = VolleyAttack(targetX, targetY, self.room)
        table.insert(self.room.attacks, attack)
    end
end

function Entity:render()

    local x, y = self:getPosition()
    if self.dashing then
        x, y = self:getPosition()
    end

    self.stateMachine:render()

    -- ? debug rectangle
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line',x-self.width/2, y - self.height/2, self.width, self.height)
    if self.currentAnimation then
        local texture = self.currentAnimation.texture
        local frame = self.currentAnimation:getCurrentFrame()
        local animOffsetX = self.direction == 'right' and self.currentAnimation.offsetX or -self.currentAnimation.offsetX
        local animOffsetY = self.currentAnimation.offsetY

        local quad = gFrames[texture][frame]
        local _, _, w, h = quad:getViewport()

        -- draw sprite slightly transparent if invulnerable every 0.1 seconds
        if self.invulnerable and self.flashTimer > 0.1 then
            self.flashTimer = 0
            love.graphics.setColor(1, 1, 1, 64/255)
        end

        love.graphics.draw(
            gTextures[texture],
            quad,
            math.floor(x) + animOffsetX,
            math.floor(y) + self.height/2 + animOffsetY,
            0,
            self.direction == 'right' and 1 or -1, 1,
            w / 2,
            h)
    end
end

function Entity:getPosition()
    return self.body:getPosition()
end

function  Entity:reverseDirection()
    self.direction = self.direction == 'right' and 'left' or 'right'
end