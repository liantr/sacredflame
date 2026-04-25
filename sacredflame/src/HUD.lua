HUD = Class{}


function HUD:init(playState)
    self.playState = playState

    self.boxX = TILE_SIZE

    self.barWidth = TILE_SIZE * 3
    self.barHeight = TILE_SIZE
    self.barX = self.boxX + 14

    self.y = TILE_SIZE

    self.torchX = self.barX + 40
    self.torchY = self.y * 2

    self.flameX = self.boxX
    self.flameY = self.y * 2.5

    self.torchText1X = self.torchX - 28
    self.torchText2X = self.torchX + 13
    self.torchTextY = self.torchY + 22
end

function HUD:update(dt)
end

function HUD:render()
    love.graphics.draw(gTextures['player-health-box'], self.boxX, self.y)

    local scaleFactor = WINDOW_HEIGHT/VIRTUAL_HEIGHT
    local player = self.playState.player
    local healthScaling = player.health == 0 and player.health or player.health/player.maxHealth

    love.graphics.setScissor(self.barX * scaleFactor,
        self.y * scaleFactor,
        self.barWidth * scaleFactor * healthScaling,
        self.barHeight * scaleFactor)
    love.graphics.draw(gTextures['player-health-bar'], self.barX, self.y)
    love.graphics.setScissor()

    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(1, 1, 1, 1)

    local torchesLit = self.playState.torchesLit
    local totalTorches = self.playState.totalTorches
    love.graphics.printf(tostring(torchesLit) .." of " ..tostring(totalTorches), self.torchText1X, self.torchTextY, 100)
    love.graphics.printf(" lit", self.torchText2X, self.torchTextY, 100)

    love.graphics.draw(gTextures['small-torches'], gFrames['torch-hud'][1], self.torchX, self.torchY)
    love.graphics.draw(gTextures['flame-idle'], gFrames['flame-idle'][3], self.flameX, self.flameY)

end