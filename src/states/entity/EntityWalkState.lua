EntityWalkState = Class{__includes = BaseState}

function EntityWalkState:init(entity)
    self.entity = entity
    self.entity:changeAnimation('walk')

    -- used for AI control
    self.moveDuration = 0
    self.movementTimer = 0
end

function EntityWalkState:update(dt)
    local _, evy = self.entity.body:getLinearVelocity()
    local speed = self.entity.direction =='right' and self.entity.moveSpeed or -self.entity.moveSpeed
    self.entity.body:setLinearVelocity(speed, evy)
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