local followMouse = {}

function followMouse.new(_entity)
    local follow = {}
    follow.name = "followMouse"

    function follow:start()
        self.entity = _entity:getComponent("transform")
    end

    function follow:update(dt)
       self.entity.x = love.mouse.getX()
       self.entity.y = love.mouse.getY()
    end

    return follow
end

return followMouse