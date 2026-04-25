HUD = Class{}


function HUD:init(player)
    self.player = player

    self.boxX = TILE_SIZE
    self.barWidth = TILE_SIZE * 3
    self.barHeight = TILE_SIZE
    self.barX = self.boxX + 14
    self.y = TILE_SIZE*2

    self.sliceX = self.barX + self.barWidth + 14
end

function HUD:update(dt)
end

function HUD:render()
    love.graphics.draw(gTextures['player-health-box'], self.boxX, self.y)

    local scaleFactor = WINDOW_HEIGHT/VIRTUAL_HEIGHT
    local healthScaling = self.player.health == 0 and self.player.health or self.player.health/self.player.maxHealth
    
    love.graphics.setScissor(self.barX * scaleFactor,
        self.y * scaleFactor,
        self.barWidth * scaleFactor * healthScaling,
        self.barHeight * scaleFactor)

    love.graphics.draw(gTextures['player-health-bar'], self.barX, self.y)

    love.graphics.setScissor()
end