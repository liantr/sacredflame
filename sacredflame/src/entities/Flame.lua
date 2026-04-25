Flame = Class{__includes=Entity}

function Flame:init(def, world, player)
    self.player = player
    local playerX, playerY = player.body:getPosition()

    Entity.init(self, def, world, playerX + FLAME_TARGET_X_FROM_PLAYER, playerY - FLAME_TARGET_Y_FROM_PLAYER)

    self.fixture:setUserData({type='flame', entity = self})
    self.fixture:setSensor(true) -- no collision
    self.body:setLinearDamping(5)
    self.body:setAngularDamping(5)

    self.angle = 0
end

function Flame:update(dt)
    Entity.update(self, dt)
end

function Flame:attack()
end

function Flame:returnToPlayer(dt)
    local px, py = self.player.body:getPosition()
    local x, y = self.body:getPosition()

    local targetY = py - FLAME_TARGET_Y_FROM_PLAYER
    local targetX = px + FLAME_TARGET_X_FROM_PLAYER

    local dy = targetY - y
    local dx = targetX - x

    local dist = math.sqrt(dx*dx + dy*dy)
    local stepSize = FLAME_MOVE_SPEED * dt

    if dist > 0 then
        self.body:setLinearVelocity(dx/dist*stepSize, dy/dist*stepSize)
    end
    if math.abs(dx) <= TILE_SIZE and math.abs(dy) <= TILE_SIZE then
        self.body:setLinearVelocity(0, 0)
        self.angle = self.angle + dt * -FLAME_SINE_SPEED

        local floatingY = math.sin(self.angle)
        self.body:setPosition(x, py - FLAME_TARGET_Y_FROM_PLAYER + floatingY)
    end

end