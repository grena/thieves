local class = require 'libs.middleclass'

local Position = class('Position')

function Position:initialize(x, y)
    self:set(x, y)
end

function Position:set(x, y)
    self.x = x
    self.y = y
end

function Position:equal(position)
    return self.x == position.x and self.y == position.y
end

function Position:__tostring()
    return 'Position: [x:' .. tostring(self.x) .. ', y:' .. tostring(self.y) .. ']'
end

return Position