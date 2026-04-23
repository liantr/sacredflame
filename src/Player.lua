Player = Class{__includes=Entity}

function Player:init(def, world, startX, startY)
    Entity.init(self, def, world, startX, startY)
    self.fixture:setUserData({type='player'})
    self.canJump = true
    self.runSpeed = def.runSpeed
end