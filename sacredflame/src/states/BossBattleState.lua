BossBattleState = Class{__includes = BaseState}

function BossBattleState:init(playState)
    self.playState = playState
    self.room = self.playState.currentRoom
end

function BossBattleState:enter()
    local prevMusic = self.room.music
    gSounds[prevMusic]:stop()
    gSounds['boss']:play()
    gSounds['boss']:setLooping(true)

    self.room:spawnBoss()
end

function BossBattleState:update(dt)
    -- BossBattleState is on top of the PlayState
    -- StateStack only updates the top most state, but the PlayState should still update
    -- otherwise gameplay breaks
    self.playState:update(dt)
end