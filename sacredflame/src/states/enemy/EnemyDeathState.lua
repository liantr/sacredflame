
EnemyDeathState = Class{__includes = BaseState}

function EnemyDeathState:init(entity)
    self.entity = entity
end

function EnemyDeathState:enter(params)
    self.entity.body:setActive(false)
    self.entity:changeAnimation('death')
end

function EnemyDeathState:processAI(params, dt)
end

function EnemyDeathState:update(dt)
    local anim = self.entity.currentAnimation
    if anim.timesPlayed > 0 then
        anim.timesPlayed = 0
        self.entity.dead = true
    end
end