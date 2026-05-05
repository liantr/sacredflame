HUD = Class{}


function HUD:init(playState)
    self.playState = playState

    -- box holding the health bar
    self.boxX = TILE_SIZE

    -- health bar layout
    self.barWidth = TILE_SIZE * 3
    self.barHeight = TILE_SIZE
    self.barX = self.boxX + 14 -- offset to align bar inside the box. 

    self.y = TILE_SIZE

    -- torch counter layout [text1][torch][text2]
    self.torchX = self.barX + 40
    self.torchY = self.y * 2
    self.torchText1X = self.torchX - 28
    self.torchText2X = self.torchX + 13
    self.torchTextY = self.torchY + 22

    -- flame attack availability indicator
    self.flameX = self.boxX
    self.flameY = self.y * 2.5
end

function HUD:render()
    love.graphics.draw(gTextures['player-health-box'], self.boxX, self.y)

    -- scissor clips the health bar based on the current
    -- percentage of max hp the player has
    local scaleFactor = WINDOW_HEIGHT/VIRTUAL_HEIGHT
    local player = self.playState.player
    local healthScaling = player.health/player.maxHealth

    love.graphics.setScissor(self.barX * scaleFactor,
        self.y * scaleFactor,
        self.barWidth * scaleFactor * healthScaling,
        self.barHeight * scaleFactor)
    love.graphics.draw(gTextures['player-health-bar'], self.barX, self.y)
    love.graphics.setScissor()

    -- torch counter section
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)

    local torchesLit = self.playState.torchesLit
    local totalTorches = self.playState.totalTorches
    love.graphics.printf(
        tostring(torchesLit) .." of " ..tostring(totalTorches),
        self.torchText1X,
        self.torchTextY,
        100)
    love.graphics.printf(" lit", self.torchText2X, self.torchTextY, 100)

    love.graphics.draw(gTextures['small-torches'], gFrames['torch-hud'][1], self.torchX, self.torchY)

    local flameAvailable = self.playState.flameAvailable

    -- flame atatck availability indicator
    if not flameAvailable then
        love.graphics.setColor(1, 1, 1, 0.5)
    end

    love.graphics.draw(gTextures['flame-idle'], gFrames['flame-idle'][3], self.flameX, self.flameY)

    love.graphics.setColor(1, 1, 1, 1)
end