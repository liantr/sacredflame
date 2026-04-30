Player = Class{__includes=Entity}

function Player:init(def, world, startX, startY)
    Entity.init(self, def, world, startX, startY)
    self.fixture:setUserData({type='player', entity = self})
    self.canJump = true
    self.runSpeed = def.runSpeed
    self.maxHealth = self.health
    self.timesDied = 0
    self.dashing = false
    self.wallHoldAllowed = true
    self.canHoldWall = true
end

function Player:update(dt)
    Entity.update(self, dt)

    if self.health == 0 then
        self:changeState('death')
    end
end