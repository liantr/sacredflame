function GenerateQuads(atlas, tilewidth, tileheight)
    local sheetWidth = atlas:getWidth() / tilewidth
    local sheetHeight = atlas:getHeight() / tileheight

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(x * tilewidth, y * tileheight, tilewidth,
                tileheight, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function GenerateQuadsFromRegion(atlas, tile_width, tile_height, region_width, region_height, startX, startY)

    -- coordinates where we should start splitting the texture
    startX = startX or 0
    startY = startY or 0

    local sheetWidth = region_width / tile_width
    local sheetHeight = region_height / tile_height

    local sheetCounter = 1
    local spritesheet = {}

    for y = 0, sheetHeight - 1 do
        for x = 0, sheetWidth - 1 do
            spritesheet[sheetCounter] =
                love.graphics.newQuad(startX + x * tile_width, startY + y * tile_height, tile_width,
                tile_height, atlas:getDimensions())
            sheetCounter = sheetCounter + 1
        end
    end

    return spritesheet
end

function createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval,
            looping = animationDef.looping,
            offsetX = animationDef.offsetX,
            offsetY = animationDef.offsetY,
            name = k
        }
    end

    return animationsReturned
end

function grabWall(player)
    if player.touchingWall and
        player.canHoldWall and
        player.wallHoldAllowed and
        (love.keyboard.isDown('left') or love.keyboard.isDown('right')) then
            local playerX, _ = player.body:getPosition()
            local playerFacingWall = (player.wallX > playerX and player.direction == 'right')
                or (player.wallX < playerX and player.direction == 'left')
                if playerFacingWall then
                    player:changeState('wall-hold')
                end
    end
end

function handleMovementInput(player, speed)
    local _, yVel = player.body:getLinearVelocity()
    if love.keyboard.isDown('left')then
        player.direction = 'left'
        player.body:setLinearVelocity(-speed, yVel)
        return true
    elseif love.keyboard.isDown("right") then
        player.direction = 'right'
        player.body:setLinearVelocity(speed, yVel)
        return true
    end

    return false
end

function getDistanceFromPlayer(entity, player)
    local ex, _ = entity:getPosition()
    local px, _ = player:getPosition()
    return px - ex
end

function damageEnemy(room, hitBox)
    for k, enemy in pairs(room.enemies) do
        if enemy:collides(hitBox) and enemy.health > 0 then
            enemy:damage(1)
            gSounds['hit-enemy']:play()
            return true
        end
    end
    return false
end

function damagePlayer(room, hitBox)
    local player = room.player
    if player:collides(hitBox) and player.health > 0 then
        player:damage(1)
        gSounds['hit-player']:play()
        return true
    end
    return false
end

function createEntityHitBoxes(entity)
    local result = {}

    -- create hitbox based on the direction
    if entity.hitBoxes then
        local direction = entity.direction
        local hitBoxX, hitBoxY
        local ex, ey = entity:getPosition()
        for animName, hitBoxes in pairs(entity.hitBoxes) do

            result[animName] = {}
            for _, hitBox in pairs(hitBoxes) do
                local offsetX = hitBox.offsetX or 0
                local offsetY = hitBox.offsetY or 0
                if hitBox.bidirectional then
                    hitBoxX = ex - hitBox.width - entity.width/2 - offsetX
                    hitBoxY = ey + offsetY
                    table.insert(result[animName], {
                        frames = hitBox.frames,
                        hitBox = HitBox(hitBoxX, hitBoxY, hitBox.width, hitBox.height)
                    })
                else
                    if direction == 'left' then
                        hitBoxX = ex - hitBox.width - entity.width/2 - offsetX
                        hitBoxY = ey + offsetY
                    elseif direction == 'right' then
                        hitBoxX = ex + entity.width/2 + offsetX
                        hitBoxY = ey + offsetY
                    end
                    table.insert(result[animName], {
                        frames = hitBox.frames,
                        hitBox = HitBox(hitBoxX, hitBoxY, hitBox.width, hitBox.height)
                    })
                end      
            end
        end
    end

    return result
end

function getHitBoxes(state)
    local animation = state.entity.currentAnimation
    if not animation or not state.hitBoxes then return nil end

    local hitBoxes = state.hitBoxes[animation.name]

    if not hitBoxes then return nil end
    local currFrame = animation:getCurrentFrame()
    local results = {}

    for _, hitBox in pairs(hitBoxes) do
        for _,frame in pairs(hitBox.frames) do
            if frame == currFrame then
                table.insert(results, hitBox)
            end
        end
    end
    
    return results
end

function generateFramesList(n, start, endNum)
    if not start then start = 1 end
    if endNum then n = endNum end

    local frames = {}
    for i=start,n do
        table.insert(frames, i)
    end

    return frames
end

function generateBossAttack3HitBoxesDef()
    local defHitBoxes = {
        {
            width = TILE_SIZE,
            height = TILE_SIZE*2.2,
            offsetX = 0,
            offsetY = -TILE_SIZE*4,
            frames = generateFramesList(14),
            bidirectional = true
        },
        {
            width = TILE_SIZE,
            height = TILE_SIZE*2.2,
            offsetX = -TILE_SIZE*3,
            offsetY = -TILE_SIZE*4,
            frames = generateFramesList(14),
            bidirectional = true
        },
        {
            width = TILE_SIZE*1.5,
            height = TILE_SIZE*2,
            offsetX = -TILE_SIZE/2,
            offsetY = -TILE_SIZE*4,
            frames = generateFramesList(30, 15, 17),
            bidirectional = true
        },
        {
            width = TILE_SIZE*1.5,
            height = TILE_SIZE*2,
            offsetX = -TILE_SIZE*3,
            offsetY = -TILE_SIZE*4,
            frames = generateFramesList(30, 15, 17),
            bidirectional = true
        },
        {
            width = TILE_SIZE,
            height = TILE_SIZE,
            offsetX = -TILE_SIZE/2,
            offsetY = -TILE_SIZE*4.5,
            frames = generateFramesList(30, 20, 21),
            bidirectional = true
        },
        {
            width = TILE_SIZE,
            height = TILE_SIZE,
            offsetX = -TILE_SIZE*2.5,
            offsetY = -TILE_SIZE*4.5,
            frames = generateFramesList(30, 20, 21),
            bidirectional = true 
        },
        {
            width = TILE_SIZE*1.5,
            height = TILE_SIZE,
            offsetX = -TILE_SIZE/2,
            offsetY = -TILE_SIZE*3.5,
            frames = generateFramesList(30, 18, 19),
            bidirectional = true
        },
        {
            width = TILE_SIZE*1.5,
            height = TILE_SIZE,
            offsetX = -TILE_SIZE*3,
            offsetY = -TILE_SIZE*3.5,
            frames = generateFramesList(30, 18, 19),
            bidirectional = true
        }
    }

    -- start values for the first part of the attack
    local offsetXLeft = 0
    local offsetYLeft = -TILE_SIZE*2.5
    local offsetXRight = -TILE_SIZE*2.5
    local offsetYRight = -TILE_SIZE*2.5
    
    -- and for the second
    local offsetXLeft2 = TILE_SIZE*0.5
    local offsetYLeft2 = -TILE_SIZE*3.5
    local offsetXRight2 = -TILE_SIZE*3
    local offsetYRight2 = -TILE_SIZE*3.5
    for i=1,12 do
        if i <= 9 then
            table.insert(defHitBoxes, {
                width = TILE_SIZE/2,
                height = TILE_SIZE/2,
                offsetX = offsetXLeft,
                offsetY = offsetYLeft,
                frames = {18},
                bidirectional = true
            })

            table.insert(defHitBoxes, {
                width = TILE_SIZE/2,
                height = TILE_SIZE/2,
                offsetX = offsetXRight,
                offsetY = offsetYRight,
                frames = {18},
                bidirectional = true
            })

            offsetXLeft = offsetXLeft + TILE_SIZE*0.5
            offsetYLeft = offsetYLeft + TILE_SIZE*0.5

            offsetXRight = offsetXRight - TILE_SIZE*0.5
            offsetYRight = offsetYRight + TILE_SIZE*0.5
        end

        table.insert(defHitBoxes, {
            width = TILE_SIZE/2,
            height = TILE_SIZE/2,
            offsetX = offsetXLeft2,
            offsetY = offsetYLeft2,
            frames = {22},
            bidirectional = true
        })

        table.insert(defHitBoxes, {
                width = TILE_SIZE/2,
                height = TILE_SIZE/2,
                offsetX = offsetXRight2,
                offsetY = offsetYRight2,
                frames = {22},
                bidirectional = true
            })

        offsetXLeft2 = offsetXLeft2 + TILE_SIZE*0.5
        offsetYLeft2 = offsetYLeft2 + TILE_SIZE*0.5

        offsetXRight2 = offsetXRight2 - TILE_SIZE*0.5
        offsetYRight2 = offsetYRight2 + TILE_SIZE*0.5
    end

    return defHitBoxes
end