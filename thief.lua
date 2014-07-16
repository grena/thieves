local class = require 'middleclass'

Thief = class('Thief')

function Thief:initialize(id, speed, x, y)
    self.id = id
    self.speed = speed
    self.destination_x = nil
    self.destination_y = nil
    self.orientation = 0
    self.x = x
    self.y = y
end

function Thief:set_destination(x, y)
    self.destination_x = x
    self.destination_y = y
end

function Thief:update_position(dt)
    if(self.x == self.destination_x and self.y == self.destination_y) then goto continue end

    x_diff = self.destination_x - self.x
    y_diff = self.destination_y - self.y

    if x_diff > 0 then
        new_x = self.x + (dt * self.speed)
        if new_x > self.destination_x then new_x = self.destination_x end
    else
        new_x = self.x - (dt * self.speed)
        if new_x < self.destination_x then new_x = self.destination_x end
    end

    self.x = new_x

    if y_diff > 0 then
        new_y = self.y + (dt * self.speed)
        if new_y > self.destination_y then new_y = self.destination_y end
    else
        new_y = self.y - (dt * self.speed)
        if new_y < self.destination_y then new_y = self.destination_y end
    end

    self.y = new_y

    -- Update orientation
    self:update_orientation(x_diff, y_diff)

    ::continue::
end

function Thief:update_orientation(x_diff, y_diff)
    if x_diff > 0 and y_diff < 0 then
        self.orientation = 7 * math.pi / 4          -- Direction N-E
    elseif x_diff > 0 and y_diff == 0 then
        self.orientation = 0                        -- Direction E
    elseif x_diff > 0 and y_diff > 0 then
        self.orientation = math.pi / 4              -- Direction S-E
    elseif x_diff == 0 and y_diff > 0 then
        self.orientation = math.pi / 2              -- Direction S
    elseif x_diff < 0 and y_diff > 0 then
        self.orientation = 3 * math.pi / 4          -- Direction S-W
    elseif x_diff < 0 and y_diff == 0 then
        self.orientation = math.pi                  -- Direction W
    elseif x_diff < 0 and y_diff < 0 then
        self.orientation =  5 * math.pi / 4         -- Direction N-W
    elseif x_diff == 0 and y_diff < 0 then
        self.orientation = 3 * math.pi / 2              -- Direction N
    end
end