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

local puzzle_menu = puzzle("maineditor"):submenu("Puzzle", "puzzle")
puzzle_menu:button("Create Lua file", function()
    if file_exists(getlevelassetsfolder() .. "/puzzle.lua") then
        dialog.create("A puzzle.lua file already exists in this level's assets folder!", DBS.OK)
        return
    else
        writelevelfile(getlevelassetsfolder() .. "/puzzle.lua", [=[
--[[
    Welcome to puzzle! You can use this file to add custom buttons in Ved, specific to this level, which can run any Lua code you want.

    Here's an example button:

    puzzle("maineditor"):button("Hello", function()
        dialog.create("Hello, world!", DBS.OK)
    end)

    This adds a "Hello" button to the main editor, which shows a dialog box when pressed.

    Adding submenus are also possible (and you should put most things in one!):

    local menu = puzzle("maineditor"):submenu("Test menu", "testmenu")
    menu:button("Test button 1", function() dialog.create("You pressed test button 1!", DBS.OK) end)
    menu:button("Test button 2", function() dialog.create("You pressed test button 2!", DBS.OK) end)

    Further documentation can be found in the GitHub repository: https://github.com/NyakoFox/VedPuzzle/

    Happy puzzling!
]]
]=])
        dialog.create("Created puzzle.lua!", DBS.OK)
    end
end)

puzzle_menu:button("Reload puzzle scripts", function()
    PUZZLE_LOAD(getlevelassetsfolder())
    dialog.create("Reloaded puzzle scripts!", DBS.OK)
end)

local shift_menu = puzzle("maineditor"):submenu("Shift room", "shift")
shift_menu:button("Shift room " .. arrow_left, function() shift_room(-1, 0) end)
shift_menu:button("Shift room " .. arrow_right, function() shift_room(1, 0) end)
shift_menu:button("Shift room " .. arrow_up, function() shift_room(0, -1) end)
shift_menu:button("Shift room " .. arrow_down, function() shift_room(0, 1) end)
