PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player

    EntityWalkState.init(self, player)
end

function PlayerWalkState:update(dt)
    local _, yVel = self.entity.body:getLinearVelocity()
    if not handleMovementInput(self.entity) then
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('space') and self.entity.canJump then
        self.entity:changeState('jump')
    end

    if love.keyboard.wasPressed('x') then
        self.entity:changeState('swing-sword')
    elseif love.keyboard.wasPressed('s') then
        self.entity:changeState('swing-sword', {combo = true})
    end
end