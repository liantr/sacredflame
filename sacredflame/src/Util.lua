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
            offsetY = animationDef.offsetY
        }
    end

    return animationsReturned
end

function handleMovementInput(player)
    local _, yVel = player.body:getLinearVelocity()
    if love.keyboard.isDown('left')then
        player.direction = 'left'
        if love.keyboard.isDown('z') then
            player.body:setLinearVelocity(-player.runSpeed, yVel)
        else
            player.body:setLinearVelocity(-player.moveSpeed, yVel)
        end
        return true
    elseif love.keyboard.isDown("right") then
        player.direction = 'right'
        if love.keyboard.isDown('z') then
            player.body:setLinearVelocity(player.runSpeed, yVel)
        else
            player.body:setLinearVelocity(player.moveSpeed, yVel)
        end
        return true
    end

    return false
end

function getDistanceFromPlayer(entity, player)
    local ex, _ = entity:getPosition()
    local px, _ = player:getPosition()
    return px - ex
end