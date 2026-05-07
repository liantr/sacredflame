PlayerDashState = Class{__includes = BaseState}

function PlayerDashState:init(player)
    self.entity = player
end

function PlayerDashState:enter(params)
    self.entity:changeAnimation('dash')
    local anim = self.entity.currentAnimation
    anim:refresh()

    self.nextState = params and params.nextState or 'idle'
    self.entity.dashing = true

    local dashDirection = self.entity.direction == 'right' and 1 or -1
    local dashDuration = anim.interval * #anim.frames -- total duration of the dash animation
    local dashSpeed = (PLAYER_DASH_DIST / dashDuration) * dashDirection -- v = d/t, accounts for direction

    self.entity:goInvulnerable(dashDuration) -- lets the player dash to avoid enemies

    local _, pvy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(dashSpeed, pvy)

    -- once the animation has played/player has dashed reset variables and exit the state
    Timer.after(dashDuration, function()
        _, pvy = self.entity.body:getLinearVelocity()
        self.entity.body:setLinearVelocity(0, pvy)
        self.entity.dashing = false
        self.entity:changeState(self.nextState)
    end)
end

function PlayerDashState:update(dt)
end

function PlayerDashState:render()
end

