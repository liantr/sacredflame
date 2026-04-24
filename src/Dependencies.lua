--[[
    CS50 2D, Spring 2026
    FinalProject
    
    Author: Lian Randle
    lir140@g.harvard.edu
]]

Class = require 'lib/class'
push = require 'lib/push'
Timer = require 'lib/knife.timer'
STI = require 'lib/sti/sti'

require 'src/constants'

require 'src/defs/room_defs'
require 'src/defs/entity_defs'

require 'src/Animation'
require 'src/Util'
require 'src/Room'
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

require 'src/Entity'
require 'src/Player'

require 'src/states/entity/EntityWalkState'
require 'src/states/entity/EntityIdleState'

require 'src/states/player/PlayerWalkState'
require 'src/states/player/PlayerIdleState'
require 'src/states/player/PlayerJumpState'
require 'src/states/player/PlayerFallingState'
require 'src.states.player.PlayerDeathState'
require 'src.states.player.PlayerSwordSwingState'


gTextures = {
    -- backgrounds
    ['templeBg1'] = love.graphics.newImage('assets/graphics/ruinedTemple/background.png'),
    ['templeBg2'] = love.graphics.newImage('assets/graphics/ruinedTemple/background2.png'),
    ['templeBg3'] = love.graphics.newImage('assets/graphics/ruinedTemple/background3.png'),
    ['templeBg4'] = love.graphics.newImage('assets/graphics/ruinedTemple/background4.png'),

    -- player
    ['player-idle'] = love.graphics.newImage('assets/graphics/The Dark Series/Character/Tiny Swordmaster/swordsman-idle.png'),
    ['player-walk'] = love.graphics.newImage('assets/graphics/The Dark Series/Character/Tiny Swordmaster/swordsman-walk.png'),
    ['player-jump'] = love.graphics.newImage('assets/graphics/The Dark Series/Character/Tiny Swordmaster/swordsman-jump.png'),
    ['player-falling'] = love.graphics.newImage('assets/graphics/The Dark Series/Character/Tiny Swordmaster/swordsman-falling.png'),
    ['player-death'] = love.graphics.newImage('assets/graphics/The Dark Series/Character/Tiny Swordmaster/swordsman-death.png'),
    ['player-attack'] = love.graphics.newImage('assets/graphics/The Dark Series/Character/Tiny Swordmaster/swordsman-attack.png'),
    ['player-attack-combo'] = love.graphics.newImage('assets/graphics/The Dark Series/Character/Tiny Swordmaster/swordsman-attack-combo.png')
}

gFrames = {
    ['player-idle'] = GenerateQuadsFromRegion(gTextures['player-idle'],
        TILE_SIZE, TILE_SIZE, TILE_SIZE*13, TILE_SIZE, TILE_SIZE/2, TILE_SIZE),
    ['player-walk'] = GenerateQuadsFromRegion(gTextures['player-walk'],
        TILE_SIZE, TILE_SIZE, TILE_SIZE*15, TILE_SIZE, TILE_SIZE/2, TILE_SIZE),
    ['player-jump'] = GenerateQuadsFromRegion(gTextures['player-jump'],
        TILE_SIZE, TILE_SIZE, TILE_SIZE*3, TILE_SIZE, TILE_SIZE/2, TILE_SIZE),
    ['player-falling'] = GenerateQuadsFromRegion(gTextures['player-falling'],
        TILE_SIZE, TILE_SIZE, TILE_SIZE*5, TILE_SIZE, TILE_SIZE/2, TILE_SIZE),
    ['player-death'] = GenerateQuadsFromRegion(gTextures['player-death'],
        TILE_SIZE, TILE_SIZE, TILE_SIZE*11, TILE_SIZE, TILE_SIZE/2, TILE_SIZE),
    ['player-attack'] = GenerateQuadsFromRegion(gTextures['player-attack'],
        TILE_SIZE*2, TILE_SIZE, TILE_SIZE*2*6, TILE_SIZE, 0, TILE_SIZE),
    ['player-attack-combo'] = GenerateQuadsFromRegion(gTextures['player-attack-combo'],
        TILE_SIZE*2, TILE_SIZE*2, TILE_SIZE*17*2, TILE_SIZE*2, 0, 0),
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