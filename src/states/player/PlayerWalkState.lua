PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player

    EntityWalkState.init(self, player)
end

function PlayerWalkState:update(dt)
    local _, yVel = self.entity.body:getLinearVelocity()
    if love.keyboard.isDown('left') then
        self.entity.direction = 'left'
        self.entity.body:setLinearVelocity(-self.entity.moveSpeed, yVel)
    elseif love.keyboard.isDown('right') then
        self.entity.direction = 'right'
        self.entity.body:setLinearVelocity(self.entity.moveSpeed, yVel)
    else
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('space') and self.entity.canJump then
        self.entity:changeState('jump')
    end
end