local class          = require 'libs/middleclass'
local _              = require 'libs/moses'
local Thief          = require 'thief'
local Entity         = require 'entity'
local Position       = require 'position'
local DayNightEngine = require 'day_night_engine'

local Game = class('Game')

function Game:initialize(global)
    self.global = global
    self.thieves = {}
    self.gold_chests = {}

    self.day_night_engine = DayNightEngine:new()

    self.time_marker_new_ennemy = nil
    self.time_before_new_ennemy = 3
    self.killed_counter = 0

    self.resources = {
        gold = 50,
        wood = 20
    }

    Thief.image = self.global.graphics.entities['thief']

    -- TODO: Move
    self.difficulty = self:init_difficulty()

    -- Choose battlefield appearance
    self:randomize_battlefield()

    -- Create THE chest !
    self:create_chest()
end

function Game:update(dt)

    -- Update day night cycle
    self.day_night_engine:update()
    self:update_entities_color()

    -- Create a thief with cooldown
    self:create_thief()

    -- Move all thieves
    self:move_thieves(dt)
end

function Game:draw()

    -- Draw the world
    self:render_background()

    -- Draw the chest
    self.chest:draw()

    -- Draw thieves
    self:render_thieves()

    -- Draw gold chests
    self:render_gold_chests()
end

function Game:update_entities_color()
    self.chest.image_color = self.day_night_engine.current_color

    for index, thief in ipairs(self.thieves) do
        thief.image_color = self.day_night_engine.current_color
    end
end

function Game:mousepressed(x, y, button)
    if button == 'l' then
        self:trigger_attack(x, y)
    end
end

function Game:randomize_battlefield()
    local type_number = #self.global.graphics.backgrounds

    -- Grass or Sand ?
    local type_of_ground = self.global.graphics.backgrounds[ love.math.random( 1, type_number ) ]

    -- Then variant of Grass or Sand
    self.background_image = type_of_ground[ love.math.random( 1, #type_of_ground ) ]
end

function Game:create_chest()

    self.chest = Entity:new()
    self.chest.position = Position:new(0, 0)
    self.chest.image = self.global.graphics.entities['chest']
    self.chest.hitbox_size = 60

    local x_padding = self.global.game_parameters.chest_padding.x
    local y_padding = self.global.game_parameters.chest_padding.y

    local w_width, w_height = love.window.getDimensions()

    self.chest.position.x = love.math.random( x_padding, (w_width - self.chest.hitbox_size - x_padding) )
    self.chest.position.y = love.math.random( y_padding, (w_height - self.chest.hitbox_size - y_padding) )
end

function Game:create_thief()

    -- Only at night
    if self.day_night_engine.current_hour >= 6 and self.day_night_engine.current_hour <= 22 then
        return false
    end

    if (self.time_marker_new_ennemy == nil) then
        self.time_marker_new_ennemy = love.timer.getTime()
    end

    local diff = love.timer.getTime() - self.time_marker_new_ennemy

    if( diff > self.time_before_new_ennemy ) then

        love.audio.play( self.global.sounds['thief_appears'] )

        local new_thief = Thief:new()

        -- Apparation zone
        local rand_zone = love.math.random( 1, 4 )
        local w_width, w_height = love.window.getDimensions()
        local birth_x = 0
        local birth_y = 0

        if rand_zone == 1 then         -- North
            birth_y = 0
            birth_x = love.math.random(w_width)
        elseif rand_zone == 2 then     -- South
            birth_y = w_height
            birth_x = love.math.random(w_width)
        elseif rand_zone == 3 then     -- East
            birth_x = 0
            birth_y = love.math.random(w_height)
        else                           -- West
            birth_x = w_width
            birth_y = love.math.random(w_height)
        end

        new_thief.position = Position:new( birth_x, birth_y )
        new_thief.destination = self.chest.position -- Go and attack the chest !! >:)
        new_thief.speed = love.math.random( 15, 35 )

        table.insert(self.thieves, new_thief)

        -- Reset apparition cooldown
        self.time_marker_new_ennemy = love.timer.getTime()
    end
end

function Game:create_gold_chest()

        local new_gold_chest = Entity:new()
        new_gold_chest.image = self.global.graphics.entities['gold_chest']
        new_gold_chest.hitbox_size = 40
        new_gold_chest.hitbox_color = {255, 255, 0, 80}

        -- Apparation zone
        local w_width, w_height = love.window.getDimensions()
        local birth_x = love.math.random( 100, w_width - 100)
        local birth_y = love.math.random( 100, w_height - 100)

        new_gold_chest.position = Position:new( birth_x, birth_y )

        table.insert(self.gold_chests, new_gold_chest)
end

function Game:move_thieves(dt)
    for index, thief in ipairs(self.thieves) do

        thief:update_position(dt)

        if(thief:collide_with(self.chest)) then
            self:trigger_lose()
        end
    end
end

-- TODO: Read from a file
function Game:init_difficulty()
    return {
        {unlocked_at = 5, cooldown = 4,speed = love.math.random( 40, 60 ), pv = 4},
        {unlocked_at = 10, cooldown = 3, speed = love.math.random( 50, 70 ), pv = 5},
        {unlocked_at = 15, cooldown = 2, speed = love.math.random( 50, 85 ), pv = 6},
        {unlocked_at = 20, cooldown = 2, speed = love.math.random( 50, 85 ), pv = 7},
        {unlocked_at = 30, cooldown = 1, speed = love.math.random( 50, 100 ), pv = 8},
    }
end

function Game:trigger_attack(x, y)

    -- Var to check if a thief has been killed
    local one_dead = false

    -- Check if a thief is hit
    for index, thief in ipairs(self.thieves) do

        if thief:collide_with_point(x, y) then

            love.audio.play( self.global.sounds['hit'] )
            thief:hurt(1)

            if thief.dead then
                one_dead = true
                self:trigger_dead_thief(thief)
            end
        end
    end

    -- Clean dead entities
    if one_dead then
        self.thieves = _.reject(self.thieves, function(key, thief)
            return thief.dead
        end)

        -- apply_difficulty()  -- Check for difficulty progress
    end
end

function Game:trigger_dead_thief(thief)
    love.audio.play( self.global.sounds['killed'] )
    self.killed_counter = self.killed_counter + 1
    self.resources.gold = self.resources.gold + 5
end

function Game:render_background()
    for i = 0, love.graphics.getWidth() / self.background_image:getWidth() do
        for j = 0, love.graphics.getHeight() / self.background_image:getHeight() do
            love.graphics.setColor( self.day_night_engine.current_color )
            love.graphics.draw(self.background_image, i * self.background_image:getWidth(), j * self.background_image:getHeight())
        end
    end
end

function Game:render_thieves()
    for index, thief in ipairs(self.thieves) do
        thief:draw()
    end
end

function Game:render_gold_chests()
    for index, gold_chest in ipairs(self.gold_chests) do
        gold_chest:draw()
    end
end

function Game:trigger_lose()
    self.global.gamestate = 'lose'
    love.audio.play( self.global.sounds['lose'] )
end

function update_lose()
end

function apply_difficulty()
    _.each(difficulty_levels, function(k, v)
        if v.unlocked_at == killed_counter then
            TEsound.play("sound_fx/notify.wav")
            self.time_before_new_ennemy = v.cooldown
            Thief.static.default_speed = v.speed
            Thief.static.default_pv = v.pv
        end
    end)
end

return Game