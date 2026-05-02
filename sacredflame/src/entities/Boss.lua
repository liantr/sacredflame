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
                            width = hurtBox.width,
                            height = hurtBox.height,
                            offsetX = hurtBox.offsetX,
                            offsetY = hurtBox.offsetY
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
    print("curr anim: " ..tostring(self.currentAnimation))
    if self.hurtBoxes and self.currentAnimation and self.currentHurtBox then
        local hurtBoxWidth = self.currentHurtBox.width or self.width
        local hurtBoxHeight = self.currentHurtBox.height or self.height
        local offsetX = self.currentHurtBox.offsetX or 0
        local offsetY = self.currentHurtBox.offsetY or 0

        print("offsetY: " ..tostring(offsetY))

        local ex = x - self.width/2 + offsetX
        local ey = y - self.height/2 + offsetY
        return not (ex > hitBox.x + hitBox.width or hitBox.x > ex + hurtBoxWidth or
                    ey > hitBox.y + hitBox.height or hitBox.y > ey + hurtBoxHeight)
    end

    return Entity.collides(self, hitBox)
end

function Boss:update(dt)
    Entity.update(self, dt)
    local currAnimation = self.currentAnimation
    if self.hurtBoxes and currAnimation then
        self.currentHurtBox = self.hurtBoxes[currAnimation.name][currAnimation:getCurrentFrame()] or nil
    end
end

-- function Boss:processAI(params, dt)
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