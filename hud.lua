local class = require 'libs/middleclass'

local HUD = class('HUD')

function HUD:initialize(global)
    self.global = global
end

function HUD:draw()

    love.graphics.setColor( 0, 0, 0, 125 )
    love.graphics.rectangle("fill", 0, 0, love.window.getWidth(), 35 )

    love.graphics.setColor( 255, 255, 255 )
    love.graphics.print("Gold : " .. self.global.game.resources.gold, 10, 10)
    love.graphics.setColor( 255, 255, 255 )
    love.graphics.print("hour : " .. self.global.game.day_night_engine.current_hour, 100, 10)
end

return HUD