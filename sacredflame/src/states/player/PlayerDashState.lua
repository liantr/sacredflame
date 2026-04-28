PlayerDashState = Class{__includes = BaseState}

function PlayerDashState:init(player)
    self.entity = player
end

function PlayerDashState:enter(params)
    self.entity:changeAnimation('dash')
    local anim = self.entity.currentAnimation
    anim:refresh()

    if params then
        self.nextState = params.nextState
    end

    self.entity.invulnerable = true
    self.entity.dashing = true

    local dashStartX, _ = self.entity.body:getPosition()
    local interval = anim.interval * #anim.frames
    local dashDirection = self.entity.direction == 'right' and 1 or -1
    local dashDistance = TILE_SIZE * 2.5 * dashDirection + TILE_SIZE
    local dashDuration = interval * #anim.frames

    self.dashEndX = dashStartX+dashDistance

    Timer.tween(dashDuration,
    {
        [self] = {
            dashEndX = dashStartX + dashDistance
        }
    })

    Timer.after(dashDuration, function()
        local _, pvy = self.entity.body:getLinearVelocity()

        self.entity.body:setLinearVelocity(0, pvy)
        self.entity.invulnerable = false
        self.entity.dashing = false
        self.entity:changeState(self.nextState)
    end)
end

function PlayerDashState:update(dt)
    local _, py = self.entity.body:getPosition()
    self.entity.body:setPosition(math.max(0, math.min(self.dashEndX, VIRTUAL_WIDTH)), py)
end

function PlayerDashState:render()
end

