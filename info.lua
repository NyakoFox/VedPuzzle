t = ...  -- Required for this info file to work.

t.id = "NyakoFox:Puzzle" -- Something unique: use your name, a colon, and then the plugin name
t.author_color = "P" -- One of the Ved help colors used for your name
t.shortname = "Puzzle"  -- The name that will be displayed on the button in the plugins list. Should be no longer than 21 characters, or it will be wider than the button.
t.longname = "Puzzle"  -- This can be about twice as long
t.author = "NyakoFox"  -- Your name
t.version = "1.0.1"  -- The current version of this plugin, can be anything you want
t.minimumved = "2.0"  -- The minimum version of Ved this plugin is designed to work with. If unsure, just use the latest version.
t.description = [[
Puzzle piece buttons, for your Lua scripting needs.

Why's it called that? Uh... that's the puzzle!
]]  -- The description that will be displayed in the plugins list. This uses the help/notepad system, so you can use text formatting here, and even images!
t.overrideinfo = false  -- Set this to true if you want to make your description fully custom and disable the default header with the plugin name, your username and the plugin version at the top. Leave at false if uncertain.
PUZZLE_PATH = t.internal_pluginpath .. "/"
