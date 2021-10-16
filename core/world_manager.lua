local Class = require("lib.middleclass")
local Entity = require("core.entity")

local WorldManager = Class("WorldManager")

local entities = {}

function WorldManager:addEntity(entity)
    assert(entity:isInstanceOf(Entity), "Entity needs be a instance of Entity.")
    table.insert(entities, entity)
end

function WorldManager:findEntity(entityTag)
    for index, value in ipairs(entities) do
        if value.tag == entityTag then
            return value
        end
    end

    return nil
end

function WorldManager:destroy(entityTag)
    for index, value in ipairs(entities) do
        if value.tag == entityTag then
            table.remove(entities, index)
            return true
        end
    end

    return false
end


function WorldManager:load()
    for index, value in ipairs(entities) do
        value:load()
    end
end

function WorldManager:update(dt)
    for index, value in ipairs(entities) do
            if value.update then
                value:update(dt)
            end
    end
end

function WorldManager:draw(dt)
    for index, value in ipairs(entities) do
            if value.draw then
                value:draw()
            end
    end
end

return WorldManager
