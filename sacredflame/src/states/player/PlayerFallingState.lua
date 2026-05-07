PlayerFallingState = Class{__includes = BaseState}

function PlayerFallingState:init(player)
    self.player = player
end

function PlayerFallingState:enter()
    self.player:changeAnimation('falling')
    self.player.canJump = self.player.doubleJumpAllowed and
        (self.player.timesJumped < 2 and true or false) or false
    self.player.canHoldWall = true
end

function PlayerFallingState:update(dt)

    local _, yVel = self.player.body:getLinearVelocity()
    self.player:handleMovementInput(PLAYER_WALK_SPEED)

    if self:scanForGroundBelow(dt)  or yVel == 0 then
        self.player:changeState('idle')
    end

    self.player:grabWall()

    if love.keyboard.wasPressed('z') and self.player.canJump then
        self.player:changeState('jump')
    elseif love.keyboard.wasPressed('v') then
        self.player:changeState('dash', {nextState='falling'})
    elseif love.keyboard.wasPressed('x') then
        self.player:changeState('swing-sword')
    end
end

function PlayerFallingState:scanForGroundBelow(dt)
    local world = self.player.body:getWorld()

    local rayHeight = self.player.height / 2 + 2

    local ex, ey = self.player.body:getPosition()

    -- from the center of the body
    local x1 = ex
    local y1 = ey

    local x2 = x1
    local y2 = y1 + rayHeight  -- into ground


    local groundDetected = false

    world:rayCast(x1, y1, x2, y2, function(fixture, x, y, xn, yn, fraction)

        if fixture:getUserData().type == 'ground' then
            groundDetected = true
            return 0
        end
        return 1
    end)


    return groundDetected
end