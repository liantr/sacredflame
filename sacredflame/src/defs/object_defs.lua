OBJECT_DEFS = {
    ['torch'] = {
        width = TILE_SIZE,
        height = TILE_SIZE * 3,
        bodyType = 'static',
        category = TORCH_CATEGORY,
        texture = 'torches',
        animations = {
            ['unlit'] = {
                frames = {1},
                interval = 0.5,
                texture = 'torch-unlit'
            },
            ['lit'] = {
                frames = {2,3,4},
                interval = 0.5,
                texture = 'torch-lit'
            }
        }
    }
}