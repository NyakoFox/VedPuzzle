# Puzzle

Adds a puzzle piece icon to certain editors in Ved, so you can add custom buttons! Modify the current room, generate scripts, and more!

## Download?

Download this repository as a ZIP, and put the folder containing the files into your Ved plugins directory.

## How do I use them?

Using puzzle scripts is simple. In certain editors, you'll find a puzzle piece icon. Clicking it will open the puzzle menu, where you can click any buttons there.

## How do I add my own?

You will find a `puzzle.lua` file in your Ved save directory after installing the plugin (and running Ved at least once).

This file is where you can add puzzle buttons *globally* -- meaning, the buttons you add here will appear in every level.

For per-level buttons, put a `puzzle.lua` file in your level's folder!

Puzzle scripts are just Lua. To add a button, you first have to get a section or a menu:

```lua
local main = puzzle("maineditor")
```

and then add a button to it:

```lua
local main = puzzle("maineditor")
main:button("Say hi", function()
    dialog.create("Hi!", DBS.OK)
end)
```

This adds a button to the main editor which, when clicked, creates a dialog box that says "Hi!".

> [!NOTE]
> This is a very basic example. You will most likely need to know some Ved internals to make more complex scripts, but if help is needed, feel free to ask in the `#ved` channel in the [VVVVVV Discord server](https://discord.gg/Zf7Nzea). In the future, this README may be expanded with more complex examples.

### Submenus

Submenus are what you'll want to put your buttons in, most of the time. To add a submenu, use the `section:submenu(name, id)` function:

```lua
local my_submenu = puzzle("maineditor"):submenu("My submenu", "submenu")

my_submenu:button("Say 1", function() dialog.create("1!", DBS.OK) end)
my_submenu:button("Say 2", function() dialog.create("2!", DBS.OK) end)
my_submenu:button("Say 3", function() dialog.create("3!", DBS.OK) end)
```

...and now your submenu has three buttons in it!

### Available editors/sections

Puzzle has the following editors/sections available:

- `maineditor` (main editor)
- `scripteditor` (script editor)

... with more to come in the future!

## API Documentation

Puzzle has a pretty simple API. Documented here are the public functions expected to be used by puzzle scripts.

Anything marked with **ADV** is more advanced and, most of the time, not necessary for basic scripts.

### Globals

- `puzzle(section)` - Gets a "puzzle section" by ID. Returns a PuzzleSection.

### PuzzleSection

- `section:button(label, callback)` - Adds a button to the section.
- `section:submenu(label, id)` - Adds a "simple" submenu to the section.
- **ADV:** `section:getMenu(name)` - Gets a menu by name. Returns a PuzzleMenu.
- **ADV:** `section:pushMenu(name)` - Enters a menu.
- **ADV:** `section:popMenu()` - Returns to the previous menu.
- **ADV:** `section:registerMenu(name, menu)` - Registers a PuzzleMenu submenu to the section.

### PuzzleMenu

- `menu:button(label, callback)` - Adds a button to the menu.
- `menu:submenu(label, id)` - Adds a "simple" submenu to the menu.
- **ADV:** `menu:nextPage()` - Goes to the next page of the menu, wrapping around if there are no more pages.
- **ADV:** `menu:previousPage()` - Goes to the previous page of the menu, wrapping around if there are no more pages.

## Advanced

If you feel like getting your hands dirty, you can bypass the "simple" submenu system and create them by hand:

```lua
local test = puzzle("maineditor"):submenu("My submenu", "submenu")
```

Is the same as...

```lua
local main = puzzle("maineditor") -- Grab the main editor section

local test = PuzzleMenu:new() -- Make a new menu
main:registerMenu(id, menu) -- Register the menu to the section

-- Add a button to the main editor
main:button("My submenu >", function()
    -- On click, open our new menu
    self.parent:pushMenu(id)
end)
```

This is useful if you don't want to automatically add a button to the section.

You could even make a menu which enters itself:

```lua
local my_menu = puzzle("maineditor"):submenu("My submenu", "submenu")

my_menu:button("Recurse", function()
    self.parent:pushMenu("submenu")
end)
```

... but I'm not sure why you would.
