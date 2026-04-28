PlayerFallingState = Class{__includes = BaseState}

function PlayerFallingState:init(player)
    self.player = player
end

function PlayerFallingState:enter()
    self.player:changeAnimation('falling')
    self.player.canJump = false
end

function PlayerFallingState:update(dt)
    local _, yVel = self.player.body:getLinearVelocity()

    handleMovementInput(self.player, PLAYER_WALK_SPEED)

    if yVel == 0 then
        self.player:changeState('idle')
    end

    if love.keyboard.wasPressed('x') then
        self.player:changeState('dash', {nextState='falling'})
    elseif love.keyboard.wasPressed('s') then
        self.player:changeState('swing-sword')
    end
end