PlayerSwordSwingState = Class{__includes = BaseState}

function PlayerSwordSwingState:init(player)
    self.player = player

    self.swordHitBoxes = {}
    self:createHitBoxes()
end

function PlayerSwordSwingState:enter(params)
    self.hitEnemy = false
    if params and params.combo then
        self.player:changeAnimation('swing-sword-combo')
    else
        self.player:changeAnimation('swing-sword')
    end
end

function PlayerSwordSwingState:exit()
end

function PlayerSwordSwingState:createHitBoxes()
    self.swordHitBoxes = {}

    -- create hitbox based on where the player is and facing
    local hitBoxX, hitBoxY
    local px, py = self.player:getPosition()
    if self.player.hitBoxes then
        local direction = self.player.direction
        for _, hitBox in pairs(self.player.hitBoxes) do
            local offsetX = hitBox.offsetX or 0
            local offsetY = hitBox.offsetY or 0
            if direction == 'left' then
                hitBoxX = px - hitBox.width - self.player.width/2 - offsetX
                hitBoxY = py + offsetY
            elseif direction == 'right' then
                hitBoxX = px + self.player.width/2 + offsetX
                hitBoxY = py + offsetY
            end
            self.swordHitBoxes[hitBox.animation] = HitBox(hitBoxX, hitBoxY, hitBox.width, hitBox.height)
        end
    end
end

function PlayerSwordSwingState:getHitBox()
    local animation = self.player.currentAnimation
    if animation and self.swordHitBoxes then
        return self.swordHitBoxes[animation.name]
    end

    return nil
end

function PlayerSwordSwingState:update(dt)
    self:createHitBoxes()
    local hitBox = self:getHitBox()
    if hitBox and not self.hitEnemy then
        self.hitEnemy = damageEnemy(self.player.room, self:getHitBox())
    end

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    if love.keyboard.wasPressed('x') then
        self.player:changeState('swing-sword')
    end

end

function PlayerSwordSwingState:render()
    love.graphics.setColor(1, 0, 1, 1)
    local px, py = self.player:getPosition()
    local hitBox = self:getHitBox()

    if hitBox then
        --love.graphics.rectangle('line', px, py, self.player.width, self.player.height)
        love.graphics.rectangle('line', hitBox.x, hitBox.y,
            hitBox.width, hitBox.height)
        love.graphics.setColor(255, 255, 255, 255)
    end
end