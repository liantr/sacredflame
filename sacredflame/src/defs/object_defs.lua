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
    }
}