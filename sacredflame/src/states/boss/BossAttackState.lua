BossAttackState = Class{__includes=EnemyAttackState}

function BossAttackState:init(entity)
    EnemyAttackState.init(self, entity)
    self.attack2Duration = math.random(3, 5)
end

function BossAttackState:enter(params)
    self.hitFrames = {}
    self.hitBoxes = createEntityHitBoxes(self.entity)
    self.attack2TimerStarted = false

    local animation = 'attack1' -- default
    if params then
        self.player = params.player
        animation = params.animation
    end
    local _, evy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, evy)

    local ex, _ = self.entity.body:getPosition()
    local px, _ = self.player.body:getPosition()
    self.attack2Direction = px - ex > 0 and 'right' or 'left'

    self.entity:changeAnimation(animation)

    self.entity.currentAnimation:refresh()
end

function BossAttackState:update(dt)
    local _, vy = self.entity.body:getLinearVelocity()
    self.hitBoxes = createEntityHitBoxes(self.entity)
    local hitBoxEntries = getHitBoxes(self)
    local currentAnimation = self.entity.currentAnimation
    local currFrame = self.entity.currentAnimation:getCurrentFrame()

    if hitBoxEntries and not self.hitFrames[currFrame] then
        for _, entry in pairs(hitBoxEntries) do
            if damagePlayerWithHitBox(self.entity.room, entry.hitBox) then
                self.hitFrames[currFrame] = true
            end
        end
    end

    if self.entity.currentAnimation and self.entity.currentAnimation.name =='attack2' then
        self.entity.direction = self.attack2Direction
        self.entity.body:setLinearVelocity(self.attack2Direction == 'right' and 200 or -200, vy)

        if self.entity.currentAnimation.timesPlayed > 0 then
            currentAnimation.timesPlayed = 0
            self.hitFrames = {}
        end

        if not self.attack2TimerStarted then
            self.attack2TimerStarted = true
            Timer.after(self.attack2Duration, function ()
                if not self.entity.dead and not self.entity.destroyed then
                    self.entity:changeState('disappear')
                end
            end)
        end
    else
        self.entity.body:setLinearVelocity(0,vy)
        if currentAnimation and not currentAnimation.looping and currentAnimation.timesPlayed > 0 then
            currentAnimation.timesPlayed = 0
            self.entity:changeState("idle")
        end
    end
end