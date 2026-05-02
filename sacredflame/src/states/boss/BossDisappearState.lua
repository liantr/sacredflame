BossDisappearState = Class{__includes=BaseState}

function BossDisappearState:init(entity)
    self.entity = entity
end

function BossDisappearState:enter()
    self.timerStarted = false
    local _, evy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, evy)
    self.entity:changeAnimation('disappear')
    self.entity.currentAnimation:refresh()
end

function BossDisappearState:update(dt)
end

function BossDisappearState:processAI(params, dt)
    if not self.timerStarted then
        self.timerStarted = true
        Timer.after(1, function ()
            print("Boss [disappear] -> [appear]")
            self.entity:changeState('appear')
        end)
    end
end