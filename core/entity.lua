local Class = require("lib.middleclass")

local Entity = Class("Entity")

function Entity:initialize(world, tag, position)
    self.world = world
    world:addEntity(self)

    self.tag = tag or "Entity0"
    self.removed = false

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

function Entity:destroy()
    self.world:destroy(self.tag)
end

function Entity:load()

end

function Entity:update()

end

return Entity