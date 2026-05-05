
function generateBossAttack3HitBoxesDef()
    local defHitBoxes = {
        {
            width = TILE_SIZE,
            height = TILE_SIZE*2.2,
            offsetX = 0,
            offsetY = -TILE_SIZE*4,
            frames = generateFramesList(14),
            bidirectional = true
        },
        {
            width = TILE_SIZE,
            height = TILE_SIZE*2.2,
            offsetX = -TILE_SIZE*3,
            offsetY = -TILE_SIZE*4,
            frames = generateFramesList(14),
            bidirectional = true
        },
        {
            width = TILE_SIZE*1.5,
            height = TILE_SIZE*2,
            offsetX = -TILE_SIZE/2,
            offsetY = -TILE_SIZE*4,
            frames = generateFramesList(17, 15),
            bidirectional = true
        },
        {
            width = TILE_SIZE*1.5,
            height = TILE_SIZE*2,
            offsetX = -TILE_SIZE*3,
            offsetY = -TILE_SIZE*4,
            frames = generateFramesList(17, 15),
            bidirectional = true
        },
        {
            width = TILE_SIZE,
            height = TILE_SIZE,
            offsetX = -TILE_SIZE/2,
            offsetY = -TILE_SIZE*4.5,
            frames = generateFramesList(21, 20),
            bidirectional = true
        },
        {
            width = TILE_SIZE,
            height = TILE_SIZE,
            offsetX = -TILE_SIZE*2.5,
            offsetY = -TILE_SIZE*4.5,
            frames = generateFramesList(21, 20),
            bidirectional = true 
        },
        {
            width = TILE_SIZE*1.5,
            height = TILE_SIZE,
            offsetX = -TILE_SIZE/2,
            offsetY = -TILE_SIZE*3.5,
            frames = generateFramesList(19, 18),
            bidirectional = true
        },
        {
            width = TILE_SIZE*1.5,
            height = TILE_SIZE,
            offsetX = -TILE_SIZE*3,
            offsetY = -TILE_SIZE*3.5,
            frames = generateFramesList(19, 18),
            bidirectional = true
        }
    }

    -- start values for the first part of the attack
    local offsetXLeft = 0
    local offsetYLeft = -TILE_SIZE*2.5
    local offsetXRight = -TILE_SIZE*2.5
    local offsetYRight = -TILE_SIZE*2.5
    
    -- and for the second
    local offsetXLeft2 = TILE_SIZE*0.5
    local offsetYLeft2 = -TILE_SIZE*3.5
    local offsetXRight2 = -TILE_SIZE*3
    local offsetYRight2 = -TILE_SIZE*3.5
    for i=1,12 do
        if i <= 9 then
            table.insert(defHitBoxes, {
                width = TILE_SIZE/2,
                height = TILE_SIZE/2,
                offsetX = offsetXLeft,
                offsetY = offsetYLeft,
                frames = {18},
                bidirectional = true
            })

            table.insert(defHitBoxes, {
                width = TILE_SIZE/2,
                height = TILE_SIZE/2,
                offsetX = offsetXRight,
                offsetY = offsetYRight,
                frames = {18},
                bidirectional = true
            })

            offsetXLeft = offsetXLeft + TILE_SIZE*0.5
            offsetYLeft = offsetYLeft + TILE_SIZE*0.5

            offsetXRight = offsetXRight - TILE_SIZE*0.5
            offsetYRight = offsetYRight + TILE_SIZE*0.5
        end

        table.insert(defHitBoxes, {
            width = TILE_SIZE/2,
            height = TILE_SIZE/2,
            offsetX = offsetXLeft2,
            offsetY = offsetYLeft2,
            frames = {22},
            bidirectional = true
        })

        table.insert(defHitBoxes, {
                width = TILE_SIZE/2,
                height = TILE_SIZE/2,
                offsetX = offsetXRight2,
                offsetY = offsetYRight2,
                frames = {22},
                bidirectional = true
            })

        offsetXLeft2 = offsetXLeft2 + TILE_SIZE*0.5
        offsetYLeft2 = offsetYLeft2 + TILE_SIZE*0.5

        offsetXRight2 = offsetXRight2 - TILE_SIZE*0.5
        offsetYRight2 = offsetYRight2 + TILE_SIZE*0.5
    end

    return defHitBoxes
end

ENTITY_DEFS = {
    ['player'] = {
        x = VIRTUAL_WIDTH / 2,
        y = VIRTUAL_HEIGHT / 2,
        height = TILE_SIZE * 1.5,
        width = TILE_SIZE / 2,
        moveSpeed = PLAYER_WALK_SPEED,
        runSpeed = PLAYER_RUN_SPEED,
        health = 6,
        bodyType = 'dynamic',
        category = PLAYER_CATEGORY,
        hitBoxes = {
            ['swing-sword'] = {
                {
                    width = TILE_SIZE * 3,
                    height = TILE_SIZE,
                    offsetX = 0,
                    offsetY = 0,
                    frames={ 2 }
                }
            },
            ['swing-sword-combo'] = {
                {
                    width = TILE_SIZE * 4,
                    height = TILE_SIZE * 2.5,
                    offsetX = -TILE_SIZE,
                    offsetY = -TILE_SIZE * 1.5,
                    frames={ 2 }
                },
                {
                    width = TILE_SIZE * 5.5,
                    height = TILE_SIZE,
                    offsetX = -TILE_SIZE * 2.25,
                    offsetY = 0,
                    frames={ 6 }
                }
            }
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
                offsetX = 0,
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
                interval = 0.06,
                looping = false,
                texture = 'swordmaster-attack',
                offsetY = 0,
                offsetX = TILE_SIZE,
            },
            ['swing-sword-combo'] = {
                frames = generateFramesList(11),
                interval = 0.06,
                looping = false,
                texture = 'swordmaster-attack-combo',
                offsetY = 0,
                offsetX = TILE_SIZE
            },
            ['wall-hold'] = {
                frames = generateFramesList(1),
                interval = 0.08,
                texture = 'swordmaster-wall-hold',
                offsetY = 0,
                offsetX = TILE_SIZE/2
            },
        }
    },
    ['flame'] = {
        height = TILE_SIZE * 1.5,
        width = TILE_SIZE * 1.5,
        moveSpeed = FLAME_MOVE_SPEED,
        bodyType = 'kinematic',
        category = FLAME_CATEGORY,
        animations = {
            ['idle'] = {
                frames = generateFramesList(11, 1, 2),
                interval = 0.5,
                texture = 'flame-idle'
            }
        }
    },
    ['archer-bandit'] = {
        height = TILE_SIZE * 1.5,
        width = TILE_SIZE * 1.5,
        moveSpeed = 50,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE * 3,
        bodyType = 'dynamic',
        category = ARCHER_BANDIT_CATEGORY,
        rangedAttack = true,
        health = 3,
        hitBoxes = {
            ['attack'] = {
                {
                    width = TILE_SIZE * 1.5,
                    height = TILE_SIZE * 6,
                    offsetX = -TILE_SIZE * 1.5,
                    offsetY = -TILE_SIZE * 6.5,
                    frames = { 25 }
                }
            }
        },
        animations = {
            ['idle'] = {
                frames = generateFramesList(15, 1, 2),
                interval = 0.15,
                texture = 'archer-bandit-idle'
            },
            ['walk'] = {
                frames = generateFramesList(15, 1, 2),
                interval = 0.15,
                texture = 'archer-bandit-run'
            },
            ['death'] = {
                frames = generateFramesList(16),
                interval = 0.15,
                looping = false,
                texture = 'archer-bandit-death'
            },
            ['attack'] = {
                frames = generateFramesList(37, 1, 2),
                looping = false,
                interval = 0.08,
                texture = 'archer-bandit-attack'
            }
        }
    },
    ['dagger-bandit'] = {
        height = TILE_SIZE * 1.5,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = DAGGER_BANDIT_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE * 2,
        health = 3,
        hitBoxes = {
            ['attack'] = {
                {
                    width = TILE_SIZE * 2,
                    height = TILE_SIZE,
                    offsetX = 0,
                    offsetY = 0,
                    frames = {2, 5}
                }
            }
        },
        animations = {
            ['idle'] = {
                frames = generateFramesList(15, 1, 2),
                interval = 0.15,
                texture = 'dagger-bandit-idle'
            },
            ['walk'] = {
                frames = generateFramesList(15, 1, 2),
                interval = 0.15,
                texture = 'dagger-bandit-run'
            },
            ['death'] = {
                frames = generateFramesList(16),
                interval = 0.15,
                looping = false,
                texture = 'dagger-bandit-death'
            },
            ['attack'] = {
                frames = generateFramesList(7),
                looping = false,
                interval = 0.06,
                offsetX = TILE_SIZE * 1.5,
                offsetY = 0,
                texture = 'dagger-bandit-attack'
            }
        }
    },
    ['spitter'] = {
        height = TILE_SIZE * 2,
        width = TILE_SIZE,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = SPITTER_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE * 1.5,
        health = 4,
        hitBoxes = {
            ['attack'] = {
                {
                    width = TILE_SIZE,
                    height = TILE_SIZE * 2,
                    offsetX = 0,
                    offsetY = -TILE_SIZE,
                    frames={ 5 }
                }
            }
        },
        animations = {
            ['idle'] = {
                frames = generateFramesList(11, 1, 2),
                interval = 0.15,
                texture = 'spitter-idle'
            },
            ['walk'] = {
                frames = generateFramesList(13, 1, 2),
                interval = 0.15,
                texture = 'spitter-walk'
            },
            ['death'] = {
                frames = generateFramesList(8),
                interval = 0.15,
                looping = false,
                texture = 'spitter-death'
            },
            ['attack'] = {
                frames = generateFramesList(11, 1, 2),
                looping = false,
                interval = 0.08,
                texture = 'spitter-attack',
                offsetX = TILE_SIZE * 0.5,
                offsetY = 0,
            }
        }
    },
    ['ghoul'] = {
        height = TILE_SIZE * 2,
        width = TILE_SIZE / 2,
        moveSpeed = 50,
        bodyType = 'dynamic',
        category = GHOUL_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE,
        health = 4,
        hitBoxes = {
            ['attack'] = {
                {
                    width = TILE_SIZE,
                    height = TILE_SIZE * 2,
                    offsetX = 0,
                    offsetY = 0,
                    frames={ 3 }
                }
            },
        },
        animations = {
            ['idle'] = {
                frames = generateFramesList(7, 1, 2),
                interval = 3,
                texture = 'ghoul-idle',
                offsetY = 0,
                offsetX = TILE_SIZE * 0.5,
            },
            ['walk'] = {
                frames = generateFramesList(17, 1, 2),
                interval = 0.15,
                texture = 'ghoul-walk'
            },
            ['death'] = {
                frames = generateFramesList(8),
                interval = 0.15,
                looping = false,
                texture = 'ghoul-death'
            },
            ['attack'] = {
                frames = generateFramesList(13, 1, 2),
                looping = false,
                interval = 0.08,
                texture = 'ghoul-attack',
                offsetX = TILE_SIZE,
                offsetY = 0,
            }
        }
    },
    ['boss'] = {
        height = TILE_SIZE * 4,
        width = TILE_SIZE * 2,
        moveSpeed = 100,
        bodyType = 'dynamic',
        category = BOSS_CATEGORY,
        chaseSpeed = 100,
        attackDistance = TILE_SIZE * 5,
        health = 22,
        hurtBoxes = {
            ['idle'] = {
                {
                    frames = generateFramesList(9),
                    offsetX = 0
                }
            }
            ,
            ['walk'] = {
                {
                    frames = generateFramesList(2),
                    offsetX = 0
                }
            },
            ['chase'] = {
                {
                    frames = generateFramesList(2),
                    offsetX = 0
                }
            },
            ['appear'] = {
                {
                    frames = { 9 },
                    offsetX = 0
                }
            },
            ['disappear'] = {},
            ['death'] = {},
            ['attack1'] = {
                {
                    frames = generateFramesList(9),
                    height = TILE_SIZE * 2,
                    offsetY = TILE_SIZE
                }
            },
            ['attack2'] = {
                {
                    frames = generateFramesList(16),
                    offsetX = 0
                }
            },
            ['attack3'] = {
                {
                    height = TILE_SIZE * 4,
                    width = TILE_SIZE * 2,
                    offsetX = 0,
                    offsetY = -TILE_SIZE * 4,
                    frames = generateFramesList(6)
                },
                {
                    height = TILE_SIZE * 2,
                    width = TILE_SIZE * 2,
                    offsetX = 0,
                    offsetY = TILE_SIZE,
                    frames = generateFramesList(30, 7)
                }
            }
        },
        hitBoxes = {
            ['attack1'] = {
                {
                    width = TILE_SIZE * 16,
                    height = TILE_SIZE * 2,
                    offsetX = -TILE_SIZE * 9,
                    offsetY = 0,
                    frames = { 4 }
                }
            },
            ['attack2'] = {
                {
                    width = TILE_SIZE * 2,
                    height = TILE_SIZE * 2,
                    offsetX = 0,
                    offsetY = TILE_SIZE * 3,
                    frames = { 3 }
                },
                {
                    width = TILE_SIZE * 2,
                    height = TILE_SIZE * 2,
                    offsetX = 0,
                    offsetY = TILE_SIZE * 2,
                    frames = { 10 }
                }
            },
            ['attack3'] = generateBossAttack3HitBoxesDef()
        },
        animations = {
            ['idle'] = {
                frames = generateFramesList(9),
                interval = 0.15,
                texture = 'boss-idle',
                offsetX = TILE_SIZE / 2
            },
            ['walk'] = {
                frames = generateFramesList(2),
                looping = true,
                interval = 0.15,
                texture = 'boss-walk',
                offsetX = TILE_SIZE / 2
            },
             ['death'] = {
                frames = generateFramesList(36),
                interval = 0.15,
                looping = false,
                texture = 'boss-death'
            },
            ['attack1'] = {
                frames = generateFramesList(9),
                interval = 0.05,
                looping = false,
                texture = 'boss-attack1',
                offsetX = TILE_SIZE,
                offsetY = TILE_SIZE
            },
            ['attack2'] = {
                frames = generateFramesList(16),
                interval = 0.05,
                texture = 'boss-attack2',
                offsetX = TILE_SIZE,
                offsetY = 0
            },
            ['attack3'] = {
                frames = generateFramesList(30),
                looping = false,
                interval = 0.05,
                texture = 'boss-attack3',
                offsetX = TILE_SIZE * 1.5,
                offsetY = 0
            },
            ['appear'] = {
                frames = generateFramesList(9),
                looping = false,
                interval = 0.03,
                texture = 'boss-appear',
                offsetX = TILE_SIZE,
                offsetY = 0
            },
            ['disappear'] = {
                frames = generateFramesList(5),
                looping = false,
                interval = 0.05,
                texture = 'boss-disappear',
                offsetX = 0,
                offsetY = 0
            },
        }
    }
}