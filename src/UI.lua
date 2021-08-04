local UIComponents = {
    buttons = {},
    text = {}
}

local font = love.graphics.newFont("data/font/arial.ttf", 32)

function UIComponents.update(mouseX, mouseY, leftMouseDown)
    if leftMouseDown then
        for key, value in ipairs(UIComponents.buttons) do
            if mouseX >= value.x and mouseY >= value.y and mouseX < value.x + value.width and mouseY < value.y + value.height then
                value.click()
            end
        end     
    end

    for key, value in ipairs(UIComponents.buttons) do
        if mouseX >= value.x and mouseY >= value.y and mouseX < value.x + value.width and mouseY < value.y + value.height then
            value.color = {0.5, 0.5, 0.5, 1}
        else
            value.color = {1, 1, 1, 1}
        end
    end 
    
end

function UIComponents.draw()
    love.graphics.setFont(font)
    for key, value in ipairs(UIComponents.buttons) do
        love.graphics.setColor(value.color)
        love.graphics.rectangle("fill", value.x, value.y, value.width, value.height)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(tostring(value.text), value.x + 10, value.y)
    end

    for key, value in pairs(UIComponents.text) do
        love.graphics.setColor(value.color)
        love.graphics.rectangle("fill", value.x, value.y, value.width, value.height)
        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(tostring(value.text), value.x + (value.x / 2), value.y, 0)
    end
end

---Creates a new button.
---@param text string
---@param x number
---@param y number
---@param width number
---@param height number
function UIComponents.newButton(buttonName, text, x, y, width, height, click, color) 
    local button = {
        text = text,
        x = x,
        y = y,
        width = width,
        height = height,
        click = click,
        color = color
    }
    table.insert(UIComponents.buttons, button)
end

function UIComponents.newText(textName, text, x, y, width, height, color) 
    local textUI = {
        text = text,
        x = x,
        y = y,
        width = width,
        height = height,
        color = color
    }
    UIComponents.text[textName] = textUI
    --table.insert(UIComponents.text, textUI)
end

return UIComponents