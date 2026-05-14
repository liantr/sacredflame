PlayState = Class{__includes = BaseState}

function PlayState:init()

    -- Box2D world creation
    self.world = love.physics.newWorld(0, GRAVITY, true)

    -- controls box
    local controlsText = 'Left Shift | Run\nZ | Attack\nX | Attack Combo\nC | Dash\n'..
        'Space | Jump\nLeft Arrow | Move Left\nRight Arrow | Move Right'

    self.controlsPanel = Textbox(VIRTUAL_WIDTH - 160, 20, 120, 150, controlsText, gFonts['small'])

    -- Create the map of rooms
    self.map = {}
    for name, def in pairs(ROOM_DEFS) do
        self.map[name] = Room(def, self.world, self, name)
    end

    -- initialize the current room to entry
    self.currentRoom = self.map['entry']
    gSounds[self.currentRoom.music]:play()
    gSounds[self.currentRoom.music]:setLooping(true)
    self.currentRoom:enter()

    self:spawnEntities()

    self.torchesLit = 0
    self.totalTorches = TOTAL_TORCHES

    self.HUD = HUD(self)

    -- camera that follows the player
    self.camX = 0
    self.camY = 0
    self:updateCamera()

    -- for transitioning between rooms
    self.transitioning = false
    self.transitionAlpha = 0

    -- for respawning, default
    self.saveData = {
        spawnX = self.currentRoom.spawnX,
        spawnY = self.currentRoom.spawnY,
        room = self.currentRoom.name,
        health = PLAYER_MAX_HEALTH
    }

    -- define collision callbacks for our world; the World object expects four,
    -- one for different stages of any given collision
    function beginContact(a, b, coll)
        local types = {}
        types[a:getUserData().type] = true
        types[b:getUserData().type] = true

         if types['wall'] and types['boss'] then
            local bossFixture = a:getUserData().type == 'boss' and a or b
            local boss = bossFixture:getUserData().entity
            boss:changeState('disappear')
        end

        if types['player'] and types['ground'] then
            self.player.canJump = true
            self.player.canHoldWall = false
            self.player.timesJumped = 0
        end

        if types['player'] and types['wall'] then
            local wallFixture = a:getUserData().type == 'wall' and a or b

            local wallShape = wallFixture:getShape()
            local _, y1, _, y2 = wallShape:computeAABB(wallFixture:getBody():getTransform())

            if math.abs(y2 - y1) > TILE_SIZE then
                self.player.touchingWall = true
                local wallX, _ = wallFixture:getBody():getPosition()
                self.player.wallX = wallX
            end
        end

        if types['player'] and types['torch'] then
            local torchFixture = a:getUserData().type == 'torch' and a or b

            local torch = torchFixture:getUserData().entity
            torch.playerInRange = true
        end

        if types['player'] and types['door'] then
            local doorFixture = a:getUserData().type == 'door' and a or b

            local door = doorFixture:getUserData().entity
            door.playerInRange = true
        end

        if types['player'] and types['powerup'] then
            local powerupFixture = a:getUserData().type == 'powerup' and a or b

            local powerup = powerupFixture:getUserData().object
            powerup.consumed = true
            powerup:pushAcquisitionDialogue()

            if powerup.name == 'wall-hold' then
                self.player.wallHoldAllowed = true
            end

            if powerup.name == 'double-jump' then
                self.player.doubleJumpAllowed = true
            end
        end

        if types['player'] and types['enemy'] then
            local enemyFixture = a:getUserData().type == 'enemy' and a or b

            local _, evy = enemyFixture:getBody():getLinearVelocity()
            enemyFixture:getBody():setLinearVelocity(0, evy)

            -- player takes damage and goes invulnerable for a short period
            damagePlayer(self.player)
        end

        if types['player'] and types['spike'] then
            -- player takes damage and goes invulnerable for a short period
            damagePlayer(self.player)
        end

        if types['enemy'] and types['wall'] then
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
            local torchFixture = a:getUserData().type == 'torch' and a or b

            local torch = torchFixture:getUserData().entity
            torch.playerInRange = false
        end

        if types['player'] and types['door'] then
            local doorFixture = a:getUserData().type == 'door' and a or b

            local door = doorFixture:getUserData().entity
            door.playerInRange = false
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

        if types['player'] and types['door'] then
            local doorFixture = a:getUserData().type == 'door' and a or b
            local door = doorFixture:getUserData().entity

            if door.open then
                coll:setEnabled(false)
            end
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
    self.bossBattleInitiated = false
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

        self:updateTorchesLit()
    end

    if self.currentRoom.name == 'boss' and not self.bossBattleInitiated then
        local px, _ = self.player.body:getPosition()

        if px > (self.currentRoom.map.width * TILE_SIZE) / 2 - TILE_SIZE * 3 then
            self.bossBattleInitiated = true
            gStateStack:push(BossBattleState(self))
        end
    end

    if love.keyboard.wasPressed('p') and gStateStack.name ~= 'start' then
        gStateStack:push(PauseState())
    end

    self:updateCamera()
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

function PlayState:updateTorchesLit()
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
end

function PlayState:moveTo(connection, direction)
    self.transitioning = true
    local previousRoomMusic = self.currentRoom.music

    if self.bossBattleInitiated then
        previousRoomMusic = 'boss'
        gSounds['boss']:stop()
        self.bossBattleInitiated = false

        gStateStack:pop()
        self.currentRoom:clearEnemies()
    end

    Timer.tween(0.5, {[self] = {transitionAlpha = 1}}):finish(function()
        self.currentRoom:exit()
        self.currentRoom = self.map[connection.room]
        local newRoomMusic = self.currentRoom.music
        if self.currentRoom.music ~= previousRoomMusic then
            gSounds[previousRoomMusic]:stop()
            gSounds[newRoomMusic]:play()
            gSounds[newRoomMusic]:setLooping(true)
        end
        self.currentRoom:enter()

        self.player.body:setPosition(connection.spawnX, connection.spawnY)
        self.currentRoom.player = self.player
        self.currentRoom.flame = self.flame
        self.player.room = self.currentRoom

        local px, py = self.player.body:getPosition()
        if direction then
            if direction == 'south' then
                self.player:changeState('falling')
            elseif direction == 'north' then
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
    local direction
    if y > self.currentRoom.map.height * TILE_SIZE and connections.south then
        connectionPoints = connections.south
        direction = 'south'
    elseif y < 0 and connections.north then
        connectionPoints = connections.north
        direction = 'north'
    elseif x > self.currentRoom.map.width * TILE_SIZE and connections.east then
        connectionPoints = connections.east
        direction = 'east'
    elseif x < 0 and connections.west then
        connectionPoints = connections.west
        direction = 'west'
    end

    if connectionPoints then
        local connection = self:getRoomConnection(connectionPoints, direction)
        if connection then
            self:moveTo(connection, direction)
        end
    end
end

--[[
    Gets the room connection the player's x or y is overlapping.
    Checks x position for north and south connections.
    Transitions if the player goes past the room height in either direction and is within the horizontal gap

    Checks y position for east and west connections.
    Transitions if the player goes past the room width in either direction and is within the vertical gap
]]
function PlayState:getRoomConnection(connections, direction)
    local px, py = self.player.body:getPosition()
    for _, connection in ipairs(connections) do
        if direction == 'east' or direction == 'west'then
            if py >= connection.gapY and py <= connection.gapY + ROOM_CONNECTION_SIZE then
                return connection
            end
        else
            if px >= connection.gapX and px <= connection.gapX + ROOM_CONNECTION_SIZE then
                return connection
            end
        end
    end

    return nil
end

function PlayState:reSpawn()
    if self.saveData then

        if self.bossBattleInitiated then
            gStateStack:pop()
            gSounds['boss']:stop()
            self.bossBattleInitiated = false
        end

        for _, room in pairs(self.map) do
            room.allEnemiesDead = false
            room:clearEnemies()
        end

        gSounds[self.currentRoom.music]:stop()
        self.currentRoom:exit()

        self.currentRoom = self.map[self.saveData.room]
        self.currentRoom:enter()
        gSounds[self.currentRoom.music]:play()
        gSounds[self.currentRoom.music]:setLooping(true)

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
    love.graphics.scale(CAMERA_ZOOM, CAMERA_ZOOM)

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

    -- draw the control panel
    if love.keyboard.isDown('q') then
        self.controlsPanel:render()
    end

    -- room transition fade in and out
    love.graphics.setColor(0,0,0,self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)

    love.graphics.setColor(1, 1, 1, 1)
end