EnemyAttackState = Class{__includes=BaseState}

function EnemyAttackState:init(entity)
    self.entity = entity
    self.rangedAttackSpawned = false
end

function EnemyAttackState:enter(params)
   self.hitFrames = {}
    if params then
        self.player = params.player
    end
    local _, evy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, evy)
    self.hitBoxes = createEntityHitBoxes(self.entity)
    self.entity:changeAnimation('attack')
    self.entity.currentAnimation:refresh()
end

function EnemyAttackState:update(dt)
    local _, vy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, vy)

    -- gets the current hit box frames and damages the player if the player has collided
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
    local px, py = self.player.body:getPosition()

    -- volley attack for archer bandits
    if self.entity.rangedAttack and
        not self.rangedAttackSpawned and
        currentAnimation:getCurrentFrame() == currentAnimation.frames[#currentAnimation.frames] then
        self.rangedAttackSpawned = true
        self:spawnRangedAttack(px, py)
    end

    -- return to idle once the attack is complete
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

function EnemyAttackState:processAI(params, dt)
end

--[[
    Spawns a VolleyAttack for archer bandit attack
]]
function EnemyAttackState:spawnRangedAttack(targetX, targetY)
    if self.entity.rangedAttack then
        local attack = VolleyAttack(targetX, targetY, self.entity.room)
        table.insert(self.entity.room.attacks, attack)
    end
end

function EnemyAttackState:render()
    if DEBUG then
        love.graphics.setColor(1, 0, 1, 1)
        local hitBoxEntries = getHitBoxes(self)

        if hitBoxEntries and #hitBoxEntries > 0 then
            for _, hitBoxEntry in pairs(hitBoxEntries) do
                if hitBoxEntry and hitBoxEntry.hitBox then
                    local hitBox = hitBoxEntry.hitBox
                    love.graphics.rectangle(
                        'line',
                        hitBox.x,
                        hitBox.y,
                        hitBox.width,
                        hitBox.height)
                end
            end
        end
        love.graphics.setColor(1, 1, 1, 1)
    end
end