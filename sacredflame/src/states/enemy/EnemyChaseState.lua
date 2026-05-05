
EnemyChaseState = Class{__includes = EntityWalkState}

function EnemyChaseState:init(entity)
    EntityWalkState.init(self, entity)
end

function EnemyChaseState:enter(params)
    if params then
        self.player = params.player
    end

    assert(self.player, "player is nil in chase state!")

    self.entity:changeAnimation('walk')
end

function EnemyChaseState:update(dt)
    EntityWalkState.update(self, dt)
end

function EnemyChaseState:processAI(params, dt)

    local xDistFromPlayer = getXDistanceFromPlayer(self.entity, self.player)
    local yDistFromPlayer = getYDistanceFromPlayer(self.entity, self.player)

    if math.abs(xDistFromPlayer) < self.entity.attackDistance and
        math.abs(yDistFromPlayer) < ENEMY_ATTACK_Y_RANGE and
    self.entity.canAttack then
        -- enemy within attack range
        self.entity:changeState('attack', {player = self.player})
    elseif math.abs(xDistFromPlayer) > ENEMY_DETECTION_RANGE then
        -- player too far, return to idle state
        self.entity:changeState('idle')
    else
        -- run towards player
        local _, vy = self.entity.body:getLinearVelocity()
        self.entity.direction = xDistFromPlayer > 0 and 'right' or 'left'
        local speed = self.entity.direction == 'right' and self.entity.chaseSpeed or -self.entity.chaseSpeed
        self.entity.body:setLinearVelocity(speed, vy)
    end
end