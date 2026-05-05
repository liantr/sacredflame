PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player

    EntityWalkState.init(self, player)
end

function PlayerWalkState:update(dt, run)

    local v = run and PLAYER_RUN_SPEED or PLAYER_WALK_SPEED

    local _, vy = self.entity.body:getLinearVelocity()

    if vy > 10 then
        self.entity:changeState('falling')
    end

    if love.keyboard.isDown('lshift') and not run then
        self.entity:changeState('run')
    end

    if not self.entity:handleMovementInput(v) then
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('z') and self.entity.canJump then
        self.entity:changeState('jump')
    end

    if love.keyboard.wasPressed('v') then
        self.entity:changeState('dash', {nextState='walk'})
    elseif love.keyboard.wasPressed('x') then
        self.entity:changeState('swing-sword')
    elseif love.keyboard.wasPressed('c') then
        self.entity:changeState('swing-sword', {combo = true})
    end
end