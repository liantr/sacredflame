ENTITY_DEFS = {
    ['player'] = {
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT / 2,
        height = TILE_SIZE,
        width = TILE_SIZE,
        moveSpeed = PLAYER_WALK_SPEED,
        runSpeed = PLAYER_RUN_SPEED,
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
                frames = {3, 5},
                interval = 0.15,
                looping = false,
                texture = 'player-falling'
            },
            ['death'] = {
                frames = {1, 3, 5},
                interval = 0.5,
                looping = false,
                texture = 'player-death'
            }
        }
    }
}