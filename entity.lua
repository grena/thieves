local class = require 'libs/middleclass'
local Position = require 'position'

local Entity = class('Entity')

function Entity:initialize()
    self.image = nil
    self.image_color = {255, 255, 255}
    self.position = Position:new(0, 0)
    self.orientation = 0
    self.hitbox_size = 0        -- Diameteer
    self.hitbox_color = {255, 255, 255, 80}
end

-- Set image to draw for this entity
function Entity:set_image(image)
    self.image = image
end

-- Draw this entity with its image and
-- its hitbox
function Entity:draw()

    -- Render hitbox circle
    self:draw_hitbox()

    -- Render graphic image
    self:draw_image()
end

-- Render hitbox circle
function Entity:draw_hitbox()
    love.graphics.setColor( self.hitbox_color )
    love.graphics.circle( 'line', self.position.x, self.position.y, self.hitbox_size/2, 20 )
end

-- Render graphic image
function Entity:draw_image()
    love.graphics.setColor( self.image_color )
    love.graphics.draw( self.image,
                        self.position.x,
                        self.position.y,
                        self.orientation, 1, 1,
                        self.image:getWidth()/2,
                        self.image:getHeight()/2 )
end

-- Detect if this entity hitbox collides with
-- an other entity hitbox
-- Helped from http://blogs.love2d.org/content/circle-collisions
function Entity:collide_with(entity)
    local dist = (self.position.x - entity.position.x)^2 + (self.position.y - entity.position.y)^2
    return dist <= ( (self.hitbox_size/2) + (entity.hitbox_size/2) )^2
end

function Entity:collide_with_point(x, y)
    return (x - self.position.x)^2 + (y - self.position.y)^2 < (self.hitbox_size/2)^2
end

return Entity