local class = require 'middleclass'

Thief = class('Thief')

function Thief:initialize(id, speed, x, y)
    self.id = id
    self.speed = speed
    self.x = x
    self.y = y
    self.orientation = 0
end

function set_x(x)
    self.x = x
end

function set_y(y)
    self.y = y
end