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

require 'src.VolleyAttack'

require 'src/states/BaseState'
require 'src/states/StartState'
require 'src/states/PlayState'
require 'src/states/BossBattleState'
require 'src/states/GameOverState'
require 'src/states/PauseState'
require 'src/states/RespawnState'
require 'src/states/TorchLightingState'
require 'src/states/VictoryState'

require 'src.entities.Entity'
require 'src.entities.Player'
require 'src.entities.Flame'

require 'src/states/entity/EntityWalkState'
require 'src/states/entity/EntityIdleState'
require 'src.states.enemy.EnemyChaseState'
require 'src.states.enemy.EnemyAttackState'

require 'src/states/flame/FlameFollowingState'

require 'src.states.player.PlayerWalkState'
require 'src.states.player.PlayerIdleState'
require 'src.states.player.PlayerJumpState'
require 'src.states.player.PlayerFallingState'
require 'src.states.player.PlayerDeathState'
require 'src.states.player.PlayerSwordSwingState'


gTextures = {
    -- backgrounds
    ['templeBg1'] = love.graphics.newImage('assets/graphics/ruinedTemple/background.png'),
    ['templeBg2'] = love.graphics.newImage('assets/graphics/ruinedTemple/background2.png'),
    ['templeBg3'] = love.graphics.newImage('assets/graphics/ruinedTemple/background3.png'),
    ['templeBg4'] = love.graphics.newImage('assets/graphics/ruinedTemple/background4.png'),

    -- player
    ['player-idle'] = love.graphics.newImage('assets/graphics/characters/Tiny Swordmaster/swordsman-idle.png'),
    ['player-walk'] = love.graphics.newImage('assets/graphics/characters/Tiny Swordmaster/swordsman-walk.png'),
    ['player-jump'] = love.graphics.newImage('assets/graphics/characters/Tiny Swordmaster/swordsman-jump.png'),
    ['player-falling'] = love.graphics.newImage('assets/graphics/characters/Tiny Swordmaster/swordsman-falling.png'),
    ['player-death'] = love.graphics.newImage('assets/graphics/characters/Tiny Swordmaster/swordsman-death.png'),
    ['player-attack'] = love.graphics.newImage('assets/graphics/characters/Tiny Swordmaster/swordsman-attack.png'),
    ['player-attack-combo'] = love.graphics.newImage('assets/graphics/characters/Tiny Swordmaster/swordsman-attack-combo.png'),

    ['flame-idle'] = love.graphics.newImage('assets/graphics/fire/fire1.png'),

    ['archer-bandit-idle'] = love.graphics.newImage('assets/graphics/characters/Archer Bandit/archer-idle.png'),
    ['archer-bandit-run'] = love.graphics.newImage('assets/graphics/characters/Archer Bandit/archer-run.png'),
    ['archer-bandit-attack'] = love.graphics.newImage('assets/graphics/characters/Archer Bandit/archer-attack.png'),
    ['archer-bandit-attack-volley'] = love.graphics.newImage('assets/graphics/characters/Archer Bandit/attack-volley.png'),

    ['dagger-bandit-idle'] = love.graphics.newImage('assets/graphics/characters/Dagger Bandit/dagger-bandit-idle.png'),
    ['dagger-bandit-run'] = love.graphics.newImage('assets/graphics/characters/Dagger Bandit/dagger-bandit-run.png'),
    ['dagger-bandit-attack'] = love.graphics.newImage('assets/graphics/characters/Dagger Bandit/dagger-bandit-attack.png'),

    ['spitter-idle'] = love.graphics.newImage('assets/graphics/characters/Spitter/spitter-idle.png'),
    ['spitter-walk'] = love.graphics.newImage('assets/graphics/characters/Spitter/spitter-walk.png'),
    ['spitter-attack'] = love.graphics.newImage('assets/graphics/characters/Spitter/spitter-attack.png'),

    ['ghoul-idle'] = love.graphics.newImage('assets/graphics/characters/Ghoul/ghoul-wake.png'),
    ['ghoul-walk'] = love.graphics.newImage('assets/graphics/characters/Ghoul/ghoul-walk.png'),
    ['ghoul-attack'] = love.graphics.newImage('assets/graphics/characters/Ghoul/ghoul-attack.png'),
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

    ['flame-idle'] = GenerateQuadsFromRegion(gTextures['flame-idle'],
        TILE_SIZE, TILE_SIZE*1.5, TILE_SIZE*11, TILE_SIZE*1.5, TILE_SIZE/2, 0),

    ['archer-bandit-idle'] = GenerateQuadsFromRegion(gTextures['archer-bandit-idle'],
        TILE_SIZE*1.5, TILE_SIZE*1.5, TILE_SIZE*23, TILE_SIZE*1.5, 0, TILE_SIZE/2*11),
    ['archer-bandit-run'] = GenerateQuadsFromRegion(gTextures['archer-bandit-run'],
        TILE_SIZE*1.5, TILE_SIZE*1.5, TILE_SIZE*25, TILE_SIZE*1.5, 0, TILE_SIZE/2 * 11),
    ['archer-bandit-attack'] = GenerateQuadsFromRegion(gTextures['archer-bandit-attack'],
        TILE_SIZE*2, TILE_SIZE*7, TILE_SIZE*2*2*19, TILE_SIZE*7, 0, 0),
    ['archer-bandit-attack-volley'] = GenerateQuadsFromRegion(gTextures['archer-bandit-attack-volley'],
        TILE_SIZE*4, TILE_SIZE*7, TILE_SIZE*2*16, TILE_SIZE*7, 0, 0),

    ['dagger-bandit-idle'] = GenerateQuadsFromRegion(gTextures['dagger-bandit-idle'],
        TILE_SIZE, TILE_SIZE*1.5, TILE_SIZE*16, TILE_SIZE*1.5, 0, TILE_SIZE/2*7),
    ['dagger-bandit-run'] = GenerateQuadsFromRegion(gTextures['dagger-bandit-run'],
        TILE_SIZE, TILE_SIZE*1.5, TILE_SIZE*16, TILE_SIZE*1.5, 0, TILE_SIZE/2 * 7),
    ['dagger-bandit-attack'] = GenerateQuadsFromRegion(gTextures['dagger-bandit-attack'],
        TILE_SIZE*4, TILE_SIZE*1.5, TILE_SIZE*28, TILE_SIZE*1.5, 0, TILE_SIZE * 3.5),

    ['spitter-idle'] = GenerateQuadsFromRegion(gTextures['spitter-idle'],
        TILE_SIZE, TILE_SIZE*2, TILE_SIZE*11, TILE_SIZE*2, 0, TILE_SIZE/2),
    ['spitter-walk'] = GenerateQuadsFromRegion(gTextures['spitter-walk'],
        TILE_SIZE, TILE_SIZE*2, TILE_SIZE*13, TILE_SIZE*2, 0, TILE_SIZE/2),
    ['spitter-attack'] = GenerateQuadsFromRegion(gTextures['spitter-attack'],
        TILE_SIZE*2, TILE_SIZE*2, TILE_SIZE*27, TILE_SIZE*2, 0, 0),

    ['ghoul-idle'] = GenerateQuadsFromRegion(gTextures['ghoul-idle'],
        TILE_SIZE, TILE_SIZE*1.5, TILE_SIZE*4*2, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['ghoul-walk'] = GenerateQuadsFromRegion(gTextures['ghoul-walk'],
        TILE_SIZE, TILE_SIZE*1.5, TILE_SIZE*9*2, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['ghoul-attack'] = GenerateQuadsFromRegion(gTextures['ghoul-attack'],
        TILE_SIZE*3, TILE_SIZE*2, TILE_SIZE*7*6, TILE_SIZE*2, 0, 0),
}

print("total frames:" ..tostring(#gFrames['ghoul-idle']))


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