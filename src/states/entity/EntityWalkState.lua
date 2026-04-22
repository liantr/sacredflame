EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('walk')

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0
end

function EntityWalkState:update(dt)
end