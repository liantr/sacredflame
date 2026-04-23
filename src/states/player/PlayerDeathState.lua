PlayerDeathState = Class{__includes = BaseState}

function PlayerDeathState:init(player, world)
    self.player = player
    self.world = world
end

function PlayerDeathState:enter()
    self.player:changeAnimation('death')

    Timer.after(1.5, function()
        gStateMachine:change('start')
    end)
end

function PlayerDeathState:update(dt)
end