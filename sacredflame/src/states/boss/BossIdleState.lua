BossIdleState = Class{__includes=EntityIdleState}

function BossIdleState:init(entity)
    EntityIdleState.init(self, entity)
    self.idleTimer = 0
    self.idleTime = math.random(5, 10) / 10
end

function BossIdleState:processAI(params, dt)
    self.idleTimer = self.idleTimer + dt
    local player = params.player
    local distFromPlayer = getXDistanceFromPlayer(self.entity, player)

    if self.idleTimer >= self.idleTime then
        if math.abs(distFromPlayer) < ENEMY_DETECTION_RANGE and self.entity.canAttack then
            if distFromPlayer > 0 then
                self.entity.direction = 'right'
            else
                self.entity.direction = 'left'
            end
            self.entity:changeState('chase', {player=player})
        else
            self.entity:changeState('disappear')
        end
    end
end