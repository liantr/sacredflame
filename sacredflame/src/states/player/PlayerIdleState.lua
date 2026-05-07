PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player)
    EntityIdleState.init(self, player)
    self.entity = player
end

function PlayerIdleState:enter()
    self.entity.dead = false
    self.entity:changeAnimation('idle')
end

function PlayerIdleState:update(dt)
    local _, yVel = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, yVel)

    if yVel > 10 then
        self.entity:changeState('falling')
    end

    if love.keyboard.isDown('left') or love.keyboard.isDown('right') then
        if love.keyboard.isDown('lshift') then
            self.entity:changeState('run')
        else
            self.entity:changeState('walk')
        end
    end

    if love.keyboard.wasPressed('z') and self.entity.canJump then
        self.entity:changeState('jump')
    end

    if love.keyboard.wasPressed('v') then
        self.entity:changeState('dash', {nextState='idle'})
    elseif love.keyboard.wasPressed('x') then
        self.entity:changeState('swing-sword')
    elseif love.keyboard.wasPressed('c') then
        self.entity:changeState('swing-sword', {combo = true})
    end
end