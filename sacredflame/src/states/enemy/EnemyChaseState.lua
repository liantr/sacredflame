
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

    local distFromPlayer = getDistanceFromPlayer(self.entity, self.player)

    if math.abs(distFromPlayer) < self.entity.attackDistance and self.entity.canAttack then
        -- enemy within attack range
        self.entity:changeState('attack', {player = self.player})
    elseif math.abs(distFromPlayer) > ENEMY_CHASE_MIN_DISTANCE then
        -- player too far, return to idle state
        self.entity:changeState('idle')
    else
        -- run towards player
        local _, vy = self.entity.body:getLinearVelocity()
        self.entity.direction = distFromPlayer > 0 and 'right' or 'left'
        local speed = self.entity.direction == 'right' and self.entity.chaseSpeed or -self.entity.chaseSpeed
        self.entity.body:setLinearVelocity(speed, vy)
    end
end