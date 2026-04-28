ENTITY_DEFS = {
    ['player'] = {
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT / 2,
        height = TILE_SIZE*1.5,
        width = TILE_SIZE/2,
        moveSpeed = PLAYER_WALK_SPEED,
        runSpeed = PLAYER_RUN_SPEED,
        health = 6,
        bodyType = 'dynamic',
        category = PLAYER_CATEGORY,
        hitBoxes = {
            { animation='swing-sword', width = TILE_SIZE*3, height = TILE_SIZE, directional=true },
            { animation='swing-sword-down', width = TILE_SIZE*2, height = TILE_SIZE/2, offsetX = -TILE_SIZE, offsetY = TILE_SIZE/2, directional=true },
            { animation='swing-sword-combo', width = TILE_SIZE*4, height = TILE_SIZE*2.5, offsetX = -TILE_SIZE, offsetY = -TILE_SIZE*1.5, directional=true },
        },
        animations = {
            ['idle'] = {
                frames = generateFramesList(9),
                interval = 0.15,
                texture = 'swordmaster-idle',
                offsetX = TILE_SIZE - 3,
                offsetY = 0
            },
            ['walk'] = {
                frames = generateFramesList(8),
                interval = 0.15,
                texture = 'swordmaster-walk',
                offsetX = TILE_SIZE - 3,
                offsetY = 0
            },
            ['run'] = {
                frames = generateFramesList(8),
                interval = 0.15,
                texture = 'swordmaster-run',
                offsetX = TILE_SIZE,
                offsetY = 0
            },
            ['dash'] = {
                frames = generateFramesList(6),
                interval = 0.05,
                looping = false,
                texture = 'swordmaster-dash',
                offsetX = TILE_SIZE,
                offsetY = 0
            },
            ['jump'] = {
                frames = generateFramesList(3),
                interval = 0.15,
                looping = false,
                texture = 'swordmaster-jump',
                offsetX = TILE_SIZE + 3,
                offsetY = 0
            },
            ['falling'] = {
                frames = generateFramesList(7),
                interval = 0.15,
                looping = false,
                texture = 'swordmaster-falling',
                offsetX = TILE_SIZE - 3,
                offsetY = 0
            },
            ['death'] = {
                frames = generateFramesList(6),
                interval = 0.5,
                looping = false,
                texture = 'swordmaster-death',
                offsetX = TILE_SIZE - 3,
                offsetY = 0
            },
            ['swing-sword'] = {
                frames = generateFramesList(7),
                interval = 0.08,
                looping = false,
                texture = 'swordmaster-attack',
                offsetY = 0,
                offsetX = TILE_SIZE*1.5,
            },
            ['swing-sword-down'] = {
                frames = generateFramesList(9),
                interval = 0.08,
                looping = false,
                texture = 'swordmaster-attack-down',
                offsetY = 0,
                offsetX = TILE_SIZE,
            },
            ['swing-sword-combo'] = {
                frames = generateFramesList(11),
                interval = 0.08,
                looping = false,
                texture = 'swordmaster-attack-combo',
                offsetY = 0,
                offsetX = TILE_SIZE
            },
            ['wall-hold'] = {
                frames = generateFramesList(2),
                interval = 0.08,
                texture = 'swordmaster-wall-hold',
                offsetY = 0,
                offsetX = TILE_SIZE
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
        health = 3,
        hitBoxes = {
            { animation='attack', width = TILE_SIZE*1.5, height = TILE_SIZE*4, offsetX = -TILE_SIZE*1.5, offsetY = -TILE_SIZE*4.5 },
        },
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
            ['death'] = {
                frames = (function()
                    local frames = {}
                    for i=1,16 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                interval = 0.15,
                looping = false,
                texture = 'archer-bandit-death'
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
        height = TILE_SIZE*1.5,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = DAGGER_BANDIT_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE * 2,
        health = 3,
        hitBoxes = {
            { animation='attack', width = TILE_SIZE*2, height = TILE_SIZE, offsetX = 0, offsetY = 0, directional=true },
        },
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
            ['death'] = {
                frames = (function()
                    local frames = {}
                    for i=1,16 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                interval = 0.15,
                looping = false,
                texture = 'dagger-bandit-death'
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
                offsetX = TILE_SIZE*1.5,
                offsetY = 0,
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
        health = 4,
        hitBoxes = {
            { animation='attack', width = TILE_SIZE, height = TILE_SIZE*2, offsetX = 0, offsetY = -TILE_SIZE, directional=true },
        },
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
            ['death'] = {
                frames = (function()
                    local frames = {}
                    for i=1,8 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                interval = 0.15,
                looping = false,
                texture = 'spitter-death'
            },
            ['attack'] = {
                frames = {1,3,5,7,9,11},
                looping = false,
                interval = 0.08,
                texture = 'spitter-attack',
                offsetX = TILE_SIZE*0.5,
                offsetY = 0,
            }
        }
    },
    ['ghoul'] = {
        height = TILE_SIZE*2,
        width = TILE_SIZE/2,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = GHOUL_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE,
        health = 4,
        hitBoxes = {
            { animation='attack', width = TILE_SIZE, height = TILE_SIZE*2, offsetX = 0, offsetY = 0, directional=true },
        },
        animations = {
            ['idle'] = {
                frames = {1,3,5,7},
                interval = 3,
                texture = 'ghoul-idle',
                offsetY = 0,
                offsetX = TILE_SIZE*0.5,
            },
            ['walk'] = {
                frames = {1, 3, 5, 7, 9, 11, 13, 15, 17},
                interval = 0.15,
                texture = 'ghoul-walk'
            },
            ['death'] = {
                frames = (function()
                    local frames = {}
                    for i=1,8 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                interval = 0.15,
                looping = false,
                texture = 'ghoul-death'
            },
            ['attack'] = {
                frames = {1,3,5,7,9,11,13},
                looping = false,
                interval = 0.08,
                texture = 'ghoul-attack',
                offsetX = TILE_SIZE*2,
                offsetY = 0,
            }
        }
    },
    ['boss'] = {
        height = TILE_SIZE*4,
        width = TILE_SIZE*2,
        moveSpeed = 100,
        bodyType = 'dynamic',
        category = BOSS_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE*5,
        health = 22,
        hitBoxes = {
            { animation='attack1', width = TILE_SIZE*7*2 + TILE_SIZE*2, height = TILE_SIZE*2, offsetX = -TILE_SIZE * 9, offsetY = 0, directional=true },
            { animation='attack', width = TILE_SIZE*2, height = TILE_SIZE*2, offsetX = 0, offsetY = 0, directional=true },
        },
        animations = {
            ['idle'] = {
                frames = {1,2,3,4,5,6,7,8,9},
                interval = 0.15,
                texture = 'boss-idle',
                offsetX = TILE_SIZE/2
            },
            ['walk'] = {
                frames = {1,2},
                looping = true,
                interval = 0.15,
                texture = 'boss-walk',
                offsetX = TILE_SIZE/2
            },
             ['death'] = {
                frames = (function()
                    local frames = {}
                    for i=1,36 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                interval = 0.15,
                looping = false,
                texture = 'boss-death'
            },
            ['attack1'] = {
                frames = {1,2,3,4,5,6,7,8,9},
                interval = 0.08,
                looping = false,
                texture = 'boss-attack1',
                offsetX = 0,
                offsetY = TILE_SIZE
            },
            ['attack'] = {
                frames = (function()
                    local frames = {}
                    for i=1,16 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                looping = false,
                interval = 0.05,
                texture = 'boss-attack2',
                offsetX = TILE_SIZE * 4.5,
                offsetY = 0
            },
            ['attack3'] = {
                frames = (function()
                    local frames = {}
                    for i=1,30 do
                        table.insert(frames, i)
                    end

                    return frames
                end)(),
                looping = false,
                interval = 0.05,
                texture = 'boss-attack3',
                offsetX = 0,
                offsetY = 0
            },
        }
    }
}