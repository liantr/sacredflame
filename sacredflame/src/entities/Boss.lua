Boss = Class{__includes=Entity}

function Boss:init(def, world, startX, startY, room)
    Entity.init(self, def, world, startX, startY, room)
    self.hurtBoxes = self:buildHurtBoxes(def)
    self.currentHurtBox = nil
    self.room = room
    self.playState = self.room.playState

    local torchesLit = self.playState.torchesLit
    self.health = self.health - (torchesLit * 2)
end

--[[
    Builds a hurt box lookup table of hurt box dimensions per animation name and frame.
    The boss's shape changes based on the animation.
    Not using Box2D here since the body shape isn't changeable after definition.
]]
function Boss:buildHurtBoxes(def)
    local hurtBoxes = {}
    if def.hurtBoxes then
        for name, _ in pairs(self.animations) do
            local animHurtBoxes = def.hurtBoxes[name]
            if animHurtBoxes then
                hurtBoxes[name] = {}
                for _, hurtBox in pairs(animHurtBoxes) do
                    for _, frame in ipairs(hurtBox.frames) do
                        hurtBoxes[name][frame] = {
                            width = hurtBox.width or self.width,
                            height = hurtBox.height or self.height,
                            offsetX = hurtBox.offsetX or 0,
                            offsetY = hurtBox.offsetY or 0
                        }
                    end
                end
            end
            
        end
    end

    return hurtBoxes
end

function Boss:collides(hitBox)
    local x, y = self.body:getPosition()
    if self.hurtBoxes and self.currentAnimation and self.currentHurtBox then
        local ex, ey = self:getHurtBoxPosition()

        return not (ex > hitBox.x + hitBox.width or hitBox.x > ex + self.currentHurtBox.width or
                    ey > hitBox.y + hitBox.height or hitBox.y > ey + self.currentHurtBox.height)
    end

    return Entity.collides(self, hitBox)
end

function Boss:update(dt)
    Entity.update(self, dt)
    local currAnimation = self.currentAnimation

    -- Set the current hurt box
    if self.hurtBoxes and currAnimation then
        self.currentHurtBox = self.hurtBoxes[currAnimation.name][currAnimation:getCurrentFrame()] or nil
    end

    -- Creates a hit box from the hurt box so player collision
    -- with the body triggers damage to the player
    if self.room.player and not self.room.player.invulnerable and self.currentHurtBox then
        local ex, ey = self:getHurtBoxPosition()
        local hitBox = HitBox(ex, ey, self.currentHurtBox.width, self.currentHurtBox.height)
        damagePlayerWithHitBox(self.room, hitBox)
    end
end

function Boss:getHurtBoxPosition()
    if self.currentHurtBox then
        local x, y = self.body:getPosition()
        local ex = x + self.currentHurtBox.offsetX - self.currentHurtBox.width/2
        local ey = y + self.currentHurtBox.offsetY - self.currentHurtBox.height /2

        return ex, ey
    end
    return nil
end

function Boss:render()
    Entity.render(self)
    if DEBUG  and self.currentHurtBox then
        local x, y = self:getHurtBoxPosition()
        local w = self.currentHurtBox.width
        local h = self.currentHurtBox.height
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle('line', x, y, w, h)
        love.graphics.setColor(1, 1, 1, 1)
    end
end