PlayerJumpState = Class{__includes = BaseState}

function PlayerJumpState:init(player)
    self.player = player
end

function PlayerJumpState:enter()
    self.player:changeAnimation('jump')
    self.player.canJump = self.player.doubleJumpAllowed and (self.player.timesJumped < 2 and true or false) or false
    self.player.canHoldWall = true
    self.player.timesJumped = self.player.timesJumped + 1
    local xVel, _ = self.player.body:getLinearVelocity()
    self.player.body:setLinearVelocity(xVel, PLAYER_JUMP_VELOCITY)
end

function PlayerJumpState:update(dt)
    local _, yVel = self.player.body:getLinearVelocity()

    handleMovementInput(self.player, PLAYER_WALK_SPEED)

    grabWall(self.player)

    if yVel >= 0 then
        self.player:changeState('falling')
    end

    if love.keyboard.wasPressed('z') and self.player.canJump then
        self.player:changeState('jump')
    elseif love.keyboard.wasPressed('v') then
        self.player:changeState('dash', {nextState='falling'})
    elseif love.keyboard.wasPressed('x') then
        self.player:changeState('swing-sword')
    end
end