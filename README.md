# imlove

A pure Lua 5.1 immediate mode GUI library for [LÖVE 2D](https://love2d.org/), inspired by [Dear ImGui](https://github.com/ocornut/imgui). Single file, no external dependencies beyond the built-in `bit` library and `utf8`.

**v0.3.0 is a major architectural upgrade:** It features a **zero-allocation rendering loop** on the hot path. Widgets pool their state, meaning `imlove` generates virtually zero Lua garbage collection overhead during normal operation.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/radda-ui/imlove?style=social)](https://github.com/radda-ui/imlove)

---

## Features

- **Single file** — drop `imlove.lua` into your project and require it.
- **Immediate mode** — no retained widget state to sync, your app owns all the data.
- **Zero-Allocation Hot Path** — aggressive internal pooling means UI rendering won't trigger Lua GC stutters.
- **Z-order & Input Isolation** — windows stack correctly, topmost window captures all input.
- **Widgets** — Button, Label, Checkbox, RadioButton, Slider, SliderInt, InputText, InputInt, InputFloat, Combo (Dropdown), ProgressBar, Selectable, SelectableImage, Image, CollapsingHeader.
- **Layout** — SameLine, Separator, Spacing, Indent, Unindent, TextWrapped.
- **Windows** — draggable, resizable, minimizable, closeable, scrollable, with a robust Flag system.
- **Menu bar** — BeginMenuBar / BeginMenu / MenuItem / MenuSeparator.
- **Popups** — modal-style dropdowns and windows, auto-close on outside click.
- **Tooltips** — IsItemHovered / SetTooltip / BeginTooltip.
- **Style system** — PushStyleColor / PopStyleColor, PushStyleVar / PopStyleVar, PushFont / PopFont.
- **Save / Load layout** — persists window positions, sizes, and open/minimized state to the LÖVE save directory.

---

## Quick Start

```lua
local im = require "imlove"

local checked  = false
local sliderV  = 0.5
local inputStr = "hello"
local comboIdx = 1

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

    -- Options table is nil, followed by optional layout flags
    if im.Begin("My Window", nil, im.NoCollapse) then
        im.Label("Hello from imlove!")
        if im.Button("Click me") then print("clicked") end

        checked  = im.Checkbox("Enable", checked)
        sliderV  = im.Slider("Speed", sliderV, 0, 1)
        comboIdx = im.Combo("Options", comboIdx, {"Apple", "Banana", "Cherry"})
        inputStr = im.InputText("Name", inputStr)
    end
    im.End()

    im.EndFrame()
end

-- Wire LÖVE inputs to imlove
function love.mousepressed(x,y,b)  im.MousePressed(x,y,b)  end
function love.mousereleased(x,y,b) im.MouseReleased(x,y,b) end
function love.wheelmoved(x,y)      im.WheelMoved(x,y)      end
function love.keypressed(k,s)      im.KeyPressed(k)        end
function love.textinput(t)         im.TextInput(t)         end
```

---

## Installation

Download `imlove.lua` and place it in your project directory.

```lua
local im = require "imlove"
```

---

## API Reference

### Initialization

```lua
im.Init()          -- call once in love.load()
im.Update(dt)      -- call in love.update(dt) for cursor blinking and timers
```

### Frame

```lua
im.BeginFrame()    -- call at the start of love.draw()
im.EndFrame()      -- call at the end of love.draw() — triggers batched rendering
```

### Windows & Flags

```lua
-- Window ID is the title, or use "Title##id" to separate display title from stable ID
-- Signature: im.Begin(name, options_table, ...flags)
local options = { x = 100, y = 100, w = 300, h = 400, open = true }

local visible, open = im.Begin("My Window", options, im.NoResize, im.NoTitleBar)
if visible then
    -- draw widgets here
end
im.End()
```

**Available Flags:**
`im.NoTitleBar`, `im.NoResize`, `im.NoMove`, `im.NoScrollbar`, `im.NoBackground`, `im.NoClose`, `im.NoMinimize`

### Widgets

```lua
-- Label
im.Label("Some text")
im.LabelColored("Red text", 1, 0, 0)
im.TextWrapped("Long text that wraps automatically.")

-- Button (btnW, btnH are optional)
if im.Button("Click", btnW, btnH) then ... end

-- Checkbox & Radio
checked = im.Checkbox("Enable", checked)
radio = im.RadioButton("Option A", radio, 1)
radio = im.RadioButton("Option B", radio, 2)

-- Sliders
slFloat = im.Slider("Float", slFloat, 0, 1, "%.3f")  -- optional format string
slInt   = im.SliderInt("Int", slInt, 0, 100)

-- Text & Numeric Inputs
text = im.InputText("Name", text, maxLen)  -- Supports UTF-8, Clipboard, Selection
val  = im.InputInt("Age", val, 1)          -- Stepper buttons (+/-) included
val  = im.InputFloat("Weight", val, 0.5)

-- Combo (Dropdown Menu)
-- returns the new selected index and a boolean if it just changed
current_idx, changed = im.Combo("Fruit", current_idx, {"Apple", "Orange", "Banana"})

-- ProgressBar
im.ProgressBar(fraction, barW, barH, "overlay text")

-- Selectable (Lists)
selected = im.Selectable("Item", selected)
open = im.CollapsingHeader("Section", open)

-- Images
im.Image(image, quad, dispW, dispH)
selected = im.SelectableImage("label", image, quad, selected)
```

### Layout

```lua
im.SameLine(spacing, yOffset) -- place next widget on the same line
im.Separator()                -- horizontal divider line
im.Spacing(amount)            -- extra vertical space
im.Indent(amount)             -- indent widgets
im.Unindent(amount)
```

### Menu Bar

```lua
if im.Begin("Window") then
    if im.BeginMenuBar() then
        if im.BeginMenu("File") then
            if im.MenuItem("Save", "Ctrl+S") then ... end
            im.MenuSeparator()
            if im.MenuItem("Quit") then ... end
            im.EndMenu()
        end
        im.EndMenuBar()
    end
end
im.End()
```

### Popups

Popups automatically render *over* other windows and close when the user clicks outside of them.

```lua
if im.Button("Open") then im.OpenPopup("Alert##pop") end

-- Draw (can be outside the window that opened it)
if im.BeginPopup("Alert##pop", {w=240, h=120}) then
    im.Label("Are you sure?")
    if im.Button("OK") then im.ClosePopup("Alert##pop") end
    im.EndPopup()
end
```

### Tooltips

```lua
-- Simple text tooltip on the last widget rendered
if im.Button("Save") then ... end
im.SetTooltip("Save the file\nCtrl+S")

-- Rich tooltip with widgets inside
im.Image(icon, nil, 32, 32)
if im.BeginTooltip() then
    im.Label("My Icon")
    im.EndTooltip()
end
```

### ID System

When multiple widgets share the exact same label, use `##` to give them distinct underlying IDs so `imlove` can tell them apart:

```lua
im.Button("OK##dialog1")
im.Button("OK##dialog2")
```

For dynamic lists, use `PushID` / `PopID` instead of concatenating strings:

```lua
for i = 1, 10 do
    im.PushID(i)
    if im.Button("Select") then ... end
    im.PopID()
end
```

### Save / Load Layout

```lua
im.SaveLayout()              -- saves to 'imlove_layout.lua' in LÖVE save dir
im.SaveLayout("my_ui.lua")   -- custom filename

im.LoadLayout()              -- loads layout and applies to windows
```

Call `im.LoadLayout()` during `love.load()` after `im.Init()`. It restores window positions, sizes, and minimized/open states seamlessly.

---

## Style Reference

Key entries in `im.style` you can override:

| Key | Default | Description |
|-----|---------|-------------|
| `padding` | 8 | Inner widget padding |
| `itemSpacingY` | 4 | Vertical gap between widgets |
| `itemSpacingX` | 6 | Horizontal gap for SameLine |
| `windowPadding` | 10 | Inner window padding |
| `titleBarH` | 24 | Title bar height |
| `scrollbarW` | 10 | Scrollbar width |
| `windowRound` | 0 | Window corner rounding (0 = square) |
| `widgetRound` | 0 | Widget corner rounding (0 = square) |
| `font` | default | Set via `Init()`, override with `im.PushFont` |

Colors live in `im.style.col`. You can override them globally or temporarily using `im.PushStyleColor`:

```lua
im.PushStyleColor("button", {0.8, 0.2, 0.2, 1})
if im.Button("Red Button") then end
im.PopStyleColor(1)
```

---

## License

MIT License — see the license header inside `imlove.lua`.

Copyright (c) 2024-2026 Salem Raddaoui