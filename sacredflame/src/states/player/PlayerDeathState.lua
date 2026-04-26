PlayerDeathState = Class{__includes = BaseState}

function PlayerDeathState:init(player, world)
    self.player = player
    self.world = world
end

function PlayerDeathState:enter()
    self.player:changeAnimation('death')

    Timer.after(1.5, function()
        if self.player.timesDied >= 2 then
            gStateMachine:change('start')
        else
            -- TODO : update to Respawn/saved state after learning state stacks and implementing torch system
            self.player:changeState('idle')
        end
    end)
end

function PlayerDeathState:update(dt)
end