
EnemyDeathState = Class{__includes = BaseState}

function EnemyDeathState:init(entity)
    self.entity = entity
end

function EnemyDeathState:enter(params)
    self.entity:changeAnimation('death')
end

function EnemyDeathState:update(dt)
    self.animation:update(dt)
    if self.animation.timesPlayed > 0 then
        self.animation.timesPlayed = 0
        self.entity.body:destroy()
    end
end