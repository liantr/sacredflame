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
    if not self.player.canHoldWall or not self.player.touchingWall then
        self.player:changeState('idle')
    end

    self.player.body:setLinearVelocity(0, 0)

    if love.keyboard.wasPressed('z') then
        local px, py = self.player.body:getPosition()

        -- set the horizontal jump velocity and direction away from the wall
        -- also shift the player slightly off the wall once they've jumped
        local vel = self.player.direction == 'right' and - PLAYER_WALL_JUMP_VELOCITY_X or PLAYER_WALL_JUMP_VELOCITY_X
        local shift = self.player.direction == 'right' and - PLAYER_WALL_JUMP_SHIFT_X or PLAYER_WALL_JUMP_SHIFT_X

        if self.player.direction == 'right' then
            self.player.direction = 'left'
        else
            self.player.direction = 'right'
        end

        self.player.body:setPosition(px + shift, py)
        self.player.body:setLinearVelocity(vel, 0)
        self.player:changeState('jump')
    end
end