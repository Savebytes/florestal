local Class = require("lib.middleclass")
local Entity = require("core.entity")

local CustomEntity = Class("CustomMouse", Entity)

function CustomEntity:initialize(world)
    Entity.initialize(self, world)
end

function CustomEntity:load()
    
end

function CustomEntity:update()
    
end

function CustomEntity:draw()
    
end

return CustomEntity