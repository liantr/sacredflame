Player = Class{__includes=Entity}

function Player:init(def, world, startX, startY)
    Entity.init(self, def, world, startX, startY)
    self.runSpeed = def.runSpeed
    self.timesDied = 0
    self.fixture:setUserData({type = 'player', entity = self})
    if DEBUG then
        self.doubleJumpAllowed = true
        self.wallHoldAllowed = true
        self.attackComboAllowed = true
    else
        self.wallHoldAllowed = false
        self.doubleJumpAllowed = false
        self.attackComboAllowed = false
    end

    -- jump related variables
    self.canJump = true
    self.timesJumped = 0

    -- wall hold related variables
    self.canHoldWall = true
    self.touchingWall = false
    self.wallX = nil

    self.dashing = false
    self:createParticleSystem()
end

--[[
    Called when the player collides with an enemy's Box2D box
]]
function Player:takeDamage()
    if self.health > 0 and not self.invulnerable then
        self:damage(1)
        self:goInvulnerable(1.5)
        gSounds['hit-player']:play()
        return true
    end

    return false
end

--[[
    Damages the player when colliding with an enemy's hit box
]]
function Player:takeDamageFromEnemyHitBox(hitBox)
    if self:collides(hitBox) and self.health > 0 and not self.invulnerable then
        self:damage(1)
        self:goInvulnerable(1.5)
        gSounds['hit-player']:play()
        return true
    end

    return false
end

function Player:update(dt)
    Entity.update(self, dt)
    local x, y = self.body:getPosition()
    self.particleSystem:setPosition(x, y)
    self.particleSystem:update(dt)
end

function Player:gainHealthFromEnemy()
    self.healthRestored = true
    self:emitParticles()
    self.health = self.health + 1
end

--[[
    Applies movement to the player based on user input
]]
function Player:handleMovementInput(speed)
    local _, yVel = self.body:getLinearVelocity()
    if love.keyboard.isDown('left')then
        self.direction = 'left'
        self.body:setLinearVelocity(-speed, yVel)
        return true
    elseif love.keyboard.isDown("right") then
        self.direction = 'right'
        self.body:setLinearVelocity(speed, yVel)
        return true
    end

    return false
end

--[[
    Transitions player to wall hold state if touching and facing a wall
]]
function Player:grabWall()
    if self.touchingWall and
        self.canHoldWall and
        self.wallHoldAllowed and
        (love.keyboard.isDown('left') or love.keyboard.isDown('right')) then
            local playerX, _ = self.body:getPosition()
            local playerFacingWall = (self.wallX > playerX and self.direction == 'right')
                or (self.wallX < playerX and self.direction == 'left')
                if playerFacingWall then
                    self:changeState('wall-hold')
                end
    end
end

function Player:createParticleSystem()
    self.particleSystem = love.graphics.newParticleSystem(gTextures['particle'], 60)
    self.particleSystem:setParticleLifetime(0.3, 0.6)
    self.particleSystem:setRadialAcceleration(-20, 20)
    self.particleSystem:setLinearAcceleration(-20, -60, 20, -20)
    self.particleSystem:setEmissionArea('borderellipse', self.width/2, self.height/2)
    self.particleSystem:setEmissionRate(20)
    self.particleSystem:setSizes(0.5, 0)
    self.particleSystem:setColors(1,1,1,1)
end

function Player:emitParticles()
    -- emits particles while powered up
    self.particleSystem:start()
    Timer.after(3, function()
        self.particleSystem:stop()
        self.healthRestored = false
    end)
end


function Player:render()
    Entity.render(self)

    local x, y = self.body:getPosition()

    if self.healthRestored then
        love.graphics.draw(self.particleSystem)
    end
    
    love.graphics.setColor(1, 1, 0.9, 0.05)
    love.graphics.circle('fill', math.floor(x), math.floor(y), self.width * 4)
    love.graphics.setColor(1, 1, 1, 1)
end