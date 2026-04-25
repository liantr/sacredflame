--[[
    CS50 2D
    Super Mario Bros. Remake

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]
EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

function EntityIdleState:enter(params)
    self.entity:changeAnimation('idle')
end

function EntityIdleState:update(dt)
    local _, evy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(0, evy)
end

--[[
    We can call this function if we want to use this state on an agent in our game; otherwise,
    we can use this same state in our Player class and have it not take action.
]]
function EntityIdleState:processAI(params, dt)

    local player = params.player
    local distFromPlayer = getDistanceFromPlayer(self.entity, player)
    local absDistFromPlayer = math.abs(distFromPlayer)

    print("dist from player: " ..tostring(absDistFromPlayer) ..", min dist: " ..tostring(ENEMY_CHASE_MIN_DISTANCE))

    if math.abs(distFromPlayer) < ENEMY_CHASE_MIN_DISTANCE then
        if distFromPlayer > 0 then
            self.entity.direction = 'right'
        else
            self.entity.direction = 'left'
        end
        self.entity:changeState('chase', {player=player})
    elseif self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('walk')
        end
    end
end