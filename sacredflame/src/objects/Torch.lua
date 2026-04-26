Torch = Class{__includes=Object}

function Torch:init(def, world, x, y)
    Object.init(self, def, world, x, y)
    self.animations = createAnimations(def.animations)
    self.lit = false

    self.fixture:setUserData({type='torch', entity = self})
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
end

function Torch:render()
    local x, y = self.body:getPosition()
    -- ? debug rectangle
    love.graphics.setColor(1,1,1,1)
    love.graphics.rectangle('line',x-self.width/2, y - self.height/2, self.width, self.height)

    if self.currentAnimation then
        local frameTex = self.currentAnimation.texture
        local frame = self.currentAnimation:getCurrentFrame()
        local quad = gFrames[frameTex][frame]

        print("texture: " ..self.texture ..", frameTex: " ..frameTex ..", frame: " ..tostring(frame))

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
        end
end