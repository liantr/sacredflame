PlayerDeathState = Class{__includes = BaseState}

function PlayerDeathState:init(player, world)
    self.player = player
    self.world = world
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
            -- TODO respawn at last torch position
            -- local room = self.room
            -- local _, y = self.player.body:getPosition()
            -- self.player.body:setPosition(, y)
            self.player.health = 6
            self.player:changeState('idle')
        end
    end)
end

function PlayerDeathState:update(dt)
    local _, yVel = self.player.body:getLinearVelocity()
    self.player.body:setLinearVelocity(0, yVel)
end