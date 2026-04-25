GhoulSleepState = Class{__includes = BaseState}

function GhoulSleepState:init(entity)
    self.entity = entity
end

function GhoulSleepState:enter()
    self.entity:changeAnimation('sleep')
end

function GhoulSleepState:update(dt)
    
end