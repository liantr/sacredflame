EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('walk')

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0
end

function EntityWalkState:update(dt)

    local groundDetected = self:scanForGroundAhead(dt)
    local _, evy = self.entity.body:getLinearVelocity()

    if groundDetected then
        local speed = self.entity.direction =='right' and self.entity.moveSpeed or -self.entity.moveSpeed
        self.entity.body:setLinearVelocity(speed, evy)
    else
        self.movementTimer = 0
        self.entity.direction = self.entity.direction == 'right' and 'left' or 'right'
        self.entity:changeState('idle')
    end
end

function EntityWalkState:scanForGroundAhead(dt)
    local world = self.entity.body:getWorld()

    local rayHeight = self.entity.height + TILE_SIZE/2

    local ex, ey = self.entity.body:getPosition()

    local x1 = self.entity.direction =='right' and ex + self.entity.width/2 + TILE_SIZE/2 or ex - self.entity.width/2 - TILE_SIZE/2 -- left or right edge of body
    local y1 = ey - self.entity.height/2 -- top of body

    local x2 = x1
    local y2 = y1 + rayHeight  -- into ground


    local groundDetected = false

    world:rayCast(x1, y1, x2, y2, function(fixture, x, y, xn, yn, fraction)

        if fixture:getUserData().type == 'ground' then
            groundDetected = true
        end

        return 0
    end)


    return groundDetected
end

function EntityWalkState:processAI(params, dt)
    local directions = {'left', 'right'}

    if self.moveDuration == 0 then
        self:changeWalkDirection(directions)

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