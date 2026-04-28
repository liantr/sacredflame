PlayerJumpState = Class{__includes = BaseState}

function PlayerJumpState:init(player)
    self.player = player
end

function PlayerJumpState:enter()
    self.player:changeAnimation('jump')
    self.player.canJump = false
    local xVel, _ = self.player.body:getLinearVelocity()
    self.player.body:setLinearVelocity(xVel, PLAYER_JUMP_VELOCITY)
end

function PlayerJumpState:update(dt)
    local _, yVel = self.player.body:getLinearVelocity()

    handleMovementInput(self.player, PLAYER_WALK_SPEED)
    if yVel >= 0 then
        self.player:changeState('falling')
    end

    if love.keyboard.wasPressed('x') then
        self.player:changeState('dash', {nextState='falling'})
    elseif love.keyboard.wasPressed('s') then
        self.player:changeState('swing-sword')
    end
end