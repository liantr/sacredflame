PlayerDeathState = Class{__includes = BaseState}

function PlayerDeathState:init(player, playState)
    self.player = player
    self.playState = playState
end

function PlayerDeathState:enter()
    self.player.timesDied = self.player.timesDied + 1
    self.player.dead = true
    self.player.invulnerable = false
    self.player:changeAnimation('death')

    print("times died: " ..tostring(self.player.timesDied))


    Timer.after(5, function()
        if self.player.timesDied >= 2 then
            --TODO push a game over state before going to start
            gStateStack:pop()
            gStateStack:push(StartState())
        else
            self.player:changeState('idle')
            self.playState:reSpawn()
        end
    end)
end

function PlayerDeathState:update(dt)
    local _, yVel = self.player.body:getLinearVelocity()
    self.player.body:setLinearVelocity(0, yVel)
end