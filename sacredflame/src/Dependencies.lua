--[[
    CS50 2D, Spring 2026
    FinalProject
    
    Author: Lian Randle
    lir140@g.harvard.edu
]]

Class = require 'lib.class'
push = require 'lib.push'
Timer = require 'lib.knife.timer'
STI = require 'lib.sti.sti'

require 'src.constants'
require 'src.Util'

require 'src.defs.room_defs'
require 'src.defs.entity_defs'
require 'src.defs.object_defs'

require 'src.gui.Panel'
require 'src.gui.Textbox'


require 'src.Animation'
require 'src.Room'
require 'src.states.StateMachine'
require 'src.states.StateStack'

require 'src.objects.Object'
require 'src.objects.Powerup'
require 'src.objects.Torch'
require 'src.VolleyAttack'
require 'src.HitBox'
require 'src.HUD'

require 'src.states.BaseState'
require 'src.states.StartState'
require 'src.states.PlayState'
require 'src.states.BossBattleState'
require 'src.states.GameOverState'
require 'src.states.PauseState'
require 'src.states.VictoryState'
require 'src.states.FadeInState'
require 'src.states.FadeOutState'
require 'src.states.DialogueState'


require 'src.entities.Entity'
require 'src.entities.Player'
require 'src.entities.Boss'
require 'src.entities.Flame'

require 'src.states.entity.EntityWalkState'
require 'src.states.entity.EntityIdleState'
require 'src.states.enemy.EnemyChaseState'
require 'src.states.enemy.EnemyAttackState'
require 'src.states.enemy.EnemyDeathState'

require 'src.states.boss.BossIdleState'
require 'src.states.boss.BossWalkState'
require 'src.states.boss.BossChaseState'
require 'src.states.boss.BossAttackState'
require 'src.states.boss.BossAppearState'
require 'src.states.boss.BossDisappearState'

require 'src.states.flame.FlameFollowingState'

require 'src.states.player.PlayerWalkState'
require 'src.states.player.PlayerRunState'
require 'src.states.player.PlayerIdleState'
require 'src.states.player.PlayerJumpState'
require 'src.states.player.PlayerFallingState'
require 'src.states.player.PlayerDeathState'
require 'src.states.player.PlayerDashState'
require 'src.states.player.PlayerSwordSwingState'
require 'src.states.player.PlayerWallHoldState'

require 'src.states.objects.TorchUnlitState'
require 'src.states.objects.TorchLitState'

gTextures = {
    -- backgrounds
    ['templeBg1'] = love.graphics.newImage('assets/graphics/ruinedTemple/background.png'),
    ['templeBg2'] = love.graphics.newImage('assets/graphics/ruinedTemple/background2.png'),
    ['templeBg3'] = love.graphics.newImage('assets/graphics/ruinedTemple/background3.png'),
    ['templeBg4'] = love.graphics.newImage('assets/graphics/ruinedTemple/background4.png'),

    -- health bars
    ['player-health-box'] = love.graphics.newImage('assets/graphics/health/health_bar_decoration.png'),
    ['player-health-bar'] = love.graphics.newImage('assets/graphics/health//health_bar.png'),

    -- objects
    ['torches'] = love.graphics.newImage('assets/graphics/objects/torches.png'),
    ['small-torches'] = love.graphics.newImage('assets/graphics/objects/small-torches.png'),
    ['wall-hold'] = love.graphics.newImage('assets/graphics/powerups/wall-hold.png'),
    ['double-jump'] = love.graphics.newImage('assets/graphics/powerups/double-jump.png'),

    -- player
    ['swordmaster-idle'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-idle.png'),
    ['swordmaster-walk'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-walk.png'),
    ['swordmaster-jump'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-jump.png'),
    ['swordmaster-falling'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-fall.png'),
    ['swordmaster-death'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-death.png'),
    ['swordmaster-run'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-run.png'),
    ['swordmaster-dash'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-dash.png'),
    ['swordmaster-attack'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-attack.png'),
    ['swordmaster-attack-combo'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-attack-combo.png'),
    ['swordmaster-wall-hold'] = love.graphics.newImage('assets/graphics/characters/swordmaster/swordmaster-wall-hold.png'),

    ['flame-idle'] = love.graphics.newImage('assets/graphics/fire/fire1.png'),

    ['archer-bandit-idle'] = love.graphics.newImage('assets/graphics/characters/archer bandit/archer-idle.png'),
    ['archer-bandit-run'] = love.graphics.newImage('assets/graphics/characters/archer bandit/archer-run.png'),
    ['archer-bandit-death'] = love.graphics.newImage('assets/graphics/characters/archer bandit/archer-death.png'),
    ['archer-bandit-attack'] = love.graphics.newImage('assets/graphics/characters/archer bandit/archer-attack.png'),
    ['archer-bandit-attack-volley'] = love.graphics.newImage('assets/graphics/characters/archer bandit/attack-volley.png'),

    ['dagger-bandit-idle'] = love.graphics.newImage('assets/graphics/characters/dagger bandit/dagger-bandit-idle.png'),
    ['dagger-bandit-run'] = love.graphics.newImage('assets/graphics/characters/dagger bandit/dagger-bandit-run.png'),
    ['dagger-bandit-attack'] = love.graphics.newImage('assets/graphics/characters/dagger bandit/dagger-bandit-attack.png'),
    ['dagger-bandit-death'] = love.graphics.newImage('assets/graphics/characters/dagger bandit/dagger-bandit-death.png'),

    ['spitter-idle'] = love.graphics.newImage('assets/graphics/characters/Spitter/spitter-idle.png'),
    ['spitter-walk'] = love.graphics.newImage('assets/graphics/characters/Spitter/spitter-walk.png'),
    ['spitter-attack'] = love.graphics.newImage('assets/graphics/characters/Spitter/spitter-attack.png'),
    ['spitter-death'] = love.graphics.newImage('assets/graphics/characters/Spitter/spitter-death.png'),

    ['ghoul-idle'] = love.graphics.newImage('assets/graphics/characters/Ghoul/ghoul-wake.png'),
    ['ghoul-walk'] = love.graphics.newImage('assets/graphics/characters/Ghoul/ghoul-walk.png'),
    ['ghoul-attack'] = love.graphics.newImage('assets/graphics/characters/Ghoul/ghoul-attack.png'),
    ['ghoul-death'] = love.graphics.newImage('assets/graphics/characters/Ghoul/ghoul-death.png'),

    ['boss-idle'] = love.graphics.newImage('assets/graphics/characters/boss/boss-idle.png'),
    ['boss-walk'] = love.graphics.newImage('assets/graphics/characters/boss/boss-walk.png'),
    ['boss-attack1'] = love.graphics.newImage('assets/graphics/characters/boss/boss-attack1.png'),
    ['boss-attack2'] = love.graphics.newImage('assets/graphics/characters/boss/boss-attack2.png'),
    ['boss-attack3'] = love.graphics.newImage('assets/graphics/characters/boss/boss-attack3.png'),
    ['boss-death'] = love.graphics.newImage('assets/graphics/characters/boss/boss-death.png'),
    ['boss-disappear'] = love.graphics.newImage('assets/graphics/characters/boss/boss-disappear.png'),
    ['boss-appear'] = love.graphics.newImage('assets/graphics/characters/boss/boss-appear.png'),

    ['particle'] = love.graphics.newImage('assets/graphics/health/particle.png'),
}

gFrames = {
    ['torch-unlit'] = GenerateQuadsFromRegion(gTextures['torches'],
        TILE_SIZE, TILE_SIZE*3, TILE_SIZE, TILE_SIZE*3, 0, 0),
    ['torch-lit'] = GenerateQuadsFromRegion(gTextures['torches'],
        TILE_SIZE, TILE_SIZE*3, TILE_SIZE*4, TILE_SIZE*3, TILE_SIZE, 0),
    ['torch-hud'] = GenerateQuadsFromRegion(gTextures['small-torches'],
        TILE_SIZE, TILE_SIZE*2, TILE_SIZE, TILE_SIZE*2, TILE_SIZE, 0),
    ['double-jump'] = GenerateQuads(gTextures['double-jump'], TILE_SIZE*1.5, TILE_SIZE*1.5),
    ['wall-hold'] = GenerateQuads(gTextures['wall-hold'], TILE_SIZE*1.5, TILE_SIZE*1.5),

    ['player-health-box'] = GenerateQuadsFromRegion(gTextures['player-health-box'],
    TILE_SIZE, TILE_SIZE+1, TILE_SIZE*4, TILE_SIZE+1,0,0),
    ['player-health-bar'] = GenerateQuadsFromRegion(gTextures['player-health-bar'],
    TILE_SIZE, TILE_SIZE, TILE_SIZE*3, TILE_SIZE,0,0),

    ['swordmaster-idle'] = GenerateQuadsFromRegion(gTextures['swordmaster-idle'],
        TILE_SIZE*3, TILE_SIZE*1.5, TILE_SIZE*3*9, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['swordmaster-walk'] = GenerateQuadsFromRegion(gTextures['swordmaster-walk'],
        TILE_SIZE*3, TILE_SIZE*1.5, TILE_SIZE*3*8, TILE_SIZE*1.5, 0, 0),
    ['swordmaster-jump'] = GenerateQuadsFromRegion(gTextures['swordmaster-jump'],
        TILE_SIZE*3, TILE_SIZE*1.5, TILE_SIZE*3*3, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['swordmaster-falling'] = GenerateQuadsFromRegion(gTextures['swordmaster-falling'],
        TILE_SIZE*3, TILE_SIZE*1.5, TILE_SIZE*3*7, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['swordmaster-death'] = GenerateQuadsFromRegion(gTextures['swordmaster-death'],
        TILE_SIZE*3, TILE_SIZE*1.5, TILE_SIZE*3*6, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['swordmaster-run'] = GenerateQuadsFromRegion(gTextures['swordmaster-run'],
        TILE_SIZE*3, TILE_SIZE*1.5, TILE_SIZE*3*8, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['swordmaster-dash'] = GenerateQuadsFromRegion(gTextures['swordmaster-dash'],
        TILE_SIZE*3, TILE_SIZE*1.5, TILE_SIZE*3*6, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['swordmaster-attack'] = GenerateQuadsFromRegion(gTextures['swordmaster-attack'],
        TILE_SIZE*7, TILE_SIZE*1.5, TILE_SIZE*7*7, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['swordmaster-attack-combo'] = GenerateQuadsFromRegion(gTextures['swordmaster-attack-combo'],
        TILE_SIZE*6, TILE_SIZE*2, TILE_SIZE*6*11, TILE_SIZE*2, 0, 0),
    ['swordmaster-wall-hold'] = GenerateQuadsFromRegion(gTextures['swordmaster-wall-hold'],
        TILE_SIZE*1.5, TILE_SIZE*1.5, TILE_SIZE*1.5, TILE_SIZE*1.5, 0, TILE_SIZE/2),

    ['flame-idle'] = GenerateQuadsFromRegion(gTextures['flame-idle'],
        TILE_SIZE, TILE_SIZE*1.5, TILE_SIZE*11, TILE_SIZE*1.5, TILE_SIZE/2, 0),

    ['archer-bandit-idle'] = GenerateQuadsFromRegion(gTextures['archer-bandit-idle'],
        TILE_SIZE*1.5, TILE_SIZE*1.5, TILE_SIZE*23, TILE_SIZE*1.5, 0, TILE_SIZE/2*11),
    ['archer-bandit-run'] = GenerateQuadsFromRegion(gTextures['archer-bandit-run'],
        TILE_SIZE*1.5, TILE_SIZE*1.5, TILE_SIZE*25, TILE_SIZE*1.5, 0, TILE_SIZE/2 * 11),
    ['archer-bandit-death'] = GenerateQuadsFromRegion(gTextures['archer-bandit-death'],
        TILE_SIZE*4, TILE_SIZE*2, TILE_SIZE*4*16, TILE_SIZE*2, 0, 0),
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
    ['dagger-bandit-death'] = GenerateQuadsFromRegion(gTextures['dagger-bandit-death'],
        TILE_SIZE*5, TILE_SIZE*1.5, TILE_SIZE*5*16, TILE_SIZE*1.5, 0, TILE_SIZE / 2),

    ['spitter-idle'] = GenerateQuadsFromRegion(gTextures['spitter-idle'],
        TILE_SIZE, TILE_SIZE*2, TILE_SIZE*11, TILE_SIZE*2, 0, TILE_SIZE/2),
    ['spitter-walk'] = GenerateQuadsFromRegion(gTextures['spitter-walk'],
        TILE_SIZE, TILE_SIZE*2, TILE_SIZE*13, TILE_SIZE*2, 0, TILE_SIZE/2),
    ['spitter-attack'] = GenerateQuadsFromRegion(gTextures['spitter-attack'],
        TILE_SIZE*2, TILE_SIZE*2, TILE_SIZE*27, TILE_SIZE*2, 0, 0),
    ['spitter-death'] = GenerateQuadsFromRegion(gTextures['spitter-death'],
        TILE_SIZE*2, TILE_SIZE*2, TILE_SIZE*2*8, TILE_SIZE*2, 0, 0),

    ['ghoul-idle'] = GenerateQuadsFromRegion(gTextures['ghoul-idle'],
        TILE_SIZE, TILE_SIZE*1.5, TILE_SIZE*4*2, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['ghoul-walk'] = GenerateQuadsFromRegion(gTextures['ghoul-walk'],
        TILE_SIZE, TILE_SIZE*1.5, TILE_SIZE*9*2, TILE_SIZE*1.5, 0, TILE_SIZE/2),
    ['ghoul-attack'] = GenerateQuadsFromRegion(gTextures['ghoul-attack'],
        TILE_SIZE*3, TILE_SIZE*2, TILE_SIZE*7*6, TILE_SIZE*2, 0, 0),
    ['ghoul-death'] = GenerateQuadsFromRegion(gTextures['ghoul-death'],
        TILE_SIZE*2, TILE_SIZE*2, TILE_SIZE*2*8, TILE_SIZE*2, 0, 0),

    ['boss-idle'] = GenerateQuadsFromRegion(gTextures['boss-idle'],
        TILE_SIZE*5, TILE_SIZE*4, TILE_SIZE*9*5, TILE_SIZE*4, 0, 0),
    ['boss-walk'] = GenerateQuadsFromRegion(gTextures['boss-walk'],
        TILE_SIZE*5, TILE_SIZE*4, TILE_SIZE*2*5, TILE_SIZE*4, 0, 0),
    ['boss-disappear'] = GenerateQuadsFromRegion(gTextures['boss-disappear'],
        TILE_SIZE*6, TILE_SIZE*4, TILE_SIZE*6*5, TILE_SIZE*4, 0, 0),
    ['boss-appear'] = GenerateQuadsFromRegion(gTextures['boss-appear'],
        TILE_SIZE*6, TILE_SIZE*4, TILE_SIZE*6*9, TILE_SIZE*4, 0, 0),
    ['boss-death'] = GenerateQuadsFromRegion(gTextures['boss-death'],
        TILE_SIZE*6, TILE_SIZE*3, TILE_SIZE*6*36, TILE_SIZE*3, 0, 0),
    ['boss-attack1'] = GenerateQuadsFromRegion(gTextures['boss-attack1'],
        TILE_SIZE*18, TILE_SIZE*3, (TILE_SIZE*18)*5, TILE_SIZE*3*2, 0, 0),
    ['boss-attack2'] = GenerateQuadsFromRegion(gTextures['boss-attack2'],
        TILE_SIZE*5, TILE_SIZE*4, TILE_SIZE*5*16, TILE_SIZE*4, 0, 0),
    ['boss-attack3'] = GenerateQuadsFromRegion(gTextures['boss-attack3'],
        (TILE_SIZE*16), TILE_SIZE*7.5, (TILE_SIZE * 16) * 30, TILE_SIZE * 7.5, 0, 0),
}

gTextures['boss-attack1']:setFilter('nearest', 'nearest')
gTextures['boss-attack2']:setFilter('nearest', 'nearest')
gTextures['boss-attack3']:setFilter('nearest', 'nearest')

gSounds = {
    ['temple'] = love.audio.newSource('assets/sounds/temple-background.wav', 'static'),
    ['depths'] = love.audio.newSource('assets/sounds/depths-background.wav', 'static'),
    ['boss'] = love.audio.newSource('assets/sounds/boss-battle.wav', 'static'),
    ['hit-player'] = love.audio.newSource('assets/sounds/hit_player.wav', 'static'),
    ['hit-enemy'] = love.audio.newSource('assets/sounds/hit_enemy.wav', 'static'),
}

gFonts = {
    ['title'] = love.graphics.newFont('fonts/MedievalSharp.ttf', 64),
    ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['medium'] = love.graphics.newFont('fonts/MedievalSharp.ttf', 16),
    ['large'] = love.graphics.newFont('fonts/MedievalSharp.ttf', 32),
--     ['huge'] = love.graphics.newFont('fonts/font.ttf', 64)
}