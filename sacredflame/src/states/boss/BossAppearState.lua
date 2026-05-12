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
        newEx = math.max(TILE_SIZE * 2, math.min(roomWidth - self.entity.width - TILE_SIZE * 2, newEx))
        self.entity.body:setPosition(newEx, ey)
    end
    self.entity:changeAnimation('appear')
    self.entity.currentAnimation:refresh()
end

function BossAppearState:processAI(params, dt)
    local currAnimation = self.entity.currentAnimation
    if currAnimation and currAnimation.timesPlayed > 0 then

        -- from here either chase or immediately attack
        if math.random(2) == 1 then
            print("Boss [appear] -> [chase]")

            self.entity:changeState('chase', {player = self.room.player})
        else
            local attackOptions = { 'attack1', 'attack2', 'attack3' }
            local attack = attackOptions[math.random(#attackOptions)]
            print("Boss [appear] -> [" ..attack .."]")

            self.entity:changeState(attack, {player = self.room.player, animation = attack})
        end

    end
end