PlayerRunState = Class{__includes=PlayerWalkState}

function PlayerRunState:init(player)
    PlayerWalkState.init(self, player)
end

function PlayerRunState:enter(params)
    self.entity:changeAnimation('run')
end


function PlayerRunState:update(dt)
    PlayerWalkState.update(self, dt, true)
end