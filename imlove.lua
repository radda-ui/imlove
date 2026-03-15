
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

local lg  = love.graphics
local bit = require("bit")
local im = {
    _VERSION = "0.2.0",
    _DESCRIPTION = "A pure Lua 5.1 simple implementation of imgui for LÖVE 2D hence the name imlove",
    _URL = "https://github.com/radda-ui/imlove",
    _LICENSE = [[
        MIT License

        Copyright (c) 2026 Salem Raddaoui

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

-- ═══════════════════════════════════════════════════════════════════
--  STYLE
-- ═══════════════════════════════════════════════════════════════════
im.style = {
    padding         = 8,
    itemSpacingY    = 4,
    itemSpacingX    = 6,
    windowPadding   = 10,
    windowMinW      = 120,
    windowMinH      = 60,
    titleBarH       = 24,
    scrollbarW      = 10,
    resizeGripSize  = 14,
    checkboxSize    = 14,
    sliderH         = 14,
    inputH          = 22,
    menuBarH        = 22,
    menuItemH       = 22,
    menuItemPadX    = 10,
    windowRound     = 6,
    widgetRound     = 4,
    buttonRound     = 4,
    snapDist        = 14,    -- px threshold for docking snap
    taskbarH        = 32,    -- taskbar height in pixels
    taskbarBtnW     = 140,   -- max button width
    taskbarBtnMinW  = 60,    -- min button width (shrinks when crowded)
    taskbarPadX     = 6,     -- horizontal padding inside buttons
    taskbarPos      = "bottom", -- "bottom" or "top"
    font            = nil,   -- set in Init()
    col = {
        windowBg         = {0.15, 0.15, 0.18, 0.97},
        titleBar         = {0.22, 0.22, 0.28, 1.00},
        titleBarActive   = {0.28, 0.28, 0.40, 1.00},
        titleText        = {0.95, 0.95, 0.95, 1.00},
        border           = {0.35, 0.35, 0.45, 0.80},
        widgetBg         = {0.10, 0.10, 0.13, 1.00},
        widgetHover      = {0.25, 0.25, 0.35, 1.00},
        widgetActive     = {0.30, 0.50, 0.75, 1.00},
        button           = {0.24, 0.36, 0.58, 1.00},
        buttonHover      = {0.32, 0.46, 0.70, 1.00},
        buttonActive     = {0.42, 0.58, 0.85, 1.00},
        checkMark        = {0.40, 0.70, 0.40, 1.00},
        sliderGrab       = {0.38, 0.58, 0.90, 1.00},
        sliderGrabHover  = {0.50, 0.70, 1.00, 1.00},
        sliderTrack      = {0.20, 0.20, 0.28, 1.00},
        inputBg          = {0.12, 0.12, 0.16, 1.00},
        inputBgActive    = {0.16, 0.16, 0.22, 1.00},
        inputCursor      = {0.90, 0.90, 0.90, 1.00},
        separator        = {0.35, 0.35, 0.45, 0.60},
        text             = {0.90, 0.90, 0.90, 1.00},
        textDisabled     = {0.50, 0.50, 0.55, 1.00},
        scrollbarBg      = {0.10, 0.10, 0.13, 0.60},
        scrollbarGrab    = {0.45, 0.45, 0.55, 0.80},
        scrollbarHover   = {0.60, 0.60, 0.70, 0.90},
        resizeGrip       = {0.35, 0.35, 0.55, 0.50},
        resizeGripHover  = {0.55, 0.55, 0.80, 0.80},
        tooltip          = {0.18, 0.18, 0.22, 0.95},
        tooltipBorder    = {0.45, 0.45, 0.60, 1.00},
        tooltipText      = {0.90, 0.90, 0.90, 1.00},
        progressBar      = {0.38, 0.58, 0.90, 1.00},
        progressBg       = {0.20, 0.20, 0.28, 1.00},
        closeBtn         = {0.65, 0.18, 0.18, 0.85},
        closeBtnHover    = {0.90, 0.25, 0.25, 1.00},
        minimizeBtn      = {0.30, 0.30, 0.42, 0.85},
        minimizeBtnHover = {0.50, 0.50, 0.68, 1.00},
        menuBarBg        = {0.20, 0.20, 0.26, 1.00},
        menuBg           = {0.18, 0.18, 0.23, 0.98},
        menuHover        = {0.30, 0.50, 0.75, 1.00},
        menuText         = {0.90, 0.90, 0.90, 1.00},
        menuShortcut     = {0.55, 0.55, 0.62, 1.00},
        menuSep          = {0.35, 0.35, 0.48, 0.80},
        snapPreview      = {0.40, 0.70, 1.00, 0.35},
        snapBorder       = {0.40, 0.70, 1.00, 0.90},
        taskbarBg        = {0.12, 0.12, 0.16, 0.98},
        taskbarBorder    = {0.30, 0.30, 0.40, 1.00},
        taskbarBtn       = {0.22, 0.22, 0.28, 1.00},
        taskbarBtnHover  = {0.32, 0.32, 0.42, 1.00},
        taskbarBtnActive = {0.28, 0.28, 0.40, 1.00},
        taskbarBtnFocus  = {0.28, 0.45, 0.70, 1.00},
        taskbarBtnClosed = {0.16, 0.16, 0.20, 1.00},
        taskbarText      = {0.90, 0.90, 0.90, 1.00},
        taskbarTextDim   = {0.55, 0.55, 0.60, 1.00},
        taskbarDot       = {0.40, 0.70, 0.40, 1.00},  -- open indicator
    },
}

-- ═══════════════════════════════════════════════════════════════════
--  INTERNAL STATE
-- ═══════════════════════════════════════════════════════════════════
local S            = {}
local _colorStack  = {}
local _varStack    = {}
local _fontStack   = {}

-- ═══════════════════════════════════════════════════════════════════
--  INIT / UPDATE
-- ═══════════════════════════════════════════════════════════════════
function im.Init()
    S.windows          = {}
    S.windowOrder      = {}
    S.openMenuId       = nil
    S.tooltipText      = nil
    S.tooltipX         = 0
    S.tooltipY         = 0
    S.mx, S.my         = 0, 0
    S.mouseDown        = {false, false, false}
    S.mousePressed     = {false, false, false}
    S.mouseReleased    = {false, false, false}
    S._pendingPressed  = {false, false, false}
    S._pendingReleased = {false, false, false}
    S._pendingScroll   = 0
    S._pendingKeys     = {}
    S._pendingText     = ""
    S.scrollDelta      = 0
    S.hot              = nil
    S.active           = nil
    S.currentWindow    = nil
    S.idStack          = {}
    S.keyQueue         = {}
    S.textQueue        = ""
    S.activeInputId    = nil
    S.inputCursorPos   = 0
    S.inputSelAnchor   = 0
    S.inputBlinkT      = 0
    S._inputDragId     = nil
    S.dt               = 0
    S.frame            = 0
    S.mouseOwnerWindow = nil
    S.menuDrop         = nil
    S._menuInAny       = false
    im.style.font      = lg.getFont()
end

function im.Update(dt)
    S.dt          = dt
    S.inputBlinkT = S.inputBlinkT + dt
end

-- ═══════════════════════════════════════════════════════════════════
--  FONT STACK  — widgets always call im._font(), never lg.getFont()
-- ═══════════════════════════════════════════════════════════════════
function im._font()
    if #_fontStack > 0 then return _fontStack[#_fontStack] end
    return im.style.font or lg.getFont()
end

function im.PushFont(font)
    table.insert(_fontStack, font)
    lg.setFont(font)
end

function im.PopFont()
    table.remove(_fontStack)
    lg.setFont(im._font())
end

-- ═══════════════════════════════════════════════════════════════════
--  STYLE STACKS
-- ═══════════════════════════════════════════════════════════════════
function im.PushStyleColor(key, color)
    table.insert(_colorStack, {key=key, prev=im.style.col[key]})
    im.style.col[key] = color
end

function im.PopStyleColor(count)
    for _ = 1, (count or 1) do
        local e = table.remove(_colorStack)
        if e then im.style.col[e.key] = e.prev end
    end
end

function im.PushStyleVar(key, value)
    table.insert(_varStack, {key=key, prev=im.style[key]})
    im.style[key] = value
end

function im.PopStyleVar(count)
    for _ = 1, (count or 1) do
        local e = table.remove(_varStack)
        if e then im.style[e.key] = e.prev end
    end
end

-- ═══════════════════════════════════════════════════════════════════
--  LOVE2D INPUT CALLBACKS
-- ═══════════════════════════════════════════════════════════════════
function im.MousePressed(x, y, button)
    if button <= 3 then S._pendingPressed[button] = true end
    -- bring clicked window to front of z-order
    for i = #S.windowOrder, 1, -1 do
        local w = S.windows[S.windowOrder[i]]
        if not w or w.closed then goto mp_next end
        local effH = w.minimized and im.style.titleBarH or w.h
        if im._pointInRect(x, y, w.x, w.y, w.w, effH) then
            if i ~= #S.windowOrder then
                local wid = table.remove(S.windowOrder, i)
                table.insert(S.windowOrder, wid)
            end
            break
        end
        ::mp_next::
    end
end

function im.MouseReleased(x, y, button)
    if button <= 3 then S._pendingReleased[button] = true end
end

function im.WheelMoved(x, y)
    S._pendingScroll = S._pendingScroll + y
end

function im.KeyPressed(key, scancode)
    table.insert(S._pendingKeys, key)
end

function im.TextInput(text)
    S._pendingText = S._pendingText .. text
end

-- ═══════════════════════════════════════════════════════════════════
--  FRAME  BeginFrame / EndFrame
-- ═══════════════════════════════════════════════════════════════════
function im.BeginFrame()
    S.frame       = S.frame + 1
    S.tooltipText = nil
    S.hot         = nil
    S._lastItemRect = nil

    -- pending → current
    S.mousePressed  = {S._pendingPressed[1],  S._pendingPressed[2],  S._pendingPressed[3]}
    S.mouseReleased = {S._pendingReleased[1], S._pendingReleased[2], S._pendingReleased[3]}
    S.scrollDelta   = S._pendingScroll
    S.keyQueue      = S._pendingKeys
    S.textQueue     = S._pendingText
    -- clear pending
    S._pendingPressed  = {false, false, false}
    S._pendingReleased = {false, false, false}
    S._pendingScroll   = 0
    S._pendingKeys     = {}
    S._pendingText     = ""

    S.mx, S.my = love.mouse.getPosition()
    for i = 1, 3 do S.mouseDown[i] = love.mouse.isDown(i) end

    S.menuDrop   = nil
    S._menuInAny = false
    -- snap preview is rebuilt each drag frame; clear at frame start
    if not S.mouseDown[1] then S.snapPreview = nil end

    -- drop open menu if its window closed
    if S.openMenuId then
        local sep   = S.openMenuId:find("::", 1, true)
        local winId = sep and S.openMenuId:sub(1, sep - 1)
        local ow    = winId and S.windows[winId]
        if not ow or ow.closed or ow.minimized then S.openMenuId = nil end
    end

    -- topmost window under mouse — only its widgets respond to hover/press
    S.mouseOwnerWindow = nil
    for i = #S.windowOrder, 1, -1 do
        local w = S.windows[S.windowOrder[i]]
        if not w or w.closed then goto bf_next end
        local effH = w.minimized and im.style.titleBarH or w.h
        if im._pointInRect(S.mx, S.my, w.x, w.y, w.w, effH) then
            S.mouseOwnerWindow = S.windowOrder[i]
            break
        end
        ::bf_next::
    end
end

function im.EndFrame()
    im._renderAll()
end

-- ═══════════════════════════════════════════════════════════════════
--  WINDOW  Begin / End
-- ═══════════════════════════════════════════════════════════════════
function im.Begin(name, options)
    options = options or {}
    local st = im.style

    local title, id
    local sep = name:find("##", 1, true)
    if sep then
        title = name:sub(1, sep - 1)
        id    = name:sub(sep + 2)
        if id == "" then id = name end
    else
        title = name
        id    = name
    end

    local w = S.windows[id]
    if not w then
        -- apply saved layout if LoadLayout ran before this window was created
        local saved = S._savedLayout and S._savedLayout[id]
        w = {
            id=id, title=title,
            x = (saved and saved.x) or options.x or 100,
            y = (saved and saved.y) or options.y or 100,
            w = (saved and saved.w) or options.w or 280,
            h = (saved and saved.h) or options.h or 300,
            scrollY   = (saved and saved.scrollY)   or 0,
            closed    = (saved and saved.closed)    or false,
            minimized = (saved and saved.minimized) or false,
            open=true,
        }
        if saved then S._savedLayout[id]=nil end
        S.windows[id] = w
        table.insert(S.windowOrder, id)
    end

    w.title   = title
    w.options = options
    if not w._initDone then
        if options.w then w.w = options.w end
        if options.h then w.h = options.h end
        w._initDone = true
    end

    -- sync closed state from options.open every frame
    -- options.open=false → closed, options.open=true → open
    -- nil means "don't touch" — let imlove manage it
    if options.open ~= nil then
        w.closed = not options.open
    end

    -- keep docked windows pinned to their parent / screen edge
    -- skip when minimized — minimized windows don't participate in docking layout
    if options.dockable and not w.minimized then im._updateDockedPosition(w) end

    S.currentWindow = w
    if w.closed then return false, false end

    w._menuBar = nil
    local titleH = options.noTitleBar and 0 or st.titleBarH

    -- title-bar buttons (close / minimize)
    if titleH > 0 and im._mouseOwnedBy(w) then
        local bsz, by, closeX, minX = im._winBtnGeom(w, titleH)
        if closeX and im._pointInRect(S.mx, S.my, closeX, by, bsz, bsz) and S.mousePressed[1] then
            w.closed = true; S.currentWindow = nil; return false, false
        end
        if minX and im._pointInRect(S.mx, S.my, minX, by, bsz, bsz) and S.mousePressed[1] then
            w.minimized = not w.minimized
        end
    end

    -- drag  (with pseudo-docking when options.dockable = true)
    local dragId = "##drag_" .. id
    if not options.noMove and titleH > 0 then
        local bsz, by, closeX, minX = im._winBtnGeom(w, titleH)
        local btnW    = bsz * ((closeX and 1 or 0) + (minX and 1 or 0)) + 10
        local inTitle = im._mouseOwnedBy(w)
                     and im._pointInRect(S.mx, S.my, w.x, w.y, w.w - btnW, titleH)

        if S.mousePressed[1] and inTitle and S.active == nil then
            S.active    = dragId
            w.dragOffX  = S.mx - w.x
            w.dragOffY  = S.my - w.y
            -- undock when starting a drag
            if w.dockedTo then
                im._undock(w)
            end
        end

        if S.active == dragId then
            -- raw position follows mouse
            w.x = S.mx - w.dragOffX
            w.y = S.my - w.dragOffY

            -- move children that are docked to this window
            im._moveDockChildren(id)

            if options.dockable then
                -- compute snap candidate every drag frame for the preview
                S.snapPreview = im._findSnap(w)
            end

            if not S.mouseDown[1] then
                -- mouse released — apply snap if dockable
                if options.dockable and S.snapPreview then
                    im._applySnap(w, S.snapPreview)
                end
                S.snapPreview = nil
                S.active      = nil
            end
        end
    end

    if w.minimized then w.drawCmds = {}; return false, true end

    -- resize
    if not options.noResize then
        local rg     = st.resizeGripSize
        local inGrip = im._mouseOwnedBy(w) and im._pointInRect(S.mx, S.my, w.x+w.w-rg, w.y+w.h-rg, rg, rg)
        local resId  = "##resize_" .. id
        if S.mousePressed[1] and inGrip and S.active == nil then S.active = resId end
        if S.active == resId then
            w.w = math.max(st.windowMinW, S.mx - w.x)
            w.h = math.max(st.windowMinH, S.my - w.y)
            if not S.mouseDown[1] then S.active = nil end
        end
    end

    -- layout init
    w.drawCmds = {}
    w.contentH = 0
    w.widgetY  = 0
    w.inner    = {
        x = w.x + st.windowPadding,
        y = w.y + titleH + st.windowPadding,
        w = w.w - st.windowPadding * 2 - (options.noScrollbar and 0 or st.scrollbarW),
    }
    w.cursorX       = w.inner.x
    w.cursorY       = w.inner.y - w.scrollY
    w.lineH         = 0
    w._pendingLineH = 0
    w.sameLine      = false
    w.sameLineSpacing = st.itemSpacingX
    w.lineStartX    = w.inner.x

    return true, true
end

function im.End()
    local w = S.currentWindow
    S.currentWindow = nil
    if not w or w.closed or w.minimized then return end
    local st     = im.style
    local titleH = (w.options and w.options.noTitleBar) and 0 or st.titleBarH
    local mbH    = (w._menuBar and w._menuBar.h) or 0
    local visH   = w.h - titleH - mbH - st.windowPadding * 2
    w.contentH   = w.widgetY
    local maxScroll = math.max(0, w.contentH - visH)
    if not (w.options and w.options.noScrollbar)
       and im._mouseOwnedBy(w)
       and im._pointInRect(S.mx, S.my, w.x, w.y, w.w, w.h) then
        w.scrollY = w.scrollY - S.scrollDelta * 20
    end
    w.scrollY = math.max(0, math.min(w.scrollY, maxScroll))
end

-- ═══════════════════════════════════════════════════════════════════
--  SHARED WIDGET HELPERS
-- ═══════════════════════════════════════════════════════════════════

-- Strip "##id" suffix → returns display label, numeric id.
function im._parseLabel(label)
    local sep = label:find("##", 1, true)
    local lbl, idStr
    if sep then
        lbl   = label:sub(1, sep - 1)
        idStr = label:sub(sep + 2)
        if idStr == "" then idStr = label end
    else
        lbl   = label
        idStr = label
    end
    return lbl, im.GetID(idStr)
end

-- Alloc space + visibility check in one call. Returns x, y, visible.
function im._alloc(w, ww, wh)
    local x, y = im._allocWidget(w, ww, wh)
    return x, y, im._visibleInWindow(w, y, wh)
end

-- Core button behavior — mirrors ImGui ButtonBehavior.
-- Returns hovered, held, clicked.
function im._btnBehavior(id, x, y, ww, wh, win)
    local hovered = im._mouseOwnedBy(win)
               and im._pointInRect(S.mx, S.my, x, y, ww, wh)
    if hovered and S.active == nil then S.hot = id end

    local held    = (S.active == id)
    local clicked = false
    if hovered and S.mousePressed[1] and S.active == nil then
        S.active = id; held = true
    end
    if S.active == id and S.mouseReleased[1] then
        clicked = hovered; S.active = nil; held = false
    end
    return hovered, held, clicked
end

-- Filled rect + border — used by every framed widget.
function im._drawFrame(win, x, y, ww, wh, bgCol, borderCol)
    local st = im.style
    im._cmd(win, "rect",       {x=x, y=y, w=ww, h=wh, color=bgCol, rx=st.widgetRound})
    im._cmd(win, "rectBorder", {x=x, y=y, w=ww, h=wh, color=borderCol or st.col.border, rx=st.widgetRound})
end

-- Pick bg color from normal/hover/active based on current hot/active state.
function im._frameBg(id, normal, hover, active)
    if S.active == id then return active or im.style.col.widgetActive end
    if S.hot    == id then return hover  or im.style.col.widgetHover  end
    return normal or im.style.col.widgetBg
end

-- ═══════════════════════════════════════════════════════════════════
--  LAYOUT HELPERS
-- ═══════════════════════════════════════════════════════════════════
function im.SameLine(spacing)
    local w = S.currentWindow
    if not w then return end
    w.sameLine        = true
    w.sameLineSpacing = spacing or im.style.itemSpacingX
end

function im.Separator()
    local w = S.currentWindow
    if not w then return end
    im._newLine(w)
    local x1 = w.inner.x
    local x2 = w.inner.x + w.inner.w
    local y  = w.cursorY + 4
    im._cmd(w, "line", {x1=x1, y1=y, x2=x2, y2=y, color=im.style.col.separator})
    im._advanceCursor(w, 0, 9)
end

function im.Spacing(amount)
    local w = S.currentWindow
    if not w then return end
    im._newLine(w)
    im._advanceCursor(w, 0, amount or im.style.itemSpacingY * 2)
end

function im.Indent(amount)
    local w = S.currentWindow; if not w then return end
    amount = amount or 16
    w.inner.x = w.inner.x + amount; w.cursorX = w.inner.x; w.lineStartX = w.inner.x
end

function im.Unindent(amount)
    local w = S.currentWindow; if not w then return end
    amount = amount or 16
    w.inner.x = w.inner.x - amount; w.cursorX = w.inner.x; w.lineStartX = w.inner.x
end

-- ═══════════════════════════════════════════════════════════════════
--  MENU BAR
-- ═══════════════════════════════════════════════════════════════════
function im.BeginMenuBar()
    local w = S.currentWindow; if not w then return false end
    local st     = im.style
    local titleH = (w.options and w.options.noTitleBar) and 0 or st.titleBarH
    w._menuBar   = {y=w.y+titleH, h=st.menuBarH, curX=w.x+st.windowPadding, items={}}
    w.cursorY    = w.cursorY + st.menuBarH
    return true
end

function im.EndMenuBar()
    local w = S.currentWindow; if not w or not w._menuBar then return end
    if S.mousePressed[1] and not S._menuInAny then
        if S.openMenuId and S.openMenuId:sub(1, #w.id+2) == w.id.."::" then
            S.openMenuId = nil
        end
    end
end

function im.BeginMenu(label)
    local w = S.currentWindow; local mb = w and w._menuBar; if not mb then return false end
    local st    = im.style
    local font  = im._font()
    local itemW = font:getWidth(label) + st.menuItemPadX * 2
    local hx    = mb.curX; mb.curX = mb.curX + itemW
    local menuId = w.id.."::"..label
    local owned  = im._mouseOwnedBy(w)
    local hover  = owned and im._pointInRect(S.mx, S.my, hx, mb.y, itemW, mb.h)
    if hover and S.mousePressed[1] then
        S.openMenuId = (S.openMenuId == menuId) and nil or menuId
    end
    local isOpen = (S.openMenuId == menuId)
    if hover or isOpen then S._menuInAny = true end
    table.insert(mb.items, {label=label, x=hx, w=itemW, hover=hover, isOpen=isOpen})
    if isOpen then
        S.menuDrop = {id=menuId, x=hx, y=mb.y+mb.h, w=140, h=0, nextY=mb.y+mb.h, items={}}
        return true
    end
    return false
end

function im.EndMenu() end

function im.MenuItem(label, shortcut, enabled)
    if enabled == nil then enabled = true end
    local drop = S.menuDrop; if not drop then return false end
    local st    = im.style
    local font  = im._font()
    local itemH = st.menuItemH
    local shortW = shortcut and (font:getWidth(shortcut) + st.menuItemPadX * 2) or 0
    local needed = font:getWidth(label) + st.menuItemPadX * 2 + shortW + 16
    if needed > drop.w then drop.w = needed end
    local iy = drop.nextY; drop.nextY = iy + itemH; drop.h = drop.nextY - drop.y
    local hover   = im._pointInRect(S.mx, S.my, drop.x, iy, drop.w, itemH)
    local clicked = false
    if hover then
        S._menuInAny = true
        if enabled and S.mousePressed[1] then clicked=true; S.openMenuId=nil end
    end
    table.insert(drop.items, {kind="item", label=label, shortcut=shortcut,
                               enabled=enabled, hover=hover, iy=iy, itemH=itemH})
    return clicked
end

function im.MenuSeparator()
    local drop = S.menuDrop; if not drop then return end
    local iy = drop.nextY; drop.nextY = iy+7; drop.h = drop.nextY-drop.y
    table.insert(drop.items, {kind="sep", iy=iy, sepH=7})
end

-- ═══════════════════════════════════════════════════════════════════
--  WIDGETS
-- ═══════════════════════════════════════════════════════════════════

-- ── Label ─────────────────────────────────────────────────────────
function im.Label(text, color)
    local w = S.currentWindow; if not w then return end
    local font = im._font()
    local x, y, visible = im._alloc(w, font:getWidth(text), font:getHeight())
    if visible then
        im._cmd(w, "text", {text=text, x=x, y=y, color=color or im.style.col.text})
    end
end

function im.LabelColored(text, r, g, b, a) im.Label(text, {r,g,b,a or 1}) end

-- ── TextWrapped ────────────────────────────────────────────────────
function im.TextWrapped(text)
    local w = S.currentWindow; if not w then return end
    local font  = im._font()
    local th    = font:getHeight()
    local lines = im._wrapText(font, text, w.inner.w)
    for i, line in ipairs(lines) do
        if i > 1 then im._newLine(w) end
        local x, y, visible = im._alloc(w, font:getWidth(line), th)
        if visible then im._cmd(w, "text", {text=line, x=x, y=y, color=im.style.col.text}) end
    end
end

-- ── Button ────────────────────────────────────────────────────────
function im.Button(label, btnW, btnH)
    local w = S.currentWindow; if not w then return false end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label)
    local tw, th  = font:getWidth(lbl), font:getHeight()
    btnW = btnW or (tw + st.padding * 2)
    btnH = btnH or (th + st.padding * 2)

    local x, y, visible = im._alloc(w, btnW, btnH)
    local clicked = false
    if visible then
        local hovered, held, clk = im._btnBehavior(id, x, y, btnW, btnH, w)
        clicked = clk
        im._drawFrame(w, x, y, btnW, btnH, im._frameBg(id, st.col.button, st.col.buttonHover, st.col.buttonActive))
        im._cmd(w, "text", {
            text  = lbl,
            x     = x + math.floor((btnW - tw) * 0.5),
            y     = y + math.floor((btnH - th) * 0.5),
            color = st.col.text,
        })
    end
    return clicked
end

-- ── Checkbox ──────────────────────────────────────────────────────
function im.Checkbox(label, value)
    local w = S.currentWindow; if not w then return value, false end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label)
    local boxS    = st.checkboxSize
    local th      = font:getHeight()
    local totalH  = math.max(boxS, th)
    local totalW  = boxS + st.itemSpacingX + font:getWidth(lbl)

    local x, y, visible = im._alloc(w, totalW, totalH)
    local changed = false
    if visible then
        local by = y + math.floor((totalH - boxS) * 0.5)
        local _, _, clicked = im._btnBehavior(id, x, by, boxS, boxS, w)
        if clicked then value = not value; changed = true end
        im._drawFrame(w, x, by, boxS, boxS, im._frameBg(id, st.col.widgetBg, st.col.widgetHover, st.col.widgetActive))
        if value then
            local p = 3
            im._cmd(w, "line", {x1=x+p,       y1=by+boxS*0.55, x2=x+boxS*0.45, y2=by+boxS-p, color=st.col.checkMark, lw=2})
            im._cmd(w, "line", {x1=x+boxS*0.45, y1=by+boxS-p,  x2=x+boxS-p,   y2=by+p,       color=st.col.checkMark, lw=2})
        end
        im._cmd(w, "text", {text=lbl, x=x+boxS+st.itemSpacingX, y=y+math.floor((totalH-th)*0.5), color=st.col.text})
    end
    return value, changed
end

-- ── RadioButton ───────────────────────────────────────────────────
function im.RadioButton(label, current, buttonValue)
    local w = S.currentWindow; if not w then return current, false end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label .. tostring(buttonValue))
    local r       = st.checkboxSize * 0.5
    local th      = font:getHeight()
    local totalH  = math.max(st.checkboxSize, th)
    local totalW  = st.checkboxSize + st.itemSpacingX + font:getWidth(lbl)

    local x, y, visible = im._alloc(w, totalW, totalH)
    local changed = false
    if visible then
        local cy = y + math.floor(totalH * 0.5)
        local cx = x + r
        local hovered = im._mouseOwnedBy(w) and im._dist(S.mx, S.my, cx, cy, r+2)
        if hovered then S.hot = id end
        if hovered and S.mousePressed[1] and current ~= buttonValue then current=buttonValue; changed=true end
        local bgCol = im._frameBg(id, st.col.widgetBg, st.col.widgetHover, st.col.widgetActive)
        im._cmd(w, "circle", {x=cx, y=cy, r=r,   color=bgCol,         fill=true})
        im._cmd(w, "circle", {x=cx, y=cy, r=r,   color=st.col.border, fill=false})
        if current == buttonValue then
            im._cmd(w, "circle", {x=cx, y=cy, r=r-3, color=st.col.checkMark, fill=true})
        end
        im._cmd(w, "text", {text=lbl, x=x+st.checkboxSize+st.itemSpacingX, y=y+math.floor((totalH-th)*0.5), color=st.col.text})
    end
    return current, changed
end

-- ── Slider ────────────────────────────────────────────────────────
function im.Slider(label, value, vmin, vmax, fmt)
    local w = S.currentWindow; if not w then return value end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label)
    fmt = fmt or "%.2f"
    local th      = font:getHeight()
    local barW    = w.inner.w
    local labelH  = (lbl ~= "") and (th + st.itemSpacingY) or 0
    local totalH  = labelH + st.sliderH

    local x, y, visible = im._alloc(w, barW, totalH)
    if visible then
        if lbl ~= "" then
            im._cmd(w, "text", {text=lbl..": "..string.format(fmt,value), x=x, y=y, color=st.col.text})
        end
        local by    = y + labelH
        local grabW = 10
        im._btnBehavior(id, x, by-4, barW, st.sliderH+8, w)
        if S.active == id then
            local t = math.max(0, math.min(1, (S.mx - x - grabW*0.5) / (barW - grabW)))
            value = vmin + t*(vmax-vmin)
            if not S.mouseDown[1] then S.active = nil end
        end
        value = im.Clamp(value, vmin, vmax)
        local t     = (vmax > vmin) and ((value-vmin)/(vmax-vmin)) or 0
        local grabX = x + t*(barW-grabW)
        local grabCol = im._frameBg(id, st.col.sliderGrab, st.col.sliderGrabHover, st.col.widgetActive)
        im._cmd(w, "rect", {x=x,     y=by+st.sliderH*0.25, w=barW,                          h=st.sliderH*0.5, color=st.col.sliderTrack,  rx=st.sliderH*0.25})
        im._cmd(w, "rect", {x=x,     y=by+st.sliderH*0.25, w=math.max(grabW*0.5,grabX-x+grabW*0.5), h=st.sliderH*0.5, color=st.col.widgetActive, rx=st.sliderH*0.25})
        im._cmd(w, "rect", {x=grabX, y=by,                  w=grabW,                         h=st.sliderH,     color=grabCol,            rx=3})
    end
    return value
end

function im.SliderInt(label, value, vmin, vmax)
    return math.floor(im.Slider(label, value, vmin, vmax, "%d") + 0.5)
end

-- ── InputText ─────────────────────────────────────────────────────
function im.InputText(label, text, maxLen)
    local w = S.currentWindow; if not w then return text end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label)
    maxLen = maxLen or 256
    local th     = font:getHeight()
    local labelH = (lbl ~= "") and (th + st.itemSpacingY) or 0
    local bh     = st.inputH
    local x, y, visible = im._alloc(w, w.inner.w, labelH + bh)
    if not visible then return text end
    if lbl ~= "" then im._cmd(w,"text",{text=lbl,x=x,y=y,color=st.col.text}) end

    local pad = 4
    local bx, bw, by = x, w.inner.w, y+labelH

    local function selRange()
        local a = S.inputSelAnchor or S.inputCursorPos
        local b = S.inputCursorPos
        if a<=b then return a,b else return b,a end
    end
    local function computeVis(t, cp)
        local vo,vt = 0, t
        local maxW  = bw - pad*2
        while font:getWidth(vt)>maxW and #vt>0 do vt=vt:sub(2); vo=vo+1 end
        while cp<vo do vo=vo-1; vt=t:sub(vo+1) end
        while vo<#t and font:getWidth(t:sub(vo+1,cp))>maxW do vo=vo+1; vt=t:sub(vo+1) end
        return vt, vo
    end
    local function pixelToPos(relX, t, vo)
        local vt = t:sub(vo+1)
        for i=1,#vt do
            local cw = font:getWidth(vt:sub(1,i))
            if cw>=relX then
                local pw = i>1 and font:getWidth(vt:sub(1,i-1)) or 0
                return vo + (relX-pw < cw-relX and i-1 or i)
            end
        end
        return vo+#vt
    end

    local hover  = im._mouseOwnedBy(w) and im._pointInRect(S.mx,S.my,bx,by,bw,bh)
    local active = (S.activeInputId == id)

    if hover and S.mousePressed[1] then
        S.activeInputId=id; S.inputBlinkT=0; active=true
        local _,vo = computeVis(text, S.inputCursorPos)
        S.inputCursorPos = pixelToPos(S.mx-(bx+pad), text, vo)
        S.inputSelAnchor = S.inputCursorPos; S._inputDragId=id
    end
    if S._inputDragId==id and S.mouseDown[1] then
        local _,vo = computeVis(text, S.inputCursorPos)
        S.inputCursorPos = pixelToPos(S.mx-(bx+pad), text, vo)
    end
    if not S.mouseDown[1] and S._inputDragId==id then S._inputDragId=nil end
    if S.mousePressed[1] and not hover and active then S.activeInputId=nil; active=false end

    if active then
        local ctrl  = love.keyboard.isDown("lctrl")  or love.keyboard.isDown("rctrl")
        local shift = love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift")
        local function replSel(ins)
            local s,e = selRange()
            local nt  = text:sub(1,s)..ins..text:sub(e+1)
            if #nt<=maxLen then text=nt; S.inputCursorPos=s+#ins; S.inputSelAnchor=S.inputCursorPos end
        end
        local function moveCur(np, ext)
            if not ext then local s,e=selRange(); if s<e then np=(np<S.inputCursorPos) and s or e end; S.inputSelAnchor=np end
            S.inputCursorPos=np
        end
        if S.textQueue~="" and not ctrl then replSel(S.textQueue) end
        for _,k in ipairs(S.keyQueue) do
            if ctrl then
                if k=="a" then S.inputSelAnchor=0; S.inputCursorPos=#text
                elseif k=="c" then local s,e=selRange(); if s<e then love.system.setClipboardText(text:sub(s+1,e)) end
                elseif k=="x" then local s,e=selRange(); if s<e then love.system.setClipboardText(text:sub(s+1,e)); replSel("") end
                elseif k=="v" then local c=love.system.getClipboardText(); if c and c~="" then replSel(c) end
                end
            else
                if k=="backspace" then local s,e=selRange(); if s<e then replSel("") elseif S.inputCursorPos>0 then text=text:sub(1,S.inputCursorPos-1)..text:sub(S.inputCursorPos+1); S.inputCursorPos=S.inputCursorPos-1; S.inputSelAnchor=S.inputCursorPos end
                elseif k=="delete" then local s,e=selRange(); if s<e then replSel("") elseif S.inputCursorPos<#text then text=text:sub(1,S.inputCursorPos)..text:sub(S.inputCursorPos+2); S.inputSelAnchor=S.inputCursorPos end
                elseif k=="left"  then local s,e=selRange(); moveCur((s<e and not shift) and s or math.max(0,S.inputCursorPos-1), shift)
                elseif k=="right" then local s,e=selRange(); moveCur((s<e and not shift) and e or math.min(#text,S.inputCursorPos+1), shift)
                elseif k=="home"  then moveCur(0,     shift)
                elseif k=="end"   then moveCur(#text, shift)
                elseif k=="return" or k=="escape" then S.activeInputId=nil; S.inputSelAnchor=S.inputCursorPos; active=false
                end
            end
        end
    end

    im._drawFrame(w, bx, by, bw, bh, active and st.col.inputBgActive or st.col.inputBg,
                  active and st.col.widgetActive or st.col.border)

    local visText, visOff = computeVis(text, S.inputCursorPos)
    local ty = by + math.floor((bh - th) * 0.5)

    if active then
        local s,e = selRange()
        if s<e then
            local vs  = math.max(0,s-visOff); local ve = math.max(0,e-visOff)
            local hx1 = bx+pad+font:getWidth(visText:sub(1,vs))
            local hx2 = bx+pad+font:getWidth(visText:sub(1,math.min(ve,#visText)))
            if hx2>hx1 then im._cmd(w,"rectClip",{x=hx1,y=by+2,w=hx2-hx1,h=bh-4,color={st.col.widgetActive[1],st.col.widgetActive[2],st.col.widgetActive[3],0.55},clipX=bx,clipY=by,clipW=bw,clipH=bh}) end
        end
    end
    im._cmd(w,"textClip",{text=visText,x=bx+pad,y=ty,color=st.col.text,clipX=bx,clipY=by,clipW=bw,clipH=bh})
    if active then
        local s,e = selRange()
        if s==e and (math.floor(S.inputBlinkT*2)%2==0) then
            local off = math.max(0, math.min(S.inputCursorPos-visOff, #visText))
            local cx  = bx+pad+font:getWidth(visText:sub(1,off))
            im._cmd(w,"line",{x1=cx,y1=by+3,x2=cx,y2=by+bh-3,color=st.col.inputCursor,lw=1.5})
        end
    end
    return text
end

-- ── ProgressBar ───────────────────────────────────────────────────
function im.ProgressBar(fraction, barW, barH, overlay)
    local w = S.currentWindow; if not w then return end
    local st   = im.style
    local font = im._font()
    barW     = barW or w.inner.w
    barH     = barH or st.sliderH
    fraction = im.Clamp(fraction, 0, 1)
    local x, y, visible = im._alloc(w, barW, barH)
    if visible then
        im._cmd(w,"rect",{x=x,y=y,w=barW,h=barH,color=st.col.progressBg,rx=3})
        if fraction>0 then im._cmd(w,"rect",{x=x,y=y,w=barW*fraction,h=barH,color=st.col.progressBar,rx=3}) end
        if overlay then
            local tw,th = font:getWidth(overlay), font:getHeight()
            im._cmd(w,"text",{text=overlay, x=x+math.floor((barW-tw)*0.5), y=y+math.floor((barH-th)*0.5), color=st.col.text})
        end
    end
end

-- ── Selectable ────────────────────────────────────────────────────
function im.Selectable(label, selected, rowW, rowH)
    local w = S.currentWindow; if not w then return selected, false end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label)
    local th      = font:getHeight()
    rowW = rowW or w.inner.w
    rowH = rowH or (th + st.padding)
    local x, y, visible = im._alloc(w, rowW, rowH)
    if not visible then return selected, false end
    local hovered, _, clicked = im._btnBehavior(id, x, y, rowW, rowH, w)
    if clicked then selected = not selected end
    local bgCol = selected and st.col.widgetActive or (hovered and st.col.widgetHover or nil)
    if bgCol then im._cmd(w,"rect",{x=x,y=y,w=rowW,h=rowH,color=bgCol,rx=st.widgetRound}) end
    im._cmd(w,"text",{text=lbl, x=x+st.padding*0.5, y=y+math.floor((rowH-th)*0.5), color=selected and {1,1,1,1} or st.col.text})
    return selected, clicked
end

-- ── CollapsingHeader ──────────────────────────────────────────────
function im.CollapsingHeader(label, open)
    local w = S.currentWindow; if not w then return open end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label)
    local th      = font:getHeight()
    local hh      = th + st.padding * 2
    local x, y, visible = im._alloc(w, w.inner.w, hh)
    if not visible then return open end
    local _, _, clicked = im._btnBehavior(id, x, y, w.inner.w, hh, w)
    if clicked then open = not open end
    im._cmd(w,"rect",{x=x,y=y,w=w.inner.w,h=hh,color=im._frameBg(id,st.col.widgetBg,st.col.widgetHover,st.col.widgetActive)})
    im._cmd(w,"text",{text=(open and "v " or "> ")..lbl, x=x+st.padding, y=y+math.floor((hh-th)*0.5), color=st.col.text})
    return open
end

-- ── Image ─────────────────────────────────────────────────────────
-- Draws an image (or quad) inline in the layout.
-- dispW/dispH override display size (nil = natural size)
function im.Image(image, quad, dispW, dispH)
    local w = S.currentWindow; if not w then return end
    local iw, ih
    if quad then local _,_,qw,qh=quad:getViewport(); iw,ih=qw,qh
    else iw,ih = image:getDimensions() end
    dispW = dispW or iw
    dispH = dispH or ih
    local x, y, visible = im._alloc(w, dispW, dispH)
    if visible then
        im._cmd(w, "imageClip", {
            image=image, quad=quad,
            x=x, y=y, sx=dispW/iw, sy=dispH/ih,
            clipX=w.x, clipY=w.y, clipW=w.w, clipH=w.h,
        })
    end
end

-- ── SelectableImage ───────────────────────────────────────────────
-- Clickable image row. quad is optional.
-- Returns selected (bool), clicked (bool).
function im.SelectableImage(label, image, quad, selected, dispW, dispH)
    local w = S.currentWindow; if not w then return selected, false end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label)
    local iw, ih
    if quad then local _,_,qw,qh=quad:getViewport(); iw,ih=qw,qh
    else iw,ih = image:getDimensions() end
    dispW = dispW or iw
    dispH = dispH or ih
    local th   = font:getHeight()
    local rowW = w.inner.w
    local rowH = dispH + st.padding
    local x, y, visible = im._alloc(w, rowW, rowH)
    if not visible then return selected, false end
    local hovered, _, clicked = im._btnBehavior(id, x, y, rowW, rowH, w)
    if clicked then selected = not selected end
    local bgCol = selected and st.col.widgetActive or (hovered and st.col.widgetHover or nil)
    if bgCol then im._cmd(w,"rect",{x=x,y=y,w=rowW,h=rowH,color=bgCol,rx=st.widgetRound}) end
    local ix = x + st.padding * 0.5
    local iy = y + math.floor((rowH - dispH) * 0.5)
    im._cmd(w, "imageClip", {
        image=image, quad=quad, x=ix, y=iy, sx=dispW/iw, sy=dispH/ih,
        clipX=x, clipY=y, clipW=rowW, clipH=rowH,
    })
    if lbl ~= "" then
        im._cmd(w,"text",{
            text=lbl, x=ix+dispW+st.itemSpacingX,
            y=y+math.floor((rowH-th)*0.5),
            color=selected and {1,1,1,1} or st.col.text,
        })
    end
    return selected, clicked
end

-- ── Popup ─────────────────────────────────────────────────────────
-- Usage:
--   if im.Button("Open") then im.OpenPopup("Alert") end
--   if im.BeginPopup("Alert") then
--       im.Label("Are you sure?")
--       if im.Button("Yes") then im.ClosePopup("Alert") end
--       im.EndPopup()
--   end
-- Popup sits on top of all windows, closes on outside click.

function im.OpenPopup(name)
    local sep=name:find("##",1,true); local id=sep and name:sub(sep+2) or name
    if id=="" then id=name end
    S._pendingPopup = id
end

function im.ClosePopup(name)
    local sep=name:find("##",1,true); local id=sep and name:sub(sep+2) or name
    if id=="" then id=name end
    local pw=S.windows[id]; if pw then pw.closed=true end
end

function im.BeginPopup(name, options)
    options = options or {}
    options.noMinimize = true
    options.isPopup    = true
    local sep=name:find("##",1,true); local id=sep and name:sub(sep+2) or name
    if id=="" then id=name end

    local justOpened = false

    if S._pendingPopup == id then
        S._pendingPopup = nil
        justOpened      = true
        -- set initial position near mouse before Begin creates the window
        options.x = options.x or math.max(10, math.floor(S.mx-(options.w or 220)*0.5))
        options.y = options.y or math.max(10, math.floor(S.my-20))
        -- if window already existed (re-open), un-close it and bring to top
        local existing = S.windows[id]
        if existing then
            existing.closed = false
            for i,wid in ipairs(S.windowOrder) do
                if wid==id then table.remove(S.windowOrder,i); break end
            end
            table.insert(S.windowOrder, id)
        end
    else
        -- popup was not just opened — if it isn't open, nothing to do
        local pw = S.windows[id]
        if not pw or pw.closed then return false end
        -- close on click outside (never on the open frame)
        if S.mousePressed[1] and S.mouseOwnerWindow ~= id then
            pw.closed = true; return false
        end
    end

    -- Begin creates the window if new, or updates it if existing
    local visible, open = im.Begin(name, options)
    if not visible then return false end

    -- first-open: bring to top (window just got created by Begin)
    if justOpened then
        for i,wid in ipairs(S.windowOrder) do
            if wid==id then table.remove(S.windowOrder,i); break end
        end
        table.insert(S.windowOrder, id)
    end

    return true
end

function im.EndPopup() im.End() end

-- ── ColorPicker ───────────────────────────────────────────────────
-- color : {r, g, b}  or  {r, g, b, a}  (values 0-1)
-- Returns the (possibly modified) color table.
--
-- Layout (all inline, fits inside any window):
--   [ SV square ] [ hue bar ] [ alpha bar (if hasAlpha) ]
--   [ hex label + preview swatch ]
--
-- Usage:
--   myColor = im.ColorPicker("Tint##cp", myColor)

-- ── internal HSV ↔ RGB ────────────────────────────────────────────
local function _hsvToRgb(h, s, v)
    if s == 0 then return v, v, v end
    h = (h % 1) * 6
    local i  = math.floor(h)
    local f  = h - i
    local p  = v * (1 - s)
    local q  = v * (1 - s * f)
    local t  = v * (1 - s * (1 - f))
    if     i==0 then return v,t,p
    elseif i==1 then return q,v,p
    elseif i==2 then return p,v,t
    elseif i==3 then return p,q,v
    elseif i==4 then return t,p,v
    else              return v,p,q end
end

local function _rgbToHsv(r, g, b)
    local mx = math.max(r,g,b)
    local mn = math.min(r,g,b)
    local d  = mx - mn
    local h, s, v = 0, 0, mx
    if mx ~= 0 then s = d / mx end
    if d ~= 0 then
        if     mx==r then h = (g-b)/d + (g<b and 6 or 0)
        elseif mx==g then h = (b-r)/d + 2
        else              h = (r-g)/d + 4 end
        h = h / 6
    end
    return h, s, v
end

-- Build SV square mesh (4-corner gradient).
-- hue in 0-1.  Returns a Love2D Mesh.
local function _makeSVMesh(x, y, sz, hue)
    local hr, hg, hb = _hsvToRgb(hue, 1, 1)
    -- corners: TL=white, TR=hue-color, BL=black, BR=black
    -- we layer two quads: white→hue-color (top), then transparent→black (bottom)
    -- simplest: use a 4-vertex mesh with per-vertex color
    --   TL: white (s=0,v=1)   TR: pure hue (s=1,v=1)
    --   BL: black (s=0,v=0)   BR: black    (s=1,v=0)
    local verts = {
        {x,      y,      0, 0,  1,   1,   1,   1},   -- TL white
        {x+sz,   y,      1, 0,  hr,  hg,  hb,  1},   -- TR hue
        {x+sz,   y+sz,   1, 1,  0,   0,   0,   1},   -- BR black
        {x,      y+sz,   0, 1,  0,   0,   0,   1},   -- BL black
    }
    local m = lg.newMesh(verts, "fan", "dynamic")
    return m
end

-- Build vertical hue-bar mesh (rainbow strip).
local function _makeHueMesh(x, y, w, h)
    local steps = 12
    local verts = {}
    for i = 0, steps do
        local t  = i / steps
        local r,g,b = _hsvToRgb(t, 1, 1)
        local yy = y + t * h
        table.insert(verts, {x,   yy, 0, t, r, g, b, 1})
        table.insert(verts, {x+w, yy, 1, t, r, g, b, 1})
    end
    local m = lg.newMesh(#verts, "strip", "dynamic")
    for i,v in ipairs(verts) do m:setVertex(i, v) end
    return m
end

-- Build vertical alpha bar mesh (color → transparent).
local function _makeAlphaMesh(x, y, w, h, r, g, b)
    local verts = {
        {x,   y,   0,0,  r,g,b,1},
        {x+w, y,   1,0,  r,g,b,1},
        {x+w, y+h, 1,1,  r,g,b,0},
        {x,   y+h, 0,1,  r,g,b,0},
    }
    local m = lg.newMesh(verts, "fan", "dynamic")
    return m
end

function im.ColorPicker(label, color)
    local w = S.currentWindow; if not w then return color end
    local st      = im.style
    local font    = im._font()
    local lbl, id = im._parseLabel(label)
    local hasAlpha = (#color >= 4)

    -- copy so we don't mutate caller's table unless changed
    local r = color[1] or 0
    local g = color[2] or 0
    local b = color[3] or 0
    local a = color[4] or 1

    local h, sv, vv = _rgbToHsv(r, g, b)

    -- layout constants
    local sqSz   = math.min(w.inner.w - 60, 140)   -- SV square size
    local barW   = 14                                -- hue / alpha bar width
    local barGap = 6
    local totalW = sqSz + barGap + barW + (hasAlpha and barGap + barW or 0)
    local swatchH = font:getHeight() + 4
    local totalH  = sqSz + st.itemSpacingY + swatchH
                  + (lbl ~= "" and font:getHeight() + st.itemSpacingY or 0)

    local ox, oy, visible = im._alloc(w, totalW, totalH)
    if not visible then return color end

    local labelY = oy
    if lbl ~= "" then
        im._cmd(w,"text",{text=lbl, x=ox, y=labelY, color=st.col.text})
        oy = oy + font:getHeight() + st.itemSpacingY
    end

    -- coordinates
    local sqX  = ox
    local sqY  = oy
    local hbX  = sqX + sqSz + barGap
    local hbY  = sqY
    local abX  = hbX + barW + barGap
    local abY  = sqY

    -- ── IDs for each drag zone ────────────────────────────────────
    local svId    = id          -- SV square
    local hueId   = id + 1      -- hue bar
    local alphaId = id + 2      -- alpha bar

    local owned = im._mouseOwnedBy(w)

    -- ── SV square interaction ─────────────────────────────────────
    local svHov = owned and im._pointInRect(S.mx,S.my, sqX,sqY, sqSz,sqSz)
    if svHov and S.mousePressed[1] and S.active==nil then S.active=svId end
    if S.active==svId then
        sv = im.Clamp((S.mx - sqX) / sqSz, 0, 1)
        vv = 1 - im.Clamp((S.my - sqY) / sqSz, 0, 1)
        r,g,b = _hsvToRgb(h, sv, vv)
        if not S.mouseDown[1] then S.active=nil end
    end

    -- ── hue bar interaction ───────────────────────────────────────
    local hHov = owned and im._pointInRect(S.mx,S.my, hbX,hbY, barW,sqSz)
    if hHov and S.mousePressed[1] and S.active==nil then S.active=hueId end
    if S.active==hueId then
        h = im.Clamp((S.my - hbY) / sqSz, 0, 0.9999)
        r,g,b = _hsvToRgb(h, sv, vv)
        if not S.mouseDown[1] then S.active=nil end
    end

    -- ── alpha bar interaction ─────────────────────────────────────
    if hasAlpha then
        local aHov = owned and im._pointInRect(S.mx,S.my, abX,abY, barW,sqSz)
        if aHov and S.mousePressed[1] and S.active==nil then S.active=alphaId end
        if S.active==alphaId then
            -- alpha bar goes opaque (top) → transparent (bottom)
            a = 1 - im.Clamp((S.my - abY) / sqSz, 0, 1)
            if not S.mouseDown[1] then S.active=nil end
        end
    end

    -- ── build meshes each frame (cheap for small sizes) ──────────
    local svMesh  = _makeSVMesh(sqX, sqY, sqSz, h)
    local hueMesh = _makeHueMesh(hbX, hbY, barW, sqSz)

    local clipX = w.x; local clipY = w.y; local clipW = w.w; local clipH = w.h

    im._cmd(w, "meshClip", {mesh=svMesh,  clipX=clipX,clipY=clipY,clipW=clipW,clipH=clipH})
    im._cmd(w, "meshClip", {mesh=hueMesh, clipX=clipX,clipY=clipY,clipW=clipW,clipH=clipH})

    -- SV square border
    im._cmd(w,"rectBorder",{x=sqX,y=sqY,w=sqSz,h=sqSz, color=st.col.border})
    im._cmd(w,"rectBorder",{x=hbX,y=hbY,w=barW,h=sqSz, color=st.col.border})

    -- SV crosshair
    local cxX = sqX + sv  * sqSz
    local cxY = sqY + (1-vv) * sqSz
    im._cmd(w,"line",{x1=cxX-5,y1=cxY,   x2=cxX+5,y2=cxY,   color={1,1,1,1},lw=1.5})
    im._cmd(w,"line",{x1=cxX,  y1=cxY-5, x2=cxX,  y2=cxY+5, color={1,1,1,1},lw=1.5})
    im._cmd(w,"line",{x1=cxX-5,y1=cxY,   x2=cxX+5,y2=cxY,   color={0,0,0,0.6},lw=0.5})

    -- hue bar marker (horizontal line)
    local hmY = hbY + h * sqSz
    im._cmd(w,"line",{x1=hbX-2,y1=hmY, x2=hbX+barW+2,y2=hmY, color={1,1,1,1},lw=2})

    -- alpha bar
    if hasAlpha then
        -- checkerboard bg to show transparency
        local cbSz = 5
        local rows = math.ceil(sqSz / cbSz)
        for row = 0, rows-1 do
            for col = 0, 1 do
                local dark = ((row+col)%2==0)
                local cy   = abY + row*cbSz
                local cx2  = abX + col*(barW*0.5)
                im._cmd(w,"rect",{
                    x=cx2, y=cy, w=barW*0.5, h=math.min(cbSz, sqSz-row*cbSz),
                    color=dark and {0.4,0.4,0.4,1} or {0.7,0.7,0.7,1},
                })
            end
        end
        local alphaMesh = _makeAlphaMesh(abX, abY, barW, sqSz, r, g, b)
        im._cmd(w,"meshClip",{mesh=alphaMesh, clipX=clipX,clipY=clipY,clipW=clipW,clipH=clipH})
        im._cmd(w,"rectBorder",{x=abX,y=abY,w=barW,h=sqSz, color=st.col.border})
        -- alpha marker
        local amY = abY + (1-a)*sqSz
        im._cmd(w,"line",{x1=abX-2,y1=amY, x2=abX+barW+2,y2=amY, color={1,1,1,1},lw=2})
    end

    -- ── swatch + hex label ────────────────────────────────────────
    local swY    = sqY + sqSz + st.itemSpacingY
    local swW    = sqSz + barGap + barW + (hasAlpha and barGap+barW or 0)
    -- checkerboard behind swatch for alpha
    if hasAlpha then
        local cbSz=6
        for col=0, math.ceil(swW/(cbSz*2))-1 do
            for row=0,1 do
                local dark=((col+row)%2==0)
                im._cmd(w,"rect",{
                    x=ox+col*cbSz*2+row*cbSz, y=swY,
                    w=cbSz, h=swatchH,
                    color=dark and {0.4,0.4,0.4,1} or {0.7,0.7,0.7,1},
                })
            end
        end
    end
    im._cmd(w,"rect",      {x=ox, y=swY, w=swW,    h=swatchH, color={r,g,b,a}})
    im._cmd(w,"rectBorder",{x=ox, y=swY, w=swW,    h=swatchH, color=st.col.border})

    -- hex text
    local hexStr
    if hasAlpha then
        hexStr = string.format("#%02X%02X%02X%02X",
            math.floor(r*255+0.5), math.floor(g*255+0.5),
            math.floor(b*255+0.5), math.floor(a*255+0.5))
    else
        hexStr = string.format("#%02X%02X%02X",
            math.floor(r*255+0.5), math.floor(g*255+0.5), math.floor(b*255+0.5))
    end
    local hxW = font:getWidth(hexStr)
    im._cmd(w,"text",{
        text  = hexStr,
        x     = ox + math.floor((swW - hxW)*0.5),
        y     = swY + math.floor((swatchH - font:getHeight())*0.5),
        color = (r*0.299+g*0.587+b*0.114) > 0.5 and {0,0,0,1} or {1,1,1,1},
    })

    -- return updated color
    if hasAlpha then
        return {r, g, b, a}
    else
        return {r, g, b}
    end
end

-- ── IsItemHovered ─────────────────────────────────────────────────
-- Returns true if the mouse is over the last widget that was laid out.
-- Respects window ownership — won't fire through other windows.
function im.IsItemHovered()
    local r = S._lastItemRect
    if not r then return false end
    -- check the window that owns the item still has mouse ownership
    local win = S.windows[r.winId]
    if not win then return false end
    return im._mouseOwnedBy(win)
       and im._pointInRect(S.mx, S.my, r.x, r.y, r.w, r.h)
end

-- ── SetTooltip ────────────────────────────────────────────────────
-- Show a tooltip if the last widget is hovered.
-- Call immediately after the widget you want to annotate.
--
--   im.Button("Save")
--   im.SetTooltip("Save the current file  (Ctrl+S)")
--
-- Multiple lines: separate with \n
--   im.SetTooltip("Line one\nLine two")
function im.SetTooltip(text)
    if not im.IsItemHovered() then return end
    S.tooltipText = text
    -- offset slightly from mouse so it doesn't cover the widget
    S.tooltipX    = S.mx + 14
    S.tooltipY    = S.my + 18
end

-- ── BeginTooltip / EndTooltip ─────────────────────────────────────
-- For rich tooltips with multiple widgets inside.
-- Usage:
--   if im.BeginTooltip() then
--       im.Label("Rich tooltip")
--       im.Image(icon, nil, 32, 32)
--       im.EndTooltip()
--   end
function im.BeginTooltip()
    if not im.IsItemHovered() then return false end
    -- open a tiny borderless popup near the mouse
    local opts = {
        x          = S.mx + 14,
        y          = S.my + 18,
        w          = 200,
        h          = 20,   -- will grow with content
        noTitleBar = true,
        noResize   = true,
        noMove     = true,
        noScrollbar= true,
        noBg       = false,
        noClose    = true,
        noMinimize = true,
        noTaskbar  = true,
        isPopup    = true,
    }
    S._pendingPopup = "##tooltip_popup"
    return im.Begin("##tooltip_popup", opts)
end

function im.EndTooltip()
    im.End()
end
local SAVE_FILE = "imlove_layout.lua"

local function _serialize(tbl, indent)
    indent = indent or 0
    local pad = string.rep("  ", indent)
    local lines = {"{"}
    for k,v in pairs(tbl) do
        local key = type(k)=="number" and "["..k.."]" or '["'..tostring(k)..'"]'
        local val
        local tv = type(v)
        if     tv=="number"  then val=tostring(v)
        elseif tv=="boolean" then val=tostring(v)
        elseif tv=="string"  then val=string.format("%q",v)
        elseif tv=="table"   then val=_serialize(v, indent+1)
        end
        if val then table.insert(lines, pad.."  "..key.." = "..val..",") end
    end
    table.insert(lines, pad.."}"); return table.concat(lines,"\n")
end

-- Save window positions/sizes/scroll/state to love save directory.
function im.SaveLayout(filename)
    filename = filename or SAVE_FILE
    local data = {}
    for id,w in pairs(S.windows) do
        data[id] = {
            x=math.floor(w.x), y=math.floor(w.y),
            w=math.floor(w.w), h=math.floor(w.h),
            scrollY=math.floor(w.scrollY or 0),
            closed=w.closed or false,
            minimized=w.minimized or false,
            dockedTo=w.dockedTo or nil,
        }
    end
    local ok,err = love.filesystem.write(filename, "return ".._serialize(data))
    if not ok then print("[imlove] SaveLayout failed: "..tostring(err)) end
    return ok
end

-- Load saved layout and apply to existing windows.
-- Windows not yet created will receive their saved state when Begin() is called.
function im.LoadLayout(filename)
    filename = filename or SAVE_FILE
    if not love.filesystem.getInfo(filename) then return false end
    local chunk,err = love.filesystem.load(filename)
    if not chunk then print("[imlove] LoadLayout error: "..tostring(err)); return false end
    local ok,data = pcall(chunk)
    if not ok or type(data)~="table" then print("[imlove] LoadLayout bad data"); return false end
    for id,saved in pairs(data) do
        local w = S.windows[id]
        if w then
            w.x=saved.x or w.x; w.y=saved.y or w.y
            w.w=saved.w or w.w; w.h=saved.h or w.h
            w.scrollY=saved.scrollY or 0
            w.closed=saved.closed or false
            w.minimized=saved.minimized or false
            if saved.dockedTo then
                w.dockedTo = saved.dockedTo
                -- rebuild _dockedChildren on parent
                local pid = saved.dockedTo.id
                if pid ~= "screen" and S.windows[pid] then
                    local p = S.windows[pid]
                    p._dockedChildren = p._dockedChildren or {}
                    local found = false
                    for _,cid in ipairs(p._dockedChildren) do if cid==id then found=true end end
                    if not found then table.insert(p._dockedChildren, id) end
                end
            end
        else
            S._savedLayout = S._savedLayout or {}
            S._savedLayout[id] = saved
        end
    end
    return true
end

-- ═══════════════════════════════════════════════════════════════════
--  TASKBAR
-- ═══════════════════════════════════════════════════════════════════
-- Call once per frame inside BeginFrame/EndFrame, outside any Begin/End.
-- options (all optional):
--   pos      = "bottom"|"top"   override style.taskbarPos
--   filter   = function(w) return bool  — return false to hide a window
--   showAll  = bool  — include popups (default false)
--
-- Behaviour:
--   • Click open window    → minimize it
--   • Click minimized      → restore and bring to front
--   • Click closed window  → re-open and bring to front
--   • Focused window button is highlighted

S._taskbar = {
    -- tracks button hover ids for this frame
    hovered = nil,
}

function im.Taskbar(options)
    options = options or {}
    local st   = im.style
    local font = im._font()
    local sw   = lg.getWidth()
    local sh   = lg.getHeight()
    local th   = font:getHeight()
    local tbH  = st.taskbarH
    local pos  = options.pos or st.taskbarPos or "bottom"
    local tbY  = (pos == "top") and 0 or (sh - tbH)

    -- collect windows to show (skip popups and noTaskbar windows)
    local entries = {}
    for _, wid in ipairs(S.windowOrder) do
        local w = S.windows[wid]
        if not w then goto tb_next end
        if w.options and w.options.isPopup  then goto tb_next end
        if w.options and w.options.noTaskbar then goto tb_next end
        if options.filter and not options.filter(w) then goto tb_next end
        table.insert(entries, w)
        ::tb_next::
    end

    -- compute button widths — shrink evenly if too many
    local padX   = st.taskbarPadX
    local btnMax = st.taskbarBtnW
    local btnMin = st.taskbarBtnMinW
    local gap    = 4
    local totalAvail = sw - gap * 2
    local n      = #entries
    local btnW   = n > 0
        and math.max(btnMin, math.min(btnMax, (totalAvail - gap * (n - 1)) / n))
        or btnMax

    -- hit-test taskbar bar itself for input capture
    local mx, my = S.mx, S.my
    local inBar  = im._pointInRect(mx, my, 0, tbY, sw, tbH)
    if inBar then
        -- consume mouse owner so windows below don't react
        S.mouseOwnerWindow = nil
    end

    -- store for _renderAll
    S._taskbar.entries = entries
    S._taskbar.btnW    = btnW
    S._taskbar.gap     = gap
    S._taskbar.tbY     = tbY
    S._taskbar.tbH     = tbH
    S._taskbar.hovered = nil

    -- process clicks
    local topWid = S.windowOrder[#S.windowOrder]
    for i, w in ipairs(entries) do
        local bx = gap + (i - 1) * (btnW + gap)
        local by = tbY + math.floor((tbH - (th + 6)) * 0.5)
        local bh = th + 6

        local hover = im._pointInRect(mx, my, bx, by, btnW, bh)
        if hover then S._taskbar.hovered = w.id end

        if hover and S.mousePressed[1] then
            if w.closed then
                -- re-open
                w.closed    = false
                w.minimized = false
                -- bring to front
                for j, wid in ipairs(S.windowOrder) do
                    if wid == w.id then table.remove(S.windowOrder, j); break end
                end
                table.insert(S.windowOrder, w.id)
            elseif w.minimized then
                -- restore
                w.minimized = false
                for j, wid in ipairs(S.windowOrder) do
                    if wid == w.id then table.remove(S.windowOrder, j); break end
                end
                table.insert(S.windowOrder, w.id)
            elseif w.id == topWid then
                -- already focused — minimize
                w.minimized = true
            else
                -- bring to front
                for j, wid in ipairs(S.windowOrder) do
                    if wid == w.id then table.remove(S.windowOrder, j); break end
                end
                table.insert(S.windowOrder, w.id)
            end
        end
    end
end
-- snap candidate structure:
--   { x, y, edge, targetId }
--   edge = "left"|"right"|"top"|"bottom"  (which edge of W snaps)
--   targetId = window id string OR "screen"

-- Undock a window from whatever it's docked to.
function im._undock(w)
    if not w.dockedTo then return end
    local tgt = S.windows[w.dockedTo.id]
    if tgt and tgt._dockedChildren then
        for i, cid in ipairs(tgt._dockedChildren) do
            if cid == w.id then
                table.remove(tgt._dockedChildren, i); break
            end
        end
    end
    w.dockedTo = nil
end

-- Move all children docked to this window by the same delta.
function im._moveDockChildren(parentId)
    local parent = S.windows[parentId]
    if not parent or not parent._dockedChildren then return end
    for _, cid in ipairs(parent._dockedChildren) do
        local child = S.windows[cid]
        if child and child.dockedTo and child.dockedTo.id == parentId then
            im._reposDockedChild(child, parent, true)
        end
    end
end

-- Recompute a docked child's position from its parent's current position.
-- cascade=true only when called during an active drag to propagate chains.
function im._reposDockedChild(child, parent, cascade)
    local d = child.dockedTo
    if     d.edge == "right"  then
        child.x = parent.x - child.w
        child.y = parent.y
        child.h = parent.h          -- stay same height
    elseif d.edge == "left"   then
        child.x = parent.x + parent.w
        child.y = parent.y
        child.h = parent.h          -- stay same height
    elseif d.edge == "bottom" then
        child.x = parent.x
        child.y = parent.y - child.h
        child.w = parent.w          -- stay same width
    elseif d.edge == "top"    then
        child.x = parent.x
        child.y = parent.y + parent.h
        child.w = parent.w          -- stay same width
    end
    if cascade then im._moveDockChildren(child.id) end
end

-- Find the best snap candidate for window w while dragging.
-- Returns a snap table or nil.
function im._findSnap(w)
    local st   = im.style
    local D    = st.snapDist
    local sw   = lg.getWidth()
    local sh   = lg.getHeight()
    local best = nil
    local bestDist = D + 1

    local function trySnap(nx, ny, edge, targetId, dist)
        if dist < bestDist then
            bestDist = dist
            best = {x=nx, y=ny, edge=edge, targetId=targetId}
        end
    end

    -- ── screen edges ─────────────────────────────────────────────
    -- left screen edge: w.x snaps to 0
    trySnap(0, w.y, "left", "screen", math.abs(w.x))
    -- right screen edge: w.x+w.w snaps to sw
    trySnap(sw - w.w, w.y, "right", "screen", math.abs(w.x + w.w - sw))
    -- top screen edge: w.y snaps to 0
    trySnap(w.x, 0, "top", "screen", math.abs(w.y))
    -- bottom screen edge: w.y+w.h snaps to sh
    trySnap(w.x, sh - w.h, "bottom", "screen", math.abs(w.y + w.h - sh))

    -- ── other dockable windows ────────────────────────────────────
    for _, oid in ipairs(S.windowOrder) do
        local o = S.windows[oid]
        if not o or o.closed or o.minimized then goto next_win end
        if o.id == w.id then goto next_win end
        if not (o.options and o.options.dockable) then goto next_win end

        -- w's right edge → o's left edge
        trySnap(o.x - w.w, w.y, "right", oid,
            math.abs((w.x + w.w) - o.x) + math.abs(w.y - o.y) * 0.1)
        -- w's left edge → o's right edge
        trySnap(o.x + o.w, w.y, "left", oid,
            math.abs(w.x - (o.x + o.w)) + math.abs(w.y - o.y) * 0.1)
        -- w's bottom edge → o's top edge
        trySnap(w.x, o.y - w.h, "bottom", oid,
            math.abs((w.y + w.h) - o.y) + math.abs(w.x - o.x) * 0.1)
        -- w's top edge → o's bottom edge
        trySnap(w.x, o.y + o.h, "top", oid,
            math.abs(w.y - (o.y + o.h)) + math.abs(w.x - o.x) * 0.1)

        ::next_win::
    end

    return best
end

-- Apply a snap: move w to snap position and record dockedTo.
function im._applySnap(w, snap)
    w.x = snap.x
    w.y = snap.y

    if snap.targetId == "screen" then
        w.dockedTo = {id="screen", edge=snap.edge, offsetX=w.x, offsetY=w.y}
        return
    end

    local parent = S.windows[snap.targetId]
    if not parent then return end

    -- match perpendicular dimension
    if snap.edge == "left" or snap.edge == "right" then
        -- side-by-side: match heights, align tops
        w.h    = parent.h
        w.y    = parent.y
    elseif snap.edge == "top" or snap.edge == "bottom" then
        -- stacked: match widths, align lefts
        w.w    = parent.w
        w.x    = parent.x
    end

    w.dockedTo = {
        id      = snap.targetId,
        edge    = snap.edge,
        offsetX = w.x - parent.x,
        offsetY = w.y - parent.y,
    }
    parent._dockedChildren = parent._dockedChildren or {}
    for _, cid in ipairs(parent._dockedChildren) do
        if cid == w.id then return end
    end
    table.insert(parent._dockedChildren, w.id)
end

-- Called each frame for docked windows to keep position in sync
-- when the parent moves without being dragged (e.g. programmatic move).
function im._updateDockedPosition(w)
    if not w.dockedTo then return end
    local d = w.dockedTo
    if d.id == "screen" then
        local sw, sh = lg.getWidth(), lg.getHeight()
        -- edge = which edge of W is pinned to the screen boundary
        if     d.edge == "left"   then w.x = 0
        elseif d.edge == "right"  then w.x = sw - w.w
        elseif d.edge == "top"    then w.y = 0
        elseif d.edge == "bottom" then w.y = sh - w.h
        end
        return
    end
    local parent = S.windows[d.id]
    if not parent or parent.closed then
        -- parent gone — undock silently
        w.dockedTo = nil; return
    end
    im._reposDockedChild(w, parent, false)
end
function im.PushID(id) table.insert(S.idStack, tostring(id)) end
function im.PopID()    table.remove(S.idStack, #S.idStack)    end

function im.GetID(str)
    local seed = table.concat(S.idStack, "/").."/"..str
    local h    = 0x725C9DC5
    for i = 1, #seed do
        h = bit.bxor(h, seed:byte(i))
        h = (h * 0x1000193) % 0x100000000
    end
    return h
end

-- ═══════════════════════════════════════════════════════════════════
--  UTILITY
-- ═══════════════════════════════════════════════════════════════════
function im.Clamp(v,lo,hi) return math.max(lo, math.min(hi,v)) end

function im.IsMouseHoveringRect(x,y,w,h) return im._pointInRect(S.mx,S.my,x,y,w,h) end

function im.IsWindowOpen(id)
    local w = S.windows[id]; return w ~= nil and not w.closed
end
function im.SetWindowOpen(id, open)
    local w = S.windows[id]; if w then w.closed = not open end
end
function im.SetWindowMinimized(id, min)
    local w = S.windows[id]; if w then w.minimized = min end
end
function im.ClearWindows()
    S.windows={}; S.windowOrder={}; S.openMenuId=nil; S.activeInputId=nil; S.active=nil; S.hot=nil
end

-- ═══════════════════════════════════════════════════════════════════
--  INTERNAL HELPERS
-- ═══════════════════════════════════════════════════════════════════
function im._pointInRect(px,py,rx,ry,rw,rh)
    return px>=rx and px<=rx+rw and py>=ry and py<=ry+rh
end

function im._mouseOwnedBy(w)
    -- owner window, OR the widget already has S.active (drag continues across window edges)
    return S.mouseOwnerWindow == w.id
        or (S.active ~= nil and S.active == "##drag_"..w.id)
        or (S.active ~= nil and S.active == "##resize_"..w.id)
end

function im._winBtnGeom(w, titleH)
    local bsz=titleH-8; local by=w.y+math.floor((titleH-bsz)*0.5)
    local m=5; local g=3
    local closeX = (not(w.options and w.options.noClose))    and (w.x+w.w-m-bsz)           or nil
    local minX   = (not(w.options and w.options.noMinimize)) and (w.x+w.w-m-bsz-((closeX and bsz+g) or 0)) or nil
    return bsz, by, closeX, minX
end

function im._dist(ax,ay,bx,by,r) local dx,dy=ax-bx,ay-by; return dx*dx+dy*dy<=r*r end

function im._cmd(w, kind, data)
    if w and w.drawCmds then table.insert(w.drawCmds, {kind=kind, data=data}) end
end

function im._allocWidget(w, ww, wh)
    local st = im.style
    if not w.sameLine then im._newLine(w) end
    local x, y
    if w.sameLine then
        x=w.cursorX+w.sameLineSpacing; y=w.cursorY; w.cursorX=x+ww
        w._pendingLineH=math.max(w._pendingLineH or 0, wh); w.lineH=w._pendingLineH
    else
        x=w.lineStartX; y=w.cursorY; w.cursorX=x+ww; w.lineH=wh; w._pendingLineH=wh
    end
    local absY=y+wh-(w.inner.y-w.scrollY); if absY>w.widgetY then w.widgetY=absY end
    w.sameLine=false; w.sameLineSpacing=st.itemSpacingX
    -- record for IsItemHovered / SetTooltip
    S._lastItemRect = {x=x, y=y, w=ww, h=wh, winId=w.id}
    return x, y
end

function im._newLine(w)
    if w._pendingLineH and w._pendingLineH>0 then
        w.cursorY=w.cursorY+w._pendingLineH+im.style.itemSpacingY
        w.cursorX=w.lineStartX; w.lineH=0; w._pendingLineH=0
    end
end

function im._advanceCursor(w,dw,dh)
    w.cursorY=w.cursorY+dh; w.cursorX=w.lineStartX; w.lineH=0; w._pendingLineH=0
    local absY=w.cursorY-(w.inner.y-w.scrollY); if absY>w.widgetY then w.widgetY=absY end
end

function im._visibleInWindow(w, wy, wh)
    local st     = im.style
    local titleH = (w.options and w.options.noTitleBar) and 0 or st.titleBarH
    return wy+wh > w.y+titleH and wy < w.y+w.h
end

function im._wrapText(font, text, maxW)
    local lines, line = {}, ""
    for word in text:gmatch("%S+") do
        local test = line=="" and word or line.." "..word
        if font:getWidth(test)<=maxW then line=test
        else if line~="" then table.insert(lines,line) end; line=word end
    end
    if line~="" then table.insert(lines,line) end
    if #lines==0 then lines[1]="" end
    return lines
end

-- ═══════════════════════════════════════════════════════════════════
--  RENDERING
-- ═══════════════════════════════════════════════════════════════════
local function setColor(c)
    if c then lg.setColor(c[1],c[2],c[3],c[4] or 1) else lg.setColor(1,1,1,1) end
end

local function execCmd(cmd)
    local d = cmd.data
    if cmd.kind=="rect" then
        setColor(d.color)
        if d.rx and d.rx>0 then lg.rectangle("fill",d.x,d.y,d.w,d.h,d.rx,d.rx)
        else lg.rectangle("fill",d.x,d.y,d.w,d.h) end

    elseif cmd.kind=="rectBorder" then
        setColor(d.color); lg.setLineWidth(1)
        if d.rx and d.rx>0 then lg.rectangle("line",d.x,d.y,d.w,d.h,d.rx,d.rx)
        else lg.rectangle("line",d.x,d.y,d.w,d.h) end

    elseif cmd.kind=="text" then
        setColor(d.color); lg.print(d.text, math.floor(d.x), math.floor(d.y))

    elseif cmd.kind=="textClip" then
        local px,py,pw,ph = lg.getScissor()
        lg.setScissor(d.clipX,d.clipY,d.clipW,d.clipH)
        setColor(d.color); lg.print(d.text, math.floor(d.x), math.floor(d.y))
        if px then lg.setScissor(px,py,pw,ph) else lg.setScissor() end

    elseif cmd.kind=="line" then
        setColor(d.color); lg.setLineWidth(d.lw or 1)
        lg.line(d.x1,d.y1,d.x2,d.y2); lg.setLineWidth(1)

    elseif cmd.kind=="circle" then
        setColor(d.color); lg.circle(d.fill and "fill" or "line", d.x,d.y,d.r)

    elseif cmd.kind=="rectClip" then
        local px,py,pw,ph = lg.getScissor()
        lg.setScissor(d.clipX,d.clipY,d.clipW,d.clipH)
        setColor(d.color); lg.rectangle("fill",d.x,d.y,d.w,d.h)
        if px then lg.setScissor(px,py,pw,ph) else lg.setScissor() end

    elseif cmd.kind=="imageClip" then
        -- window scissor is already set by _renderAll — just draw
        lg.setColor(1,1,1,1)
        if d.quad then lg.draw(d.image,d.quad,math.floor(d.x),math.floor(d.y),0,d.sx or 1,d.sy or 1)
        else            lg.draw(d.image,      math.floor(d.x),math.floor(d.y),0,d.sx or 1,d.sy or 1) end

    elseif cmd.kind=="mesh" then
        lg.setColor(1,1,1,1)
        lg.draw(d.mesh)

    elseif cmd.kind=="meshClip" then
        -- window scissor already set — just draw
        lg.setColor(1,1,1,1)
        lg.draw(d.mesh)
    end
end

function im._renderAll()
    lg.setLineStyle("smooth")
    local st = im.style

    for _, wid in ipairs(S.windowOrder) do
        local w = S.windows[wid]
        if not w or w.closed then goto continue end

        -- dim overlay for popups (drawn just before the popup itself)
        if w.options and w.options.isPopup then
            setColor({0,0,0,0.35})
            lg.rectangle("fill",0,0,lg.getWidth(),lg.getHeight())
        end

        local titleH = (w.options and w.options.noTitleBar) and 0 or st.titleBarH
        local effH   = w.minimized and titleH or w.h
        local isTop  = (S.windowOrder[#S.windowOrder] == wid)

        -- background + border
        if not (w.options and w.options.noBg) then
            setColor(st.col.windowBg)
            lg.rectangle("fill", w.x,w.y,w.w,effH, st.windowRound,st.windowRound)
            setColor(st.col.border); lg.setLineWidth(1)
            lg.rectangle("line", w.x,w.y,w.w,effH, st.windowRound,st.windowRound)
        end

        -- title bar
        if titleH > 0 then
            setColor(isTop and st.col.titleBarActive or st.col.titleBar)
            lg.rectangle("fill", w.x,w.y,w.w,titleH, st.windowRound,st.windowRound)
            if not w.minimized then
                lg.rectangle("fill", w.x, w.y+titleH*0.5, w.w, titleH*0.5)
            end
            -- buttons
            local bsz,by,closeX,minX = im._winBtnGeom(w, titleH)
            local owned = (S.mouseOwnerWindow == wid)
            if closeX then
                local hov = owned and im._pointInRect(S.mx,S.my,closeX,by,bsz,bsz)
                setColor(hov and st.col.closeBtnHover or st.col.closeBtn)
                lg.rectangle("fill",closeX,by,bsz,bsz,2,2)
                setColor(st.col.titleText); lg.setLineWidth(1.5)
                local p=3
                lg.line(closeX+p,by+p, closeX+bsz-p,by+bsz-p)
                lg.line(closeX+bsz-p,by+p, closeX+p,by+bsz-p)
                lg.setLineWidth(1)
            end
            if minX then
                local hov = owned and im._pointInRect(S.mx,S.my,minX,by,bsz,bsz)
                setColor(hov and st.col.minimizeBtnHover or st.col.minimizeBtn)
                lg.rectangle("fill",minX,by,bsz,bsz,2,2)
                setColor(st.col.titleText); lg.setLineWidth(1.5)
                if w.minimized then
                    local cx=minX+math.floor(bsz*0.5); local p=3
                    lg.line(minX+p,by+bsz-p, cx,by+p, minX+bsz-p,by+bsz-p)
                else
                    local my=by+math.floor(bsz*0.5); lg.line(minX+3,my,minX+bsz-3,my)
                end
                lg.setLineWidth(1)
            end
            -- title text
            setColor(st.col.titleText)
            local font = im._font()
            local tw   = font:getWidth(w.title)
            lg.print(w.title, math.floor(w.x+(w.w-tw)*0.5), math.floor(w.y+(titleH-font:getHeight())*0.5))
        end

        if w.minimized then goto continue end

        -- menu bar (outside scissor — never scrolls)
        local mbH = 0
        if w._menuBar then
            local mb   = w._menuBar; mbH = mb.h
            local font = im._font(); local padX = st.menuItemPadX
            setColor(st.col.menuBarBg); lg.rectangle("fill",w.x,mb.y,w.w,mb.h)
            setColor(st.col.separator); lg.setLineWidth(1); lg.line(w.x,mb.y+mb.h,w.x+w.w,mb.y+mb.h)
            for _,item in ipairs(mb.items) do
                if item.hover or item.isOpen then setColor(st.col.menuHover); lg.rectangle("fill",item.x,mb.y,item.w,mb.h) end
                setColor(st.col.menuText)
                lg.print(item.label, math.floor(item.x+padX), math.floor(mb.y+(mb.h-font:getHeight())*0.5))
            end
        end

        -- scrollbar
        if not (w.options and w.options.noScrollbar) then
            local visH = w.h-titleH-mbH-st.windowPadding*2
            local totH = math.max(visH, w.contentH)
            if totH > visH then
                local sbX=w.x+w.w-st.scrollbarW-2; local sbY=w.y+titleH+mbH+2; local sbH=w.h-titleH-mbH-4
                setColor(st.col.scrollbarBg); lg.rectangle("fill",sbX,sbY,st.scrollbarW,sbH,st.scrollbarW*0.5)
                local grabH = math.max(16, sbH*(visH/totH))
                local grabY = sbY + (w.scrollY/(totH-visH))*(sbH-grabH)
                local sbId  = "##scrollbar_"..wid
                local owned = (S.mouseOwnerWindow==wid)
                local grabHov = owned and im._pointInRect(S.mx,S.my,sbX,grabY,st.scrollbarW,grabH)
                if owned and im._pointInRect(S.mx,S.my,sbX,sbY,st.scrollbarW,sbH) and S.mousePressed[1] and S.active==nil then
                    S.active=sbId; w._sbGrabOff=S.my-grabY
                end
                if S.active==sbId then
                    local t=(S.my-(w._sbGrabOff or 0)-sbY)/(sbH-grabH)
                    w.scrollY=im.Clamp(t*(totH-visH),0,totH-visH)
                    if not S.mouseDown[1] then S.active=nil end
                end
                setColor((S.active==sbId or grabHov) and st.col.scrollbarHover or st.col.scrollbarGrab)
                lg.rectangle("fill",sbX,grabY,st.scrollbarW,grabH,st.scrollbarW*0.5)
            end
        end

        -- resize grip
        if not (w.options and w.options.noResize) then
            local rg=st.resizeGripSize
            local inG=im._pointInRect(S.mx,S.my,w.x+w.w-rg,w.y+w.h-rg,rg,rg)
            setColor((inG or S.active=="##resize_"..wid) and st.col.resizeGripHover or st.col.resizeGrip)
            lg.polygon("fill", w.x+w.w,w.y+w.h, w.x+w.w-rg,w.y+w.h, w.x+w.w,w.y+w.h-rg)
        end

        -- clip + draw widget commands
        lg.setScissor(w.x+1, w.y+titleH+mbH,
            w.w-2-(w.options and w.options.noScrollbar and 0 or st.scrollbarW),
            w.h-titleH-mbH-1)
        if w.drawCmds then for _,cmd in ipairs(w.drawCmds) do execCmd(cmd) end end
        lg.setScissor()

        ::continue::
    end

    -- dropdown overlay
    if S.menuDrop and S.openMenuId then
        local drop = S.menuDrop
        local font = im._font(); local padX=st.menuItemPadX; local th=font:getHeight()
        if S.mousePressed[1] and not S._menuInAny then S.openMenuId=nil end
        if S.openMenuId then
            setColor({0,0,0,0.25}); lg.rectangle("fill",drop.x+3,drop.y+3,drop.w,drop.h,3,3)
            setColor(st.col.menuBg);  lg.rectangle("fill",drop.x,drop.y,drop.w,drop.h,3,3)
            setColor(st.col.border);  lg.setLineWidth(1); lg.rectangle("line",drop.x,drop.y,drop.w,drop.h,3,3)
            for _,item in ipairs(drop.items) do
                if item.kind=="sep" then
                    setColor(st.col.menuSep)
                    lg.line(drop.x+6, item.iy+math.floor(item.sepH*0.5), drop.x+drop.w-6, item.iy+math.floor(item.sepH*0.5))
                elseif item.kind=="item" then
                    if item.hover and item.enabled then
                        setColor(st.col.menuHover); lg.rectangle("fill",drop.x+1,item.iy,drop.w-2,item.itemH,2,2)
                    end
                    setColor(item.enabled and st.col.menuText or st.col.textDisabled)
                    lg.print(item.label, drop.x+padX, item.iy+math.floor((item.itemH-th)*0.5))
                    if item.shortcut then
                        local sw=font:getWidth(item.shortcut)
                        setColor(st.col.menuShortcut)
                        lg.print(item.shortcut, drop.x+drop.w-sw-padX, item.iy+math.floor((item.itemH-th)*0.5))
                    end
                end
            end
        end
    end

    -- snap preview ghost rect (shown while dragging a dockable window)
    if S.snapPreview then
        local sp = S.snapPreview
        -- find the dragging window's size
        local dragW, dragH = 100, 100
        for _, wid in ipairs(S.windowOrder) do
            if S.active == "##drag_"..wid then
                local dw = S.windows[wid]
                if dw then dragW, dragH = dw.w, dw.h end
                break
            end
        end
        setColor(st.col.snapPreview)
        lg.rectangle("fill", sp.x, sp.y, dragW, dragH, st.windowRound, st.windowRound)
        setColor(st.col.snapBorder)
        lg.setLineWidth(2)
        lg.rectangle("line", sp.x, sp.y, dragW, dragH, st.windowRound, st.windowRound)
        lg.setLineWidth(1)
    end

    -- tooltip
    if S.tooltipText then
        local font = im._font()
        local pad  = 6
        local th   = font:getHeight()
        local lsp  = 2
        -- split on \n
        local lines = {}
        for line in (S.tooltipText.."\n"):gmatch("([^\n]*)\n") do
            table.insert(lines, line)
        end
        local maxW = 0
        for _, line in ipairs(lines) do
            local lw = font:getWidth(line)
            if lw > maxW then maxW = lw end
        end
        local totalH = #lines * th + (#lines-1) * lsp
        local bw = maxW + pad * 2
        local bh = totalH + pad * 2
        local tx = math.min(S.tooltipX, lg.getWidth()  - bw - 2)
        local ty = math.min(S.tooltipY, lg.getHeight() - bh - 2)
        setColor(st.col.tooltip)
        lg.rectangle("fill", tx, ty, bw, bh, 4, 4)
        setColor(st.col.tooltipBorder)
        lg.setLineWidth(1)
        lg.rectangle("line", tx, ty, bw, bh, 4, 4)
        setColor(st.col.tooltipText)
        for i, line in ipairs(lines) do
            lg.print(line, tx + pad, ty + pad + (i-1) * (th + lsp))
        end
    end

    -- taskbar (always on top of everything)
    if S._taskbar and S._taskbar.entries and #S._taskbar.entries > 0 then
        local tb    = S._taskbar
        local font  = im._font()
        local th    = font:getHeight()
        local sw    = lg.getWidth()
        local btnW  = tb.btnW
        local gap   = tb.gap
        local tbY   = tb.tbY
        local tbH   = tb.tbH
        local topWid = S.windowOrder[#S.windowOrder]

        -- bar background
        setColor(st.col.taskbarBg)
        lg.rectangle("fill", 0, tbY, sw, tbH)
        -- top/bottom border line
        setColor(st.col.taskbarBorder)
        lg.setLineWidth(1)
        local lineY = (st.taskbarPos == "top") and (tbY + tbH) or tbY
        lg.line(0, lineY, sw, lineY)

        for i, w in ipairs(tb.entries) do
            local bx  = gap + (i - 1) * (btnW + gap)
            local bh  = th + 6
            local by  = tbY + math.floor((tbH - bh) * 0.5)
            local isFocused = (w.id == topWid) and not w.closed and not w.minimized
            local isHovered = (tb.hovered == w.id)
            local isClosed  = w.closed
            local isMin     = w.minimized

            -- button background
            local bgCol
            if isFocused      then bgCol = st.col.taskbarBtnFocus
            elseif isHovered  then bgCol = st.col.taskbarBtnHover
            elseif isClosed   then bgCol = st.col.taskbarBtnClosed
            else                   bgCol = st.col.taskbarBtn end

            setColor(bgCol)
            lg.rectangle("fill", bx, by, btnW, bh, 3, 3)

            -- open indicator dot (bottom centre of button)
            if not isClosed then
                setColor(isMin and st.col.taskbarTextDim or st.col.taskbarDot)
                local dotR = 2.5
                lg.circle("fill", bx + btnW * 0.5, by + bh - dotR - 1, dotR)
            end

            -- title text — clipped to button width
            local label = w.title ~= "" and w.title or w.id
            local textCol = (isClosed or isMin) and st.col.taskbarTextDim or st.col.taskbarText
            local maxTW   = btnW - st.taskbarPadX * 2
            -- truncate with ellipsis if too wide
            local dispLabel = label
            while font:getWidth(dispLabel) > maxTW and #dispLabel > 1 do
                dispLabel = dispLabel:sub(1, -2)
            end
            if dispLabel ~= label then dispLabel = dispLabel:sub(1,-2) .. "..." end
            local tw = font:getWidth(dispLabel)
            local tx = bx + math.floor((btnW - tw) * 0.5)
            local ty = by + math.floor((bh - th) * 0.5)

            lg.setScissor(bx, by, btnW, bh)
            setColor(textCol)
            lg.print(dispLabel, math.floor(tx), math.floor(ty))
            lg.setScissor()
        end
    end

    lg.setColor(1,1,1,1); lg.setLineWidth(1)
end

return im
