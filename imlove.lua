
-- QUICK START
-- ───────────
--   local im = require "imlove"
--
--   function love.load()     im.Init()       end
--   function love.update(dt) im.Update(dt)   end
--   function love.draw()
--       im.BeginFrame()
--       if im.Begin("My Window") then
--           im.Label("Hello!")
--           if im.Button("Click") then print("clicked") end
--           myVal = im.Slider("Speed", myVal, 0, 100)
--           myChk = im.Checkbox("Enable", myChk)
--           myTxt = im.InputText("Name", myTxt)
--       end
--       im.End()
--       im.EndFrame()
--   end
--   function love.mousepressed(x,y,b)  im.MousePressed(x,y,b)  end
--   function love.mousereleased(x,y,b) im.MouseReleased(x,y,b) end
--   function love.wheelmoved(x,y)      im.WheelMoved(x,y)      end
--   function love.keypressed(k,s)      im.KeyPressed(k,s)       end
--   function love.textinput(t)         im.TextInput(t)          end

local lg        = love.graphics
local bit       = require("bit")
local utf8      = require("utf8")

local im        = {
    _VERSION     = "0.3.2",
    _DESCRIPTION = "A pure Lua 5.1 immediate-mode UI for LÖVE 2D",
    _URL         = "https://github.com/radda-ui/imlove",
    _LICENSE     = [[
       MIT License

        Copyright (c) 2024-2026 Salem Raddaoui

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
}

-- ─────────────────────────────────────────────────────────────────────────────
--  FLAG CONSTANTS  (pass as varargs after options in im.Begin)
-- ─────────────────────────────────────────────────────────────────────────────
im.NoTitleBar   = "noTitleBar"
im.NoResize     = "noResize"
im.NoMove       = "noMove"
im.NoScrollbar  = "noScrollbar"
im.NoBackground = "noBackground"
im.NoClose      = "noClose"
im.NoMinimize   = "noMinimize"
im.FitContent   = "fitContent"
-- ─────────────────────────────────────────────────────────────────────────────
--  STYLE
-- ─────────────────────────────────────────────────────────────────────────────
im.style        = {
    padding        = 8,
    itemSpacingY   = 4,
    itemSpacingX   = 6,
    windowPadding  = 10,
    windowMinW     = 120,
    windowMinH     = 60,
    titleBarH      = 20,
    scrollbarW     = 10,
    resizeGripSize = 14,
    checkboxSize   = 14,
    sliderH        = 14,
    inputH         = 22,
    menuBarH       = 22,
    menuItemH      = 22,
    menuItemPadX   = 10,
    windowRound    = 0,
    widgetRound    = 0,
    font           = nil,
    col            = {
        windowBg         = { 0.15, 0.15, 0.18, 0.97 },
        titleBar         = { 0.22, 0.22, 0.28, 1.00 },
        titleBarActive   = { 0.28, 0.28, 0.40, 1.00 },
        titleText        = { 0.95, 0.95, 0.95, 1.00 },
        border           = { 0.35, 0.35, 0.45, 0.80 },
        widgetBg         = { 0.10, 0.10, 0.13, 1.00 },
        widgetHover      = { 0.25, 0.25, 0.35, 1.00 },
        widgetActive     = { 0.30, 0.50, 0.75, 1.00 },
        button           = { 0.24, 0.36, 0.58, 1.00 },
        buttonHover      = { 0.32, 0.46, 0.70, 1.00 },
        buttonActive     = { 0.42, 0.58, 0.85, 1.00 },
        checkMark        = { 0.40, 0.70, 0.40, 1.00 },
        sliderGrab       = { 0.38, 0.58, 0.90, 1.00 },
        sliderGrabHover  = { 0.50, 0.70, 1.00, 1.00 },
        sliderTrack      = { 0.20, 0.20, 0.28, 1.00 },
        inputBg          = { 0.12, 0.12, 0.16, 1.00 },
        inputBgActive    = { 0.16, 0.16, 0.22, 1.00 },
        inputCursor      = { 0.90, 0.90, 0.90, 1.00 },
        separator        = { 0.35, 0.35, 0.45, 0.60 },
        text             = { 0.90, 0.90, 0.90, 1.00 },
        textDisabled     = { 0.50, 0.50, 0.55, 1.00 },
        scrollbarBg      = { 0.10, 0.10, 0.13, 0.60 },
        scrollbarGrab    = { 0.45, 0.45, 0.55, 0.80 },
        scrollbarHover   = { 0.60, 0.60, 0.70, 0.90 },
        resizeGrip       = { 0.35, 0.35, 0.55, 0.50 },
        resizeGripHover  = { 0.55, 0.55, 0.80, 0.80 },
        tooltip          = { 0.18, 0.18, 0.22, 0.95 },
        tooltipBorder    = { 0.45, 0.45, 0.60, 1.00 },
        tooltipText      = { 0.90, 0.90, 0.90, 1.00 },
        progressBar      = { 0.38, 0.58, 0.90, 1.00 },
        progressBg       = { 0.20, 0.20, 0.28, 1.00 },
        closeBtn         = { 0.65, 0.18, 0.18, 0.85 },
        closeBtnHover    = { 0.90, 0.25, 0.25, 1.00 },
        minimizeBtn      = { 0.30, 0.30, 0.42, 0.85 },
        minimizeBtnHover = { 0.50, 0.50, 0.68, 1.00 },
        menuBarBg        = { 0.20, 0.20, 0.26, 1.00 },
        menuBg           = { 0.18, 0.18, 0.23, 0.98 },
        menuHover        = { 0.30, 0.50, 0.75, 1.00 },
        menuText         = { 0.90, 0.90, 0.90, 1.00 },
        menuShortcut     = { 0.55, 0.55, 0.62, 1.00 },
        menuSep          = { 0.35, 0.35, 0.48, 0.80 },
    },
}

-- ─────────────────────────────────────────────────────────────────────────────
--  PROTOTYPES  — authoritative schema for every widget/structure
-- ─────────────────────────────────────────────────────────────────────────────
im._proto       = {

    window = {
        id = "", title = "", x = 0, y = 0, w = 280, h = 300, scrollY = 0, open = true, minimized = false,
        flags = { noTitleBar = false, noResize = false, noMove = false, noScrollbar = false, noBackground = false, noClose = false, noMinimize = false ,fitContent = false },
        inner = nil, cursorX = 0, cursorY = 0, lineH = 0, _pendingLineH = 0, lineStartX = 0, sameLine = false, sameLineSpacing = 0, sameLineOffsetY = 0, widgetY = 0, contentW = 0, contentH = 0, _menuBar = nil,
        dragOffX = 0, dragOffY = 0, _sbGrabOff = 0, drawCmds = nil, _cmdPool = nil, _cmdCount = 0, _indentStack = nil, _baseInnerX = 0, _initDone = false, _isPopup = false,
    },
    label = { x = 0, y = 0, text = "", color = nil },
    button = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0 },
    checkbox = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0, value = false },
    radioButton = { id = 0, label = "", x = 0, y = 0, r = 0, current = nil, buttonValue = nil },
    slider = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0, value = 0, vmin = 0, vmax = 1, fmt = "%.2f", grabX = 0, grabW = 10 },
    inputText = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0, text = "", maxLen = 256, cursorPos = 0, selAnchor = 0 },
    inputInt = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0 },
    inputFloat = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0 },
    combo = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0 },
    progressBar = { x = 0, y = 0, w = 0, h = 0, fraction = 0, overlay = nil },
    selectable = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0, selected = false },
    collapsingHeader = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0, open = false },
    image = { x = 0, y = 0, w = 0, h = 0, image = nil, quad = nil, sx = 1, sy = 1 },
    selectableImage = { id = 0, label = "", x = 0, y = 0, w = 0, h = 0, image = nil, quad = nil, sx = 1, sy = 1, selected = false },
    separator = { x1 = 0, y1 = 0, x2 = 0, y2 = 0 },

    menuBar = { y = 0, h = 0, curX = 0, items = {} },
    menuDrop = { id = "", x = 0, y = 0, w = 140, h = 0, nextY = 0, items = {} },
    menuItem = { kind = "item", label = "", shortcut = nil, enabled = true, hover = false, iy = 0, itemH = 0 },
}

local function _copy(proto)
    local c = {}
    for k, v in pairs(proto) do
        if type(v) == "table" then
            local nc = {}
            for kk, vv in pairs(v) do nc[kk] = vv end
            c[k] = nc
        else
            c[k] = v
        end
    end
    return c
end

-- ─────────────────────────────────────────────────────────────────────────────
--  INTERNAL STATE
-- ─────────────────────────────────────────────────────────────────────────────
local S           = {}
local _colorStack = {}
local _varStack   = {}
local _fontStack  = {}

-- ─────────────────────────────────────────────────────────────────────────────
--  INIT / UPDATE
-- ─────────────────────────────────────────────────────────────────────────────
function im.Init()
    S.windows          = {}
    S.windowOrder      = {}
    S.widgets          = {}
    S.openMenuId       = nil
    S.tooltipText      = nil
    S.tooltipX         = 0
    S.tooltipY         = 0
    S.mx, S.my         = 0, 0
    S.mouseDown        = { false, false, false }
    S.mousePressed     = { false, false, false }
    S.mouseReleased    = { false, false, false }
    S._pendingPressed  = { false, false, false }
    S._pendingReleased = { false, false, false }
    S._pendingScroll   = 0
    S._pendingKeys     = {}
    S._pendingText     = ""
    S.scrollDelta      = 0
    S.hot              = nil
    S.active           = nil
    S.currentWindow    = nil
    S.idStack          = {}
    S._idPrefix        = nil
    S.keyQueue         = {}
    S.textQueue        = ""
    S.activeInputId    = nil
    S.inputStates      = {}
    S.inputCursorPos   = 0
    S.inputSelAnchor   = 0
    S.inputBlinkT      = 0
    S._inputDragId     = nil
    S.dt               = 0
    S.frame            = 0
    S.mouseOwnerWindow = nil
    S.menuDrop         = nil
    S._menuInAny       = false
    S._lastItemRect    = nil
    S._pendingPopup    = nil
    S._savedLayout     = nil
    im.style.font      = lg.getFont()
end

function im.Update(dt)
    S.dt          = dt
    S.inputBlinkT = S.inputBlinkT + dt

end

-- ─────────────────────────────────────────────────────────────────────────────
--  FONT STACK
-- ─────────────────────────────────────────────────────────────────────────────
function im._font()
    if #_fontStack > 0 then return _fontStack[#_fontStack] end
    return im.style.font or lg.getFont()
end

function im.PushFont(font) table.insert(_fontStack, font); lg.setFont(font) end
function im.PopFont() table.remove(_fontStack); lg.setFont(im._font()) end

-- ─────────────────────────────────────────────────────────────────────────────
--  STYLE STACKS
-- ─────────────────────────────────────────────────────────────────────────────
function im.PushStyleColor(key, color)
    if type(key) ~= "string" or not im.style.col[key] then
        print("[imlove] ERROR: Invalid Style Color Key: " .. tostring(key))
        return
    end
    table.insert(_colorStack, { key = key, prev = im.style.col[key] })
    -- Copy the values so the user's table reference doesn't mutate the UI
    im.style.col[key] = { color[1], color[2], color[3], color[4] or 1 }
end
function im.PopStyleColor(count)
    for _ = 1, (count or 1) do
        local e = table.remove(_colorStack)
        if e then im.style.col[e.key] = e.prev end
    end
end


function im.PushStyleVar(key, value)
    if type(key) ~= "string" or im.style[key] == nil then
        print("[imlove] ERROR: Invalid Style Var Key: " .. tostring(key))
        return
    end
    table.insert(_varStack, { key = key, prev = im.style[key] })
    im.style[key] = value
end
function im.PopStyleVar(count)
    for _ = 1, (count or 1) do
        local e = table.remove(_varStack)
        if e then im.style[e.key] = e.prev end
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
--  LOVE2D INPUT CALLBACKS
-- ─────────────────────────────────────────────────────────────────────────────
function im.MousePressed(x, y, button) if button <= 3 then S._pendingPressed[button] = true end end
function im.MouseReleased(x, y, button) if button <= 3 then S._pendingReleased[button] = true end end
function im.WheelMoved(x, y) S._pendingScroll = S._pendingScroll + y end
function im.KeyPressed(key) table.insert(S._pendingKeys, key) end
function im.TextInput(text) S._pendingText = S._pendingText .. text end
function im.resize(w,h)end

-- ─────────────────────────────────────────────────────────────────────────────
--  FRAME
-- ─────────────────────────────────────────────────────────────────────────────
function im.BeginFrame()
    -- this prevent stack leak:
    if #S.idStack > 0 then S.idStack = {}; S._idPrefix = nil end
    if #_colorStack > 0 then im.PopStyleColor(#_colorStack) end
    if #_varStack > 0 then im.PopStyleVar(#_varStack) end
    S.frame            = S.frame + 1
    S.tooltipText = nil
    S.hot = nil
    S._lastItemRect = nil
    S._idPrefix = nil

    S.mousePressed     = { S._pendingPressed[1], S._pendingPressed[2], S._pendingPressed[3] }
    S.mouseReleased    = { S._pendingReleased[1], S._pendingReleased[2], S._pendingReleased[3] }
    S.scrollDelta      = S._pendingScroll
    S.keyQueue         = S._pendingKeys
    S.textQueue        = S._pendingText
    S._pendingPressed  = { false, false, false }
    S._pendingReleased = { false, false, false }
    S._pendingScroll   = 0
    S._pendingKeys = {}
    S._pendingText = ""

    S.mx, S.my         = love.mouse.getPosition()
    for i = 1, 3 do S.mouseDown[i] = love.mouse.isDown(i) end

    S.menuDrop = nil
    S._menuInAny = false

    if S.openMenuId then
        local sep = S.openMenuId:find("::", 1, true)
        local winId = sep and S.openMenuId:sub(1, sep - 1)
        local ow = winId and S.windows[winId]
        if not ow or not ow.open or ow.minimized then S.openMenuId = nil end
    end

    S.mouseOwnerWindow = nil
    local promoted = false
    for i = #S.windowOrder, 1, -1 do
        local wid = S.windowOrder[i]
        local w = S.windows[wid]
        if not w or not w.open then goto bf_next end
        local effH = w.minimized and im.style.titleBarH or w.h
        if im._pointInRect(S.mx, S.my, w.x, w.y, w.w, effH) then
            if S.mouseOwnerWindow == nil then S.mouseOwnerWindow = wid end
            if S.mousePressed[1] and not promoted and S.active == nil then
                if i ~= #S.windowOrder then
                    table.remove(S.windowOrder, i)
                    table.insert(S.windowOrder, wid)
                end
                promoted = true
            end
            break
        end
        ::bf_next::
    end
end

function im.EndFrame()
    im._renderAll()
    local i = 1
    while i <= #S.windowOrder do
        local wid = S.windowOrder[i]
        local w = S.windows[wid]
        if w and not w.open and w._isPopup then
            S.windows[wid] = nil
            table.remove(S.windowOrder, i)
        else
            i = i + 1
        end
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
--  WINDOW
-- ─────────────────────────────────────────────────────────────────────────────
function im.Begin(name, options, ...)
    options = options or {}
    local st = im.style

    local title, id
    local sep = name:find("##", 1, true)
    if sep then
        title = name:sub(1, sep - 1)
        id = name:sub(sep + 2)
        if id == "" then id = name end
    else
        title = name
        id = name
    end

    local w = S.windows[id]
    if not w then
        local saved = S._savedLayout and S._savedLayout[id]
        w = _copy(im._proto.window)
        w.id = id
        w.title = title
        w.x = (saved and saved.x) or options.x or 100
        w.y = (saved and saved.y) or options.y or 100
        w.w = (saved and saved.w) or options.w or 280
        w.h = (saved and saved.h) or options.h or 300
        w.scrollY = (saved and saved.scrollY) or 0
        w.open = (saved and saved.open ~= nil) and saved.open or true
        w.minimized = (saved and saved.minimized) or false
        w.drawCmds = {}
        w._cmdPool = {}
        w._indentStack = {}
        if saved then S._savedLayout[id] = nil end
        S.windows[id] = w
        table.insert(S.windowOrder, id)
    end

    w.title = title
    if not w._initDone then
        if options.w then w.w = options.w end
        if options.h then w.h = options.h end
        if options.x then w.x = options.x end
        if options.y then w.y = options.y end
        local flags = w.flags
        for i = 1, select("#", ...) do
            local f = select(i, ...)
            if f and flags[f] ~= nil then flags[f] = true end
        end
        for k in pairs(flags) do if options[k] then flags[k] = true end end
        w._isPopup = options.isPopup or false
        w._initDone = true
    end

    if options.open ~= nil then w.open = options.open end
    -- w._frameStyle = im._captureStyle(w._frameStyle)
    S.currentWindow = w
    if not w.open then return false, false end

    local flags = w.flags
    local titleH = flags.noTitleBar and 0 or st.titleBarH

    if titleH > 0 and im._mouseOwnedBy(w) then
        local bsz, by, closeX, minX = im._winBtnGeom(w, titleH)
        if closeX and im._pointInRect(S.mx, S.my, closeX, by, bsz, bsz) and S.mousePressed[1] then
            w.open = false
            S.currentWindow = nil
            return false, false
        end
        if minX and im._pointInRect(S.mx, S.my, minX, by, bsz, bsz) and S.mousePressed[1] then
            w.minimized = not w.minimized
        end
    end

    local dragId = "##drag_" .. id
    if not flags.noMove and titleH > 0 then
        local bsz, _, closeX, minX = im._winBtnGeom(w, titleH)
        local btnW = bsz * ((closeX and 1 or 0) + (minX and 1 or 0)) + 10
        local inTitle = im._mouseOwnedBy(w) and im._pointInRect(S.mx, S.my, w.x, w.y, w.w - btnW, titleH)
        if S.mousePressed[1] and inTitle and S.active == nil then
            S.active = dragId
            w.dragOffX = S.mx - w.x
            w.dragOffY = S.my - w.y
        end
        if S.active == dragId then
            w.x = math.max(0, S.mx - w.dragOffX)
            w.y = math.max(0, S.my - w.dragOffY)
            if not S.mouseDown[1] then S.active = nil end
        end
    end

    if not flags.noResize and not flags.fitContent then
        local rg = st.resizeGripSize
        local resId = "##resize_" .. id
        local inGrip = im._mouseOwnedBy(w) and im._pointInRect(S.mx, S.my, w.x + w.w - rg, w.y + w.h - rg, rg, rg)
        if S.mousePressed[1] and inGrip and S.active == nil then S.active = resId end
        if S.active == resId then
            w.w = im.Clamp(S.mx - w.x, st.windowMinW, lg.getWidth() - w.x)
            w.h = im.Clamp(S.my - w.y, st.windowMinH, lg.getHeight() - w.y)
            if not S.mouseDown[1] then S.active = nil end
        end
    end

    if w.minimized then
        for i = #w.drawCmds, 1, -1 do w.drawCmds[i] = nil end
        w._cmdCount = 0
        return false, true
    end

    for i = #w.drawCmds, 1, -1 do w.drawCmds[i] = nil end
    w._cmdCount = 0
    w.contentW = st.windowPadding
    w.contentH = st.windowPadding
    w.widgetY = 0
    w._menuBar = nil
    for i = #w._indentStack, 1, -1 do w._indentStack[i] = nil end

    w.inner = {
        x = w.x + st.windowPadding,
        y = w.y + titleH + st.windowPadding,
        w = w.w - st.windowPadding * 2 - (flags.noScrollbar and 0 or st.scrollbarW),
    }
    w._baseInnerX = w.inner.x
    w.cursorX = w.inner.x
    w.cursorY = w.inner.y - w.scrollY
    w.lineH = 0
    w._pendingLineH = 0
    w.sameLine = false
    w.sameLineSpacing = st.itemSpacingX
    w.sameLineOffsetY = 0
    w.lineStartX = w.inner.x
    return true, true
end

function im.End()
    local w = S.currentWindow
    S.currentWindow = nil
    if not w or not w.open or w.minimized then return end
    local st = im.style
    if w.flags.fitContent then
        local titleH = w.flags.noTitleBar and 0 or st.titleBarH
        local mbH = (w._menuBar and w._menuBar.h) or 0

        w.w = math.max(st.windowMinW, w.contentW + st.windowPadding + (w.flags.noScrollbar and 0 or st.scrollbarW))
        w.h = math.max(st.windowMinH, w.contentH + titleH + mbH + st.windowPadding)
    end
    local titleH = w.flags.noTitleBar and 0 or st.titleBarH
    local mbH = (w._menuBar and w._menuBar.h) or 0
    local visH = w.h - titleH - mbH - st.windowPadding * 2
    w.contentH = w.widgetY
    if not w.flags.noScrollbar and im._mouseOwnedBy(w) and im._pointInRect(S.mx, S.my, w.x, w.y, w.w, w.h) then
        w.scrollY = w.scrollY - S.scrollDelta * 20
    end
    w.scrollY = im.Clamp(w.scrollY, 0, math.max(0, w.contentH - visH))
end

-- ─────────────────────────────────────────────────────────────────────────────
--  LAYOUT HELPERS
-- ─────────────────────────────────────────────────────────────────────────────
function im.SameLine(spacing, yOffset)
    local w = S.currentWindow
    if not w then return end
    w.sameLine = true
    w.sameLineSpacing = spacing or im.style.itemSpacingX
    w.sameLineOffsetY = yOffset or 0
end

function im.Separator()
    local w = S.currentWindow
    if not w then return end
    im._newLine(w)
    im._cmd(w, "line", { x1 = w.inner.x, y1 = w.cursorY + 4, x2 = w.inner.x + w.inner.w, y2 = w.cursorY + 4, color = im.style.col.separator })
    im._advanceCursor(w, 0, 9)
end

function im.Spacing(amount)
    local w = S.currentWindow
    if not w then return end
    im._newLine(w)
    im._advanceCursor(w, 0, amount or im.style.itemSpacingY * 2)
end

function im.Indent(amount)
    local w = S.currentWindow
    if not w then return end
    amount = amount or 16
    table.insert(w._indentStack, w.inner.x)
    w.inner.x = w.inner.x + amount
    w.inner.w = w.inner.w - amount
    w.cursorX = w.inner.x
    w.lineStartX = w.inner.x
end

function im.Unindent(amount)
    local w = S.currentWindow
    if not w then return end
    local prev = table.remove(w._indentStack)
    if prev then
        local delta = w.inner.x - prev
        w.inner.x = prev
        w.inner.w = w.inner.w + delta
        w.cursorX = w.inner.x
        w.lineStartX = w.inner.x
    end
end

-- ─────────────────────────────────────────────────────────────────────────────
--  MENU BAR
-- ─────────────────────────────────────────────────────────────────────────────
function im.BeginMenuBar()
    local w = S.currentWindow
    if not w then return false end
    local st = im.style
    local titleH = w.flags.noTitleBar and 0 or st.titleBarH
    local mb = _copy(im._proto.menuBar)
    mb.y = w.y + titleH
    mb.h = st.menuBarH
    mb.curX = w.x + st.windowPadding
    w._menuBar = mb
    w.inner.y = w.inner.y + st.menuBarH
    w.cursorY = w.inner.y - w.scrollY
    return true
end

function im.EndMenuBar()
    local w = S.currentWindow
    if not w or not w._menuBar then return end
    if S.mousePressed[1] and not S._menuInAny then
        local inDrop = S.menuDrop and im._pointInRect(S.mx, S.my, S.menuDrop.x, S.menuDrop.y, S.menuDrop.w, S.menuDrop.h)
        if not inDrop and S.openMenuId and S.openMenuId:sub(1, #w.id + 2) == w.id .. "::" then
            S.openMenuId = nil
        end
    end
end

function im.BeginMenu(label)
    local w = S.currentWindow
    local mb = w and w._menuBar
    if not mb then return false end
    local st = im.style
    local font = im._font()
    local itemW = font:getWidth(label) + st.menuItemPadX * 2
    local hx = mb.curX
    mb.curX = mb.curX + itemW
    local menuId = w.id .. "::" .. label
    local hover = im._mouseOwnedBy(w) and im._pointInRect(S.mx, S.my, hx, mb.y, itemW, mb.h)
    if hover and S.mousePressed[1] then
        S.openMenuId = (S.openMenuId == menuId) and nil or menuId
    end
    local isOpen = (S.openMenuId == menuId)
    if hover then S._menuInAny = true end
    table.insert(mb.items, { label = label, x = hx, w = itemW, hover = hover, isOpen = isOpen })
    if isOpen then
        local drop = _copy(im._proto.menuDrop)
        drop.id = menuId
        drop.x = hx
        drop.y = mb.y + mb.h
        drop.nextY = mb.y + mb.h
        S.menuDrop = drop
        return true
    end
    return false
end

function im.EndMenu() end

function im.MenuItem(label, shortcut, enabled)
    if enabled == nil then enabled = true end
    local drop = S.menuDrop
    if not drop then return false end
    local st = im.style
    local font = im._font()
    local item = _copy(im._proto.menuItem)
    item.label = label
    item.shortcut = shortcut
    item.enabled = enabled
    item.itemH = st.menuItemH
    local shortW = shortcut and (font:getWidth(shortcut) + st.menuItemPadX * 2) or 0
    local needed = font:getWidth(label) + st.menuItemPadX * 2 + shortW + 16
    if needed > drop.w then drop.w = needed end
    item.iy = drop.nextY
    drop.nextY = item.iy + item.itemH
    drop.h = drop.nextY - drop.y
    item.hover = im._pointInRect(S.mx, S.my, drop.x, item.iy, drop.w, item.itemH)
    local clicked = false
    if item.hover then
        S._menuInAny = true
        if enabled and S.mousePressed[1] then
            clicked = true
            S.openMenuId = nil
        end
    end
    table.insert(drop.items, item)
    return clicked
end

function im.MenuSeparator()
    local drop = S.menuDrop
    if not drop then return end
    local sep = _copy(im._proto.menuItem)
    sep.kind = "sep"
    sep.iy = drop.nextY
    sep.sepH = 7
    drop.nextY = sep.iy + sep.sepH
    drop.h = drop.nextY - drop.y
    table.insert(drop.items, sep)
end

-- ─────────────────────────────────────────────────────────────────────────────
--  WIDGETS
-- ─────────────────────────────────────────────────────────────────────────────

function im.Label(text, color)
    local w = S.currentWindow
    if not w then return end
    local font = im._font()
    local x, y, visible = im._alloc(w, font:getWidth(text), font:getHeight())
    if visible then im._cmd(w, "text", { text = text, x = x, y = y, color = color or im.style.col.text }) end
end

function im.LabelColored(text, r, g, b, a) im.Label(text, { r, g, b, a or 1 }) end

function im.TextWrapped(text)
    local w = S.currentWindow
    if not w then return end
    local font = im._font()
    local th = font:getHeight()
    local lines = im._wrapText(font, text, w.inner.w)
    for i, line in ipairs(lines) do
        if i > 1 then im._newLine(w) end
        local x, y, visible = im._alloc(w, font:getWidth(line), th)
        if visible then im._cmd(w, "text", { text = line, x = x, y = y, color = im.style.col.text }) end
    end
end

function im.Button(label, btnW, btnH)
    local w = S.currentWindow
    if not w then return false end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)

    local d = S.widgets[id]
    if not d then d = _copy(im._proto.button); S.widgets[id] = d end
    d.id = id; d.label = lbl

    local tw, th = font:getWidth(lbl), font:getHeight()
    d.w = btnW or (tw + st.padding * 2)
    d.h = btnH or (th + st.padding * 2)
    local x, y, visible = im._alloc(w, d.w, d.h)
    d.x = x; d.y = y

    local clicked = false
    if visible then
        local _, _, clk = im._btnBehavior(id, x, y, d.w, d.h, w)
        clicked = clk
        im._drawFrame(w, x, y, d.w, d.h, im._frameBg(id, st.col.button, st.col.buttonHover, st.col.buttonActive))
        im._cmd(w, "text", { text = lbl, x = x + math.floor((d.w - tw) * 0.5), y = y + math.floor((d.h - th) * 0.5), color = st.col.text })
    end
    return clicked
end

function im.Checkbox(label, value)
    local w = S.currentWindow
    if not w then return value, false end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)

    local d = S.widgets[id]
    if not d then d = _copy(im._proto.checkbox); S.widgets[id] = d end
    d.id = id; d.label = lbl; d.value = value

    local boxS = st.checkboxSize
    local th = font:getHeight()
    local totalH = math.max(boxS, th)
    d.w = boxS + st.itemSpacingX + font:getWidth(lbl)
    d.h = totalH
    local x, y, visible = im._alloc(w, d.w, d.h)
    d.x = x; d.y = y

    local changed = false
    if visible then
        local by = y + math.floor((totalH - boxS) * 0.5)
        local _, _, clicked = im._btnBehavior(id, x, by, boxS, boxS, w)
        if clicked then
            value = not value
            changed = true
        end
        im._drawFrame(w, x, by, boxS, boxS, im._frameBg(id, st.col.widgetBg, st.col.widgetHover, st.col.widgetActive))
        if value then
            local p = 3
            im._cmd(w, "line", { x1 = x + p, y1 = by + boxS * 0.55, x2 = x + boxS * 0.45, y2 = by + boxS - p, color = st.col.checkMark, lw = 2 })
            im._cmd(w, "line", { x1 = x + boxS * 0.45, y1 = by + boxS - p, x2 = x + boxS - p, y2 = by + p, color = st.col.checkMark, lw = 2 })
        end
        im._cmd(w, "text", { text = lbl, x = x + boxS + st.itemSpacingX, y = y + math.floor((totalH - th) * 0.5), color = st.col.text })
    end
    return value, changed
end

function im.RadioButton(label, current, buttonValue)
    local w = S.currentWindow
    if not w then return current, false end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label .. tostring(buttonValue))

    local d = S.widgets[id]
    if not d then d = _copy(im._proto.radioButton); S.widgets[id] = d end
    d.id = id; d.label = lbl; d.current = current; d.buttonValue = buttonValue; d.r = st.checkboxSize * 0.5

    local th = font:getHeight()
    local totalH = math.max(st.checkboxSize, th)
    local totalW = st.checkboxSize + st.itemSpacingX + font:getWidth(lbl)
    local x, y, visible = im._alloc(w, totalW, totalH)
    d.x = x; d.y = y

    local changed = false
    if visible then
        local cy = y + math.floor(totalH * 0.5)
        local cx = x + d.r
        local hovered = im._mouseOwnedBy(w) and im._pointInCircle(S.mx, S.my, cx, cy, d.r + 2)
        if hovered then S.hot = id end
        if hovered and S.mousePressed[1] and current ~= buttonValue then
            current = buttonValue
            changed = true
        end
        local bgCol = im._frameBg(id, st.col.widgetBg, st.col.widgetHover, st.col.widgetActive)
        im._cmd(w, "circle", { x = cx, y = cy, r = d.r, color = bgCol, fill = true })
        im._cmd(w, "circle", { x = cx, y = cy, r = d.r, color = st.col.border, fill = false })
        if current == buttonValue then im._cmd(w, "circle", { x = cx, y = cy, r = d.r - 3, color = st.col.checkMark, fill = true }) end
        im._cmd(w, "text", { text = lbl, x = x + st.checkboxSize + st.itemSpacingX, y = y + math.floor((totalH - th) * 0.5), color = st.col.text })
    end
    return current, changed
end

function im.Slider(label, value, vmin, vmax, fmt)
    local w = S.currentWindow
    if not w then return value end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)

    local d = S.widgets[id]
    if not d then d = _copy(im._proto.slider); S.widgets[id] = d end
    d.id = id; d.label = lbl; d.value = value; d.vmin = vmin; d.vmax = vmax; d.fmt = fmt or "%.2f"

    local th = font:getHeight()
    local labelH = (lbl ~= "") and (th + st.itemSpacingY) or 0
    d.w = w.inner.w
    d.h = labelH + st.sliderH
    local x, y, visible = im._alloc(w, d.w, d.h)
    d.x = x; d.y = y

    if visible then
        if lbl ~= "" then
            im._cmd(w, "text", { text = lbl .. ": " .. string.format(d.fmt, value), x = x, y = y, color = st.col.text })
        end
        local by = y + labelH
        im._btnBehavior(id, x, by - 4, d.w, st.sliderH + 8, w)
        if S.active == id then
            local t = im.Clamp((S.mx - x - d.grabW * 0.5) / (d.w - d.grabW), 0, 1)
            value = vmin + t * (vmax - vmin)
            if not S.mouseDown[1] then S.active = nil end
        end
        value = im.Clamp(value, vmin, vmax)
        local t = (vmax > vmin) and ((value - vmin) / (vmax - vmin)) or 0
        d.grabX = x + t * (d.w - d.grabW)
        local grabCol = im._frameBg(id, st.col.sliderGrab, st.col.sliderGrabHover, st.col.widgetActive)
        im._cmd(w, "rect", { x = x, y = by + st.sliderH * 0.25, w = d.w, h = st.sliderH * 0.5, color = st.col.sliderTrack, rx = st.sliderH * 0.25 })
        im._cmd(w, "rect", { x = x, y = by + st.sliderH * 0.25, w = math.max(d.grabW * 0.5, d.grabX - x + d.grabW * 0.5), h = st.sliderH * 0.5, color = st.col.widgetActive, rx = st.sliderH * 0.25 })
        im._cmd(w, "rect", { x = d.grabX, y = by, w = d.grabW, h = st.sliderH, color = grabCol, rx = 3 })
    end
    return value
end

function im.SliderInt(label, value, vmin, vmax)
    return math.floor(im.Slider(label, value, vmin, vmax, "%d") + 0.5)
end

-- ── InputText Behavior Extraction ──────────────────────────────────────────────
local function _stepUTF8(text, pos, dir)
    if dir > 0 then
        if pos >= #text then return #text end
        local p = utf8.offset(text, 2, pos + 1)
        return p and (p - 1) or #text
    else
        if pos <= 0 then return 0 end
        local p = utf8.offset(text, -1, pos + 1)
        return p and (p - 1) or 0
    end
end

local function _InputTextBehavior(w, id, text, maxLen, bx, by, bw, bh, filterPattern)
    local st = im.style
    local font = im._font()
    local pad = 4
    local th = font:getHeight()

    local function selRange()
        local a = S.inputSelAnchor or S.inputCursorPos
        local b = S.inputCursorPos
        if a <= b then return a, b else return b, a end
    end
    local function computeVis(t, cp)
        local vo = 0
        local maxW = bw - pad * 2
        while vo < cp and font:getWidth(t:sub(vo + 1, cp)) > maxW do vo = _stepUTF8(t, vo, 1) end
        return t:sub(vo + 1), vo
    end
    local function pixelToPos(relX, t, vo)
        local vt = t:sub(vo + 1)
        local cur = 0
        while cur < #vt do
            local nxt = _stepUTF8(vt, cur, 1)
            local cw = font:getWidth(vt:sub(1, nxt))
            if cw >= relX then
                local pw = cur > 0 and font:getWidth(vt:sub(1, cur)) or 0
                return vo + (relX - pw < cw - relX and cur or nxt)
            end
            cur = nxt
        end
        return vo + #vt
    end

    local hover = im._mouseOwnedBy(w) and im._pointInRect(S.mx, S.my, bx, by, bw, bh)
    local active = (S.activeInputId == id)
    local submitted = false

    if not S.inputStates[id] then S.inputStates[id] = { cursorPos = 0, selAnchor = 0 } end
    local ws = S.inputStates[id]
    if active then
        S.inputCursorPos = ws.cursorPos
        S.inputSelAnchor = ws.selAnchor
    end

    if hover and S.mousePressed[1] then
        S.activeInputId = id
        S.inputBlinkT = 0
        active = true
        S.inputCursorPos = ws.cursorPos
        S.inputSelAnchor = ws.selAnchor
        local _, vo = computeVis(text, S.inputCursorPos)
        S.inputCursorPos = pixelToPos(S.mx - (bx + pad), text, vo)
        S.inputSelAnchor = S.inputCursorPos
        S._inputDragId = id
        ws.cursorPos = S.inputCursorPos
        ws.selAnchor = S.inputSelAnchor
    end
    if S._inputDragId == id and S.mouseDown[1] then
        local _, vo = computeVis(text, S.inputCursorPos)
        S.inputCursorPos = pixelToPos(S.mx - (bx + pad), text, vo)
        ws.cursorPos = S.inputCursorPos
    end
    if not S.mouseDown[1] and S._inputDragId == id then S._inputDragId = nil end
    if S.mousePressed[1] and not hover and active then
        S.activeInputId = nil
        active = false
        submitted = true
        ws.cursorPos = S.inputCursorPos
        ws.selAnchor = S.inputSelAnchor
    end

    if active then
        local ctrl = love.keyboard.isDown("lctrl") or love.keyboard.isDown("rctrl")
        local shift = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
        local function replSel(ins)
            local s, e = selRange()
            local nt = text:sub(1, s) .. ins .. text:sub(e + 1)
            if #nt <= maxLen then
                text = nt
                S.inputCursorPos = s + #ins
                S.inputSelAnchor = S.inputCursorPos
            end
        end
        local function moveCur(np, ext)
            if not ext then
                local s, e = selRange()
                if s < e then np = (np < S.inputCursorPos) and s or e end
                S.inputSelAnchor = np
            end
            S.inputCursorPos = np
        end

        if S.textQueue ~= "" and not ctrl then
            local ins = S.textQueue
            if filterPattern then ins = ins:gsub(filterPattern, "") end
            if ins ~= "" then replSel(ins) end
        end

        for _, k in ipairs(S.keyQueue) do
            if ctrl then
                if k == "a" then
                    S.inputSelAnchor = 0
                    S.inputCursorPos = #text
                elseif k == "c" then
                    local s, e = selRange()
                    if s < e then love.system.setClipboardText(text:sub(s + 1, e)) end
                elseif k == "x" then
                    local s, e = selRange()
                    if s < e then
                        love.system.setClipboardText(text:sub(s + 1, e))
                        replSel("")
                    end
                elseif k == "v" then
                    local c = love.system.getClipboardText()
                    if c and c ~= "" then
                        if filterPattern then c = c:gsub(filterPattern, "") end
                        if c ~= "" then replSel(c) end
                    end
                end
            else
                if k == "backspace" then
                    local s, e = selRange()
                    if s < e then
                        replSel("")
                    elseif S.inputCursorPos > 0 then
                        local prev = _stepUTF8(text, S.inputCursorPos, -1)
                        text = text:sub(1, prev) .. text:sub(S.inputCursorPos + 1)
                        S.inputCursorPos = prev
                        S.inputSelAnchor = prev
                    end
                elseif k == "delete" then
                    local s, e = selRange()
                    if s < e then
                        replSel("")
                    elseif S.inputCursorPos < #text then
                        local nxt = _stepUTF8(text, S.inputCursorPos, 1)
                        text = text:sub(1, S.inputCursorPos) .. text:sub(nxt + 1)
                        S.inputSelAnchor = S.inputCursorPos
                    end
                elseif k == "left" then
                    local s, e = selRange()
                    local prev = _stepUTF8(text, S.inputCursorPos, -1)
                    moveCur((s < e and not shift) and s or prev, shift)
                elseif k == "right" then
                    local s, e = selRange()
                    local nxt = _stepUTF8(text, S.inputCursorPos, 1)
                    moveCur((s < e and not shift) and e or nxt, shift)
                elseif k == "home" then
                    moveCur(0, shift)
                elseif k == "end" then
                    moveCur(#text, shift)
                elseif k == "return" or k == "escape" then
                    S.activeInputId = nil
                    S.inputSelAnchor = S.inputCursorPos
                    active = false
                    submitted = true
                end
            end
        end
        ws.cursorPos = S.inputCursorPos
        ws.selAnchor = S.inputSelAnchor
    end

    im._drawFrame(w, bx, by, bw, bh, active and st.col.inputBgActive or st.col.inputBg,
        active and st.col.widgetActive or st.col.border)
    local visText, visOff = computeVis(text, S.inputCursorPos)
    local ty = by + math.floor((bh - th) * 0.5)

    if active then
        local s, e = selRange()
        if s < e then
            local vs = math.max(0, s - visOff)
            local ve = math.max(0, e - visOff)
            local hx1 = bx + pad + font:getWidth(visText:sub(1, vs))
            local hx2 = bx + pad + font:getWidth(visText:sub(1, math.min(ve, #visText)))
            if hx2 > hx1 then
                im._cmd(w, "rectClip", { x = hx1, y = by + 2, w = hx2 - hx1, h = bh - 4, color = { st.col.widgetActive[1], st.col.widgetActive[2], st.col.widgetActive[3], 0.55 }, clipX = bx, clipY = by, clipW = bw, clipH = bh })
            end
        end
    end

    im._cmd(w, "textClip", { text = visText, x = bx + pad, y = ty, color = st.col.text, clipX = bx, clipY = by, clipW = bw, clipH = bh })

    if active then
        local s, e = selRange()
        if s == e and math.floor(S.inputBlinkT * 2) % 2 == 0 then
            local off = math.max(0, math.min(S.inputCursorPos - visOff, #visText))
            local cx = bx + pad + font:getWidth(visText:sub(1, off))
            im._cmd(w, "line", { x1 = cx, y1 = by + 3, x2 = cx, y2 = by + bh - 3, color = st.col.inputCursor, lw = 1.5 })
        end
    end

    return text, submitted, active, hover
end

function im.InputText(label, text, maxLen)
    local w = S.currentWindow
    if not w then return text end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)

    local d = S.widgets[id]
    if not d then d = _copy(im._proto.inputText); S.widgets[id] = d end
    d.id = id; d.label = lbl; d.text = text; d.maxLen = maxLen or 256

    local th = font:getHeight()
    local labelH = (lbl ~= "") and (th + st.itemSpacingY) or 0
    d.w = w.inner.w
    d.h = labelH + st.inputH
    local x, y, visible = im._alloc(w, d.w, d.h)
    d.x = x; d.y = y
    if not visible then return text end

    if lbl ~= "" then im._cmd(w, "text", { text = lbl, x = x, y = y, color = st.col.text }) end
    local bx, bw, by = x, d.w, y + labelH
    local newText = _InputTextBehavior(w, id, text, d.maxLen, bx, by, bw, st.inputH, nil)
    return newText
end

-- ── InputInt / InputFloat ────────────────────────────────────────────────────
function im._InputNumeric(label, value, step, fmt, isFloat)
    local w = S.currentWindow
    if not w then return value, false end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)

    local protoName = isFloat and "inputFloat" or "inputInt"
    local d = S.widgets[id]
    if not d then d = _copy(im._proto[protoName]); S.widgets[id] = d end
    d.id = id; d.label = lbl

    local th = font:getHeight()
    local labelH = (lbl ~= "") and (th + st.itemSpacingY) or 0
    d.w = w.inner.w
    d.h = labelH + st.inputH
    local x, y, visible = im._alloc(w, d.w, d.h)
    d.x = x; d.y = y
    if not visible then return value, false end

    if lbl ~= "" then im._cmd(w, "text", { text = lbl, x = x, y = y, color = st.col.text }) end

    local btnW = st.inputH
    local by = y + labelH
    local bx = x + btnW + st.itemSpacingX
    local bw = d.w - (btnW * 2 + st.itemSpacingX * 2)
    local bh = st.inputH
    local changed = false

    local _, _, lclk = im._btnBehavior(id .. "_minus", x, by, btnW, bh, w)
    if lclk then value = value - step; changed = true end
    im._drawFrame(w, x, by, btnW, bh, im._frameBg(id .. "_minus", st.col.button, st.col.buttonHover, st.col.buttonActive))
    im._cmd(w, "text", { text = "-", x = x + math.floor((btnW - font:getWidth("-")) * 0.5), y = by + math.floor((bh - th) * 0.5), color = st.col.text })

    local rx = x + d.w - btnW
    local _, _, rclk = im._btnBehavior(id .. "_plus", rx, by, btnW, bh, w)
    if rclk then value = value + step; changed = true end
    im._drawFrame(w, rx, by, btnW, bh, im._frameBg(id .. "_plus", st.col.button, st.col.buttonHover, st.col.buttonActive))
    im._cmd(w, "text", { text = "+", x = rx + math.floor((btnW - font:getWidth("+")) * 0.5), y = by + math.floor((bh - th) * 0.5), color = st.col.text })

    if S.activeInputId == id then
        for _, k in ipairs(S.keyQueue) do
            if k == "up" then value = value + step; changed = true
            elseif k == "down" then value = value - step; changed = true end
        end
    end

    if not S.inputStates[id] then S.inputStates[id] = { cursorPos = 0, selAnchor = 0, text = string.format(fmt, value) } end
    local ws = S.inputStates[id]

    if S.activeInputId ~= id and not changed then
        ws.text = string.format(fmt, value)
    elseif changed then
        ws.text = string.format(fmt, value)
        ws.cursorPos = #ws.text
        ws.selAnchor = ws.cursorPos
    end

    local filterPattern = isFloat and "[^%d%.%-]" or "[^%d%-]"
    local newText, submitted = _InputTextBehavior(w, id, ws.text, 64, bx, by, bw, bh, filterPattern)
    ws.text = newText

    if submitted then
        local parsed = tonumber(ws.text)
        if parsed then
            value = parsed
            if not isFloat then value = math.floor(value) end
            changed = true
        end
        ws.text = string.format(fmt, value)
    end

    return value, changed
end

function im.InputInt(label, value, step)
    return im._InputNumeric(label, value, step or 1, "%d", false)
end

function im.InputFloat(label, value, step, fmt)
    return im._InputNumeric(label, value, step or 1.0, fmt or "%.2f", true)
end

-- ── Combo ────────────────────────────────────────────────────────────────────
function im.Combo(label, current, items)
    local w = S.currentWindow
    if not w then return current, false end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)

    local d = S.widgets[id]
    if not d then d = _copy(im._proto.combo); S.widgets[id] = d end
    d.id = id; d.label = lbl

    local th = font:getHeight()
    local labelH = (lbl ~= "") and (th + st.itemSpacingY) or 0
    d.w = w.inner.w
    d.h = labelH + st.inputH
    local x, y, visible = im._alloc(w, d.w, d.h)
    d.x = x; d.y = y
    if not visible then return current, false end

    if lbl ~= "" then im._cmd(w, "text", { text = lbl, x = x, y = y, color = st.col.text }) end

    local bx, by, bw, bh = x, y + labelH, d.w, st.inputH
    local changed = false
    local hover = im._mouseOwnedBy(w) and im._pointInRect(S.mx, S.my, bx, by, bw, bh)
    local popupId = "##combo_" .. id

    if hover and S.mousePressed[1] then
        im.OpenPopup(popupId)
    end

    local bgCol = (hover or im.IsWindowOpen(popupId)) and st.col.widgetHover or st.col.widgetBg
    im._drawFrame(w, bx, by, bw, bh, bgCol, st.col.border)

    local currentText = items[current] or ""
    im._cmd(w, "textClip", { text = currentText, x = bx + 4, y = by + math.floor((bh - th) * 0.5), color = st.col.text, clipX = bx, clipY = by, clipW = bw - st.inputH, clipH = bh })

    local arrowW = st.inputH
    local ax = bx + bw - arrowW
    im._drawFrame(w, ax, by, arrowW, bh, st.col.button, st.col.border)

    local cx = ax + arrowW * 0.5
    local cy = by + bh * 0.5
    im._cmd(w, "polygon", { vertices = { cx - 3, cy - 2, cx + 3, cy - 2, cx, cy + 3 }, color = st.col.text })

    im.SetWindowSize(popupId, bw, nil)
    if im.BeginPopup(popupId, { x = bx, y = by + bh, w = bw }) then
        for i, item in ipairs(items) do
            local isSelected = (i == current)
            local _, clicked = im.Selectable(item, isSelected)
            if clicked then
                current = i
                changed = true
                im.ClosePopup(popupId)
            end
        end
        im.EndPopup()
    end

    return current, changed
end

-- ── Visuals and Wrappers ─────────────────────────────────────────────────────
function im.ProgressBar(fraction, barW, barH, overlay)
    local w = S.currentWindow
    if not w then return end
    local st = im.style
    local font = im._font()
    local fw = barW or w.inner.w
    local fh = barH or st.sliderH
    local x, y, visible = im._alloc(w, fw, fh)
    if visible then
        im._cmd(w, "rect", { x = x, y = y, w = fw, h = fh, color = st.col.progressBg, rx = 3 })
        local fr = im.Clamp(fraction, 0, 1)
        if fr > 0 then im._cmd(w, "rect", { x = x, y = y, w = fw * fr, h = fh, color = st.col.progressBar, rx = 3 }) end
        if overlay then
            local tw, th = font:getWidth(overlay), font:getHeight()
            im._cmd(w, "text", { text = overlay, x = x + math.floor((fw - tw) * 0.5), y = y + math.floor((fh - th) * 0.5), color = st.col.text })
        end
    end
end

function im.Selectable(label, selected, rowW, rowH)
    local w = S.currentWindow
    if not w then return selected, false end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)

    local d = S.widgets[id]
    if not d then d = _copy(im._proto.selectable); S.widgets[id] = d end
    d.id = id; d.label = lbl; d.selected = selected

    local th = font:getHeight()
    d.w = rowW or w.inner.w
    d.h = rowH or (th + st.padding)
    local x, y, visible = im._alloc(w, d.w, d.h)
    d.x = x; d.y = y
    if not visible then return selected, false end

    if d.w >= w.inner.w then w.cursorX = x end
    local hovered, _, clicked = im._btnBehavior(id, x, y, d.w, d.h, w)
    if clicked then selected = not selected end
    local bgCol = selected and st.col.widgetActive or (hovered and st.col.widgetHover or nil)
    if bgCol then im._cmd(w, "rect", { x = x, y = y, w = d.w, h = d.h, color = bgCol, rx = st.widgetRound }) end
    im._cmd(w, "text", { text = lbl, x = x + st.padding * 0.5, y = y + math.floor((d.h - th) * 0.5), color = selected and { 1, 1, 1, 1 } or st.col.text })
    return selected, clicked
end

function im.CollapsingHeader(label, open)
    local w = S.currentWindow
    if not w then return open end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)

    local d = S.widgets[id]
    if not d then d = _copy(im._proto.collapsingHeader); S.widgets[id] = d end
    d.id = id; d.label = lbl; d.open = open

    local th = font:getHeight()
    d.w = w.inner.w
    d.h = th + st.padding * 2
    local x, y, visible = im._alloc(w, d.w, d.h)
    d.x = x; d.y = y
    if not visible then return open end

    local _, _, clicked = im._btnBehavior(id, x, y, d.w, d.h, w)
    if clicked then open = not open end
    im._cmd(w, "rect", { x = x, y = y, w = d.w, h = d.h, color = im._frameBg(id, st.col.widgetBg, st.col.widgetHover, st.col.widgetActive) })
    im._cmd(w, "text", { text = (open and "v " or "> ") .. lbl, x = x + st.padding, y = y + math.floor((d.h - th) * 0.5), color = st.col.text })
    return open
end

function im.Image(image, quad, dispW, dispH)
    local w = S.currentWindow
    if not w then return end
    local iw, ih
    if quad then
        local _, _, qw, qh = quad:getViewport()
        iw, ih = qw, qh
    else iw, ih = image:getDimensions() end
    local dw = dispW or iw
    local dh = dispH or ih
    local x, y, visible = im._alloc(w, dw, dh)
    if visible then
        im._cmd(w, "imageClip", { image = image, quad = quad, x = x, y = y, sx = dw / iw, sy = dh / ih, clipX = w.x, clipY = w.y, clipW = w.w, clipH = w.h })
    end
end
function im.SelectableImage(label, image, quad, selected, dispW, dispH)
    local w = S.currentWindow
    if not w then return selected, false end
    local st = im.style
    local font = im._font()
    local lbl, id = im._parseLabel(label)
    local d = S.widgets[id]
    if not d then d = _copy(im._proto.selectableImage); S.widgets[id] = d end
    d.id = id
    d.label = lbl
    d.image = image
    d.quad = quad
    d.selected = selected
    local iw, ih
    if quad then
        local _, _, qw, qh = quad:getViewport()
        iw, ih = qw, qh
    else iw, ih = image:getDimensions() end
    d.w = dispW or iw
    d.h = dispH or ih
    d.sx = d.w / iw
    d.sy = d.h / ih
    local th = font:getHeight()
    local rowW = dispW and (dispW + st.padding) or w.inner.w
    local rowH = d.h + st.padding
    local x, y, visible = im._alloc(w, rowW, rowH)
    d.x = x
    d.y = y
    if not visible then return selected, false end
    local hovered, _, clicked = im._btnBehavior(id, x, y, rowW, rowH, w)
    if clicked then selected = not selected end
    local bgCol = selected and st.col.widgetActive or (hovered and st.col.widgetHover or nil)
    if bgCol then im._cmd(w, "rect", { x = x, y = y, w = rowW, h = rowH, color = bgCol, rx = st.widgetRound }) end
    local ix = x + st.padding * 0.5
    local iy = y + math.floor((rowH - d.h) * 0.5)
    im._cmd(w, "imageClip", { image = image, quad = quad, x = ix, y = iy, sx = d.sx, sy = d.sy, clipX = x, clipY = y, clipW =
    rowW, clipH = rowH })
    if lbl ~= "" then
        im._cmd(w, "text",
            { text = lbl, x = ix + d.w + st.itemSpacingX, y = y + math.floor((rowH - th) * 0.5), color = selected and
            { 1, 1, 1, 1 } or st.col.text })
    end
    return selected, clicked
end


-- ─────────────────────────────────────────────────────────────────────────────
--  POPUP
-- ─────────────────────────────────────────────────────────────────────────────
local function _parseId(name)
    local sep = name:find("##", 1, true)
    local id = sep and name:sub(sep + 2) or name
    return (id == "") and name or id
end

function im.OpenPopup(name) S._pendingPopup = _parseId(name) end

function im.ClosePopup(name)
    local pw = S.windows[_parseId(name)]
    if pw then pw.open = false end
end

function im.BeginPopup(name, options)
    options = options or {}
    options.isPopup = true
    local id = _parseId(name)
    local justOpened = false
    if S._pendingPopup == id then
        S._pendingPopup = nil
        justOpened = true
        options.x = options.x or math.max(10, math.floor(S.mx - (options.w or 220) * 0.5))
        options.y = options.y or math.max(10, math.floor(S.my - 20))
        local existing = S.windows[id]
        if existing then
            existing.open = true
            for i, wid in ipairs(S.windowOrder) do if wid == id then table.remove(S.windowOrder, i); break end end
            table.insert(S.windowOrder, id)
        end
    else
        local pw = S.windows[id]
        if not pw or not pw.open then return false end
        if S.mousePressed[1] and S.mouseOwnerWindow ~= id then
            pw.open = false
            return false
        end
    end
    local visible = im.Begin(name, options, im.NoMinimize)
    if not visible then return false end
    if justOpened then
        for i, wid in ipairs(S.windowOrder) do if wid == id then table.remove(S.windowOrder, i); break end end
        table.insert(S.windowOrder, id)
    end
    return true
end

function im.EndPopup() im.End() end

-- ─────────────────────────────────────────────────────────────────────────────
--  TOOLTIP
-- ─────────────────────────────────────────────────────────────────────────────
function im.IsItemHovered()
    local r = S._lastItemRect
    if not r then return false end
    local win = S.windows[r.winId]
    if not win then return false end
    return im._mouseOwnedBy(win) and im._pointInRect(S.mx, S.my, r.x, r.y, r.w, r.h)
end

function im.SetTooltip(text)
    if not im.IsItemHovered() then return end
    S.tooltipText = text
    S.tooltipX = S.mx + 14
    S.tooltipY = S.my + 18
end

function im.BeginTooltip()
    if not im.IsItemHovered() then return false end
    S._pendingPopup = "##tooltip_popup"
    return im.Begin("##tooltip_popup", { x = S.mx + 14, y = S.my + 18, w = 200, h = 20, isPopup = true },
        im.NoTitleBar, im.NoResize, im.NoMove, im.NoScrollbar, im.NoClose, im.NoMinimize)
end

function im.EndTooltip() im.End() end

-- ─────────────────────────────────────────────────────────────────────────────
--  SAVE / LOAD LAYOUT
-- ─────────────────────────────────────────────────────────────────────────────
local SAVE_FILE = "imlove_layout.lua"

local function _serialize(tbl, indent)
    indent = indent or 0
    local pad = string.rep("  ", indent)
    local lines = { "{" }
    for k, v in pairs(tbl) do
        local key = type(k) == "number" and "[" .. k .. "]" or '["' .. tostring(k) .. '"]'
        local val
        local tv = type(v)
        if tv == "number" then val = tostring(v)
        elseif tv == "boolean" then val = tostring(v)
        elseif tv == "string" then val = string.format("%q", v)
        elseif tv == "table" then val = _serialize(v, indent + 1) end
        if val then table.insert(lines, pad .. "  " .. key .. " = " .. val .. ",") end
    end
    table.insert(lines, pad .. "}")
    return table.concat(lines, "\n")
end

function im.SaveLayout(filename)
    filename = filename or SAVE_FILE
    local data = {}
    for id, w in pairs(S.windows) do
        data[id] = {
            x = math.floor(w.x), y = math.floor(w.y), w = math.floor(w.w), h = math.floor(w.h),
            scrollY = math.floor(w.scrollY or 0), open = w.open, minimized = w.minimized or false
        }
    end
    local ok, err = love.filesystem.write(filename, "return " .. _serialize(data))
    if not ok then print("[imlove] SaveLayout failed: " .. tostring(err)) end
    return ok
end

function im.LoadLayout(filename)
    filename = filename or SAVE_FILE
    if not love.filesystem.getInfo(filename) then return false end
    local chunk, err = love.filesystem.load(filename)
    if not chunk then print("[imlove] LoadLayout error: " .. tostring(err)); return false end
    local ok, data = pcall(chunk)
    if not ok or type(data) ~= "table" then print("[imlove] LoadLayout bad data"); return false end
    for id, saved in pairs(data) do
        local w = S.windows[id]
        if w then
            w.x = saved.x or w.x
            w.y = saved.y or w.y
            w.w = saved.w or w.w
            w.h = saved.h or w.h
            w.scrollY = saved.scrollY or 0
            w.open = saved.open ~= false
            w.minimized = saved.minimized or false
        else
            S._savedLayout = S._savedLayout or {}
            S._savedLayout[id] = saved
        end
    end
    return true
end

-- ─────────────────────────────────────────────────────────────────────────────
--  ID STACK
-- ─────────────────────────────────────────────────────────────────────────────
function im.PushID(id) table.insert(S.idStack, tostring(id)); S._idPrefix = nil end
function im.PopID() table.remove(S.idStack, #S.idStack); S._idPrefix = nil end

function im.GetID(str)
    if not S._idPrefix then S._idPrefix = #S.idStack > 0 and (table.concat(S.idStack, "/") .. "/") or "" end
    local seed = S._idPrefix .. str
    local h = 0x725C9DC5
    for i = 1, #seed do
        h = bit.bxor(h, seed:byte(i))
        h = (h * 0x1000193) % 0x100000000
    end
    return h
end

-- ─────────────────────────────────────────────────────────────────────────────
--  UTILITY
-- ─────────────────────────────────────────────────────────────────────────────
function im.Clamp(v, lo, hi) return math.max(lo, math.min(hi, v)) end
function im.WantCaptureMouse() return S.mouseOwnerWindow ~= nil end
function im.IsMouseHoveringRect(x, y, w, h) return im._pointInRect(S.mx, S.my, x, y, w, h) end

function im.IsWindowOpen(id)
    local w = S.windows[id]
    return w ~= nil and w.open
end

function im.SetWindowOpen(id, open)
    local w = S.windows[id]
    if w then w.open = open end
end

function im.ClearWindows()
    S.windows = {}
    S.windowOrder = {}
    S.widgets = {}
    S.openMenuId = nil
    S.activeInputId = nil
    S.active = nil
    S.hot = nil
end

function im.SetWindowSize(id, nw, nh)
    local w = S.windows[id]
    if not w then return end
    if nw then w.w = math.max(im.style.windowMinW, nw) end
    if nh then w.h = math.max(im.style.windowMinH, nh) end
end

function im.SetWindowPos(id, x, y)
    local w = S.windows[id]
    if not w then return end
    w.x = x; w.y = y
end

function im.SetWindowMinimized(id, min)
    local w = S.windows[id]
    if w then w.minimized = min end
end

function im.GetWindowRect(name)
    local w = S.windows[_parseId(name)]
    if not w or not w.open then return nil end
    return w.x, w.y, w.w, w.h
end

function im.GetContentWidth()
    local cw = S.currentWindow
    return cw and cw.inner and cw.inner.w or 0
end

-- ─────────────────────────────────────────────────────────────────────────────
--  INTERNAL HELPERS
-- ─────────────────────────────────────────────────────────────────────────────
function im._pointInRect(px, py, rx, ry, rw, rh) return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh end
function im._pointInCircle(px, py, cx, cy, r) local dx, dy = px - cx, py - cy; return dx * dx + dy * dy <= r * r end

function im._mouseOwnedBy(w)
    return S.mouseOwnerWindow == w.id
        or (S.active ~= nil and S.active == "##drag_" .. w.id)
        or (S.active ~= nil and S.active == "##resize_" .. w.id)
end

function im._winBtnGeom(w, titleH)
    local flags  = w.flags
    local bsz = titleH - 8
    local by     = w.y + math.floor((titleH - bsz) * 0.5)
    local m, g = 5, 3
    local closeX = (not flags.noClose) and (w.x + w.w - m - bsz) or nil
    local minX   = (not flags.noMinimize) and (w.x + w.w - m - bsz - ((closeX and bsz + g) or 0)) or nil
    return bsz, by, closeX, minX
end

function im._parseLabel(label)
    local sep = label:find("##", 1, true)
    local lbl, idStr
    if sep then
        lbl = label:sub(1, sep - 1)
        idStr = label:sub(sep + 2)
        if idStr == "" then idStr = label end
    else
        lbl = label; idStr = label
    end
    return lbl, im.GetID(idStr)
end

function im._cmd(w, kind, data)
    if not w or not w.drawCmds then return end
    w._cmdCount = w._cmdCount + 1

    -- If the slot doesn't exist, create it (happens only during startup/expanding window)
    if not w._cmdPool[w._cmdCount] then
        w._cmdPool[w._cmdCount] = { kind = kind, data = data }
    else
        -- RECYCLE: Overwrite the existing table, no allocation!
        local cmd = w._cmdPool[w._cmdCount]
        cmd.kind = kind
        cmd.data = data
    end
    w.drawCmds[w._cmdCount] = w._cmdPool[w._cmdCount]
end

function im._drawFrame(win, x, y, ww, wh, bgCol, borderCol)
    local st = im.style
    im._cmd(win, "rect", { x = x, y = y, w = ww, h = wh, color = bgCol, rx = st.widgetRound })
    im._cmd(win, "rectBorder", { x = x, y = y, w = ww, h = wh, color = borderCol or st.col.border, rx = st.widgetRound })
end

function im._frameBg(id, normal, hover, active)
    if S.active == id then return active or im.style.col.widgetActive end
    if S.hot == id then return hover or im.style.col.widgetHover end
    return normal or im.style.col.widgetBg
end

function im._btnBehavior(id, x, y, ww, wh, win)
    local hovered = im._mouseOwnedBy(win) and im._pointInRect(S.mx, S.my, x, y, ww, wh)
    if hovered and S.active == nil then S.hot = id end
    local held = (S.active == id)
    local clicked = false
    if hovered and S.mousePressed[1] and S.active == nil then
        S.active = id
        held = true
    end
    if S.active == id and S.mouseReleased[1] then
        clicked = hovered
        S.active = nil
        held = false
    end
    return hovered, held, clicked
end

function im._alloc(w, ww, wh)
    local x, y = im._allocWidget(w, ww, wh)
    return x, y, im._visibleInWindow(w, y, wh)
end

function im._allocWidget(w, ww, wh)
    local st = im.style
    if not w.sameLine then im._newLine(w) end
    local x, y
    if w.sameLine then
        x = w.cursorX + w.sameLineSpacing
        y = w.cursorY + (w.sameLineOffsetY or 0)
        w.cursorX = x + ww
        w._pendingLineH = math.max(w._pendingLineH or 0, wh + (w.sameLineOffsetY or 0))
        w.lineH = w._pendingLineH
    else
        x = w.lineStartX
        y = w.cursorY
        w.cursorX = x + ww
        w.lineH = wh
        w._pendingLineH = wh
    end
    local absY = y + wh - (w.inner.y - w.scrollY)
    if absY > w.widgetY then w.widgetY = absY end
    w.sameLine = false
    w.sameLineSpacing = st.itemSpacingX
    w.sameLineOffsetY = 0
    local r = S._lastItemRect
    if not r then
        r = { x = 0, y = 0, w = 0, h = 0, winId = nil }
        S._lastItemRect = r
    end
    r.x = x; r.y = y; r.w = ww; r.h = wh; r.winId = w.id
    local localRight = (x + ww) - w.x
    if localRight > w.contentW then w.contentW = localRight end
    local localBottom = (y + wh) - w.y + st.windowPadding
    if localBottom > w.contentH then w.contentH = localBottom end
    return x, y
end

function im._newLine(w)
    if w._pendingLineH and w._pendingLineH > 0 then
        w.cursorY = w.cursorY + w._pendingLineH + im.style.itemSpacingY
        w.cursorX = w.lineStartX
        w.lineH = 0
        w._pendingLineH = 0
    end
end

function im._advanceCursor(w, dw, dh)
    w.cursorY = w.cursorY + dh
    w.cursorX = w.lineStartX
    w.lineH = 0
    w._pendingLineH = 0
    local absY = w.cursorY - (w.inner.y - w.scrollY)
    if absY > w.widgetY then w.widgetY = absY end
end

function im._visibleInWindow(w, wy, wh)
    local titleH = w.flags.noTitleBar and 0 or im.style.titleBarH
    return wy + wh > w.y + titleH and wy < w.y + w.h
end

function im._wrapText(font, text, maxW)
    local lines, line = {}, ""
    for word in text:gmatch("%S+") do
        local test = line == "" and word or line .. " " .. word
        if font:getWidth(test) <= maxW then
            line = test
        else
            if line ~= "" then table.insert(lines, line) end
            line = word
        end
    end
    if line ~= "" then table.insert(lines, line) end
    if #lines == 0 then lines[1] = "" end
    return lines
end
function im._captureStyle(target)
    -- If the table doesn't exist yet, create it ONCE
    if not target then target = { col = {} } end

    for k, v in pairs(im.style) do
        if k ~= "col" then target[k] = v end
    end
    for k, v in pairs(im.style.col) do
        target.col[k] = v -- Copy reference (extremely fast, 0 allocations)
    end

    return target
end
-- ─────────────────────────────────────────────────────────────────────────────
--  RENDERING
-- ─────────────────────────────────────────────────────────────────────────────
local function _safeScissor(nx, ny, nw, nh)
    local cx, cy, cw, ch = lg.getScissor()
    if not cx then lg.setScissor(nx, ny, nw, nh); return end
    local x1 = math.max(cx, nx)
    local y1 = math.max(cy, ny)
    local x2 = math.min(cx + cw, nx + nw)
    local y2 = math.min(cy + ch, ny + nh)
    lg.setScissor(x1, y1, math.max(0, x2 - x1), math.max(0, y2 - y1))
end

local function _c(col) lg.setColor(col[1], col[2], col[3], col[4] or 1) end

local function _execCmd(cmd)
    local d = cmd.data
    if cmd.kind == "rect" then
        _c(d.color)
        if d.rx and d.rx > 0 then lg.rectangle("fill", d.x, d.y, d.w, d.h, d.rx, d.rx)
        else lg.rectangle("fill", d.x, d.y, d.w, d.h) end
    elseif cmd.kind == "rectBorder" then
        _c(d.color); lg.setLineWidth(1)
        if d.rx and d.rx > 0 then lg.rectangle("line", d.x, d.y, d.w, d.h, d.rx, d.rx)
        else lg.rectangle("line", d.x, d.y, d.w, d.h) end
    elseif cmd.kind == "rectClip" then
        local px, py, pw, ph = lg.getScissor()
        _safeScissor(d.clipX, d.clipY, d.clipW, d.clipH)
        _c(d.color); lg.rectangle("fill", d.x, d.y, d.w, d.h)
        if px then lg.setScissor(px, py, pw, ph) else lg.setScissor() end
    elseif cmd.kind == "text" then
        _c(d.color); lg.print(d.text, math.floor(d.x), math.floor(d.y))
    elseif cmd.kind == "textClip" then
        local px, py, pw, ph = lg.getScissor()
        _safeScissor(d.clipX, d.clipY, d.clipW, d.clipH)
        _c(d.color); lg.print(d.text, math.floor(d.x), math.floor(d.y))
        if px then lg.setScissor(px, py, pw, ph) else lg.setScissor() end
    elseif cmd.kind == "line" then
        _c(d.color); lg.setLineWidth(d.lw or 1); lg.line(d.x1, d.y1, d.x2, d.y2); lg.setLineWidth(1)
    elseif cmd.kind == "circle" then
        _c(d.color); lg.circle(d.fill and "fill" or "line", d.x, d.y, d.r)
    elseif cmd.kind == "polygon" then
        _c(d.color); lg.polygon("fill", unpack(d.vertices))
    elseif cmd.kind == "imageClip" then
        lg.setColor(1, 1, 1, 1)
        local px, py, pw, ph = lg.getScissor()
        _safeScissor(d.clipX, d.clipY, d.clipW, d.clipH)
        if d.quad then lg.draw(d.image, d.quad, math.floor(d.x), math.floor(d.y), 0, d.sx or 1, d.sy or 1)
        else lg.draw(d.image, math.floor(d.x), math.floor(d.y), 0, d.sx or 1, d.sy or 1) end
        if px then lg.setScissor(px, py, pw, ph) else lg.setScissor() end
    elseif cmd.kind == "meshClip" then
        lg.setColor(1, 1, 1, 1)
        local px, py, pw, ph = lg.getScissor()
        _safeScissor(d.clipX, d.clipY, d.clipW, d.clipH)
        lg.draw(d.mesh)
        if px then lg.setScissor(px, py, pw, ph) else lg.setScissor() end
    end
end

function im._renderAll()
    lg.push("all")
    lg.setLineStyle("smooth")
    local st = im.style

    local firstPopupIdx = nil
    for i, wid in ipairs(S.windowOrder) do
        local w = S.windows[wid]
        if w and w.open and w._isPopup then firstPopupIdx = i; break end
    end

    for idx, wid in ipairs(S.windowOrder) do
        local w = S.windows[wid]
        if not w or not w.open then goto continue end

        if idx == firstPopupIdx then
            lg.setColor(0, 0, 0, 0.35)
            lg.rectangle("fill", 0, 0, lg.getWidth(), lg.getHeight())
        end

        local flags = w.flags
        local titleH = flags.noTitleBar and 0 or st.titleBarH
        local effH = w.minimized and titleH or w.h
        local isTop = (S.windowOrder[#S.windowOrder] == wid)

        if not flags.noBackground then
            _c(st.col.windowBg)
            lg.rectangle("fill", w.x, w.y, w.w, effH, st.windowRound, st.windowRound)
            _c(st.col.border); lg.setLineWidth(1)
            lg.rectangle("line", w.x, w.y, w.w, effH, st.windowRound, st.windowRound)
        end

        if titleH > 0 then
            _c(isTop and st.col.titleBarActive or st.col.titleBar)
            lg.rectangle("fill", w.x, w.y, w.w, titleH, st.windowRound, st.windowRound)
            if not w.minimized then lg.rectangle("fill", w.x, w.y + titleH * 0.5, w.w, titleH * 0.5) end
            local bsz, by, closeX, minX = im._winBtnGeom(w, titleH)
            local owned = (S.mouseOwnerWindow == wid)
            if closeX then
                local hov = owned and im._pointInRect(S.mx, S.my, closeX, by, bsz, bsz)
                _c(hov and st.col.closeBtnHover or st.col.closeBtn)
                lg.rectangle("fill", closeX, by, bsz, bsz, 2, 2)
                _c(st.col.titleText); lg.setLineWidth(1.5)
                local p = 3
                lg.line(closeX + p, by + p, closeX + bsz - p, by + bsz - p)
                lg.line(closeX + bsz - p, by + p, closeX + p, by + bsz - p)
                lg.setLineWidth(1)
            end
            if minX then
                local hov = owned and im._pointInRect(S.mx, S.my, minX, by, bsz, bsz)
                _c(hov and st.col.minimizeBtnHover or st.col.minimizeBtn)
                lg.rectangle("fill", minX, by, bsz, bsz, 2, 2)
                _c(st.col.titleText); lg.setLineWidth(1.5)
                if w.minimized then
                    local cx = minX + math.floor(bsz * 0.5)
                    local p = 3
                    lg.line(minX + p, by + bsz - p, cx, by + p, minX + bsz - p, by + bsz - p)
                else
                    local my2 = by + math.floor(bsz * 0.5)
                    lg.line(minX + 3, my2, minX + bsz - 3, my2)
                end
                lg.setLineWidth(1)
            end
            local font = im._font()
            local tw = font:getWidth(w.title)
            _c(st.col.titleText)
            lg.print(w.title, math.floor(w.x + (w.w - tw) * 0.5), math.floor(w.y + (titleH - font:getHeight()) * 0.5))
        end

        if w.minimized then goto continue end

        local mbH = 0
        if w._menuBar then
            local mb = w._menuBar
            mbH = mb.h
            local font = im._font()
            local padX = st.menuItemPadX
            _c(st.col.menuBarBg); lg.rectangle("fill", w.x, mb.y, w.w, mb.h)
            _c(st.col.separator); lg.setLineWidth(1)
            lg.line(w.x, mb.y + mb.h, w.x + w.w, mb.y + mb.h)
            for _, item in ipairs(mb.items) do
                if item.hover or item.isOpen then
                    _c(st.col.menuHover)
                    lg.rectangle("fill", item.x, mb.y, item.w, mb.h)
                end
                _c(st.col.menuText)
                lg.print(item.label, math.floor(item.x + padX), math.floor(mb.y + (mb.h - font:getHeight()) * 0.5))
            end
        end

        if not flags.noScrollbar and not flags.fitContent then
            local visH = w.h - titleH - mbH - st.windowPadding * 2
            local totH = math.max(visH, w.contentH)
            if totH > visH then
                local sbX = w.x + w.w - st.scrollbarW - 2
                local sbY = w.y + titleH + mbH + 2
                local sbH = w.h - titleH - mbH - 4
                _c(st.col.scrollbarBg)
                lg.rectangle("fill", sbX, sbY, st.scrollbarW, sbH, st.scrollbarW * 0.5)
                local grabH = math.max(16, sbH * (visH / totH))
                local grabY = sbY + (w.scrollY / (totH - visH)) * (sbH - grabH)
                local sbId = "##scrollbar_" .. wid
                local owned = (S.mouseOwnerWindow == wid)
                local grabHov = owned and im._pointInRect(S.mx, S.my, sbX, grabY, st.scrollbarW, grabH)
                if owned and im._pointInRect(S.mx, S.my, sbX, sbY, st.scrollbarW, sbH) and S.mousePressed[1] and S.active == nil then
                    S.active = sbId
                    w._sbGrabOff = S.my - grabY
                end
                if S.active == sbId then
                    local t = (S.my - (w._sbGrabOff or 0) - sbY) / (sbH - grabH)
                    w.scrollY = im.Clamp(t * (totH - visH), 0, totH - visH)
                    if not S.mouseDown[1] then S.active = nil end
                end
                _c((S.active == sbId or grabHov) and st.col.scrollbarHover or st.col.scrollbarGrab)
                lg.rectangle("fill", sbX, grabY, st.scrollbarW, grabH, st.scrollbarW * 0.5)
            end
        end

        if not flags.noResize and not flags.fitContent  then
            local rg = st.resizeGripSize
            local inG = im._pointInRect(S.mx, S.my, w.x + w.w - rg, w.y + w.h - rg, rg, rg)
            _c((inG or S.active == "##resize_" .. wid) and st.col.resizeGripHover or st.col.resizeGrip)
            lg.polygon("fill", w.x + w.w, w.y + w.h, w.x + w.w - rg, w.y + w.h, w.x + w.w, w.y + w.h - rg)
        end

        lg.setScissor(w.x + 1, w.y + titleH + mbH, w.w - 2 - (flags.noScrollbar and 0 or st.scrollbarW), w.h - titleH - mbH - 1)
        if w.drawCmds then for _, cmd in ipairs(w.drawCmds) do _execCmd(cmd) end end
        lg.setScissor()

        ::continue::
    end

    if S.menuDrop and S.openMenuId then
        local drop = S.menuDrop
        local font = im._font()
        local padX = st.menuItemPadX
        local th = font:getHeight()
        local inDrop = im._pointInRect(S.mx, S.my, drop.x, drop.y, drop.w, drop.h)
        if S.mousePressed[1] and not S._menuInAny and not inDrop then S.openMenuId = nil end
        if S.openMenuId then
            lg.setColor(0, 0, 0, 0.25)
            lg.rectangle("fill", drop.x + 3, drop.y + 3, drop.w, drop.h, 3, 3)
            _c(st.col.menuBg)
            lg.rectangle("fill", drop.x, drop.y, drop.w, drop.h, 3, 3)
            _c(st.col.border); lg.setLineWidth(1)
            lg.rectangle("line", drop.x, drop.y, drop.w, drop.h, 3, 3)
            for _, item in ipairs(drop.items) do
                if item.kind == "sep" then
                    _c(st.col.menuSep)
                    lg.line(drop.x + 6, item.iy + math.floor(item.sepH * 0.5), drop.x + drop.w - 6, item.iy + math.floor(item.sepH * 0.5))
                elseif item.kind == "item" then
                    if item.hover and item.enabled then
                        _c(st.col.menuHover)
                        lg.rectangle("fill", drop.x + 1, item.iy, drop.w - 2, item.itemH, 2, 2)
                    end
                    _c(item.enabled and st.col.menuText or st.col.textDisabled)
                    lg.print(item.label, drop.x + padX, item.iy + math.floor((item.itemH - th) * 0.5))
                    if item.shortcut then
                        local sw = font:getWidth(item.shortcut)
                        _c(st.col.menuShortcut)
                        lg.print(item.shortcut, drop.x + drop.w - sw - padX, item.iy + math.floor((item.itemH - th) * 0.5))
                    end
                end
            end
        end
    end

    if S.tooltipText then
        local font = im._font()
        local pad = 6
        local lsp = 2
        local th = font:getHeight()
        local lines = {}
        for line in (S.tooltipText .. "\n"):gmatch("([^\n]*)\n") do table.insert(lines, line) end
        local maxW = 0
        for _, line in ipairs(lines) do
            local lw = font:getWidth(line)
            if lw > maxW then maxW = lw end
        end
        local bw = maxW + pad * 2
        local bh = #lines * th + (#lines - 1) * lsp + pad * 2
        local tx = math.min(S.tooltipX, lg.getWidth() - bw - 2)
        local ty = math.min(S.tooltipY, lg.getHeight() - bh - 2)
        _c(st.col.tooltip)
        lg.rectangle("fill", tx, ty, bw, bh, 4, 4)
        _c(st.col.tooltipBorder); lg.setLineWidth(1)
        lg.rectangle("line", tx, ty, bw, bh, 4, 4)
        for i, line in ipairs(lines) do
            _c(st.col.tooltipText)
            lg.print(line, tx + pad, ty + pad + (i - 1) * (th + lsp))
        end
    end

    lg.setColor(1, 1, 1, 1)
    lg.setLineWidth(1)
    lg.pop()
end

im._S = S
return im