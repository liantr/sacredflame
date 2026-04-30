PlayerWallHoldState = Class{__includes = BaseState}

function PlayerWallHoldState:init(player)
    self.player = player
end

function PlayerWallHoldState:enter()
    self.player:changeAnimation('wall-hold')
    self.player.timesJumped = 0
    self.player.canJump = true
end

function PlayerWallHoldState:update(dt)
    if not self.player.canHoldWall then
        self.player:changeState('idle')
    end
    self.player.body:setLinearVelocity(0, 0)

    if love.keyboard.wasPressed('space') then
        local px, py = self.player.body:getPosition()
        local vel = self.player.direction == 'right' and -30 or 30
        local shift = self.player.direction == 'right' and -10 or 10
        if self.player.direction == 'right' then
            self.player.direction = 'left'
        else
            self.player.direction = 'right'
        end
        self.player.body:setPosition(px+shift, py)
        self.player.body:setLinearVelocity(vel, 0)
        self.player:changeState('jump')
    end
end