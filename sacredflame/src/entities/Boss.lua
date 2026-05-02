Boss = Class{__includes=Entity}

function Boss:init(def, world, startX, startY, room)
    Entity.init(self, def, world, startX, startY, room)
    self.hurtBoxes = self:buildHurtBoxes(def)
    self.currentHurtBox = nil
    self.fixture:setUserData({type='boss', entity = self})
end

function Boss:buildHurtBoxes(def)
    local hurtBoxes = {}
    if def.hurtBoxes then
        for name, anim in pairs(self.animations) do
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
    if self.hurtBoxes and currAnimation then
        self.currentHurtBox = self.hurtBoxes[currAnimation.name][currAnimation:getCurrentFrame()] or nil
    end

    if self.room.player and not self.room.player.invulnerable and self.currentHurtBox then
        local ex, ey = self:getHurtBoxPosition()
        local hitBox = HitBox(ex, ey, self.currentHurtBox.width, self.currentHurtBox.height)

        if damagePlayer(self.room, hitBox) then
            self.room.player:goInvulnerable(1.5)
        end
    end
end

function Boss:getHurtBoxPosition()
    local x, y = self.body:getPosition()
    local ex = x - self.width/2 + self.currentHurtBox.offsetX
    local ey = y - self.height/2 + self.currentHurtBox.offsetY

    return ex, ey
end

-- function Boss:processAI(params, dt)
-- TODO update once all states are ready
-- end

function Boss:render()
    Entity.render(self)
    if DEBUG then
        local x, y = self.body:getPosition()
        local offsetX = self.currentHurtBox and self.currentHurtBox.offsetX or 0
        local offsetY = self.currentHurtBox and self.currentHurtBox.offsetY or 0
        local w = self.currentHurtBox and self.currentHurtBox.width or self.width
        local h = self.currentHurtBox and self.currentHurtBox.height or self.height
        love.graphics.setColor(0, 1, 0, 1)
        love.graphics.rectangle('line', x + offsetX - w/2, y + offsetY - h/2, w, h)
        love.graphics.setColor(1, 1, 1, 1)
    end
end