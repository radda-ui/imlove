local bit = require("bit")
local imlove = {
    _VERSION = "0.1.3",
    _DESCRIPTION = "A pure Lua 5.1 simple implementation of imgui for LÖVE 2D hence the name imlove",
    _URL = "https://github.com/radda09/imlove",
    _LICENSE = [[
        MIT License

        Copyright (c) 2024 Salem Raddaoui

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]],
    state = {},
    hot = nil,
    active = nil,
    windows = {},
    old = {},
    currentWindow = nil,
    drawList = {},
    style = {
        minWindowWidth = 100,
        minWindowHeight = 100,
        minWidth = 100,
        minHeight = 20,
        padding = 2,
        margin = 4,
        itemSpacing = 5,
        globalAlpha = 1,
        resizeHandleSize = 10,
        scrollbarWidth = 12,
        scrollbarMinHeight = 20
    },
    KeysDown= {},
    Ctrl = false,
    Alt = false,
    Shift = false,
    input = false,
    text = ""
}
imlove.colors = {
    Text                   = {1.00, 1.00, 1.00, 1.00},
    TextDisabled           = {0.50, 0.50, 0.50, 1.00},
    WindowBg               = {0.06, 0.06, 0.06, 0.94},
    ChildBg                = {0.00, 0.00, 0.00, 0.00},
    PopupBg                = {0.08, 0.08, 0.08, 0.94},
    Border                 = {0.43, 0.43, 0.50, 0.50},
    BorderShadow           = {0.00, 0.00, 0.00, 0.00},
    FrameBg                = {0.16, 0.29, 0.48, 0.54},
    FrameBgHovered         = {0.26, 0.59, 0.98, 0.40},
    FrameBgActive          = {0.26, 0.59, 0.98, 0.67},
    TitleBg                = {0.04, 0.04, 0.04, 1.00},
    TitleBgActive          = {0.16, 0.29, 0.48, 1.00},
    TitleBgCollapsed       = {0.00, 0.00, 0.00, 0.51},
    MenuBarBg              = {0.14, 0.14, 0.14, 1.00},
    ScrollbarBg            = {0.02, 0.02, 0.02, 0.53},
    ScrollbarGrab          = {0.31, 0.31, 0.31, 1.00},
    ScrollbarGrabHovered   = {0.41, 0.41, 0.41, 1.00},
    ScrollbarGrabActive    = {0.51, 0.51, 0.51, 1.00},
    CheckMark              = {0.26, 0.59, 0.98, 1.00},
    SliderGrab             = {0.24, 0.52, 0.88, 1.00},
    SliderGrabActive       = {0.26, 0.59, 0.98, 1.00},
    Button                 = {0.26, 0.59, 0.98, 0.40},
    ButtonHovered          = {0.26, 0.59, 0.98, 1.00},
    ButtonActive           = {0.06, 0.53, 0.98, 1.00},
    Header                 = {0.26, 0.59, 0.98, 0.31},
    HeaderHovered          = {0.26, 0.59, 0.98, 0.80},
    HeaderActive           = {0.26, 0.59, 0.98, 1.00},
    Separator              = {0.43, 0.43, 0.50, 0.50},
    SeparatorHovered       = {0.10, 0.40, 0.75, 0.78},
    SeparatorActive        = {0.10, 0.40, 0.75, 1.00},
    ResizeGrip             = {0.26, 0.59, 0.98, 0.20},
    ResizeGripHovered      = {0.26, 0.59, 0.98, 0.67},
    ResizeGripActive       = {0.26, 0.59, 0.98, 0.95},
    Tab                    = {0.18, 0.35, 0.58, 0.86},
    TabHovered             = {0.26, 0.59, 0.98, 0.80},
    TabActive              = {0.20, 0.41, 0.68, 1.00},
    TabUnfocused           = {0.07, 0.10, 0.15, 0.97},
    TabUnfocusedActive     = {0.14, 0.26, 0.42, 1.00},
    DockingPreview         = {0.26, 0.59, 0.98, 0.70},
    DockingEmptyBg         = {0.20, 0.20, 0.20, 1.00},
    PlotLines              = {0.61, 0.61, 0.61, 1.00},
    PlotLinesHovered       = {1.00, 0.43, 0.35, 1.00},
    PlotHistogram          = {0.90, 0.70, 0.00, 1.00},
    PlotHistogramHovered   = {1.00, 0.60, 0.00, 1.00},
    TextSelectedBg         = {0.26, 0.59, 0.98, 0.35},
    DragDropTarget         = {1.00, 1.00, 0.00, 0.90},
}
local function applyAlpha(color)
    return { color[1], color[2], color[3], (color[4]) * imlove.style.globalAlpha }
end
local function textprint(tex,x,y,limit,align)
    love.graphics.setColor(imlove.colors.Text)
    love.graphics.print(tex, math.floor(x), math.floor(y))
end
local function textprintf(tex,x,y,limit,align,...)
    love.graphics.printf(tex, math.floor(x), math.floor(y),limit,align,...)
end
local mouse = {
    left_down = false,
    right_down = false,
    left_up = false,
    right_up = false,
    double = false,
    x = 0,
    y = 0,
    dx = 0,
    dy = 0,
    wheel = 0,
    timer = 0,
    double_interval = 0.3,
    last_click = 0,
}
imlove.idStack = {}
imlove.currentId = nil
-- Function to calculate FNV-1a hash
local function FNV1a(str)
    local hash = 0x811C9DC5
    for i = 1, #str do
        hash = bit.bxor(hash, str:byte(i))
        hash = (hash * 0x1000193) % 0x100000000
    end
    return hash
end
function imlove.init()
    imlove.load()
end

function imlove.GetID(str)
    local id
    if type(str) == "string" then
        id = FNV1a(str)
    elseif type(str) == "number" then
        id = str
    else
        error("GetID: Invalid input type. Expected string or number.")
    end
    return id
end
function imlove.PushID(id)
    table.insert(imlove.idStack, id)
    imlove.currentId = table.concat(imlove.idStack, ".")
end
function imlove.PopID()
    table.remove(imlove.idStack)
    imlove.currentId = #imlove.idStack > 0 and table.concat(imlove.idStack, ".") or nil
end
function imlove.newFrame()
    imlove.hot = nil
    imlove.drawList = {}

    if not mouse.left_down then
        imlove.active = nil
        for _, window in pairs(imlove.windows) do
            window.dragging = false
            window.resizing = false
        end
    end
end
function imlove.endFrame()
    imlove.mouse()
end
local first = true
function imlove.Begin(title, open, x, y, w, h)
    local id = imlove.GetID(title)
    imlove.PushID(title)
    local win = {}
    if imlove.old[id] and first then
        win = imlove.old[id]
        first = false
    end
    local window = imlove.windows[id] or {
        id = id,
        x = win.x or x,
        y = win.y or y,
        w = math.max(win.w or w, imlove.style.minWidth),
        h = math.max(win.h or h, imlove.style.minHeight),
        title = title,
        scrollY = 0,
        maxScrollY = 0,
        contentHeight = 0
    }
    imlove.currentWindow= window
    imlove.windows[id] = imlove.currentWindow
    imlove.windows[id].open = open

    -- Window dragging
    if imlove.active == id and imlove.currentWindow.dragging then
        imlove.currentWindow.x = mouse.x - imlove.currentWindow.dragOffsetX
        imlove.currentWindow.y = mouse.y - imlove.currentWindow.dragOffsetY
    end

    -- Window resizing
    if imlove.active == id and imlove.currentWindow.resizing then
        imlove.currentWindow.w = math.max(imlove.style.minWindowWidth, mouse.x - imlove.currentWindow.x)
        imlove.currentWindow.h = math.max(imlove.style.minWindowHeight, mouse.y - imlove.currentWindow.y)
    end

    imlove.currentWindow.x = math.max(imlove.currentWindow.x, 0)
    imlove.currentWindow.y = math.max(imlove.currentWindow.y, 0)
    imlove.currentWindow.w = math.min(imlove.currentWindow.w, math.max(love.graphics.getWidth() - imlove.currentWindow.x, imlove.style.minWindowWidth))
    imlove.currentWindow.h = math.min(imlove.currentWindow.h, math.max(love.graphics.getHeight() - imlove.currentWindow.y, imlove.style.minWindowHeight))

    -- Add close button
    local closeButtonSize = 16
    local closeButtonX = imlove.currentWindow.x + imlove.currentWindow.w - closeButtonSize - 5
    local closeButtonY = imlove.currentWindow.y + 5

    if imlove.hover(closeButtonX, closeButtonY, closeButtonSize, closeButtonSize) and mouse.left_up then
        imlove.windows[id].open = not imlove.windows[id].open
        return imlove.windows[id].open
    end
    imlove.windows[id].closeButton = {
        x = closeButtonX,
        y = closeButtonY,
        size = closeButtonSize
    }
    imlove.currentWindow.contentX = nil
    imlove.currentWindow.lastItemWidth = 0
    imlove.currentWindow.contentY = imlove.currentWindow.y + imlove.style.padding + 20

    -- Reset content height for new frame
    imlove.currentWindow.contentHeight = 0

    return imlove.windows[id].open
end
function imlove.End()
    local w = imlove.currentWindow
    -- Window dragging behavior
    if imlove.hover(w.x, w.y, w.w, 20) and mouse.left_down then
        imlove.active = w.id
        w.dragging = true
        w.dragOffsetX = mouse.x - w.x
        w.dragOffsetY = mouse.y - w.y
    end
    -- Window resizing behavior (bottom-right corner)
    local resizeHandleSize = imlove.style.resizeHandleSize
    if imlove.hover(w.x + w.w - resizeHandleSize, w.y + w.h - resizeHandleSize, resizeHandleSize, resizeHandleSize) and mouse.left_down then
        imlove.active = w.id
        w.resizing = true
    end
    -- Draw resize handle
    if w.resizing then
        table.insert(imlove.drawList, {
            type = "resize_handle",
            x = w.x + w.w - resizeHandleSize,
            y = w.y + w.h - resizeHandleSize,
            size = resizeHandleSize
        })
    end
    -- Calculate max scroll
    w.maxScrollY = math.max(0, w.contentHeight - (w.h - 20 - imlove.style.padding * 2))
    -- Add scrollbar only if content height is greater than window height
    if w.contentHeight > (w.h - 20 - imlove.style.padding * 2) then
        imlove.addScrollbar(w)
    end
    imlove.currentWindow = nil
    imlove.PopID()
end
function imlove.BeginPopup(title)
    local id = imlove.GetID(title)
    imlove.PushID(title)
    imlove.currentPopup = imlove.windows[id] or {
        id = id,
        x = love.graphics.getWidth() / 2 - 100,
        y = love.graphics.getHeight() / 2 - 100,
        w = 200,
        h = 200,
        title = title,
        isPopup = true,
        scrollY = 0,
        maxScrollY = 0,
        contentHeight = 0
    }
    imlove.windows[id] = imlove.currentPopup

    imlove.currentPopup.contentY = imlove.currentPopup.y + imlove.style.padding + 20

    if imlove.currentPopup.open then
        imlove.currentWindow = imlove.currentPopup
        imlove.currentWindow.contentX = nil
        imlove.currentWindow.lastItemWidth = 0
        -- Reset content height for new frame
        imlove.currentPopup.contentHeight = 0
        return true
    end

    return false
end
function imlove.EndPopup()
    local p = imlove.currentPopup

    -- Calculate max scroll
    p.maxScrollY = math.max(0, p.contentHeight - (p.h - 20 - imlove.style.padding * 2))

    -- Add scrollbar only if content height is greater than popup height
    if p.contentHeight > (p.h - 20 - imlove.style.padding * 2) then
        imlove.addScrollbar(p)
    end

    imlove.currentPopup = nil
    imlove.currentWindow = nil
    imlove.PopID()
end
function imlove.addScrollbar(window)
    local scrollbarX = window.x + window.w - imlove.style.scrollbarWidth - imlove.style.padding
    local scrollbarY = window.y + 20 + imlove.style.padding
    local scrollbarHeight = window.h - 20 - imlove.style.padding * 2
    local scrollbarHandleHeight = math.max(imlove.style.scrollbarMinHeight, (window.h / window.contentHeight) * scrollbarHeight)

    -- Scrollbar behavior
    if imlove.hover(scrollbarX, scrollbarY, imlove.style.scrollbarWidth, scrollbarHeight) and mouse.left_down then
        local clickY = mouse.y - scrollbarY
        local ratio = clickY / scrollbarHeight
        window.scrollY = ratio * window.maxScrollY
    end

    -- Clamp scrollY
    window.scrollY = math.max(0, math.min(window.scrollY, window.maxScrollY))

    -- Draw scrollbar
    table.insert(imlove.drawList, {
        type = "scrollbar",
        x = scrollbarX,
        y = scrollbarY,
        w = imlove.style.scrollbarWidth,
        h = scrollbarHeight,
        handleHeight = scrollbarHandleHeight,
        scrollY = window.scrollY,
        maxScrollY = window.maxScrollY
    })
end
function imlove.openPopup(title)
    local id = imlove.GetID(title)
    if imlove.windows[id] then
        imlove.windows[id].open = true
    end
end
function imlove.closePopup(title)
    local id = imlove.GetID(title)
    if imlove.windows[id] then
        imlove.windows[id].open = false
    end
end
function imlove.Button(label)
    local w = imlove.currentWindow
    local id = imlove.GetID(label)
    local x = w.contentX or (w.x + imlove.style.margin)
    local y = w.contentY -- w.scrollY
    local width = love.graphics.getFont():getWidth(label) + imlove.style.padding * 2
    local height = imlove.style.minHeight
    local hot = imlove.hover(x, y, width, height)
    local clicked = false
    if hot and mouse.left_up then
        clicked = true
    end
    table.insert(imlove.drawList, {
        type = "button",
        id = id,
        x = x,
        y = y,
        w = width,
        h = height,
        label = label,
        state = imlove.getElementState(id)
    })
    w.lastItemWidth = width
    w.contentX = nil -- Reset for the next row
    w.contentY = w.contentY + height + imlove.style.margin
    w.contentHeight = w.contentHeight + height + imlove.style.margin
    return clicked
end
function imlove.Slider(label, value, min, max)
    local w = imlove.currentWindow
    local id = imlove.GetID(label)
    local x = w.x + imlove.style.padding
    local y = w.contentY - w.scrollY
    local width = w.w - 2 * imlove.style.padding
    local height = imlove.style.minHeight
    local newValue = value
    if imlove.active == id then
        local ratio = (mouse.x - x) / width
        newValue = min + (max - min) * ratio
        newValue = math.max(min, math.min(max, newValue))
    end

    if imlove.buttonBehavior(x, y, width, height, id) then
        imlove.active = id
    end

    table.insert(imlove.drawList, {
        type = "slider",
        id = id,
        x = x,
        y = y,
        w = width,
        h = height,
        label = label,
        value = newValue,
        min = min,
        max = max,
        state = imlove.getElementState(id)
    })

    w.contentY = w.contentY + height + imlove.style.margin
    w.contentHeight = w.contentHeight + height + imlove.style.margin
    return newValue
end
function imlove.Checkbox(label, checked)
    local w = imlove.currentWindow
    local id = imlove.GetID(label)
    local x = w.x + imlove.style.padding
    local y = w.contentY - w.scrollY
    local height = imlove.style.minHeight
    local width = w.w - 2 * imlove.style.padding

    local hot = imlove.hover(x, y, width, height)
    if hot and mouse.left_up then
        checked = not checked
    end

    table.insert(imlove.drawList, {
        type = "checkbox",
        id = id,
        x = x,
        y = y,
        size = height,
        label = label,
        checked = checked,
        state = imlove.getElementState(id)
    })

    w.contentY = w.contentY + height + imlove.style.margin
    w.contentHeight = w.contentHeight + height + imlove.style.margin
    return checked
end
function imlove.TextPanel(text, alignment)
    local w = imlove.currentWindow
    local x = w.x + imlove.style.padding
    local y = w.contentY - w.scrollY
    local width = w.w - 2 * imlove.style.padding
    local font = love.graphics.getFont()
    local _, textLines = font:getWrap(text, width)
    local height = #textLines * font:getHeight() + 2 * imlove.style.padding

    alignment = alignment or "left"
    table.insert(imlove.drawList, {
        type = "text_panel",
        x = x,
        y = y,
        w = width,
        h = height,
        text = text,
        alignment = alignment
    })
    w.contentY = w.contentY + height + imlove.style.margin
    w.contentHeight = w.contentHeight + height + imlove.style.margin
end
function imlove.buttonBehavior(x, y, w, h, id)
    local hot = mouse.x > x and mouse.x < x + w and mouse.y > y and mouse.y < y + h
    if hot and imlove.active == nil then
        imlove.hot = id
    end
    if imlove.active == id then
        if not mouse.left_down then
            if imlove.hot == id then
                return true
            end
            imlove.active = nil
        end
    elseif imlove.hot == id and mouse.left_down then
        imlove.active = id
    end

    return false
end
function imlove.hover(x, y, w, h)
    return mouse.x > x and mouse.x < x + w and mouse.y > y and mouse.y < y + h
end
function imlove.getElementState(id)
    if imlove.active == id then
        return "active"
    elseif imlove.hot == id then
        return "hover"
    else
        return "normal"
    end
end
function imlove.Image(image, quad, w, h)
    local currentWindow = imlove.currentWindow
    local x = currentWindow.x + imlove.style.padding
    local y = currentWindow.contentY - currentWindow.scrollY
    local width = w or image:getWidth()
    local height = h or image:getHeight()
    table.insert(imlove.drawList, {
        type = "image",
        image = image,
        quad = quad,
        x = x,
        y = y,
        w = width,
        h = height
    })

    currentWindow.contentY = currentWindow.contentY + height + imlove.style.margin
    currentWindow.contentHeight = currentWindow.contentHeight + height + imlove.style.margin
end
function imlove.ButtonImage(image, quad, w, h)
    local currentWindow = imlove.currentWindow
    local x = currentWindow.x + imlove.style.padding
    local y = currentWindow.contentY - currentWindow.scrollY
    local width = w or image:getWidth()
    local height = h or image:getHeight()
    local id = imlove.GetID(tostring(image))
    local clicked = imlove.buttonBehavior(x, y, width, height, id)
    table.insert(imlove.drawList, {
        type = "button_image",
        image = image,
        quad = quad,
        x = x,
        y = y,
        w = width,
        h = height,
        state = imlove.getElementState(id)
    })
    currentWindow.contentY = currentWindow.contentY + height + imlove.style.margin
    currentWindow.contentHeight = currentWindow.contentHeight + height + imlove.style.margin
    return clicked
end
function imlove.Selectable(label, selected)
    local currentWindow = imlove.currentWindow
    local x = currentWindow.x + imlove.style.padding
    local y = currentWindow.contentY - currentWindow.scrollY
    local width = currentWindow.w - 2 * imlove.style.padding
    local height = imlove.style.minHeight
    local id = imlove.GetID(label)

    if imlove.buttonBehavior(x, y, width, height, id) then
        selected = not selected
    end

    table.insert(imlove.drawList, {
        type = "selectable",
        x = x,
        y = y,
        w = width,
        h = height,
        label = label,
        selected = selected,
        state = imlove.getElementState(id)
    })

    currentWindow.contentY = currentWindow.contentY + height + imlove.style.margin
    currentWindow.contentHeight = currentWindow.contentHeight + height + imlove.style.margin
    return selected
end
function imlove.SelectableImage(image, quad, selected, size)
    local currentWindow = imlove.currentWindow
    local x = currentWindow.x + imlove.style.padding
    local y = currentWindow.contentY - currentWindow.scrollY
    local width, height
    
    if type(size) == "number" then
        width, height = size, size
    elseif type(size) == "table" then
        width, height = size[1], size[2]
    else
        width, height = image:getWidth(), image:getHeight()
    end

    local id = imlove.GetID(tostring(image))

    if imlove.buttonBehavior(x, y, width, height, id) then
        selected = not selected
    end

    table.insert(imlove.drawList, {
        type = "selectable_image",
        image = image,
        quad = quad,
        x = x,
        y = y,
        w = width,
        h = height,
        selected = selected,
        state = imlove.getElementState(id)
    })

    currentWindow.contentY = currentWindow.contentY + height + imlove.style.margin
    currentWindow.contentHeight = currentWindow.contentHeight + height + imlove.style.margin
    return selected
end
function imlove.CollapsingHeader(label, open)
    local currentWindow = imlove.currentWindow
    local x = currentWindow.x + imlove.style.padding
    local y = currentWindow.contentY - currentWindow.scrollY
    local width = currentWindow.w - 2 * imlove.style.padding
    local height = imlove.style.minHeight
    local id = imlove.GetID(label)
    if imlove.buttonBehavior(x, y, width, height, id) then
        open = not open
    end
    table.insert(imlove.drawList, {
        type = "collapsing_header",
        x = x,
        y = y,
        w = width,
        h = height,
        label = label,
        open = open,
        state = imlove.getElementState(id)
    })
    currentWindow.contentY = currentWindow.contentY + height + imlove.style.margin
    currentWindow.contentHeight = currentWindow.contentHeight + height + imlove.style.margin
    return open
end
function imlove.ProgressBar(label, fraction, value, max)
    local currentWindow = imlove.currentWindow
    local x = currentWindow.x + imlove.style.padding
    local y = currentWindow.contentY - currentWindow.scrollY
    local width = currentWindow.w - 2 * imlove.style.padding
    local height = imlove.style.minHeight
    if label == "" then
        label = "Loading " .. value
    end
    table.insert(imlove.drawList, {
        type = "progress_bar",
        x = x,
        y = y,
        w = width,
        h = height,
        label = label,
        fraction = fraction,
        value = value,
        max = max
    })
    currentWindow.contentY = currentWindow.contentY + height + imlove.style.margin
    currentWindow.contentHeight = currentWindow.contentHeight + height + imlove.style.margin
end
function imlove.Sameline(spacing)
    local w = imlove.currentWindow
    spacing = spacing or imlove.style.itemSpacing
    w.contentY = w.contentY - (imlove.style.minHeight + imlove.style.margin)
    w.contentHeight = w.contentHeight - (imlove.style.minHeight + imlove.style.margin)
    w.lastItemWidth = w.lastItemWidth or 0
    w.contentX = (w.contentX or (w.x + imlove.style.margin)) + w.lastItemWidth + spacing
    w.lastItemWidth = 0
end
function imlove.Separator(label, size, position)
    local currentWindow = imlove.currentWindow
    local x = currentWindow.x + imlove.style.padding
    local y = currentWindow.contentY - currentWindow.scrollY
    local width = currentWindow.w - 2 * imlove.style.padding
    local font = love.graphics.getFont()
    size = size or font:getHeight()
    label = label or ""
    position = position or "left"
    local textWidth = font:getWidth(label)
    local height = size
    table.insert(imlove.drawList, {
        type = "separator",
        x = x,
        y = y,
        w = width,
        h = height,
        label = label,
        position = position,
        textWidth = textWidth
    })
    currentWindow.contentY = currentWindow.contentY + height + imlove.style.margin
    currentWindow.contentHeight = currentWindow.contentHeight + height + imlove.style.margin
end
function imlove.renderDrawList()
    local ctx = imlove.windows
    table.sort(ctx, function(a, b) return (a.ZOrder or 0) > (b.ZOrder or 0) end)
    love.graphics.push()
    love.graphics.setColor(1, 1, 1)
    for _, win in pairs(ctx) do
        if win.open then
            love.graphics.setColor(imlove.colors.WindowBg)
            love.graphics.rectangle("fill", win.x, win.y, win.w, win.h)
            love.graphics.setColor(imlove.colors.Border)
            love.graphics.rectangle("line", win.x, win.y, win.w, win.h)
            love.graphics.setColor(imlove.colors.Text)
            textprint(win.title, win.x + 5, win.y + 5)

            if not win.isPopup then
                love.graphics.setColor(1, 0, 0, 1)
                love.graphics.rectangle("fill", win.closeButton.x, win.closeButton.y, win.closeButton.size, win.closeButton.size)
                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.line(win.closeButton.x + 4, win.closeButton.y + 4, win.closeButton.x + win.closeButton.size - 4, win.closeButton.y + win.closeButton.size - 4)
                love.graphics.line(win.closeButton.x + 4, win.closeButton.y + win.closeButton.size - 4, win.closeButton.x + win.closeButton.size - 4, win.closeButton.y + 4)
            end

            -- Set scissor to clip content
            love.graphics.setScissor(win.x, win.y + 20, win.w, win.h - 20)

            for _, item in ipairs(imlove.drawList) do
                imlove.renderItem(item)
            end

            -- Reset scissor
            love.graphics.setScissor()
        end
    end
    love.graphics.pop()
end
function imlove.getButtonColor(state)
    if state == "active" then
        return imlove.colors.ButtonActive
    elseif state == "hover" then
        return imlove.colors.ButtonHovered
    else
        return imlove.colors.Button
    end
end
function imlove.renderItem(item)
    if item.type == "button" then
        love.graphics.setColor( applyAlpha(imlove.getButtonColor(item.state)))
        love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        love.graphics.setColor(imlove.colors.Text)
        textprint(item.label, item.x + imlove.style.padding, item.y + item.h/2 - 7)
    elseif item.type == "slider" then
        love.graphics.setColor(applyAlpha( imlove.colors.SliderGrabActive))
        love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        love.graphics.setColor(applyAlpha(imlove.colors.SliderGrab))
        local fillWidth = (item.value - item.min) / (item.max - item.min) * item.w
        love.graphics.rectangle("fill", item.x, item.y, fillWidth, item.h)
        textprint(string.format("%s: %.2f", item.label, item.value), item.x + imlove.style.padding, item.y + item.h/2 - 7)
    elseif item.type == "checkbox" then
        love.graphics.setColor(applyAlpha(imlove.colors.FrameBg))
        love.graphics.rectangle("fill", item.x, item.y, item.size, item.size)
        if item.checked then
            love.graphics.setColor(applyAlpha(imlove.colors.CheckMark))
            love.graphics.rectangle("fill", item.x + 4, item.y + 4, item.size - 8, item.size - 8)
        end
        
        textprint(item.label, item.x + item.size + imlove.style.padding, item.y + item.size/2 - 7)
    elseif item.type == "text_panel" then
        love.graphics.setColor(applyAlpha(imlove.colors.WindowBg))
        love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        love.graphics.setColor(applyAlpha(imlove.colors.Text))
        textprintf(item.text, item.x + imlove.style.padding, item.y + imlove.style.padding, item.w - 2 * imlove.style.padding, item.alignment)
    elseif item.type == "resize_handle" then
        love.graphics.setColor(applyAlpha(imlove.colors.ResizeGrip))
        love.graphics.rectangle("fill", item.x, item.y, item.size, item.size)
    elseif item.type == "image" or item.type == "button_image" or item.type == "selectable_image" then
        love.graphics.setColor(applyAlpha({1, 1, 1, 1}))
        if item.quad then
            love.graphics.draw(item.image, item.quad, item.x, item.y, 0, item.w / item.quad:getWidth(), item.h / item.quad:getHeight())
        else
            love.graphics.draw(item.image, item.x, item.y, 0, item.w / item.image:getWidth(), item.h / item.image:getHeight())
        end
        if item.type == "button_image" then
            love.graphics.setColor(applyAlpha(imlove.getButtonColor(item.state)))
            love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        elseif item.type == "selectable_image" and item.selected then
            love.graphics.setColor(applyAlpha(imlove.colors.FrameBgActive))
            love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        end
    elseif item.type == "selectable" then
        love.graphics.setColor(applyAlpha(item.selected and imlove.colors.FrameBgActive or imlove.getButtonColor(item.state)))
        love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        
        textprint(item.label, item.x + imlove.style.padding, item.y + item.h/2 - 7)
    elseif item.type == "collapsing_header" then
        love.graphics.setColor(applyAlpha(imlove.getButtonColor(item.state)))
        love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        
        textprint(item.label .. (item.open and " ▼" or " ▶"), item.x + imlove.style.padding, math.floor(item.y + item.h/2 - 7))
    elseif item.type == "progress_bar" then
        love.graphics.setColor(applyAlpha(imlove.colors.FrameBg))
        love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        love.graphics.setColor(applyAlpha( imlove.colors.PlotHistogram))
        love.graphics.rectangle("fill", item.x, item.y, item.w * item.fraction, item.h)
        
        textprint(string.format("%s: %d/%d", item.label, item.value, item.max), item.x + imlove.style.padding, item.y + item.h/2 - 7)
    elseif item.type == "scrollbar" then
        love.graphics.setColor(applyAlpha(imlove.colors.ScrollbarBg) )
        love.graphics.rectangle("fill", item.x, item.y, item.w, item.h)
        love.graphics.setColor(applyAlpha(imlove.colors.ScrollbarGrab))
        local handleY = item.y + (item.scrollY / item.maxScrollY) * (item.h - item.handleHeight)
        love.graphics.rectangle("fill", item.x, handleY, item.w, item.handleHeight)
    elseif item.type == "separator" then
        love.graphics.setColor(applyAlpha(imlove.colors.Separator))
        local font = love.graphics.getFont()
        local textHeight = font:getHeight()
        local y = item.y + (item.h - textHeight) / 2
        love.graphics.setColor(imlove.colors.Text)
        if item.position == "left" then
            textprint(item.label, item.x, y)
            love.graphics.rectangle("fill", item.x + item.textWidth + imlove.style.padding, item.y + item.h / 2, item.w - item.textWidth - imlove.style.padding, 1)
        elseif item.position == "right" then
            love.graphics.rectangle("fill", item.x, item.y + item.h / 2, item.w - item.textWidth - imlove.style.padding, 1)
            textprint(item.label, item.x + item.w - item.textWidth, y)
        elseif item.position == "middle" then
            local leftWidth = (item.w - item.textWidth) / 2 - imlove.style.padding
            love.graphics.rectangle("fill", item.x, item.y + item.h / 2, leftWidth, 1)
            textprint(item.label, item.x + leftWidth + imlove.style.padding, y)
            love.graphics.rectangle("fill", item.x + leftWidth + item.textWidth + 2 * imlove.style.padding, item.y + item.h / 2, leftWidth, 1)
        end
    end
end
-- save/load
local function serializeTable(tbl, indent)
    if not indent then indent = 0 end
    local tostring = tostring
    local result = "{\n"
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent + 1)
        if type(k) == "number" then
            formatting = formatting .. "[" .. k .. "] = "
        elseif type(k) == "string" then
            formatting = formatting .. '["' .. k .. '"] = '
        end
        if type(v) == "number" then
            result = result .. formatting .. v .. ",\n"
        elseif type(v) == "string" then
            result = result .. formatting .. string.format("%q", v) .. ",\n"
        elseif type(v) == "table" then
            result = result .. formatting .. serializeTable(v, indent + 1) .. ",\n"
        elseif type(v) == "boolean" then
            result = result .. formatting .. tostring(v) .. ",\n"
        end
    end
    result = result .. string.rep("  ", indent) .. "}"
    return result
end
function imlove.save()
    local data = {}
    for id, window in pairs(imlove.windows) do
        data[id] = {
            x = window.x,
            y = window.y,
            w = window.w,
            h = window.h,
            open = window.open,
            isPopup = window.isPopup,
            title = window.title,
            scrollY = window.scrollY,
            maxScrollY = window.maxScrollY,
            contentHeight = window.contentHeight
        }

    end
    local serialized = "return " .. string_table(data)
    love.filesystem.write("ui_state.lua", serialized)
end
function imlove.load()
    if love.filesystem.getInfo("ui_state.lua") then
        local chunk, err = love.filesystem.load("ui_state.lua")
        if chunk then
            local data = chunk()
            for id, windowData in pairs(data) do
                if imlove.windows[id] then
                    for key, value in pairs(windowData) do
                        imlove.old[id][key] = value
                    end
                else
                    -- Create a new window if it doesn't exist
                    imlove.old[id] = windowData
                end
            end
        else
            print("Error loading UI state:", err)
        end
    end
end
-- input
function imlove.keypressed(key)
    imlove.KeysDown[key] = true
    if key == "lctrl" or key == "rctrl" then
        imlove.Ctrl = true
    end
    if key == "lalt" or key == "ralt" then
        imlove.Alt = true
    end
    if key == "lshift" or key == "rshift" then
        imlove.Shift = true
    end
    if key == "backspace" and love.keyboard.hasTextInput() then
        local byteoffset = utf8.offset(imlove.text, -1)
        if byteoffset then
            imlove.text = string.sub(imlove.text, 1, byteoffset - 1)
        end
    end
end
function imlove.keyreleased(key)
    imlove.KeysDown[key] = false
    if key == "lctrl" or key == "rctrl" then
        imlove.Ctrl = false
    end
    if key == "lalt" or key == "ralt" then
        imlove.Alt = false
    end
    if key == "lshift" or key == "rshift" then
        imlove.Shift = false
    end
end
function imlove.textinput(t)
    if imlove.input then imlove.text = imlove.text .. t end 
end
function imlove.mouse()
    mouse.left_up = false
    mouse.right_up = false
    mouse.x , mouse.y = love.mouse.getPosition()
    mouse.dx = mouse.x - mouse.dx
    mouse.dy = mouse.y - mouse.dy
    mouse.wheel = 0
    mouse.timer = 0
    mouse.last_click = 0
    mouse.double = false
end
function imlove.pressed(btn)
    if btn == 1 then
        mouse.left_down = true
    elseif btn == 2 then
        mouse.right_down = true
    end
end
function imlove.released(btn)
    if btn == 1 then
        mouse.left_down = false
        mouse.left_up = true
    elseif btn == 2 then
        mouse.right_down = false
        mouse.right_up = true
    end
end
function imlove.moved(x, y)
    mouse.dx = x - mouse.x
    mouse.dy = y - mouse.y
    mouse.x, mouse.y = x, y
end
function imlove.wheel(_, y)
    mouse.wheel = y
end
return imlove