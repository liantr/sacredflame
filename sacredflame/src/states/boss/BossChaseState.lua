BossChaseState = Class{__includes=EnemyChaseState}

function BossChaseState:init(entity, room)
    EnemyChaseState.init(self, entity)
    self.room = room
end

function BossChaseState:processAI(params, dt)
    if self.room.player then
        local distFromPlayer = getXDistanceFromPlayer(self.entity, self.room.player)

        if math.abs(distFromPlayer) < self.entity.attackDistance and self.entity.canAttack then
            -- enemy within attack range
            local attackOptions = {'attack1', 'attack2', 'attack3'}
            local attack = attackOptions[math.random(#attackOptions)]
            print("Boss [chase] -> [" ..attack .."]")

            self.entity:changeState(attack, {animation = attack, player = self.room.player})
        elseif math.abs(distFromPlayer) > ENEMY_DETECTION_RANGE then
            print("Boss [appear] -> [disappear]")
            self.entity:changeState('disappear')
        else
            -- run towards player
            local _, vy = self.entity.body:getLinearVelocity()
            self.entity.direction = distFromPlayer > 0 and 'right' or 'left'
            local speed = self.entity.direction == 'right' and self.entity.chaseSpeed or -self.entity.chaseSpeed
            self.entity.body:setLinearVelocity(speed, vy)
        end
    end
end