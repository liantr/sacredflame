Player = Class{__includes=Entity}

function Player:init(def, world)
    Entity.init(self, def, world)
    self.fixture:setUserData({type='player'})
    self.canJump = true
end