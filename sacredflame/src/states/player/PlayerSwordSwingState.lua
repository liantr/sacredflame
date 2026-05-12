PlayerSwordSwingState = Class{__includes = BaseState}

function PlayerSwordSwingState:init(player)
    self.entity = player
end

function PlayerSwordSwingState:enter(params)
    self.hitFrames = {}
    self.hitBoxes = createEntityHitBoxes(self.entity)
    if params then
        self.entity:changeAnimation('swing-sword-combo')
    else
        self.entity:changeAnimation('swing-sword')
    end

    self.entity.currentAnimation:refresh()
end

function PlayerSwordSwingState:update(dt)
    local _, vy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0,vy)

    local hitBoxEntries = getHitBoxes(self)
    local currFrame = self.entity.currentAnimation:getCurrentFrame()

    if hitBoxEntries and not self.hitFrames[currFrame] then
        for _, entry in pairs(hitBoxEntries) do
            if damageEnemy(self.entity.room, entry.hitBox) then
                self.hitFrames[currFrame] = true
            end
        end
    end

    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        self.entity:changeState('idle')
    end
end

function PlayerSwordSwingState:render()
    if DEBUG then
        love.graphics.setColor(1, 0, 1, 1)
        local hitBoxEntries = getHitBoxes(self)

        if hitBoxEntries then
            for _, hitBoxEntry in pairs(hitBoxEntries) do
                local hitBox = hitBoxEntry.hitBox
                love.graphics.rectangle('line',
                    hitBox.x,
                    hitBox.y,
                    hitBox.width,
                    hitBox.height)
                love.graphics.setColor(1, 1, 1, 1)
            end
        end
    end
end