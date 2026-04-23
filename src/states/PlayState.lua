PlayState = Class{__includes = BaseState}

function PlayState:init()
    -- camera that follows the player
    self.camX = 0
    self.camY = 0

    -- Box2D world creation
    self.world = love.physics.newWorld(0, 800, true)

    -- Create the map of rooms
    self.map = {}
    for name, def in pairs(ROOM_DEFS) do
        self.map[name] = Room(def, self.world)
    end

    -- initialize the current room to entry
    self.currentRoom = self.map['entry']
    self.currentRoom:enter()

    -- for transitioning between rooms
    self.transitioning = false
    self.transitionAlpha = 0

    -- create player
    self.player = Player(ENTITY_DEFS['player'], self.world, self.currentRoom.spawnX, self.currentRoom.spawnY)

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['jump'] = function() return PlayerJumpState(self.player) end,
        ['falling'] = function() return PlayerFallingState(self.player) end
    }

    self.player:changeState('idle')

    -- define collision callbacks for our world; the World object expects four,
    -- one for different stages of any given collision
    function beginContact(a, b, coll)
        local types = {}
        types[a:getUserData().type] = true
        types[b:getUserData().type] = true

        if types['player'] and types['ground'] then
            local playerFixture = a:getUserData().type == 'Player' and a or b
            local groundFixture = a:getUserData().type == 'ground' and a or b
            self.player.canJump = true
            self.player:changeState('idle')
        end
    end

    self.world:setCallbacks(beginContact)
end

function PlayState:enter(params)
    if params then
        self = params.playState
    end
end

function PlayState:update(dt)
    Timer.update(dt)
    self.world:update(dt)
    self.player:update(dt)

    -- check for room change
    if not self.transitioning then
        self:transitionRooms()
    end

    if love.keyboard.wasPressed('p') and gStateMachine.currentStateName ~= 'start' then
        gStateMachine:change('pause', {playState = self})
    end
end

function PlayState:updateCamera()
    -- clamp movement of the camera's X between 0 and the map bounds - virtual width,
    -- setting it half the screen to the left of the player so they are in the center
    self.camX = math.max(0,
        math.min(TILE_SIZE * self.tileMap.width - VIRTUAL_WIDTH,
        self.player.x - (VIRTUAL_WIDTH / 2 - 8)))

    -- adjust background X to move a third the rate of the camera for parallax
    self.backgroundX = (self.camX / 3) % 256
end

function PlayState:moveTo(connection)
    self.transitioning = true
    Timer.tween(0.5, {[self] = {transitionAlpha = 1}}):finish(function()
        self.currentRoom:exit()

        self.currentRoom = self.map[connection.room]

        self.currentRoom:enter()
        print("Spawning player at x: " ..tostring(connection.spawnX) ..tostring(connection.spawnY))
        self.player.body:setPosition(connection.spawnX, connection.spawnY)
        self.player.body:setLinearVelocity(0, 0)
        Timer.tween(1, {[self] = {transitionAlpha = 0}}):finish(function ()
            self.transitioning = false
        end)
    end)
end

function PlayState:transitionRooms()
    local x, y = self.player.body:getPosition()
    local connections = self.currentRoom.connectedRooms
    if y > self.currentRoom.map.height * TILE_SIZE and connections.south then
        print("going down")
        self:moveTo(connections.south)
    elseif y < 0 and connections.north then
        self:moveTo(connections.north)
    elseif x > self.currentRoom.map.width * TILE_SIZE and connections.east then
        self:moveTo(connections.east)
    elseif x < 0 and connections.west then
        self:moveTo(connections.west)
    end
end

function PlayState:render()
    -- translate the entire view of the scene to emulate a camera
    --love.graphics.translate(-math.floor(self.camX), -math.floor(self.camY))

    -- draw the background
    if self.currentRoom.background == 'ruinedTemple' then
        love.graphics.draw(gTextures['templeBg1'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
        love.graphics.draw(gTextures['templeBg2'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
        love.graphics.draw(gTextures['templeBg3'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
        love.graphics.draw(gTextures['templeBg4'], 0, 0, 0, VIRTUAL_WIDTH / 1024, VIRTUAL_HEIGHT / 576)
    end

    self.currentRoom:renderBackground()

    -- draw player
    self.player:render()

    -- draw the foreground
    self.currentRoom:renderForeground()

    -- room transition fade in and out
    love.graphics.setColor(0,0,0,self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    love.graphics.setColor(1, 1, 1, 1)
end