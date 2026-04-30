PlayerSwordSwingState = Class{__includes = BaseState}

function PlayerSwordSwingState:init(player)
    self.entity = player

    self.hitBoxes = createEntityHitboxes(self.entity)
end

function PlayerSwordSwingState:enter(params)
    self.hitEnemy = false
    if params then
        if params.combo then
            self.entity:changeAnimation('swing-sword-combo')
        elseif params.downStrike then
            self.entity:changeAnimation('swing-sword-down')
        end
    else
        self.entity:changeAnimation('swing-sword')
    end

    self.entity.currentAnimation:refresh()
end

function PlayerSwordSwingState:exit()
end

function PlayerSwordSwingState:update(dt)
    createEntityHitboxes(self.entity)
    local hitBox = getHitBox(self)
    --TODO: combo should deal 3 hit points
    if hitBox and not self.hitEnemy then
        self.hitEnemy = damageEnemy(self.entity.room, hitBox)
    end

    if self.entity.currentAnimation.timesPlayed > 0 then
        self.entity.currentAnimation.timesPlayed = 0
        self.entity:changeState('idle')
    end

    if love.keyboard.wasPressed('s') then
        if love.keyboard.isDown('down') then
            self.entity:changeState('swing-sword',{downStrike = true})
        else
            self.entity:changeState('swing-sword')
        end
    end

end

function PlayerSwordSwingState:render()
    if DEBUG then
        love.graphics.setColor(1, 0, 1, 1)
        local hitBox = getHitBox(self)

        if hitBox then
            --love.graphics.rectangle('line', px, py, self.player.width, self.player.height)
            love.graphics.rectangle('line', hitBox.x, hitBox.y,
                hitBox.width, hitBox.height)
            love.graphics.setColor(255, 255, 255, 255)
        end
    end
end