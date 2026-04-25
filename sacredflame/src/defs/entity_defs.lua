ENTITY_DEFS = {
    ['player'] = {
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT / 2,
        height = TILE_SIZE,
        width = TILE_SIZE,
        moveSpeed = PLAYER_WALK_SPEED,
        runSpeed = PLAYER_RUN_SPEED,
        health = 100,
        bodyType = 'dynamic',
        category = PLAYER_CATEGORY,
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
                frames = {5},
                interval = 0.15,
                looping = true,
                texture = 'player-falling'
            },
            ['death'] = {
                frames = {1, 3, 5},
                interval = 0.5,
                looping = false,
                texture = 'player-death'
            },
            ['swing-sword'] = {
                frames = {1, 2, 3, 4, 5, 6},
                interval = 0.08,
                looping = false,
                texture = 'player-attack'
            },
            ['swing-sword-combo'] = {
                frames = (function()
                    local frames = {}
                    for i=1,17 do
                        table.insert(frames, i)
                    end
                    return frames
                end)(),
                interval = 0.08,
                looping = false,
                texture = 'player-attack-combo'
            },
        }
    },
    ['flame'] = {
        height = TILE_SIZE*1.5,
        width = TILE_SIZE*1.5,
        moveSpeed = FLAME_MOVE_SPEED,
        bodyType = 'kinematic',
        category = FLAME_CATEGORY,
        animations = {
            ['idle'] = {
                frames = {1, 3, 5, 7, 9, 11},
                interval = 0.5,
                texture = 'flame-idle'
            }
        }
    },
    ['archer-bandit'] = {
        height = TILE_SIZE*1.5,
        width = TILE_SIZE*1.5,
        moveSpeed = 50,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE * 3,
        bodyType = 'dynamic',
        category = ARCHER_BANDIT_CATEGORY,
        animations = {
            ['idle'] = {
                frames = {1, 3, 5, 7, 9, 11,13, 15},
                interval = 0.15,
                texture = 'archer-bandit-idle'
            },
            ['walk'] = {
                frames = {1, 3, 5, 7, 9, 11, 13, 15},
                interval = 0.15,
                texture = 'archer-bandit-run'
            }
        }
    },
    ['dagger-bandit'] = {
        height = TILE_SIZE*1.5,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = DAGGER_BANDIT_CATEGORY,
        animations = {
            ['idle'] = {
                frames = {1, 3, 5, 7, 9, 11,13, 15},
                interval = 0.15,
                texture = 'dagger-bandit-idle'
            },
            ['walk'] = {
                frames = {1, 3, 5, 7, 9, 11, 13, 15},
                interval = 0.15,
                texture = 'dagger-bandit-run'
            }
        }
    },
    ['spitter'] = {
        height = TILE_SIZE*2,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = SPITTER_CATEGORY,
        animations = {
            ['idle'] = {
                frames = {1, 3, 5, 7, 9, 11},
                interval = 0.15,
                texture = 'spitter-idle'
            },
            ['walk'] = {
                frames = {1, 3, 5, 7, 9, 11, 13},
                interval = 0.15,
                texture = 'spitter-walk'
            }
        }
    },
    ['ghoul'] = {
        height = TILE_SIZE*2,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = GHOUL_CATEGORY,
        sleep = true,
        animations = {
            ['sleep'] = {
                frames = {1},
                interval = 1,
                texture = 'ghoul-sleep'
            }
            -- ['idle'] = {
            --     frames = {1, 3, 5, 7, 9, 11},
            --     interval = 0.15,
            --     texture = 'ghoul-idle'
            -- },
            -- ['walk'] = {
            --     frames = {1, 3, 5, 7, 9, 11, 13},
            --     interval = 0.15,
            --     texture = 'ghoul-walk'
            -- }
        }
    }
}