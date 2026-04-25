PlayState = Class{__includes = BaseState}

function PlayState:init()

    -- Box2D world creation
    self.world = love.physics.newWorld(0, GRAVITY, true)

    -- Create the map of rooms
    self.map = {}
    for name, def in pairs(ROOM_DEFS) do
        self.map[name] = Room(def, self.world)
    end

    -- initialize the current room to entry
    self.currentRoom = self.map['entry']
    self.currentRoom:enter()

    self:spawnEntities()

    -- camera that follows the player
    self.camX = 0
    self.camY = 0
    self:updateCamera()

    -- for transitioning between rooms
    self.transitioning = false
    self.transitionAlpha = 0

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
            self.player:changeState('idle')
        end

        if types['player'] and types['enemy'] then
            local playerFixture = a:getUserData().type == 'player' and a or b
            local enemyFixture = a:getUserData().type == 'enemy' and a or b

            local _, evy = enemyFixture:getBody():getLinearVelocity()
            enemyFixture:getBody():setLinearVelocity(0, evy)
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
    end

    self.world:setCallbacks(beginContact, nil, nil)
end

function PlayState:spawnEntities()
    -- create player
    self.player = Player(ENTITY_DEFS['player'], self.world, self.currentRoom.spawnX, self.currentRoom.spawnY)

    self.player.stateMachine = StateMachine {
        ['walk'] = function() return PlayerWalkState(self.player) end,
        ['idle'] = function() return PlayerIdleState(self.player) end,
        ['jump'] = function() return PlayerJumpState(self.player) end,
        ['falling'] = function() return PlayerFallingState(self.player) end,
        ['death'] = function() return PlayerDeathState(self.player) end,
        ['swing-sword'] = function() return PlayerSwordSwingState(self.player) end,
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
end

function PlayState:enter(params)
    if params then
        self = params.playState
    end
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
    end

    if love.keyboard.wasPressed('p') and gStateMachine.currentStateName ~= 'start' then
        gStateMachine:change('pause', {playState = self})
    end

    self:updateCamera()


    -- ! [DEBUG] Press d to enter player death state
     if love.keyboard.wasPressed('d')then
        self.player:changeState('death')
     end
end

function PlayState:updateCamera()
    local x, y = self.player.body:getPosition()

    local roomWidth = self.currentRoom.map.width * TILE_SIZE
    local roomHeight = self.currentRoom.map.height * TILE_SIZE

    if USE_ZOOM then
        local visibleWidth = VIRTUAL_WIDTH / CAMERA_ZOOM
        local visibleHeight = VIRTUAL_HEIGHT / CAMERA_ZOOM
        self.camX = math.max(0, math.min(roomWidth - visibleWidth, x - visibleWidth/2))
        self.camY = math.max(0, math.min(roomHeight - visibleHeight, y - visibleHeight/2))
    else

        if roomHeight > VIRTUAL_HEIGHT then
            self.camY = math.max(0,
            math.min(roomHeight - VIRTUAL_HEIGHT,
                y - (VIRTUAL_HEIGHT / 2)))
        else
            self.camY = 0
        end

        if roomWidth > VIRTUAL_WIDTH then
            self.camX = math.max(0,
                math.min(roomWidth - VIRTUAL_WIDTH,
                x - (VIRTUAL_WIDTH / 2)))
        else
            self.camX = 0
        end
    end

    -- adjust background X to move a third the rate of the camera for parallax
    --self.backgroundX = (self.camX / 3) % 256
end

function PlayState:moveTo(connection)
    self.transitioning = true
    Timer.tween(0.5, {[self] = {transitionAlpha = 1}}):finish(function()
        self.currentRoom:exit()
        self.currentRoom = self.map[connection.room]
        self.currentRoom:enter()

        self.player.body:setPosition(connection.spawnX, connection.spawnY)
        self.currentRoom.player = self.player
        self.currentRoom.flame = self.flame

        local px, py = self.player.body:getPosition()
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
    if y > self.currentRoom.map.height * TILE_SIZE and connections.south then
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

    -- room transition fade in and out
    love.graphics.setColor(0,0,0,self.transitionAlpha)
    love.graphics.rectangle('fill', 0, 0, VIRTUAL_WIDTH, VIRTUAL_HEIGHT)
    
    love.graphics.setColor(1, 1, 1, 1)
end