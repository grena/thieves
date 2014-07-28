local class = require 'libs.middleclass'
local Entity = require 'entity'
local Position = require 'position'

local MovingEntity = class('MovingEntity', Entity)

function MovingEntity:initialize()

    -- Init parent
    Entity:initialize(self)

    self.speed = 0
    self.stopped = false
    self.destination = nil
end

function MovingEntity:update_position(dt)

    -- Only update position if thief is not stopped
    if not self.stopped then
        local x_diff = self.destination.x - self.position.x
        local y_diff = self.destination.y - self.position.y
        local new_x = 0
        local new_y = 0

        if x_diff > 0 then
            new_x = self.position.x + (dt * self.speed)
            if new_x > self.destination.x then new_x = self.destination.x end
        else
            new_x = self.position.x - (dt * self.speed)
            if new_x < self.destination.x then new_x = self.destination.x end
        end

        if y_diff > 0 then
            new_y = self.position.y + (dt * self.speed)
            if new_y > self.destination.y then new_y = self.destination.y end
        else
            new_y = self.position.y - (dt * self.speed)
            if new_y < self.destination.y then new_y = self.destination.y end
        end

        -- Update position of entity
        self.position:set(new_x, new_y)

        -- Stop entity if at destination
        if self.position:equal( self.destination ) then
            self.stopped = true
        end

        -- print(self.id..' x='..self.position.x..', y='..self.position.y)

        -- Update orientation
        self:update_orientation(x_diff, y_diff)
    end
end

function MovingEntity:update_orientation(x_diff, y_diff)
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
        self.orientation = 3 * math.pi / 2          -- Direction N
    end
end

return MovingEntity