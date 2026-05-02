BossDisappearState = Class{__includes=BaseState}

function BossDisappearState:init(entity)
    self.entity = entity
end

function BossDisappearState:enter()
    self.entity:changeAnimation('disappear')
end

function BossDisappearState:update(dt)
end