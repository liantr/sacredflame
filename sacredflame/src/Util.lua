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

--[[
    Generates quads from a specific region of the atlas
]]
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

--[[
    Initializes animation objects from the def file for an entity or object
]]
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

--[[
    Gets the horizontal distance of an enemy from the player
]]
function getXDistanceFromPlayer(entity, player)
    local ex, _ = entity:getPosition()
    local px, _ = player:getPosition()
    return px - ex
end

--[[
    Gets the vertical distance of an enemy from the player
]]
function getYDistanceFromPlayer(entity, player)
    local _, ey = entity:getPosition()
    local _, py = player:getPosition()
    return py - ey
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

--[[
    Creates a hit box table per attack animation from entity_defs
    Returns { [animationName] = { frames, hitBox } }
]]
function createEntityHitBoxes(entity)
    local result = {}

    -- create hit box based on the direction
    if entity.hitBoxes then
        local direction = entity.direction
        local hitBoxX, hitBoxY
        local ex, ey = entity:getPosition()

        for animName, hitBoxes in pairs(entity.hitBoxes) do

            result[animName] = {}
            for _, hitBox in pairs(hitBoxes) do
                local offsetX = hitBox.offsetX or 0
                local offsetY = hitBox.offsetY or 0

                -- bidirectional hit boxes aren't affected by direction
                if hitBox.bidirectional then
                    hitBoxX = ex - hitBox.width - entity.width / 2 - offsetX
                    hitBoxY = ey + offsetY
                    table.insert(result[animName], {
                        frames = hitBox.frames,
                        hitBox = HitBox(hitBoxX, hitBoxY, hitBox.width, hitBox.height)
                    })
                else
                    if direction == 'left' then
                        hitBoxX = ex - hitBox.width - entity.width / 2 - offsetX
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

--[[
    Returns the current active hit boxes
]]
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

--[[
    Generates a list of frame numbers
]]
function generateFramesList(endNum, start, step)
    if not start then start = 1 end
    if not step then step = 1 end

    local frames = {}
    for i = start, endNum, step do
        table.insert(frames, i)
    end

    return frames
end