# imlove

A pure Lua 5.1 simple immediate mode GUI implementation for LÖVE 2D.  Inspired by [Dear ImGui](https://github.com/ocornut/imgui).

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Stars](https://img.shields.io/github/stars/radda09/imlove?style=social)](https://github.com/radda09/imlove)

## Features

*   **Lightweight:**  Minimal dependencies, just the `bit` library.
*   **Easy to Integrate:** Simple API designed for LÖVE 2D.
*   **Immediate Mode:**  GUI state is not retained by the library.  Your application manages the data.
*   **Customizable:**  Styling options for colors, padding, and more.
*   **Basic Widgets:** Buttons, Sliders, Checkboxes, Text Panels, Images, Selectables, Collapsing Headers, Progress Bars, Separators.
*   **Windowing:** Supports draggable and resizable windows and popups.
*   **Scrolling:** Automatic scrollbars when content exceeds window bounds.
*   **Layout Helpers:** Sameline for horizontal layout.
*   **Save/Load:**  Basic UI state persistence.

## Bugs:
*   **there are a ton of bugs:** i hope you would help fix this library.

## Example Screenshot
![imlove Example](https://github.com/radda-ui/imlove/blob/master/ScreenShot.png?raw=true)

## Installation

1.  Download the `imlove.lua` file and place it in your project directory.
2.  Require the library in your `main.lua`:

    ```lua
    local imlove = require("imlove")
    ```

## Usage

Here's a basic example of how to use `imlove` in your LÖVE 2D project:

```lua
local imlove = require("imlove")

local open = true
local open2 = true
local sliderValue = 50
local checked = false

function love.load()
    imlove.init()
    -- Load a font for better readability (optional)
    -- local font = love.graphics.newFont(16)
    -- love.graphics.setFont(font)
end

function love.update(dt)
    imlove.newFrame()

    --Imlove Window1
    open = imlove.Begin("Window1", open, 0, 0, 150, 150)
    if open then
        imlove.TextPanel("This is a text panel.\nYou can put multiple lines of text here.")

        imlove.End()
    end
        --Imlove Window2
    if imlove.Begin("Window2", open2, 150, 0, 300, 200) then
        if imlove.Button("Click Me") then
            print("Button Clicked!")
        end

        sliderValue = imlove.Slider("Slider", sliderValue, 0, 100)
        checked = imlove.Checkbox("Checkbox", checked)

        imlove.TextPanel("This is a text panel.\nYou can put multiple lines of text here.")

        imlove.End()
    end
    imlove.endFrame()
end

function love.draw()
    love.graphics.clear(0.2, 0.2, 0.2)
    imlove.renderDrawList()
end

function love.keypressed(key)
    imlove.keypressed(key)
    if "w" == key then
        open = not open
        print(key)
    end
    if "q" == key then
        open2 = not open2
    end
end

function love.keyreleased(key)
    imlove.keyreleased(key)
end

function love.textinput(text)
    imlove.textinput(text)
end

function love.mousepressed(x, y, button)
     imlove.pressed(button)
end

function love.mousereleased(x, y, button)
    imlove.released(button)
end

function love.wheel(x, y)
    imlove.wheel(x, y)
end

```

## API Reference

### Initialization

*   `imlove.init()`: Initializes the library.  Call this once at the start of your application.

### Frame Management

*   `imlove.newFrame()`: Starts a new GUI frame.  Call this at the beginning of your `love.update` function.
*   `imlove.endFrame()`: Ends the current GUI frame.  Call this at the end of your `love.update` function.

### Rendering

*   `imlove.renderDrawList()`: Renders the GUI elements.  Call this in your `love.draw` function.

### Windowing

*   `imlove.Begin(title, open, x, y, w, h)`: Begins a window.
    *   `title`:  The title of the window (string).  Used as a unique ID.
    *   `open`:  A boolean value indicating whether the window is open.  Pass a variable, and imlove will update it when the close button is pressed.
    *   `x`, `y`: The initial position of the window.
    *   `w`, `h`: The initial width and height of the window.
    *   Returns `true` if the window is open, `false` otherwise.

*   `imlove.End()`: Ends a window.

*   `imlove.BeginPopup(title)`: Begins a popup window.
    *   `title`: The title of the popup (string). Used as a unique ID.
    *   Returns `true` if the popup is open and should be drawn, `false` otherwise.
*   `imlove.EndPopup()`: Ends a popup window.
*   `imlove.openPopup(title)`: Opens a popup window.
*   `imlove.closePopup(title)`: Closes a popup window.

### Widgets

*   `imlove.Button(label)`: Creates a button.
    *   `label`: The text label of the button.
    *   Returns `true` if the button was clicked, `false` otherwise.

*   `imlove.Slider(label, value, min, max)`: Creates a slider.
    *   `label`: The text label of the slider.
    *   `value`: The current value of the slider.
    *   `min`, `max`: The minimum and maximum values of the slider.
    *   Returns the new value of the slider.

*   `imlove.Checkbox(label, checked)`: Creates a checkbox.
    *   `label`: The text label of the checkbox.
    *   `checked`: A boolean value indicating whether the checkbox is checked.
    *   Returns the new checked state of the checkbox.

*   `imlove.TextPanel(text, alignment)`: Creates a text panel.
    *   `text`: The text to display in the panel.
    *   `alignment` (optional): "left", "center", or "right". Defaults to "left".

*   `imlove.Image(image, quad, w, h)`:  Displays an image.
    *   `image`:  LÖVE Image object.
    *   `quad` (optional): LÖVE Quad object to display a portion of the image.
    *   `w` (optional): Width to draw the image.  Defaults to image width.
    *   `h` (optional): Height to draw the image.  Defaults to image height.

*   `imlove.ButtonImage(image, quad, w, h)`: Creates a button with an image.
     *   `image`:  LÖVE Image object.
    *   `quad` (optional): LÖVE Quad object to display a portion of the image.
    *   `w` (optional): Width to draw the image.  Defaults to image width.
    *   `h` (optional): Height to draw the image.  Defaults to image height.
    *   Returns `true` if the button was clicked, `false` otherwise.

*   `imlove.Selectable(label, selected)`: Creates a selectable item (like in a listbox).
    *   `label`: The text label of the selectable.
    *   `selected`: A boolean value indicating whether the item is selected.
    *   Returns the new selected state of the item.

*   `imlove.SelectableImage(image, quad, selected, size)`: Creates a selectable item with an image.
    *   `image`: LÖVE Image object.
    *   `quad` (optional): LÖVE Quad object to display a portion of the image.
    *   `selected`: A boolean value indicating whether the item is selected.
    *   `size` (optional): A number for width and height or a table containing width and height {w, h}. Defaults to the image's width and height.
    *   Returns the new selected state of the item.

*   `imlove.CollapsingHeader(label, open)`: Creates a collapsing header.
    *   `label`: The text label of the header.
    *   `open`: A boolean value indicating whether the header is open.
    *   Returns the new open state of the header.

*   `imlove.ProgressBar(label, fraction, value, max)`: Creates a progress bar.
    *   `label`: The text label of the progress bar.
    *   `fraction`: A value between 0 and 1 indicating the progress.
    *   `value`: The current value of the progress.
    *   `max`: The maximum value of the progress.

*   `imlove.Separator(label, size, position)`: Creates a separator line.
    *   `label` (optional): A label to display on the separator line.
    *   `size` (optional): The height of the separator. Defaults to the font height.
    *   `position` (optional): "left", "right", or "middle".  Defaults to "left".

### Layout

*   `imlove.Sameline(spacing)`:  Places the next widget on the same line as the previous one.
    *   `spacing` (optional):  The spacing between the items. Defaults to `imlove.style.itemSpacing`.

### Input

*   `imlove.keypressed(key)`:  Handles key pressed events.  Call this in your `love.keypressed` function.
*   `imlove.keyreleased(key)`: Handles key released events. Call this in your `love.keyreleased` function.
*   `imlove.textinput(text)`: Handles text input events. Call this in your `love.textinput` function.
*   `imlove.pressed(x, y, button)`: Handles mouse pressed events. Call this in your `love.mousepressed` function.
*   `imlove.released(x, y, button)`: Handles mouse released events. Call this in your `love.mousereleased` function.
*   `imlove.wheel(x, y)`: Handles mouse wheel events. Call this in your `love.wheel` function.

### State Management

*   `imlove.save()`: Saves the UI state (window positions and sizes) to `ui_state.lua`.
*   `imlove.load()`: Loads the UI state from `ui_state.lua`. Call this after `imlove.init()`.

### Styling

The `imlove.style` table contains various styling options:

*   `minWindowWidth`, `minWindowHeight`: Minimum window dimensions.
*   `minWidth`, `minHeight`: Minimum widget dimensions.
*   `padding`, `margin`, `itemSpacing`: Spacing values.
*   `globalAlpha`: Global alpha transparency for all GUI elements.
*   `resizeHandleSize`: Size of the window resize handle.
*   `scrollbarWidth`, `scrollbarMinHeight`: Scrollbar dimensions.

The `imlove.colors` table contains color definitions for various GUI elements.  Each color is a table with four values: `{r, g, b, a}` (red, green, blue, alpha), where each value is between 0 and 1.  Example:

```lua
imlove.colors.Text = {1.00, 1.00, 1.00, 1.00} -- White text
```

## Contributing

Contributions are welcome!  Please submit pull requests with bug fixes, new features, or improvements .

## License

This library is licensed under the MIT License. See the `LICENSE` for details.(included in the library)
