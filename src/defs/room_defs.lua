ROOM_DEFS= {
    ['entry'] = {
        map = 'assets/graphics/map/entry.lua',
        background = 'ruinedTemple',
        spawnX = VIRTUAL_WIDTH / 2 + TILE_SIZE*2,
        spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 7,
        connectedRooms = {
            north = nil,
            south = { room = 'main1', spawnX = 28, spawnY = 8},
            east = nil,
            west = nil
        }
    },
    ['main1'] = {
        map = 'assets/graphics/map/main1.lua',
        connectedRooms = {
            north = { room = 'entry', spawnX = TILE_SIZE * 5, spawnY = VIRTUAL_HEIGHT - TILE_SIZE * 5},
            south = { room = 'main2'},
            east = { room = 'main1-right'},
            west = nil
        }
    },
    -- ['main2'] = {
    --     map = 'assets/graphics/map/main2.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
    --         west = nil
    --     }
    -- },
    -- ['main3'] = {
    --     map = 'assets/graphics/map/main3.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
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
    --         west = nil
    --     }
    -- },
    -- ['main2-left'] = {
    --     map = 'assets/graphics/map/main2-left.lua',
    --     connectedRooms = {
    --         north = nil,
    --         south = nil,
    --         east = nil,
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