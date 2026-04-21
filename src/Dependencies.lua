--[[
    CS50 2D, Spring 2026
    FinalProject
    
    Author: Lian Randle
    lir140@g.harvard.edu
]]

Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/Util'

gTextures = {
    -- backgrounds
    --['blue-desert'] = love.graphics.newImage('graphics/blue_desert.png'),

    -- aliens
    --['aliens'] = love.graphics.newImage('graphics/aliens.png'),
}

gFrames = {
    --['aliens'] = GenerateQuads(gTextures['aliens'], 35, 35),
    -- ['wood'] = {
    --     love.graphics.newQuad(0, 35, 110, 35, gTextures['wood']:getDimensions()), 
    -- }
}

gSounds = {
    --['music'] = love.audio.newSource('sounds/music.wav', 'static')
}

gFonts = {
--     ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
--     ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
--     ['large'] = love.graphics.newFont('fonts/font.ttf', 32),
--     ['huge'] = love.graphics.newFont('fonts/font.ttf', 64)
}

-- tweak circular alien quad
--gFrames['aliens'][9]:setViewport(105.5, 35.5, 35, 34.2)