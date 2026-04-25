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
        rangedAttack = true,
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
            },
            ['attack'] = {
                frames = (function()
                    local frames = {}
                    for i=0,37,2 do
                        table.insert(frames, i + 1)
                    end

                    return frames
                end)(),
                looping = false,
                interval = 0.05,
                texture = 'archer-bandit-attack'
            }
        }
    },
    ['dagger-bandit'] = {
        -- TODO fix animation rendering and end position
        height = TILE_SIZE*1.5,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = DAGGER_BANDIT_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE * 2,
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
            },
            ['attack'] = {
                frames = (function()
                    local frames = {}
                    for i=1,7 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                looping = false,
                interval = 0.08,
                texture = 'dagger-bandit-attack'
            }
        }
    },
    ['spitter'] = {
        height = TILE_SIZE*2,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = SPITTER_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE*1.5,
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
            },
            ['attack'] = {
                frames = {1,3,5,7,9,11},
                looping = false,
                interval = 0.08,
                texture = 'spitter-attack'
            }
        }
    },
    ['ghoul'] = {
        height = TILE_SIZE*2,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = GHOUL_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE,
        animations = {
            ['idle'] = {
                frames = {1,3,5,7},
                interval = 3,
                texture = 'ghoul-idle'
            },
            ['walk'] = {
                frames = {1, 3, 5, 7, 9, 11, 13, 15, 17},
                interval = 0.15,
                texture = 'ghoul-walk'
            },
            ['attack'] = {
                frames = {1,3,5,7,9,11,13},
                looping = false,
                interval = 0.08,
                texture = 'ghoul-attack'
            }
        }
    },
    ['boss'] = {
        height = TILE_SIZE*5,
        width = TILE_SIZE*5,
        moveSpeed = 100,
        bodyType = 'dynamic',
        category = BOSS_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE*5,
        animations = {
            ['idle'] = {
                frames = {1,2,3,4,5,6,7,8,9},
                interval = 0.15,
                texture = 'boss-idle'
            },
            ['walk'] = {
                frames = {1,2},
                interval = 0.15,
                texture = 'boss-walk'
            },
            ['attack1'] = {
                frames = {1,2,3,4,5,6,7,8,9},
                interval = 0.05,
                looping = false,
                texture = 'boss-attack1'
            },
            ['attack2'] = {
                frames = (function()
                    local frames = {}
                    for i=1,16 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                looping = false,
                interval = 0.05,
                texture = 'boss-attack2'
            },
            ['attack'] = {
                frames = (function()
                    local frames = {}
                    for i=1,30 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                looping = false,
                interval = 0.05,
                texture = 'boss-attack3'
            },
        }
    }
}