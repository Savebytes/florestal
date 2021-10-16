local Class = require("lib.middleclass")

local Vector3 = Class("Vector3")

function Vector3:initialize(x, y, z)
    self.x = x or 0
    self.y = y or 0
    self.z = z or 0
end

function Vector3:normalize()
    self.x = self.x / self:getLength()
    if self.x ~= self.x then self.x = 0 end

    self.y = self.y / self:getLength()
    if self.y ~= self.y then self.y = 0 end
end

function Vector3:getLength()
   return math.sqrt(self.x * self.x + self.y * self.y)
end

return Vector3