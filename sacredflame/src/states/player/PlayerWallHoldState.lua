PlayerWallHoldState = Class{__includes = BaseState}

function PlayerWallHoldState:init(player)
    self.player = player
end

function PlayerWallHoldState:enter()
    self.player:changeAnimation('wall-hold')
    self.player.canJump = true
end

function PlayerWallHoldState:update(dt)
    self.player.body:setLinearVelocity(0, 0)

    local vel = self.player.direction == 'right' and -30 or 30
    if love.keyboard.wasPressed('space') then
        self.player.body:setLinearVelocity(vel, 0)
        self.player:changeState('jump')
    end
end