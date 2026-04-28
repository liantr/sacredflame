PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player)
    EntityIdleState.init(self, player)
    self.entity = player
end

function PlayerIdleState:update(dt)
    local _, yVel = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, yVel)

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        if love.keyboard.isDown('z') then
            self.entity:changeState('run')
        else
            self.entity:changeState('walk')
        end
    end

    if love.keyboard.wasPressed('space') and self.entity.canJump then
        self.entity:changeState('jump')
    end

    if love.keyboard.wasPressed('x') then
        self.entity:changeState('dash', {nextState='idle'})
    elseif love.keyboard.wasPressed('s') then
        self.entity:changeState('swing-sword')
    elseif love.keyboard.wasPressed('d') then
        self.entity:changeState('swing-sword', {combo = true})
    end
end