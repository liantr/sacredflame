EnemyAttackState = Class{__includes=BaseState}

function EnemyAttackState:init(entity)
    self.entity = entity
    self.rangedAttackSpawned = false
end

function EnemyAttackState:enter(params)
    if params then
        self.player = params.player
    end
    local _, evy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, evy)
    self.entity:changeAnimation('attack')
end

function EnemyAttackState:processAI(params, dt)
end


function EnemyAttackState:update(dt)
    local currentAnimation = self.entity.currentAnimation

    if self.entity.rangedAttack and
        not self.rangedAttackSpawned and
        currentAnimation:getCurrentFrame() == currentAnimation.frames[#currentAnimation.frames] then
        self.rangedAttackSpawned = true
        local px, py = self.player:getPosition()
        self.entity:spawnRangedAttack(px, py)
    end

    if currentAnimation and not currentAnimation.looping and currentAnimation.timesPlayed > 0 then
        currentAnimation.timesPlayed = 0
        self.entity.canAttack = false
        self.rangedAttackSpawned = false
        Timer.after(ENEMY_ATTACK_COOL_DOWN_TIME, function ()
            self.entity.canAttack = true
        end)
        self.entity:changeState("idle")
    end
end