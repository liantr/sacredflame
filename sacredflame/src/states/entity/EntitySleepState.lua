EntitySleepState = Class{__includes = BaseState}

function EntitySleepState:init(entity)
    self.entity = entity
end

function EntitySleepState:enter()
    self.entity:changeAnimation('sleep')
end

function EntitySleepState:update(dt)
end