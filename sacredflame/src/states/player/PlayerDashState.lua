PlayerDashState = Class{__includes = BaseState}

function PlayerDashState:init(player)
    self.entity = player
end

function PlayerDashState:enter(params)
    self.entity:changeAnimation('dash')
    local anim = self.entity.currentAnimation
    anim:refresh()

    self.nextState = params and params.nextState or 'idle'
    self.entity:goInvulnerable(3)
    self.entity.dashing = true

    local dashDirection = self.entity.direction == 'right' and 1 or -1
    local dashDuration = anim.interval * #anim.frames

    local _, pvy = self.entity.body:getLinearVelocity()
    local dashSpeed = (PLAYER_DASH_DIST / dashDuration) * dashDirection
    self.entity.body:setLinearVelocity(dashSpeed, pvy)

    Timer.after(dashDuration, function()
        local _, pvy2 = self.entity.body:getLinearVelocity()
        self.entity.body:setLinearVelocity(0, pvy2)
        self.entity.invulnerable = false
        self.entity.dashing = false
        self.entity:changeState(self.nextState)
    end)
end

function PlayerDashState:update(dt)
end

function PlayerDashState:render()
end

