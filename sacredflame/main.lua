--[[
    CS50 2D, Spring 2026
    Final Project

    Author: Lian Randle
    lir140@g.harvard.edu

    TODO: Description

    Music credit:
    TODO

    Artwork credit:
    TODO
]]

love.graphics.setDefaultFilter('nearest', 'nearest')
require 'src.Dependencies'

-- deprecation bypass for LÖVE 12+
local major, minor = love.getVersion()
if major > 11 then
    love.setDeprecationOutput(false)
end

function love.load()
    math.randomseed(os.time())
    
    love.window.setTitle('The Sacred Flame')

    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        vsync = true,
        resizable = true
    })

    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, { upscale = 'normal' })

    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['boss'] = function() return BossBattleState() end,
        ['gameOver'] = function() return GameOverState() end,
        ['pause'] = function() return PauseState() end,
        ['respawn'] = function() return RespawnState() end,
        ['torchLighting'] = function() return TorchLightingState() end,
        ['victory'] = function() return VictoryState() end
    }
    gStateMachine:change('start')

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
    love.mouse.keysPressed = {}
    love.mouse.keysReleased = {}
end

function push.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)

    love.keyboard.keysPressed[key] = true
end

function love.mousepressed(x, y, key)
    love.mouse.keysPressed[key] = true
end

function love.mousereleased(x, y, key)
    love.mouse.keysReleased[key] = true 
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mouse.wasPressed(key)
    return love.mouse.keysPressed[key]
end

function love.mouse.wasReleased(key)
    return love.mouse.keysReleased[key]
end

function love.update(dt)
    gStateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push.start()
    gStateMachine:render()
    push.finish()
end