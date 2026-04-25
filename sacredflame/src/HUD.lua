HUD = Class{}


function HUD:init(playState)
    self.playState = playState

    self.boxX = 0

    self.barWidth = TILE_SIZE * 3
    self.barHeight = TILE_SIZE
    self.barX = self.boxX + 14

    self.y = TILE_SIZE

    self.torchX = self.barX + self.barWidth + TILE_SIZE*2 + 5
    self.torchY = 0
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
    love.graphics.printf(tostring(torchesLit) .." of " ..tostring(totalTorches), self.torchX - 28, self.torchY + 22, 100)
    love.graphics.printf(" lit", self.torchX + TILE_SIZE/2 + 5, self.torchY + 22, 100)

    love.graphics.draw(gTextures['small-torches'], gFrames['torch-hud'][1], self.torchX, self.torchY)

end