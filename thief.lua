local class = require 'middleclass'

Thief = class('Thief')

Thief.static.default_pv = 3
Thief.static.default_speed = love.math.random(30, 50)

function Thief:initialize(id)
    self.id = id
    self.speed = Thief.default_speed
    self.pv = Thief.default_pv
    self.destination_x = nil
    self.destination_y = nil
    self.orientation = 0
    self.stop = false
    self.dead = false
    self.x = nil
    self.y = nil
end

function Thief:set_destination(x, y)
    self.destination_x = x
    self.destination_y = y
end

function Thief:update_position(dt)
    -- Only update position if thief is not stopped
    if not self.stop then
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

        if self.x == self.destination_x and self.y == self.destination_y then
            print("Hey ".. self.id .." STOPPED.")
            self.stop = true
        end

        -- Update orientation
        self:update_orientation(x_diff, y_diff)
    end
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

function Thief:hurt(pv_attack)
    self.pv = self.pv - pv_attack
    if self.pv <= 0 then self.dead = true end
end