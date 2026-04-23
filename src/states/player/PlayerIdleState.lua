PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player)
    EntityIdleState.init(self, player)
    self.entity = player
end

function PlayerIdleState:update(dt)
    local _, yVel = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, yVel)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        self.entity:changeState('walk')
    end

    if love.keyboard.wasPressed('space') and self.entity.canJump then
        self.entity:changeState('jump')
    end

    if love.keyboard.wasPressed('x') then
        self.entity:changeState('swing-sword')
    end
end