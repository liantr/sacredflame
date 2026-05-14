OBJECT_DEFS = {
    ['torch'] = {
        width = TILE_SIZE,
        type = 'torch',
        height = TILE_SIZE * 3,
        bodyType = 'static',
        category = TORCH_CATEGORY,
        texture = 'torches',
        animations = {
            ['unlit'] = {
                frames = { 1 },
                interval = 0.5,
                texture = 'torch-unlit'
            },
            ['lit'] = {
                frames = generateFramesList(4, 2),
                interval = 0.5,
                texture = 'torch-lit'
            }
        }
    },
    ['wall-hold'] = {
        type = 'powerup',
        name = 'wall-hold',
        bodyType = 'kinematic',
        texture = 'wall-hold',
        category = POWERUP_CATEGORY,
        width = TILE_SIZE * 0.75,
        height = TILE_SIZE * 0.75,
        acquisitionText = "Wall hold acquired",
        animations = {}
    },
    ['double-jump'] = {
        type = 'powerup',
        name = 'double-jump',
        bodyType = 'kinematic',
        texture = 'double-jump',
        category = POWERUP_CATEGORY,
        width = TILE_SIZE * 0.75,
        height = TILE_SIZE * 0.75,
        acquisitionText = "Double jump acquired",
        animations = {}
    },
    ['door'] = {
        type = 'door',
        name = 'door',
        bodyType = 'static',
        texture = 'door',
        category = DOOR_CATEGORY,
        width = TILE_SIZE,
        height = TILE_SIZE * 3,
        animations = {
            ['open'] = {
                frames = generateFramesList(15),
                interval = 0.5,
                texture = 'door',
                looping = false,
                 offsetX = -TILE_SIZE * 0.5,
                offsetY = TILE_SIZE * 1.5
            },
            ['closed'] = {
                frames = generateFramesList(1),
                interval = 0.5,
                texture = 'door',
                offsetX = -TILE_SIZE * 0.5,
                offsetY = TILE_SIZE * 1.5
            }
        }
    }
}