BossAttackState = Class{__includes=EnemyAttackState}

function BossAttackState:init(entity)
    EnemyAttackState.init(self, entity)
end

function BossAttackState:enter(params)
    self.hitFrames = {}
    local animation = 'attack1' -- default
    if params then
        self.player = params.player
        animation = params.animation
    end
    local _, evy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, evy)

    self.entity:changeAnimation(animation)

    self.entity.currentAnimation:refresh()
end

function BossAttackState:processAI(params, dt)
end