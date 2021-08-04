local debug = {}
debug.woodAmount = 0

local font = love.graphics.newFont("data/font/arial.ttf", 14)

function debug.update(wood)
    debug.woodAmount = wood
end

function debug.draw()
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 0, 1)
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 0)
    love.graphics.print("X: " .. love.mouse.getX() .. " Y: " .. love.mouse.getY(), 0, 20) 
    love.graphics.print("Oxygen: 1m³", 0, 40)
    love.graphics.print("Water: " .. 1 .. "L", 0, 60) --waterAmount
end

return debug