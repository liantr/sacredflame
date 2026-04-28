PlayerWalkState = Class{__includes = EntityWalkState}

function PlayerWalkState:init(player)
    self.entity = player

    EntityWalkState.init(self, player)
end

function PlayerWalkState:update(dt, run)

    local v = run and PLAYER_RUN_SPEED or PLAYER_WALK_SPEED

    if love.keyboard.isDown('z') and not run then
        self.entity:changeState('run')
    end
    if not handleMovementInput(self.entity, v) then
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('space') and self.entity.canJump then
        self.entity:changeState('jump')
    end

    if love.keyboard.wasPressed('x') then
        self.entity:changeState('dash', {nextState='walk'})
    elseif love.keyboard.wasPressed('s') then
        self.entity:changeState('swing-sword')
    elseif love.keyboard.wasPressed('d') then
        self.entity:changeState('swing-sword', {combo = true})
    end
end