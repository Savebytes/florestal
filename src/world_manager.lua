local worldManager = {}

function worldManager:createWorld()
    local world = {}
    world.entities = {}

    function world:addEntity(entity)
        self.entities[entity.name] = entity
    end

    function world:start()
        for key, value in pairs(world.entities) do
            if value.start then
                value:start()
            end
        end
    end

    function world:update(dt)
        for key, value in pairs(world.entities) do
            if not value.update then
                return
            end
            value:update(dt)
        end
    end

    function world:draw()
        for key, value in pairs(world.entities) do
            if not value.draw then
                return
            end
            value.draw()
        end
    end

    return world
end

return worldManager