local followMouse = {}

function followMouse.new(_transform)
    local follow = {}
    follow.name = "followMouse"

    function follow.start()
        print("start mouse follow")
    end

    function follow.update(dt)
       _transform.x = love.mouse.getX()
       _transform.y = love.mouse.getY()
    end

    return follow
end

return followMouse