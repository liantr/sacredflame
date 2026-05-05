EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity)
    self.entity = entity
    
    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0

    self.directions = {'left', 'right'}
end

function EntityWalkState:enter(params)
    self.entity:changeAnimation('walk')
end

function EntityWalkState:update(dt)

    local groundDetected = self:scanForGroundAhead()
    local _, evy = self.entity.body:getLinearVelocity()

    -- if there is ground ahead, continue walking, otherwise stop and reverse direction
    if groundDetected then
        local speed = self.entity.direction =='right' and self.entity.moveSpeed or -self.entity.moveSpeed
        self.entity.body:setLinearVelocity(speed, evy)
    else
        self.movementTimer = 0
        self.entity:reverseDirection()
        self.entity:changeState('idle')
    end
end


--[[
    Casts a ray down and ahead of the entity to detect ground
]]
function EntityWalkState:scanForGroundAhead()
    local world = self.entity.body:getWorld()

    local rayHeight = self.entity.height + TILE_SIZE/2

    local ex, ey = self.entity.body:getPosition()

    -- left or right edge of body depending on current direction
    local x1 = self.entity.direction =='right' and
        ex + self.entity.width / 2 + TILE_SIZE / 2 or
        ex - self.entity.width / 2 - TILE_SIZE / 2

    -- top of body
    local y1 = ey - self.entity.height / 2

    local x2 = x1

    -- into the ground
    local y2 = y1 + rayHeight


    local groundDetected = false

    world:rayCast(x1, y1, x2, y2, function(fixture, x, y, xn, yn, fraction)

        if fixture:getUserData().type == 'ground' then
            groundDetected = true
            return 0
        end

        return 1
    end)


    return groundDetected
end

function EntityWalkState:processAI(params, dt)
    
    local player = params.player
    local xDistFromPlayer = getXDistanceFromPlayer(self.entity, player)
    local yDistFromPlayer = getYDistanceFromPlayer(self.entity, player)

    if math.abs(xDistFromPlayer) < ENEMY_DETECTION_RANGE and
    math.abs(yDistFromPlayer) < ENEMY_ATTACK_Y_RANGE and
    self.entity.canAttack then
        if xDistFromPlayer > 0 then
            self.entity.direction = 'right'
        else
            self.entity.direction = 'left'
        end
        self.entity:changeState('chase', {player=player})
    elseif self.moveDuration == 0 then
        self:changeWalkDirection(self.directions)
    elseif self.movementTimer > self.moveDuration then
        self.movementTimer = 0
        self.entity:changeState('idle')
    end

    self.movementTimer = self.movementTimer + dt
end

function EntityWalkState:changeWalkDirection(directions)
    -- set an initial move duration and direction
    self.moveDuration = math.random(2)
    self.entity.direction = directions[math.random(#directions)]
    local evx, evy = self.entity.body:getLinearVelocity()
    self.entity.body:setLinearVelocity(self.entity.direction == 'right' and evx or -evx, evy)
end