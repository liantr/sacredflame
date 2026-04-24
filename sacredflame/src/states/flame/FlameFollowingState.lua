FlameFollowingState = Class{__includes = EntityIdleState}

function FlameFollowingState:init(flame)
    EntityIdleState.init(self, flame)
    self.entity = flame
end

function FlameFollowingState:update(dt)
   self.entity:returnToPlayer(dt)
end