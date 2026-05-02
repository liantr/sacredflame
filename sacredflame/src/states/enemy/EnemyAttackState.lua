EnemyAttackState = Class{__includes=BaseState}

function EnemyAttackState:init(entity)
    self.entity = entity
    self.rangedAttackSpawned = false
    self.hitBoxes = createEntityHitBoxes(self.entity)
end

function EnemyAttackState:enter(params)
   self.hitFrames = {}

    if params then
        self.player = params.player
    end
    local _, evy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, evy)
    self.entity:changeAnimation('attack')

    self.entity.currentAnimation:refresh()
end

function EnemyAttackState:processAI(params, dt)
        local _, vy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0,vy)
    
    self.hitBoxes = createEntityHitBoxes(self.entity)
    local hitBoxEntries = getHitBoxes(self)
    local currFrame = self.entity.currentAnimation:getCurrentFrame()

    if hitBoxEntries and not self.hitFrames[currFrame] then
        for _, entry in pairs(hitBoxEntries) do
            if damagePlayer(self.entity.room, entry.hitBox) then
                self.hitFrames[currFrame] = true
            end
        end
    end
    
    local currentAnimation = self.entity.currentAnimation
    local ex, ey = self.entity.body:getPosition()
    local px, py = self.player:getPosition()
    self.entity.direction = px - ex > 0 and 'right' or 'left'

    if self.entity.rangedAttack and
        not self.rangedAttackSpawned and
        currentAnimation:getCurrentFrame() == currentAnimation.frames[#currentAnimation.frames] then
        self.rangedAttackSpawned = true
        self.entity:spawnRangedAttack(px, py)
    end

    if currentAnimation and not currentAnimation.looping and currentAnimation.timesPlayed > 0 then
        currentAnimation.timesPlayed = 0
        self.entity.canAttack = false
        self.rangedAttackSpawned = false
        Timer.after(ENEMY_ATTACK_COOL_DOWN_TIME, function ()
            self.entity.canAttack = true
        end)
        self.entity:changeState("idle")
    end
end

function EnemyAttackState:render()
    if DEBUG then
        love.graphics.setColor(1, 0, 1, 1)
        local hitBoxEntries = getHitBoxes(self)

        if hitBoxEntries then
            for _, hitBoxEntry in pairs(hitBoxEntries) do
                if hitBoxEntry and hitBoxEntry.hitBox then
                    local hitBox = hitBoxEntry.hitBox
                    --love.graphics.rectangle('line', px, py, self.player.width, self.player.height)
                    love.graphics.rectangle('line', hitBox.x, hitBox.y,
                        hitBox.width, hitBox.height)
                end
            end
        end
        love.graphics.setColor(1, 1, 1, 1)
    end
end