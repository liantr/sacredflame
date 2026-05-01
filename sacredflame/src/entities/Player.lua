Player = Class{__includes=Entity}

function Player:init(def, world, startX, startY)
    Entity.init(self, def, world, startX, startY)
    self.runSpeed = def.runSpeed
    self.maxHealth = self.health
    self.timesDied = 0
    self.fixture:setUserData({type='player', entity = self})

    -- jump related variables
    self.canJump = true
    self.doubleJumpAllowed = true
    self.timesJumped = 0

    -- wall hold related variables
    self.wallHoldAllowed = true
    self.canHoldWall = true
    self.touchingWall = false
    self.wallX = nil

     self.dashing = false
end