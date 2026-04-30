Torch = Class{__includes=Object}

function Torch:init(def, world, x, y)
    Object.init(self, def, world, x, y)
    self.animations = createAnimations(def.animations)
    self.lit = false
    self.playerInRange = false
    self.fixture:setUserData({type='torch', entity = self})
    self.lightRadius = 10
end

function Torch:changeAnimation(name)
    self.currentAnimation = self.animations[name]
end

function Torch:changeState(state, params)
    self.stateMachine:change(state, params)
end

function Torch:update(dt)
    self.stateMachine:update(dt)
    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
    if love.keyboard.wasPressed('l') and self.playerInRange and not self.lit then
        self:changeState('lit')
    end

    if self.lit and self.lightRadius < VIRTUAL_WIDTH + self.x then
        self.lightRadius = self.lightRadius + dt*150 -- speed
    end
end

function Torch:render()
    local x, y = self.body:getPosition()
    
    if DEBUG then
        love.graphics.setColor(1,1,1,1)
        love.graphics.rectangle('line',x-self.width/2, y - self.height/2, self.width, self.height)
    end

    if self.currentAnimation then
        local frameTex = self.currentAnimation.texture
        local frame = self.currentAnimation:getCurrentFrame()
        local quad = gFrames[frameTex][frame]

        love.graphics.draw(
            gTextures[self.texture],
            quad,
            math.floor(x),
            math.floor(y) + self.height/2,
            0,
            1,
            1,
            self.width / 2,
            self.height)

        if self.playerInRange and not self.lit then
            love.graphics.setFont(gFonts['small'])
            love.graphics.printf('Press [L] to light', math.floor(x)-45, math.floor(y)-40, 100, 'center')
        end
    end
end