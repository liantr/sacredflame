PlayerSwordSwingState = Class{__includes = BaseState}

function PlayerSwordSwingState:init(player)
    self.player = player
end

function PlayerSwordSwingState:enter()
    self.player:changeAnimation('swing-sword')
end

function PlayerSwordSwingState:update(dt)

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    if love.keyboard.wasPressed('x') then
        print("swing from swing state")
        self.player:changeState('swing-sword')
    end

end

-- function PlayerSwordSwingState:render()
--     local x, y = self.player.body:getPosition()
--     local anim = self.player.currentAnimation
--     love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()], x, y)
-- end