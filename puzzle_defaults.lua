local function shift_room(offset_x, offset_y)
    local previous_tiles = table.copy(level:get_tiles(roomx, roomy))
    local new_tiles = {}

    for tile = 0, 1199 do
        local x = math.floor(tile % 40)
        local y = math.floor((tile - x) / 40)

        x = (x + offset_x) % 40
        y = (y + offset_y) % 30

        local new_tile = y * 40 + x

        new_tiles[new_tile + 1] = previous_tiles[tile + 1]
    end

    level:set_tiles(roomx, roomy, new_tiles)

    table.insert(
        undobuffer,
        {
            undotype = "tiles",
            rx = roomx,
            ry = roomy,
            toundotiles = previous_tiles,
            toredotiles = new_tiles
        }
    )
    finish_undo("PUZZLE SHIFT ROOM")
end

local shift_menu = puzzle("maineditor"):submenu("Shift", "shift")
shift_menu:button("Shift room " .. arrow_left, function() shift_room(-1, 0) end)
shift_menu:button("Shift room " .. arrow_right, function() shift_room(1, 0) end)
shift_menu:button("Shift room " .. arrow_up, function() shift_room(0, -1) end)
shift_menu:button("Shift room " .. arrow_down, function() shift_room(0, 1) end)
