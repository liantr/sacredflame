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
    self.playState:update(dt)
end

function BossBattleState:exit()
end

function BossBattleState:render()
end