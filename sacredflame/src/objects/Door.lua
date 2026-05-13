Door = Class{__includes=Object}

function Door:init(def, world, x, y, room)
    Object.init(self, def, world, x, y)
    self.animations = createAnimations(def.animations)
    self.open = false
    self.playerInRange = false
    self.fixture:setUserData({type='door', entity = self})
    self.playState = room.playState
end

function Door:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Door:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Door:update(dt)
    self.stateMachine:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end

    if love.keyboard.wasPressed('o') and
        self.playerInRange and
        not self.open and
            self:openingRequirementMet() then
            self:changeState('open')
    end
end

function Door:render()
    local x, y = self.body:getPosition()

    if DEBUG then
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle('line',
            x - self.width / 2,
            y - self.height / 2,
            self.width,
            self.height)
    end

    if self.currentAnimation then
        local frameTex = self.currentAnimation.texture
        local frame = self.currentAnimation:getCurrentFrame()
        local quad = gFrames[frameTex][frame]

        local animOffsetX = self.currentAnimation.offsetX or 0
        local animOffsetY = self.currentAnimation.offsetY or 0

        love.graphics.draw(
            gTextures[self.texture],
            quad,
            math.floor(x) + animOffsetX,
            math.floor(y) + animOffsetY,
            math.rad(self.def.rotation or 0),
            1,
            1,
            self.width,
            self.height)

        if self.playerInRange and not self.open then
            love.graphics.setFont(gFonts['small'])

            if self:openingRequirementMet() then
                love.graphics.printf(
                    'Press [O] to open',
                    math.floor(x) - 45,
                    math.floor(y) - 40,
                    100,
                    'center'
                )
            else
                love.graphics.printf(
                    tostring(self.playState.torchesLit) ..'/' ..MIN_TORCH_TO_OPEN_DOOR .." to open",
                    math.floor(x) - 45,
                    math.floor(y) - 40,
                    100,
                    'center'
                )
            end
        end
    end
end

function Door:openingRequirementMet()
    return self.playState.torchesLit >= 1 -- TODO: set to MIN_TORCH_TO_OPEN_DOOR
end