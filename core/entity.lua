local Class = require("lib.middleclass")

local Entity = Class("Entity")

function Entity:initialize(position)
    if position == nil then
        self.x = 0
        self.y = 0
        self.z = 0
    else
        self.x = position.x
        self.y = position.y
        self.z = position.z
    end
end

return Entity