local class = require 'libs.middleclass'
local MovingEntity = require 'moving_entity'

local Thief = class('Thief', MovingEntity)

Thief.static.default_pv = 5
Thief.static.default_speed = 0
Thief.static.image = nil
Thief.static.hitbox_size = 30

function Thief:initialize()

    -- Init parent
    MovingEntity:initialize(self)

    self.image = Thief.image
    self.hitbox_color = {255, 0, 0, 180}
    self.speed = Thief.default_speed
    self.hitbox_size = Thief.hitbox_size
    self.pv = Thief.default_pv
    self.dead = false
end

function Thief:hurt(pv_attack)
    self.pv = self.pv - pv_attack
    if self.pv <= 0 then self.dead = true end
end

return Thief