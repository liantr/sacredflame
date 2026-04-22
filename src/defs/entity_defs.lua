ENTITY_DEFS = {
    ['player'] = {
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT / 2,
        height = TILE_SIZE,
        width = TILE_SIZE,
        moveSpeed = 100,
        health = 100,
        animations = {
            ['idle'] = {
                frames = {1, 3, 5, 7, 9, 11, 13},
                interval = 0.15,
                texture = 'player-idle'
            },
            ['walk'] = {
                frames = {1, 3, 5, 7, 9, 11, 13, 15},
                interval = 0.15,
                texture = 'player-walk'
            },
            ['jump'] = {
                frames = {1, 3},
                interval = 0.15,
                looping = false,
                texture = 'player-jump'
            },
            ['falling'] = {
                frames = {1, 3},
                interval = 0.15,
                looping = false,
                texture = 'player-falling'
            }
        }
    }
}