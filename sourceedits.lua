sourceedits =
{
	["func"] =
	{
		{
			find = [[function load_vvvvvv_tilesets(levelassetsfolder)]],
			replace = [[
function load_vvvvvv_tilesets(levelassetsfolder)
	PUZZLE_LOAD(levelassetsfolder)
]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false,
		}
	},
	["uis/maineditor/draw"] =
	{
		-- READJUST MAIN EDITOR BUTTONS AND ADD PUZZLE BUTTON
		{
			find = [[hoverdraw(image.helpbtn, love.graphics.getWidth()-120+40, 40, 16, 16, 1)]],
			replace = [[hoverdraw(image.helpbtn, love.graphics.getWidth()-120+32, 40, 16, 16, 1)]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[
	hoverdraw(image.cutbtn, love.graphics.getWidth()-120+64, 40, 16, 16, 1)
	hoverdraw(image.copybtn, love.graphics.getWidth()-120+80, 40, 16, 16, 1)
	hoverdraw(image.pastebtn, love.graphics.getWidth()-120+96, 40, 16, 16, 1)]],
			replace = [[
	hoverdraw(image.cutbtn, love.graphics.getWidth()-120+48, 40, 16, 16, 1)
	hoverdraw(image.copybtn, love.graphics.getWidth()-120+64, 40, 16, 16, 1)
	hoverdraw(image.pastebtn, love.graphics.getWidth()-120+80, 40, 16, 16, 1)
	hoverdraw("ui/images/puzzle_icon", love.graphics.getWidth()-120+96, 40, 16, 16, 1)]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[elseif mouseon(love.graphics.getWidth()-120+40, 40, 16, 16) then]],
			replace = [[elseif mouseon(love.graphics.getWidth()-120+32, 40, 16, 16) then]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[elseif mouseon(love.graphics.getWidth()-120+64, 40, 16, 16) then]],
			replace = [[elseif mouseon(love.graphics.getWidth()-120+48, 40, 16, 16) then]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[elseif mouseon(love.graphics.getWidth()-120+80, 40, 16, 16) then]],
			replace = [[elseif mouseon(love.graphics.getWidth()-120+64, 40, 16, 16) then]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[elseif mouseon(love.graphics.getWidth()-120+98, 40, 16, 16) then]],
			replace = [[elseif mouseon(love.graphics.getWidth()-120+80, 40, 16, 16) then]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[elseif onrbutton(1, 40, false, 20) then]],
			replace = [[
		elseif mouseon(love.graphics.getWidth()-120+96, 40, 16, 16) then
			PUZZLE_MAINEDITOR_SHOWN = not PUZZLE_MAINEDITOR_SHOWN
			mousepressed = true
		elseif onrbutton(1, 40, false, 20) then]],
		},
		-- HIDE DEFAULT MAIN EDITOR BUTTONS IF PUZZLE ACTIVE
		{
			find = [[	rbutton((upperoptpage2 and L.VEDOPTIONS or L.LEVELOPTIONS), 1, 40, false, 20)]],
			replace = [[

	if not PUZZLE_MAINEDITOR_SHOWN then
		rbutton((upperoptpage2 and L.VEDOPTIONS or L.LEVELOPTIONS), 1, 40, false, 20)]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[rbutton((upperoptpage2 and L.BACKB or L.MOREB), 6, 40, false, 20)]],
			replace = [[rbutton((upperoptpage2 and L.BACKB or L.MOREB), 6, 40, false, 20)
	end]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[if not editingroomname then]],
			replace = [[

	if not PUZZLE_MAINEDITOR_SHOWN then
		if not editingroomname then]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[	-- Well make them actually do something!]],
			replace = [[
	else
		puzzle("maineditor"):draw()
	end
	-- Well make them actually do something!]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[elseif onrbutton(1, 40, false, 20) then]],
			replace = [[
			elseif PUZZLE_MAINEDITOR_SHOWN then
				puzzle("maineditor"):click()
			elseif onrbutton(1, 40, false, 20) then
			]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		}
	},
	["uis/scripteditor/draw"] =
	{
		-- SHOW PUZZLE BUTTON IN SCRIPT EDITOR
		{
			find = [[showhotkey("q", love.graphics.getWidth()-24+8-2, 8-2)]],
			replace = [[showhotkey("q", love.graphics.getWidth()-24+8-2, 8-2)
	hoverdraw("ui/images/puzzle_icon", love.graphics.getWidth()-24 - 16, 8, 16, 16, 1)
	if PUZZLE_SCRIPTEDITOR_SHOWN then
		puzzle("scripteditor"):draw()
	else
	]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		{
			find = [[rbutton({L.RETURN, "b"}, 0, nil, true)]],
			replace = [[
rbutton({L.RETURN, "b"}, 0, nil, true)
	end]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		},
		-- HANDLE PUZZLE BUTTON CLICK
		{
			find = [[elseif onrbutton(1) then]],
			replace = [[
elseif mouseon(love.graphics.getWidth()-24 - 16, 8, 16, 16) and not mousepressed then
	PUZZLE_SCRIPTEDITOR_SHOWN = not PUZZLE_SCRIPTEDITOR_SHOWN
	mousepressed = true
end

if PUZZLE_SCRIPTEDITOR_SHOWN then
	puzzle("scripteditor"):click()
elseif onrbutton(1) then]],
		},
		{
			find = [[if table.contains({]],
			replace = [[if PUZZLE_SCRIPTEDITOR_SHOWN then
	return
end

if table.contains({]],
			ignore_error = false,
			luapattern = false,
			allowmultiple = false
		}
	}
}