PuzzleMenu = {}

function PuzzleMenu:new(o)
    o = o or {}
    o.current_page = o.current_page or 1
    o.parent = o.parent or nil
    o.buttons = o.buttons or {}

    o.has_return_button = o.has_return_button or false
    o.has_nav_buttons = o.has_nav_buttons or false
    o.pages = o.pages or {}

    setmetatable(o, self)
    self.__index = self
    return o
end

function PuzzleMenu:getYOffset()
    return self.parent.y_offset
end

function PuzzleMenu:getButtonSpacing()
    return self.parent.button_spacing
end

function PuzzleMenu:onarrowbutton(left, pos)
    if mousepressed or (not nodialog) then return false end

    if left then
        return mouseon(love.graphics.getWidth()-(128-8), self:getYOffset() + (self:getButtonSpacing() * pos), 32, 16)
    else
        return mouseon(love.graphics.getWidth()-(128-8) + 32 + 4 + 40 + 4, self:getYOffset() + (self:getButtonSpacing() * pos), 32, 16)
    end
end

function PuzzleMenu:draw()
    local page = self:getCurrentPage()

    if #page == 0 then
        local y = self:getYOffset() + ((self:getButtonSpacing() * math.floor(self.parent.buttons_per_page)) / 2)
        love.graphics.setColor(192, 192, 192)
        font_ui:printf("This page has no buttons, sorry!", love.graphics.getWidth() - (128 - 8), y, 112, "center")
        love.graphics.setColor(255, 255, 255)
        return
    end

    for i, v in ipairs(page) do
        rbutton(v.name, i - 1, self:getYOffset(), false, self:getButtonSpacing())
    end

    local index = self.parent.buttons_per_page - 1

    if self.has_return_button then
        rbutton("<< Back", index, self:getYOffset(), false, self:getButtonSpacing())
        index = index - 1
    end

    if self.has_nav_buttons then
        local y = self:getYOffset() + (self:getButtonSpacing() * index)
        local x = love.graphics.getWidth() - (128 - 8)
        hoverrectangle(0, 128, 128, 128, x, y, 32, 16)
        font_ui:printf(arrow_left, x + 1, y + 4, 32, "center")

        x = x + 32 + 4

        font_ui:printf("Page\n" .. self.current_page .. "/" .. #self.pages, x + 1, y, 40, "center")

        x = x + 40 + 4

        hoverrectangle(0, 128, 128, 128, x, y, 32, 16)
        font_ui:printf(arrow_right, x + 1, y + 4, 32, "center")
    end
end

--- Shortcut for adding a submenu to the main menu
function PuzzleMenu:submenu(label, id)
    local menu = PuzzleMenu:new()
    self.parent:registerMenu(id, menu)

    self:button(label .. " >", function()
        self.parent:pushMenu(id)
    end)
    return menu
end

function PuzzleMenu:button(name, func)
    table.insert(self.buttons, { name = name, func = func })
    self:recalculatePages()
end

function PuzzleMenu:recalculatePages()
    if self.parent == nil then
        -- Can't do anything yet!
        return
    end

    self.has_return_button = #self.parent.history > 0
    self.has_nav_buttons = #self.buttons > self.parent.buttons_per_page

    local buttons_per_page = self.parent.buttons_per_page
    if self.has_return_button then
        buttons_per_page = buttons_per_page - 1
    end
    if self.has_nav_buttons then
        buttons_per_page = buttons_per_page - 1
    end

    self.pages = {}
    local current_page = 1

    for i, v in ipairs(self.buttons) do
        if self.pages[current_page] == nil then
            self.pages[current_page] = {}
        end

        table.insert(self.pages[current_page], v)

        if #self.pages[current_page] >= buttons_per_page then
            current_page = current_page + 1
        end
    end
end

function PuzzleMenu:setParent(parent)
    self.parent = parent
    self:recalculatePages()
end

function PuzzleMenu:nextPage()
    if self.current_page < #self.pages then
        self.current_page = self.current_page + 1
        self.parent.current_page = self.current_page
    else
        self.current_page = 1
        self.parent.current_page = self.current_page
    end
end

function PuzzleMenu:previousPage()
    if self.current_page > 1 then
        self.current_page = self.current_page - 1
        self.parent.current_page = self.current_page
    else
        self.current_page = #self.pages
        self.parent.current_page = self.current_page
    end
end

function PuzzleMenu:getCurrentPage()
    if self.current_page <= 0 or self.current_page > #self.pages then
        return {}
    end
    return self.pages[self.current_page] or {}
end

function PuzzleMenu:click()
    local page = self:getCurrentPage()
    -- normal buttons
    for i, v in ipairs(page) do
        if onrbutton(i - 1, self:getYOffset(), false, self:getButtonSpacing()) then
            mousepressed = true
            if v.func then
                local success, result = pcall(v.func)
                if not success then
                    PUZZLE_ERROR(v.name, result)
                end
            end
            return
        end
    end

    -- return and nav buttons

    local index = self.parent.buttons_per_page - 1
    if self.has_return_button then
        if onrbutton(index, self:getYOffset(), false, self:getButtonSpacing()) then
            mousepressed = true
            self.parent:popMenu()
            return
        end
        index = index - 1
    end

    if self.has_nav_buttons then
        if self:onarrowbutton(false, index) then
            mousepressed = true
            self:nextPage()
            return
        end
        if self:onarrowbutton(true, index) then
            mousepressed = true
            self:previousPage()
            return
        end
    end
end
