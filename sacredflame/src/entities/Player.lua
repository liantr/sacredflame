Player = Class{__includes=Entity}

function Player:init(def, world, startX, startY)
    Entity.init(self, def, world, startX, startY)
    self.runSpeed = def.runSpeed
    self.timesDied = 0
    self.fixture:setUserData({type = 'player', entity = self})

    -- jump related variables
    self.canJump = true
    self.doubleJumpAllowed = true -- TODO change to false before submission
    self.timesJumped = 0

    -- wall hold related variables
    self.wallHoldAllowed = true -- TODO set to false before submission
    self.canHoldWall = true
    self.touchingWall = false
    self.wallX = nil

     self.dashing = false
end

--[[
    Applies movement to the player based on user input
]]
function Player:handleMovementInput(speed)
    local _, yVel = self.body:getLinearVelocity()
    if love.keyboard.isDown('left')then
        self.direction = 'left'
        self.body:setLinearVelocity(-speed, yVel)
        return true
    elseif love.keyboard.isDown("right") then
        self.direction = 'right'
        self.body:setLinearVelocity(speed, yVel)
        return true
    end

    return false
end

--[[
    Transitions player to wall hold state if touching and facing a wall
]]
function Player:grabWall()
    if self.touchingWall and
        self.canHoldWall and
        self.wallHoldAllowed and
        (love.keyboard.isDown('left') or love.keyboard.isDown('right')) then
            local playerX, _ = self.body:getPosition()
            local playerFacingWall = (self.wallX > playerX and self.direction == 'right')
                or (self.wallX < playerX and self.direction == 'left')
                if playerFacingWall then
                    self:changeState('wall-hold')
                end
    end
end

function Player:render()
    Entity.render(self)

    local x, y = self.body:getPosition()
    love.graphics.setColor(1, 1, 0.8, 0.12)
    love.graphics.circle('fill', math.floor(x), math.floor(y), self.width * 4)
    love.graphics.setColor(1, 1, 0.9, 0.05)
    love.graphics.circle('fill', math.floor(x), math.floor(y), self.width * 7)
    love.graphics.setColor(1, 1, 1, 1)
end
