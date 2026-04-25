VolleyAttack = Class{}

function VolleyAttack:init(targetX, targetY)
    self.targetX = targetX
    self.targetY = targetY
    self.complete = false

    self.animation = Animation({
        frames = {1,2,3,4,5},
        interval = 0.08,
        looping = false,
        texture = 'archer-bandit-attack-volley'
    })
end

function VolleyAttack:update(dt)
    self.animation:update(dt)
    print(tostring(self.animation.timesPlayed))
    if self.animation.timesPlayed > 0 then
        self.animation.timesPlayed = 0
        self.complete = true
    end
end

function VolleyAttack:render()
    if not self.complete then
        local texture = self.animation.texture
        local frame = self.animation:getCurrentFrame()
        local quad = gFrames[texture][frame]

        local _, _, w, h = quad:getViewport()

        love.graphics.draw(gTextures[self.animation.texture],
            quad,
            math.floor(self.targetX),
            math.floor(self.targetY),
            0,1,1,w/2,h/2)
    end
end