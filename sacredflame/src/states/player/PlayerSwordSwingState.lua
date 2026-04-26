PlayerSwordSwingState = Class{__includes = BaseState}

function PlayerSwordSwingState:init(player)
    self.player = player
end

function PlayerSwordSwingState:enter(params)
    if params and params.combo then
        self.player:changeAnimation('swing-sword-combo')
    else
        self.player:changeAnimation('swing-sword')
    end
end

function PlayerSwordSwingState:exit()
end

function PlayerSwordSwingState:update(dt)

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    if love.keyboard.wasPressed('x') then
        self.player:changeState('swing-sword')
    end

end