local timer = {}

function timer.updateTimers(dt) 
    for _, value in ipairs(timer) do
        if value.time > 0 then
            value.time = value.time - dt
        elseif value.time <= 0 then
            value.time = value.default
            value.callback()
        end
    end
end

function timer.newTimer(time, callback)
    local newTimerInstace = {
        time = time,
        default = time,
        callback = callback
    }

    table.insert(timer, newTimerInstace)
end

return timer