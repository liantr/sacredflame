BossIdleState = Class{__includes=EntityIdleState}

function BossIdleState:init(entity)
    EntityIdleState.init(self, entity)
end

function BossIdleState:processAI(params, dt)
    local player = params.player
    local distFromPlayer = getXDistanceFromPlayer(self.entity, player)

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