--[[
    CS50 2D
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Extension: added panel decor
]]

Panel = Class{}

function Panel:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.visible = true
end

function Panel:update(dt)

end

function Panel:render()
    if self.visible then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle('fill', self.x, self.y, self.width, self.height, 3)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.rectangle('fill', self.x + 2, self.y + 2, self.width - 4, self.height - 4, 3)
        love.graphics.setColor(1, 1, 1, 1)

        local decorWidth = gTextures['panel-decor']:getWidth()
        local decorHeight = gTextures['panel-decor']:getHeight()
        local decorX = self.x + self.width / 2 - (decorWidth / 2)

        -- draw the top decor
        love.graphics.draw(
            gTextures['panel-decor'],
            decorX,
            self.y + 2
        )

        -- draw the bottom decor
        love.graphics.draw(
            gTextures['panel-decor'],
            decorX + decorWidth / 2,
            self.y + self.height - TILE_SIZE - 2,
            math.pi,
            1,
            1,
            decorWidth / 2,
            decorHeight / 2
        )
    end
end

function Panel:toggle()
    self.visible = not self.visible
end