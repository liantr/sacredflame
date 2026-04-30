PlayerFallingState = Class{__includes = BaseState}

function PlayerFallingState:init(player)
    self.player = player
end

function PlayerFallingState:enter()
    self.player:changeAnimation('falling')
    self.player.canJump = self.player.doubleJumpAllowed and (self.player.timesJumped < 2 and true or false) or false
        print("can jump fall state: " ..tostring(self.player.timesJumped))

    self.player.canHoldWall = true
end

function PlayerFallingState:update(dt)
    local _, yVel = self.player.body:getLinearVelocity()

    handleMovementInput(self.player, PLAYER_WALK_SPEED)

    if self:scanForGroundBelow(dt) then
        self.player:changeState('idle')
    end

    if love.keyboard.wasPressed('space') and self.player.canJump then
        self.player:changeState('jump')
    elseif love.keyboard.wasPressed('x') then
        self.player:changeState('dash', {nextState='falling'})
    elseif love.keyboard.wasPressed('s') then
        if love.keyboard.isDown('down') then
            self.player:changeState('swing-sword',{downStrike = true})
        else
            self.player:changeState('swing-sword')
        end
    end
end

function PlayerFallingState:scanForGroundBelow(dt)
    local world = self.player.body:getWorld()

    local rayHeight = self.player.height + 1

    local ex, ey = self.player.body:getPosition()

    local x1 = ex
    local y1 = ey - self.player.height/2 -- top of body

    local x2 = x1
    local y2 = y1 + rayHeight  -- into ground


    local groundDetected = false

    world:rayCast(x1, y1, x2, y2, function(fixture, x, y, xn, yn, fraction)

        if fixture:getUserData().type == 'ground' then
            groundDetected = true
        end

        return 0
    end)


    return groundDetected
end