--[[
    CS50 2D, Spring 2026
    FinalProject
    
    Author: Lian Randle
    lir140@g.harvard.edu
]]

Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'

require 'src/StateMachine'
require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/BossBattleState'
require 'src/states/GameOverState'
require 'src/states/PauseState'
require 'src/states/RespawnState'
require 'src/states/TorchLightingState'
require 'src/states/VictoryState'


require 'src/constants'

require 'src/Util'

gTextures = {
    -- backgrounds
    ['templeBg1'] = love.graphics.newImage('assets/graphics/ruinedTemple/background.png'),
    ['templeBg2'] = love.graphics.newImage('assets/graphics/ruinedTemple/background2.png'),
    ['templeBg3'] = love.graphics.newImage('assets/graphics/ruinedTemple/background3.png'),
    ['templeBg4'] = love.graphics.newImage('assets/graphics/ruinedTemple/background4.png'),

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
    ['title'] = love.graphics.newFont('fonts/MedievalSharp.ttf', 64),
--     ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/MedievalSharp.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/MedievalSharp.ttf', 32),
--     ['huge'] = love.graphics.newFont('fonts/font.ttf', 64)
}

-- tweak circular alien quad
--gFrames['aliens'][9]:setViewport(105.5, 35.5, 35, 34.2)