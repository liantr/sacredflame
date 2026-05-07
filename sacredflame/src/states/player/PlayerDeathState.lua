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


    Timer.after(5, function()
        if self.player.timesDied >= 3 then
            gStateStack:push(FadeInState({
                r = 0, g = 0, b = 0
            }, 1,
            function()

                
                gStateStack:push(GameOverState())
                gStateStack:push(FadeOutState({
                    r = 0, g = 0, b = 0
                }, 1,
                function() end))
            end))
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