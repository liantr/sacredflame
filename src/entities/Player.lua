Player = Class{__includes=Entity}

function Player:init(def, world, startX, startY, bodyType)
    Entity.init(self, def, world, startX, startY, bodyType)
    self.fixture:setUserData({type='player'})
    self.canJump = true
    self.runSpeed = def.runSpeed
end