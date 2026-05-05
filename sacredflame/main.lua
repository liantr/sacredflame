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

    gStateStack = StateStack()
    gStateStack:push(StartState())

    gSounds['music']:setLooping(true)
    gSounds['music']:play()

    love.keyboard.keysPressed = {}
end

function push.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)
    Timer.update(dt)
    gStateStack:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    push.start()
    gStateStack:render()
    push.finish()
end