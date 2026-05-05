ROOM_DEFS= {
    ['entry'] = {
        map = 'assets/graphics/map/entry.lua',
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
        connectedRooms = {
            north = {
                { room = 'entry', gapX = TILE_SIZE * 19,  spawnX = TILE_SIZE * 21, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 2.75 - 1}
            },
            south = {
                { room = 'main2', gapX = TILE_SIZE * 8, spawnX = TILE_SIZE * 10, spawnY = 1 },
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
        -- enemies = {
        --     {
        --         type = 'dagger-bandit',
        --         spawnX = VIRTUAL_WIDTH-TILE_SIZE * 7,
        --         spawnY = TILE_SIZE * 4
        --     },
        --     {
        --         type = 'dagger-bandit',
        --         spawnX = TILE_SIZE * 20,
        --         spawnY = TILE_SIZE * 6
        --     },
        --     {
        --         type = 'dagger-bandit',
        --         spawnX = TILE_SIZE * 22,
        --         spawnY = TILE_SIZE * 6
        --     },
        --     {
        --         type = 'dagger-bandit',
        --         spawnX = TILE_SIZE * 15,
        --         spawnY = TILE_SIZE * 10
        --     },
        --     {
        --         type = 'archer-bandit',
        --         spawnX = TILE_SIZE * 18,
        --         spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3
        --     },
        --     {
        --         type = 'archer-bandit',
        --         spawnX = TILE_SIZE*4,
        --         spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3
        --     }
        -- }
    },
    ['main2'] = {
        map = 'assets/graphics/map/main2.lua',
        connectedRooms = {
            north = {
                { room = 'main1', gapX = TILE_SIZE * 9, spawnX = TILE_SIZE * 10, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3 },
                { room = 'main1', gapX = TILE_SIZE * 28, spawnX = VIRTUAL_WIDTH - TILE_SIZE * 10, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3 }
            },
            --south = { room = 'main3', spawnX = TILE_SIZE*4, spawnY = 0},
            east = nil,
            west = nil
        },
        objects = {
            {
                type = 'torch',
                spawnX = TILE_SIZE * 20,
                spawnY = TILE_SIZE * 4
            },
            {
                type = 'wall-hold',
                spawnX = TILE_SIZE * 2,
                spawnY = TILE_SIZE * 47
            }
        },
        enemies = {}
    },
    -- ['main3'] = {
    --     map = 'assets/graphics/map/main3.lua',
    --     connectedRooms = {
    --         north = { room = 'main2', spawnX = 16*6, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 3},
    --         south = { room = 'main4', spawnX = TILE_SIZE*80 - TILE_SIZE*3, spawnY = TILE_SIZE},
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['main4'] = {
    --     map = 'assets/graphics/map/main4.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['main5'] = {
    --     map = 'assets/graphics/map/main5.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['main1-right'] = {
    --     map = 'assets/graphics/map/main1-right.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = { room = 'main1', spawnX = VIRTUAL_WIDTH - TILE_SIZE, spawnY = TILE_SIZE*6}
    --     }
    -- },
    -- ['main2-left'] = {
    --     map = 'assets/graphics/map/main2-left.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = { room = 'main2', spawnX = TILE_SIZE, spawnY = TILE_SIZE * 8},
    --         west = nil
    --     }
    -- },
    -- ['main3-left'] = {
    --     map = 'assets/graphics/map/main3-left.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['main3-right'] = {
    --     map = 'assets/graphics/map/main3-right.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['main4-right'] = {
    --     map = 'assets/graphics/map/main4-right.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['main5-right'] = {
    --     map = 'assets/graphics/map/main5-right.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['main5-left'] = {
    --     map = 'assets/graphics/map/main5-left.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['boss-room'] = {
    --     map = 'assets/graphics/map/boss.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
}