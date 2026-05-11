BossAppearState = Class{__includes=BaseState}

function BossAppearState:init(entity, room)
    self.entity = entity
    self.room = room
end

function BossAppearState:enter()
    if self.room.player then
        local px, _ = self.room.player.body:getPosition()
        local _, ey = self.entity.body:getPosition()

        local roomWidth = self.room.map.width * TILE_SIZE

        local playerSide = math.random(2) == 1 and 'right' or 'left'
        local newEx = playerSide == 'right' and px + TILE_SIZE*4 or px - TILE_SIZE*4

        -- must appear within the room bounds
        newEx = math.max(0, math.min(roomWidth - self.entity.width, newEx))
        self.entity.body:setPosition(newEx, ey)
    end
    self.entity:changeAnimation('appear')
    self.entity.currentAnimation:refresh()
end

function BossAppearState:processAI(params, dt)
    local currAnimation = self.entity.currentAnimation
    if currAnimation and currAnimation.timesPlayed > 0 then
        local nextStateOptions = {'idle', 'chase', 'disappear', 'attack1', 'attack2', 'attack3'}
        local nextState = nextStateOptions[math.random(#nextStateOptions)]

        print("Boss [appear] -> [" ..nextState .."]")
        if (nextState == 'attack1' or nextState == 'attack2' or nextState == 'attack3') and self.room.player then
            self.entity:changeState(nextState, {player = self.room.player, animation = nextState})
        elseif nextState =='chase' and self.room.player then
            self.entity:changeState(nextState, {player = self.room.player})
        else
            self.entity:changeState(nextState)
        end
    end
end