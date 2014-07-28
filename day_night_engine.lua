local class = require 'libs/middleclass'

local DayNightEngine = class('DayNightEngine')

function DayNightEngine:initialize()
    self.max_dark_color = 110               -- Less it is, darker and blue the night is
    self.timestamp = nil
    self.current_color = { 255, 255, 255 }

    self.current_hour = 12                  -- Current HOUR of the cycle
    self.hour_full_night = 0                -- The HOUR at which it's full night (midnight)
    self.hour_full_day = 12                 -- The HOUR at which it's full day (noon)
    self.transition_time = 4                -- HOURS to transit between cycles
    self.hour_duration = 5                  -- Duration of an hour, in SECONDS
end

function DayNightEngine:update()

    -- Update the current hour to keep a track of the day
    local updated = self:update_current_hour()

    if updated then
        -- Update color of the night
        self:update_color()
    end
end

function DayNightEngine:update_current_hour()

    if(self.timestamp == nil) then
        self.timestamp = love.timer.getTime()
    end

    local hour_change = (love.timer.getTime() - self.timestamp) >= self.hour_duration

    if(hour_change) then

        if(self.current_hour < 23) then
            self.current_hour = self.current_hour + 1
        else
            self.current_hour = 0
        end

        -- Reset timestamp for next hour
        self.timestamp = love.timer.getTime()

        -- Hour has been updated
        return true
    end
end

function DayNightEngine:update_color()

    local step_size = (255 - self.max_dark_color) / (self.transition_time)

    if self.current_hour >= self.hour_full_night and self.current_hour < self.hour_full_day then
        -- After midnight...

        if(self.current_hour < (self.hour_full_day - self.transition_time)) then
            -- ... but before dawn
            self.current_color = { self.max_dark_color, self.max_dark_color, 255 }  -- Full night !
        else
            -- and in dawn transition
            local diff = (self.hour_full_day - self.current_hour)
            local color = 255 - (diff * step_size)
            self.current_color = { color, color, 255 }
        end

    elseif self.current_hour >= self.hour_full_day then
        -- Afternoon...

        if(self.current_hour < (24 - self.transition_time)) then
            -- ... but before twilight
            self.current_color = { 255, 255, 255 }  -- Full day !
        else
            -- and in twilight transition
            local diff = (24 - self.current_hour)
            local color = self.max_dark_color + (diff * step_size)
            self.current_color = { color, color, 255 }
        end
    end
end

return DayNightEngine