ved_require("puzzle.menu")
ved_require("puzzle.section")

function PUZZLE_ERROR(label, message)
    -- Seems like Ved's dialog boxes don't wrap text, so let's just... trim the error? I guess?
    local trimmed_error = ""
    local colon_pos = string.find(message, ".lua:")
    if colon_pos ~= nil then
        trimmed_error = "Line " .. string.sub(message, colon_pos + 5)
    else
        trimmed_error = message
    end

    local str = "Error in PUZZLE BUTTON \"" .. label .. "\":\n\n" .. trimmed_error .. "\n\nYour level may have been modified in some way!"

    dialog.create(str, DBS.OK)
    cons(str)
end

function PUZZLE_DOFILE_SAFE(path)
    local success, result = pcall(dofile, path)
    return success, result
end

function PUZZLE_LOAD(levelassetsfolder)
    -- Initialize (or reset) puzzle's state
    PUZZLE_SECTIONS = {}
    PUZZLE_MAINEDITOR_SHOWN = false
    PUZZLE_SCRIPTEDITOR_SHOWN = false

    -- Register sections
    PUZZLE_REGISTER_SECTION("maineditor", PuzzleSection:new({ buttons_per_page = 13, y_offset = 40, button_spacing = 20 }))
    PUZZLE_REGISTER_SECTION("scripteditor", PuzzleSection:new({ buttons_per_page = 22, y_offset = 10, button_spacing = 20 }))

    -- Load puzzle files
    if not love.filesystem.exists("puzzle.lua") then
        local success, message = love.filesystem.write("puzzle.lua", [=[
--[[
    Welcome to puzzle! You can use this file to add custom buttons in Ved globally, which can run any Lua code you want.

    If you want to add buttons in a per-level basis, create a puzzle.lua file in your level's assets folder.

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
    end

    dofile(love.filesystem.getSaveDirectory() .. "/" .. PUZZLE_PATH .. "puzzle_defaults.lua")

    local success, result = PUZZLE_DOFILE_SAFE(love.filesystem.getSaveDirectory() .. "/puzzle.lua")
    if success then
        cons("Loaded user puzzle script")
    else
        cons("Error loading user puzzle script")
        cons(result)
    end

    if levelassetsfolder ~= nil then
        local success, result = PUZZLE_DOFILE_SAFE(levelassetsfolder .. "/puzzle.lua")
        if success then
            cons("Loaded level-specific puzzle script")
        else
            cons("Error loading level-specific puzzle script")
            cons(result)
        end
    end

end

function PUZZLE_REGISTER_SECTION(name, section)
    PUZZLE_SECTIONS[name] = section
    return section
end

function puzzle(name)
    return PUZZLE_SECTIONS[name]
end
