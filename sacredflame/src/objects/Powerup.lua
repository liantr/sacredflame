Powerup = Class{__includes=Object}

function Powerup:init(def, world, x, y)
    Object.init(self, def, world, x, y)
    self.name = def.name
    self.acquisitionText = def.acquisitionText
    self.angle = 0
    self.fixture:setUserData({type='powerup', object = self})
    self.consumed = false
    self.baseY = self.y

    self.dialogBoxX = VIRTUAL_WIDTH / 2
    self.dialogBoxY = VIRTUAL_HEIGHT / 2
    self.dialogBoxWidth = TILE_SIZE * 6
end

function Powerup:update(dt)
    self.angle = self.angle + dt * - POWERUP_SIN_SPEED

    local x, _ = self.body:getPosition()
    local floatingY = math.sin(self.angle) * POWERUP_SIN_AMPLITUDE
    self.body:setPosition(x, self.baseY + floatingY)
end

function Powerup:pushAcquisitionDialogue()
    gStateStack:push(DialogueState(
        self.acquisitionText,
        self.dialogBoxX,
        self.dialogBoxY,
        self.dialogBoxWidth,
        self.dialogBoxWidth
    ))
end

function Powerup:render()
    local x, y = self.body:getPosition()

    if DEBUG then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle(
            'line',
            x - self.width / 2,
            y - self.height / 2,
            self.width,
            self.height)
    end

    -- fallback to frame 1 is no animation is active
    local frame = self.currentAnimation and self.currentAnimation:getCurrentFrame() or 1

    love.graphics.draw(
        gTextures[self.texture],
        gFrames[self.texture][frame],
        math.floor(x) - 3,
        math.floor(y),
        0,
        0.5,
        0.5,
        self.width / 2,
        self.height)
end