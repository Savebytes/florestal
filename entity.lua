local transformComponent = require("internal_components.transform")

local entity = {}

function entity.new(name, position)
    if name == "" or name == nil then
        print("The entity needs a valid name.")
        return
    end

    local ent = {}
    ent.name = name or "entity"
    ent.tag = "default"
    
    local components = {}
    components["transform"] = transformComponent.new(position[1] or 0, position[2] or 0)

    function ent:addComponent(component)
        if component == nil then
            error("Error: component not added! (nil)", 2)
        end
        if component.name == nil then
            error("Error: component doesn't have a name property!", 2)
        end
        if components[component.name] then
            error("Error: the entity already has: " .. component.name, 2)
        end

        components[component.name] = component
    end

    function ent:getComponent(componentName) 
        if components[componentName] == nil then
            print("Error: component not found!")
            return
        end
        return components[componentName]
    end

    function ent:removeComponent(componentName)
        components[componentName] = nil
    end

    function ent:start()
        for _, value in pairs(components) do
            if value.start then
                value:start()
            end
        end
    end

    function ent:update(dt)
        for _, value in pairs(components) do
            if value.update then
                value:update(dt)
            end
        end
    end

    function ent:draw()
        for _, value in pairs(components) do
            if value.draw then
                value:draw(components["transform"])
            end
        end
    end

    return ent
end

return entity