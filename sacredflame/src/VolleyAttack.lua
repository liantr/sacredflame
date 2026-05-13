VolleyAttack = Class{}

--[[
    One shot ranged attack by Archer Bandits.
    Damages player once on collision and is completed once the animation finishes.
]]
function VolleyAttack:init(targetX, targetY, room)
    self.targetX = targetX
    self.targetY = targetY
    self.room = room
    self.complete = false
    self.width = TILE_SIZE * 1.5
    self.height = TILE_SIZE * 7
    self.offsetY = -TILE_SIZE * 3
    self.hitPlayer = false

    self.animation = Animation({
        frames = generateFramesList(5),
        interval = 0.08,
        looping = false,
        texture = 'archer-bandit-attack-volley'
    })

    local hitBoxX = self.targetX - self.width/2
    local hitBoxY = self.targetY - self.height/2

    self.hitBox = HitBox(hitBoxX, hitBoxY, self.width, self.height)

    -- give the player a chance to dodge
    self.delay = 0.05
    self.delayTimer = 0

end

function VolleyAttack:update(dt)

    self.delayTimer = self.delayTimer + dt
    -- 
    if self.hitBox and not self.hitPlayer and self.delayTimer >= self.delay then
        self.hitPlayer = damagePlayerWithHitBox(self.room, self.hitBox)
    end

    self.animation:update(dt)
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
            math.floor(self.targetY + self.offsetY),
            0,1,1,w/2,h/2)
    end

    if DEBUG then
        if self.hitBox then
            love.graphics.setColor(1, 0, 1, 1)
            love.graphics.rectangle('line', self.hitBox.x, self.hitBox.y,
                self.hitBox.width, self.hitBox.height)
            love.graphics.setColor(1, 1, 1, 1)
        end
    end
end