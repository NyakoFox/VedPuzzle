PuzzleSection = {}

function PuzzleSection:new(o)
    o = o or {}
    o.current_menu = o.current_menu or nil
    o.menus = o.menus or {}
    o.history = o.history or {}
    o.buttons_per_page = o.buttons_per_page or 10

    o.y_offset = o.y_offset or 8
    o.button_spacing = o.button_spacing or 24

    setmetatable(o, self)
    self.__index = self

    o:registerMenu("main", PuzzleMenu:new())

    return o
end

function PuzzleSection:reset()
    self.current_menu = "main"
    self.history = {}
    for _, menu in pairs(self.menus) do
        menu.current_page = 1
    end
end

function PuzzleSection:getMenu(name)
    return self.menus[name]
end

--- Shortcut for adding a button to the main menu
function PuzzleSection:button(label, func)
    local menu = self:getMenu("main")
    if menu then
        menu:button(label, func)
    end
end

--- Shortcut for adding a submenu to the main menu
function PuzzleSection:submenu(label, id)
    local menu = PuzzleMenu:new()
    self:registerMenu(id, menu)

    self:button(label .. " >", function()
        self:pushMenu(id)
    end)
    return menu
end

function PuzzleSection:getCurrentMenu()
    if self.current_menu == nil then
        return nil
    end
    return self.menus[self.current_menu]
end

function PuzzleSection:getCurrentMenuPage()
    local menu = self:getCurrentMenu()
    if menu == nil then
        return {}
    end
    return menu:getCurrentPage()
end

function PuzzleSection:registerMenu(name, menu)
    self.menus[name] = menu
    menu:setParent(self)

    if self.current_menu == nil then
        self.current_menu = name
    end
end

function PuzzleSection:pushMenu(name)
    if self.menus[name] == nil then
        error("Menu " .. name .. " does not exist!")
    end

    table.insert(self.history, {
        current_menu = self.current_menu,
        current_page = self:getCurrentMenu().current_page
    })

    self.current_menu = name
    
    local menu = self:getCurrentMenu()
    if menu then
        menu:recalculatePages()
        menu.current_page = 1
    end
end

function PuzzleSection:popMenu()
    if #self.history == 0 then
        return
    end

    local last = table.remove(self.history)
    self.current_menu = last.current_menu
    
    local menu = self:getCurrentMenu()
    if menu then
        menu:recalculatePages()
        menu.current_page = last.current_page
    end
end

function PuzzleSection:draw()
    local menu = self:getCurrentMenu()
    if menu then
        menu:draw()
    end
end

function PuzzleSection:click()
    local menu = self:getCurrentMenu()
    if menu then
        menu:click()
    end
end
