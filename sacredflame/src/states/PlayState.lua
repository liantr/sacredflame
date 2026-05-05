PlayState = Class{__includes = BaseState}

function PlayState:init()

    -- Box2D world creation
    self.world = love.physics.newWorld(0, GRAVITY, true)

    -- Create the map of rooms
    self.map = {}
    for name, def in pairs(ROOM_DEFS) do
        self.map[name] = Room(def, self.world, self, name)
    end

    -- initialize the current room to entry
    self.currentRoom = self.map['entry']
    self.currentRoom:enter()

    self:spawnEntities()

    self.torchesLit = 0
    self.totalTorches = 12

    self.HUD = HUD(self)


    -- camera that follows the player
    self.camX = 0
    self.camY = 0
    self:updateCamera()

    -- for transitioning between rooms
    self.transitioning = false
    self.transitionAlpha = 0

    -- for respawning
    self.saveData = nil

    -- define collision callbacks for our world; the World object expects four,
    -- one for different stages of any given collision
    function beginContact(a, b, coll)
        local types = {}
        types[a:getUserData().type] = true
        types[b:getUserData().type] = true

        if types['player'] and types['ground'] then
            local playerFixture = a:getUserData().type == 'player' and a or b
            local groundFixture = a:getUserData().type == 'ground' and a or b
            self.player.canJump = true
            self.player.canHoldWall = false
            self.player.timesJumped = 0
        end

        if types['player'] and types['wall'] then
            local playerFixture = a:getUserData().type == 'player' and a or b
            local wallFixture = a:getUserData().type == 'wall' and a or b

            self.player.touchingWall = true
            local wallX, _ = wallFixture:getBody():getPosition()
            self.player.wallX = wallX
        end

        if types['player'] and types['torch'] then
            local playerFixture = a:getUserData().type == 'player' and a or b
            local torchFixture = a:getUserData().type == 'torch' and a or b

            local torch = torchFixture:getUserData().entity
            torch.playerInRange = true
        end

        if types['player'] and types['powerup'] then
            local playerFixture = a:getUserData().type == 'player' and a or b
            local powerupFixture = a:getUserData().type == 'powerup' and a or b

            local powerup = powerupFixture:getUserData().object
            powerup.consumed = true
            self.player.wallHoldAllowed = true
        end

        if types['player'] and types['enemy'] then
            local playerFixture = a:getUserData().type == 'player' and a or b
            local enemyFixture = a:getUserData().type == 'enemy' and a or b

            local _, evy = enemyFixture:getBody():getLinearVelocity()
            enemyFixture:getBody():setLinearVelocity(0, evy)

            -- player takes damage and goes invulnerable for a short period
            if not self.player.invulnerable then
                gSounds['hit-player']:play()
                playerFixture:getUserData().entity:damage()
                self.player:goInvulnerable(1.5)
            end
        end

        if types['player'] and types['spike'] then
            local playerFixture = a:getUserData().type == 'player' and a or b
            local spikeFixture = a:getUserData().type == 'spike' and a or b

            -- player takes damage and goes invulnerable for a short period
            if not self.player.invulnerable then
                gSounds['hit-player']:play()
                playerFixture:getUserData().entity:damage()
                self.player:goInvulnerable(1.5)
            end
        end

        if types['enemy'] and types['wall'] then
            local walLFixture = a:getUserData().type == 'wall' and a or b
            local enemyFixture = a:getUserData().type == 'enemy' and a or b
            local entity = enemyFixture:getUserData().entity
            entity:reverseDirection()
            entity:changeState('walk')
        end
    end

    function endContact(a, b, coll)
        local types = {}
        types[a:getUserData().type] = true
        types[b:getUserData().type] = true

        if types['player'] and types['torch'] then
            local playerFixture = a:getUserData().type == 'player' and a or b
            local torchFixture = a:getUserData().type == 'torch' and a or b

            local torch = torchFixture:getUserData().entity
            torch.playerInRange = false
        end

        if types['player'] and types['wall'] then
            self.player.touchingWall = false
        end
    end

    function preSolve(a, b, coll)
        local types = {}
        types[a:getUserData().type] = true
        types[b:getUserData().type] = true

        if types['player'] and types['enemy'] then
            coll:setEnabled(false)
        end

        if types['player'] and types['boss'] then
            coll:setEnabled(false)
        end


        if types['player'] and types['torch'] then
            coll:setEnabled(false)
        end

        if types['player'] and types['wall'] then
            if self.player.stateMachine.currentStateName == 'wall-hold' then
                coll:setEnabled(false)
            end
        end
    end

    function postSolve(a, b, coll)
    end

    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    self.flameAvailable = true
end

function PlayState:spawnEntities()
    -- create player
    self.player = Player(ENTITY_DEFS['player'], self.world, self.currentRoom.spawnX, self.currentRoom.spawnY, self.HUD)

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player) end,
        ['run'] = function() return PlayerRunState(self.player) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['jump'] = function() return PlayerJumpState(self.player) end,
        ['falling'] = function() return PlayerFallingState(self.player) end,
        ['death'] = function() return PlayerDeathState(self.player, self) end,
        ['dash'] = function() return PlayerDashState(self.player) end,
        ['swing-sword'] = function() return PlayerSwordSwingState(self.player) end,
        ['wall-hold'] = function() return PlayerWallHoldState(self.player) end,
    }

    self.player:changeState('idle')

    -- create flame companion
    self.flame = Flame(ENTITY_DEFS['flame'], self.world, self.player)

    self.flame.stateMachine = StateMachine {
        ['idle'] = function() return FlameFollowingState(self.flame) end
    }

    self.flame:changeState('idle')

    self.currentRoom.player = self.player
    self.currentRoom.flame = self.flame
    self.player.room = self.currentRoom
end

function PlayState:enter(params)
    if params then
        self = params.playState
    end
    self.HUD = HUD(self)
end

function PlayState:update(dt)
    Timer.update(dt)

    -- check for room change
    if not self.transitioning then
        self:transitionRooms()
        self.world:update(dt)
        self.currentRoom:update(dt)
        self.player:update(dt)
        self.flame:update(dt)

        for _,enemy in pairs(self.currentRoom.enemies) do
            enemy:update(dt)
            enemy:processAI({player = self.player}, dt)
        end

        local torchesLit = 0
        for _, room in pairs(self.map) do
            if room.objects then
                for _, object in pairs(room.objects) do
                    if object.type =='torch' and object.lit then
                        torchesLit = torchesLit + 1
                    end
                end
            end
        end

        self.torchesLit = torchesLit
    end

    if love.keyboard.wasPressed('p') and gStateStack.name ~= 'start' then
        gStateStack:push(PauseState())
    end

    self:updateCamera()
end

function PlayState:updateCamera()
    local x, y = self.player.body:getPosition()

    local roomWidth = self.currentRoom.map.width * TILE_SIZE
    local roomHeight = self.currentRoom.map.height * TILE_SIZE

    local camSpeed = self.player.dashing and 0.2 or 1

    if USE_ZOOM then
        local visibleWidth = VIRTUAL_WIDTH / CAMERA_ZOOM
        local visibleHeight = VIRTUAL_HEIGHT / CAMERA_ZOOM
        local targetX = math.max(0, math.min(roomWidth - visibleWidth, x - visibleWidth/2))
        local targetY = math.max(0, math.min(roomHeight - visibleHeight, y - visibleHeight/2))

        self.camX = self.camX + (targetX - self.camX) * camSpeed
        self.camY = self.camY + (targetY - self.camY) * camSpeed
    else
        local targetX = roomWidth > VIRTUAL_WIDTH and math.max(0,
                math.min(roomWidth - VIRTUAL_WIDTH,
                x - (VIRTUAL_WIDTH / 2))) or 0

        local targetY = ath.max(0,
            math.min(roomHeight - VIRTUAL_HEIGHT,
                y - (VIRTUAL_HEIGHT / 2))) or 0

        self.camX = self.camX + (targetX - self.camX) * camSpeed
        self.camY = self.camY + (targetY - self.camY) * camSpeed
    end

    -- adjust background X to move a third the rate of the camera for parallax
    --self.backgroundX = (self.camX / 3) % 256
end

function PlayState:moveTo(connection, verticalDirection)
    self.transitioning = true
    Timer.tween(0.5, {[self] = {transitionAlpha = 1}}):finish(function()
        self.currentRoom:exit()
        self.currentRoom = self.map[connection.room]
        self.currentRoom:enter()

        self.player.body:setPosition(connection.spawnX, connection.spawnY)
        self.currentRoom.player = self.player
        self.currentRoom.flame = self.flame
        self.player.room = self.currentRoom

        local px, py = self.player.body:getPosition()
        if verticalDirection then
            if verticalDirection == 'south' then
                self.player:changeState('falling')
            elseif verticalDirection == 'north' then
                self.player:changeState('jump')
            end
        end

        self.flame.body:setPosition(px, py)
        self.flame.body:setLinearVelocity(0,0)
        self.flame.body:setAngularVelocity(0)
        
        self.transitioning = false

        Timer.tween(0.5, {[self] = {transitionAlpha = 0}})
    end)
end

function PlayState:transitionRooms()
    local x, y = self.player.body:getPosition()
    local connections = self.currentRoom.connectedRooms

    local connectionPoints
    local verticalDirection
    if y > self.currentRoom.map.height * TILE_SIZE and connections.south then
        connectionPoints = connections.south
        verticalDirection = 'south'
    elseif y < 0 and connections.north then
        connectionPoints = connections.north
        verticalDirection = 'north'
    elseif x > self.currentRoom.map.width * TILE_SIZE and connections.east then
        connectionPoints = connections.east
    elseif x < 0 and connections.west then
        connectionPoints = connections.west
    end

    if connectionPoints then
        local connection = self:getRoomConnection(connectionPoints)
        if connection then
            self:moveTo(connection, verticalDirection)
        end
    end
end

--[[
    Gets the room connection the player's x is overlapping
]]
function PlayState:getRoomConnection(connections)
    local overlappingConnection = nil
    local px, _ = self.player.body:getPosition()
    for _, connection in pairs(connections) do
        print('px:', px, 'gapX:', connection.gapX, 'right edge:', connection.gapX + ROOM_CONNECTION_SIZE)

        if px >= connection.gapX and px <= connection.gapX + ROOM_CONNECTION_SIZE then
            overlappingConnection = connection
            break
        end
    end

    return overlappingConnection
end

function PlayState:reSpawn()
    if self.saveData then
        self.currentRoom:exit()
        self.currentRoom = self.map[self.saveData.room]
        self.currentRoom:enter()

        self.player.health = self.saveData.health
        self.player.dead = false
        self.player.body:setPosition(self.saveData.spawnX, self.saveData.spawnY)
        self.currentRoom.player = self.player
        self.currentRoom.flame = self.flame
        self.player.room = self.currentRoom

        local px, py = self.player.body:getPosition()
        self.flame.body:setPosition(px, py)
        self.flame.body:setLinearVelocity(0,0)
        self.flame.body:setAngularVelocity(0)
    end
end

function PlayState:save(data)
    self.saveData = data
end

function PlayState:render()
    love.graphics.push()

    -- zoom in around the player
    if USE_ZOOM then
        love.graphics.scale(CAMERA_ZOOM, CAMERA_ZOOM)
    end

    -- translate the entire view of the scene to emulate a camera
    love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    -- draw the background
    if self.currentRoom.background == 'ruinedTemple' then
        love.graphics.draw(gTextures['templeBg1'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
        love.graphics.draw(gTextures['templeBg2'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
        love.graphics.draw(gTextures['templeBg3'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
        love.graphics.draw(gTextures['templeBg4'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
    end

    self.currentRoom:render()

    love.graphics.pop()

    self.HUD:render()

    -- room transition fade in and out
    love.graphics.setColor(0,0,0,self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    love.graphics.setColor(1, 1, 1, 1)
end