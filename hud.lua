local class = require 'libs/middleclass'

local HUD = class('HUD')

function HUD:initialize(global)
    self.global = global
end

function HUD:draw()
    love.graphics.setColor( 255, 255, 255 )
    love.graphics.print("Killed : " .. self.global.game.killed_counter .. " Thieves on map : " .. #self.global.game.thieves, 10, 10)
end

return HUD