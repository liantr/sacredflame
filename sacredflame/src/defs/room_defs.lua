ROOM_DEFS= {
    ['entry'] = {
        map = 'assets/graphics/map/entry.lua',
        music = 'temple',
        background = 'ruinedTemple',
        spawnX = TILE_SIZE * 3,
        spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 2.75 - 1,
        connectedRooms = {
            north = nil,
            south = {
                { room = 'main1', gapX = TILE_SIZE * 19, spawnX = TILE_SIZE * 20, spawnY = 1 }
            },
            east = nil,
            west = nil
        },
        objects = {
            {
                type = 'torch',
                spawnX = TILE_SIZE * 20,
                spawnY = VIRTUAL_HEIGHT -TILE_SIZE * 17.5
            },
        }
    },
    ['main1'] = {
        map = 'assets/graphics/map/main1.lua',
        music = 'temple',
        connectedRooms = {
            north = {
                { room = 'entry', gapX = TILE_SIZE * 19,  spawnX = TILE_SIZE * 21, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 2.75 - 1}
            },
            south = {
                { room = 'main2', gapX = TILE_SIZE * 9, spawnX = TILE_SIZE * 10, spawnY = 1 },
                { room = 'main2', gapX = TILE_SIZE * 28, spawnX = VIRTUAL_WIDTH - TILE_SIZE * 10, spawnY = 1 }
            },
            east = nil,
            west = nil
        },
        objects = {
            {
                type = 'torch',
                spawnX = TILE_SIZE * 4,
                spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 11.5
            },
        },
        enemies = {
            {
                type = 'dagger-bandit',
                spawnX = VIRTUAL_WIDTH-TILE_SIZE * 7,
                spawnY = TILE_SIZE * 4
            },
            {
                type = 'dagger-bandit',
                spawnX = TILE_SIZE * 20,
                spawnY = TILE_SIZE * 6
            },
            {
                type = 'dagger-bandit',
                spawnX = TILE_SIZE * 22,
                spawnY = TILE_SIZE * 6
            },
            {
                type = 'dagger-bandit',
                spawnX = TILE_SIZE * 15,
                spawnY = TILE_SIZE * 10
            },
            {
                type = 'archer-bandit',
                spawnX = TILE_SIZE * 18,
                spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3
            },
            {
                type = 'archer-bandit',
                spawnX = TILE_SIZE*4,
                spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3
            }
        }
    },
    ['main2'] = {
        map = 'assets/graphics/map/main2.lua',
        music = 'temple',
        connectedRooms = {
            north = {
                { room = 'main1', gapX = TILE_SIZE * 9, spawnX = TILE_SIZE * 10, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3 },
                { room = 'main1', gapX = TILE_SIZE * 28, spawnX = VIRTUAL_WIDTH - TILE_SIZE * 10, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3 }
            },
            south = {
                { room = 'main3', gapX = TILE_SIZE * 19, spawnX = TILE_SIZE * 20, spawnY = 1}
            },
            east = nil,
            west = nil
        },
        objects = {
            {
                type = 'torch',
                spawnX = TILE_SIZE * 20,
                spawnY = TILE_SIZE * 5.5
            },
            {
                type = 'wall-hold',
                spawnX = TILE_SIZE * 2,
                spawnY = TILE_SIZE * 47
            }
        },
        enemies = {}
    },
    ['main3'] = {
        map = 'assets/graphics/map/main3.lua',
        music = 'depths',
        connectedRooms = {
            north = {
                { room = 'main2', gapX = TILE_SIZE * 20, spawnX = TILE_SIZE * 21, spawnY = TILE_SIZE * 47 }
            },
            south = {
                { room = 'main4', gapX = TILE_SIZE * 34, spawnX = TILE_SIZE * 37, spawnY = 1 }
            }
        },
        objects = {
            {
                type = 'double-jump',
                spawnX = VIRTUAL_WIDTH - TILE_SIZE * 3,
                spawnY = TILE_SIZE * 6
            },
            {
                type = 'torch',
                spawnX = TILE_SIZE * 15,
                spawnY = TILE_SIZE * 15.5
            }
        },
        enemies = {
            {
                 type = 'spitter',
                 spawnX = TILE_SIZE * 15,
                 spawnY = TILE_SIZE * 45
            },
            {
                 type = 'ghoul',
                 spawnX = TILE_SIZE * 13,
                 spawnY = TILE_SIZE * 36
            },
            {
                 type = 'ghoul',
                 spawnX = TILE_SIZE,
                 spawnY = TILE_SIZE * 30
            },
            {
                 type = 'dagger-bandit',
                 spawnX = TILE_SIZE * 5,
                 spawnY = TILE_SIZE * 24
            },
            {
                 type = 'dagger-bandit',
                 spawnX = TILE_SIZE * 15,
                 spawnY = TILE_SIZE * 24
            },
            {
                 type = 'dagger-bandit',
                 spawnX = TILE_SIZE * 6,
                 spawnY = TILE_SIZE * 19
            },
            {
                 type = 'archer-bandit',
                 spawnX = TILE_SIZE * 2,
                 spawnY = TILE_SIZE * 19
            },
            {
                 type = 'dagger-bandit',
                 spawnX = TILE_SIZE * 13,
                 spawnY = TILE_SIZE * 13
            },
            {
                 type = 'archer-bandit',
                 spawnX = TILE_SIZE * 6,
                 spawnY = TILE_SIZE * 13
            },
            {
                 type = 'dagger-bandit',
                 spawnX = TILE_SIZE * 31,
                 spawnY = TILE_SIZE * 25
            },
            {
                 type = 'archer-bandit',
                 spawnX = TILE_SIZE * 33,
                 spawnY = TILE_SIZE * 16
            },
            {
                 type = 'dagger-bandit',
                 spawnX = TILE_SIZE * 37,
                 spawnY = TILE_SIZE * 12
            },
        },
    },
    ['main4'] = {
        map = 'assets/graphics/map/main4.lua',
        music = 'depths',
        connectedRooms = {
            north = {
                { room = 'main3', gapX = TILE_SIZE * 36, spawnX = TILE_SIZE * 36, spawnY = TILE_SIZE * 49 }
            },
            south = {
                { room = 'boss', gapX = TILE_SIZE * 2, spawnX = TILE_SIZE * 3, spawnY = 1 }
            }
        },
        objects = {
            {
                type = 'torch',
                spawnX = TILE_SIZE * 17,
                spawnY = TILE_SIZE * 16.5
            },
            {
                type = 'door',
                spawnX = TILE_SIZE * 12.5,
                spawnY = TILE_SIZE * 16.5
            }
        },
        enemies = {
            {
                 type = 'ghoul',
                 spawnX = TILE_SIZE * 30,
                 spawnY = TILE_SIZE * 17
            },
            {
                 type = 'spitter',
                 spawnX = TILE_SIZE * 20,
                 spawnY = TILE_SIZE * 17
            },
        }
    },
    ['boss'] = {
        map = 'assets/graphics/map/boss.lua',
        music = 'depths',
        connectedRooms = {
            north = {
                { room = 'main4', gapX = TILE_SIZE * 2, spawnX = TILE_SIZE * 3, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3 }
            }
        },
        enemies = {},
        boss = {
                 type = 'boss',
                 spawnX = VIRTUAL_WIDTH / 2,
                 spawnY = VIRTUAL_HEIGHT / 2
        }
    }
}