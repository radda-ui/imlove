# imlove

A pure Lua 5.1 immediate mode GUI library for [LÖVE 2D](https://love2d.org/), inspired by [Dear ImGui](https://github.com/ocornut/imgui). Single file, no external dependencies beyond the built-in `bit` library.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/radda-ui/imlove?style=social)](https://github.com/radda-ui/imlove)

---

## Features

- **Single file** — drop `imlove.lua` into your project and require it
- **Immediate mode** — no retained widget state, your app owns all data
- **Solid IO** — pending/promote/clear input pipeline, no input bleeding between windows
- **Z-order** — windows stack correctly, topmost window captures all input
- **Widgets** — Button, Label, Checkbox, RadioButton, Slider, SliderInt, InputText, ProgressBar, Selectable, SelectableImage, Image, CollapsingHeader, ColorPicker
- **Layout** — SameLine, Separator, Spacing, Indent, Unindent, TextWrapped
- **Windows** — draggable, resizable, minimizable, closeable, scrollable
- **Menu bar** — BeginMenuBar / BeginMenu / MenuItem / MenuSeparator
- **Popups** — modal-style windows, auto-close on outside click
- **Tooltips** — IsItemHovered / SetTooltip / BeginTooltip
- **Style system** — PushStyleColor / PopStyleColor, PushStyleVar / PopStyleVar, PushFont / PopFont
- **Pseudo docking** — opt-in snap-to-edges and snap-to-windows with visual preview
- **Taskbar** — built-in window manager bar, no external state needed
- **Save / Load layout** — persists window positions, sizes and state to the LÖVE save directory

---

## Example Screenshot
![imlove Example](https://raw.githubusercontent.com/radda-ui/imlove/master/image.png)
## Quick Start

```lua
local im = require "imlove"

local checked  = false
local sliderV  = 0.5
local inputStr = "hello"

function love.load()
    love.window.setMode(800, 600)
    im.Init()
end

function love.update(dt)
    im.Update(dt)
end

function love.draw()
    love.graphics.clear(0.12, 0.12, 0.15)
    im.BeginFrame()

    if im.Begin("My Window") then
        im.Label("Hello from imlove!")
        if im.Button("Click me") then print("clicked") end
        checked  = im.Checkbox("Enable", checked)
        sliderV  = im.Slider("Speed", sliderV, 0, 1)
        inputStr = im.InputText("Name", inputStr)
    end
    im.End()

    im.EndFrame()
end

function love.mousepressed(x,y,b)  im.MousePressed(x,y,b)  end
function love.mousereleased(x,y,b) im.MouseReleased(x,y,b) end
function love.wheelmoved(x,y)      im.WheelMoved(x,y)       end
function love.keypressed(k,s)      im.KeyPressed(k,s)        end
function love.textinput(t)         im.TextInput(t)           end
```

---

## Installation

Download `imlove.lua` and place it in your project directory. That is all.

```lua
local im = require "imlove"
```

---

## API Reference

### Initialization

```lua
im.Init()          -- call once in love.load()
im.Update(dt)      -- call in love.update(dt)
```

### Frame

```lua
im.BeginFrame()    -- call at the start of love.draw()
im.EndFrame()      -- call at the end of love.draw() — also triggers rendering
```

### Windows

```lua
-- name supports "Title##id" syntax to separate display title from stable id
-- options table (all optional):
--   x, y, w, h        initial position and size
--   open               bool — false hides the window
--   noTitleBar         bool
--   noResize           bool
--   noMove             bool
--   noScrollbar        bool
--   noClose            bool
--   noMinimize         bool
--   noTaskbar          bool — exclude from taskbar
--   dockable           bool — enable pseudo docking
--
-- Returns visible (bool), open (bool)
local visible, open = im.Begin("My Window", options)
if visible then
    -- widgets here
end
im.End()
```

**Tracking close button:**
```lua
local visible, open = im.Begin("Settings##s", {open = showSettings})
showSettings = open   -- picks up X button clicks automatically
if visible then ... end
im.End()
```

### Widgets

```lua
-- Label
im.Label("Some text")
im.LabelColored("Red text", 1, 0, 0)
im.TextWrapped("Long text that wraps automatically.")

-- Button  (btnW, btnH are optional)
if im.Button("Click", btnW, btnH) then ... end

-- Checkbox  — returns value, changed
checked = im.Checkbox("Enable", checked)

-- RadioButton  — returns current, changed
radio = im.RadioButton("Option A", radio, 1)
radio = im.RadioButton("Option B", radio, 2)

-- Sliders  — returns new value
slFloat = im.Slider("Float", slFloat, 0, 1)
slFloat = im.Slider("Float", slFloat, 0, 1, "%.3f")  -- custom format
slInt   = im.SliderInt("Int", slInt, 0, 100)

-- InputText  — returns new string
text = im.InputText("Name", text)
text = im.InputText("Name", text, maxLen)
-- Supports: typing, backspace, delete, left/right/home/end,
--           shift+arrows for selection, Ctrl+A/C/X/V, cursor blink

-- ProgressBar
im.ProgressBar(fraction)                          -- 0.0 to 1.0
im.ProgressBar(fraction, barW, barH, "overlay")   -- all optional

-- Selectable  — returns selected, clicked
selected = im.Selectable("Item", selected)
selected = im.Selectable("Item", selected, rowW, rowH)

-- CollapsingHeader  — returns open
open = im.CollapsingHeader("Section", open)

-- Image
im.Image(image)
im.Image(image, quad)           -- quad is optional
im.Image(image, quad, w, h)     -- dispW, dispH override size

-- SelectableImage  — returns selected, clicked
selected = im.SelectableImage("label", image, quad, selected)
selected = im.SelectableImage("label", image, quad, selected, dispW, dispH)

-- ColorPicker  — returns updated color table
-- pass {r,g,b} for RGB or {r,g,b,a} for RGBA — alpha bar appears automatically
color = im.ColorPicker("Tint", color)
```

### Layout

```lua
im.SameLine()           -- next widget on same line
im.SameLine(spacing)    -- custom gap in pixels
im.Separator()          -- horizontal divider line
im.Spacing()            -- extra vertical space
im.Spacing(20)          -- custom pixels
im.Indent()             -- indent by style.IndentSpacing
im.Indent(amount)       -- custom pixels
im.Unindent()
im.Unindent(amount)
```

### Menu Bar

```lua
if im.Begin("Window") then
    if im.BeginMenuBar() then
        if im.BeginMenu("File") then
            if im.MenuItem("Save", "Ctrl+S") then ... end
            if im.MenuItem("Quit", nil, enabled) then ... end
            im.MenuSeparator()
            im.EndMenu()
        end
        im.EndMenuBar()
    end
    -- widgets
end
im.End()
```

### Popups

```lua
-- trigger
if im.Button("Open") then im.OpenPopup("Alert##pop") end

-- draw (outside any Begin/End is fine)
if im.BeginPopup("Alert##pop", {w=240, h=120}) then
    im.Label("Are you sure?")
    if im.Button("OK") then im.ClosePopup("Alert##pop") end
    im.EndPopup()
end
```

Popups auto-close when the user clicks outside them.

### Tooltips

```lua
-- simple text tooltip on the last widget
if im.Button("Save") then ... end
im.SetTooltip("Save the file\nCtrl+S")

-- check hover manually
if im.IsItemHovered() then
    -- do something
end

-- rich tooltip with widgets inside
im.Image(icon, nil, 32, 32)
if im.BeginTooltip() then
    im.Label("My Icon")
    im.EndTooltip()
end
```

### Style

```lua
-- override colors for a section
im.PushStyleColor("button",      {0.8, 0.2, 0.2, 1})
im.PushStyleColor("buttonHover", {1.0, 0.3, 0.3, 1})
if im.Button("Red") then end
im.PopStyleColor(2)

-- override style vars
im.PushStyleVar("padding",      16)
im.PushStyleVar("widgetRound",  8)
if im.Button("Rounded") then end
im.PopStyleVar(2)

-- switch font for a section
im.PushFont(bigFont)
im.Label("Big text")
im.PopFont()
```

All color keys are in `im.style.col`. All var keys are in `im.style`.

### ID System

When multiple widgets share the same label, use `##` to give them distinct IDs:

```lua
im.Button("OK##dialog1")
im.Button("OK##dialog2")
```

The part after `##` is the ID, the part before is the display label. Use `###` to make the entire string the ID (display label ignored for ID purposes).

For dynamic lists use `PushID` / `PopID`:

```lua
for i = 1, 10 do
    im.PushID(i)
    if im.Button("Select") then ... end
    im.PopID()
end
```

### Taskbar

```lua
-- call once per frame, outside Begin/End
im.Taskbar()
im.Taskbar({pos="top"})   -- "bottom" (default) or "top"

-- exclude a window from the taskbar
im.Begin("HUD##hud", {noTaskbar=true})
```

Click behaviour: focused window → minimize, minimized → restore, closed → reopen.

### Pseudo Docking

```lua
-- opt-in per window
im.Begin("Panel", {dockable=true})
```

Drag a dockable window near another dockable window or a screen edge — a blue ghost preview appears. Release to snap. Left/right docking matches heights, top/bottom docking matches widths. Drag away to undock.

### Save / Load Layout

```lua
im.SaveLayout()              -- saves to imlove_layout.lua
im.SaveLayout("my_ui.lua")   -- custom filename

im.LoadLayout()              -- loads from imlove_layout.lua
im.LoadLayout("my_ui.lua")
```

Files are written to and read from the LÖVE save directory (`love.filesystem`). Saves: position, size, scroll, open/closed, minimized, and docking state. Call `LoadLayout` after `Init`.

---

## Style Reference

Key entries in `im.style`:

| Key | Default | Description |
|-----|---------|-------------|
| `padding` | 8 | Inner widget padding |
| `itemSpacingY` | 4 | Vertical gap between widgets |
| `itemSpacingX` | 6 | Horizontal gap for SameLine |
| `windowPadding` | 10 | Inner window padding |
| `titleBarH` | 24 | Title bar height |
| `scrollbarW` | 10 | Scrollbar width |
| `snapDist` | 14 | Docking snap threshold in px |
| `taskbarH` | 32 | Taskbar height |
| `taskbarPos` | `"bottom"` | `"bottom"` or `"top"` |
| `windowRound` | 6 | Window corner rounding |
| `widgetRound` | 4 | Widget corner rounding |
| `font` | default | Set via `Init()`, override with `PushFont` |

Colors live in `im.style.col`. Example:

```lua
im.style.col.windowBg = {0.10, 0.10, 0.12, 1.0}
im.style.col.button   = {0.20, 0.40, 0.80, 1.0}
```

---

## Input Callbacks

Wire these in your `main.lua`:

```lua
function love.mousepressed(x,y,b)  im.MousePressed(x,y,b)  end
function love.mousereleased(x,y,b) im.MouseReleased(x,y,b) end
function love.wheelmoved(x,y)      im.WheelMoved(x,y)       end
function love.keypressed(k,s)      im.KeyPressed(k,s)        end
function love.textinput(t)         im.TextInput(t)           end
```

---

## License

MIT — see the license header inside `imlove.lua`.

Copyright (c) 2024 Salem Raddaoui
