require "TEsound"
require "thief"
require "collection"

local _ = require 'moses'

BOX_SIZE = 48
PADDING_AREA = 150   -- Padding zone where chest can't pop (too near from thieves !)

ennemies = {}
killed_counter = 0
ennemy_id = 1               -- Incremential id of ennemies
apparation_cooldown = 5    -- Seconds before an ennemy appears
time_ennemy_pop = nil

game_state = 'run'

difficulty_levels = {
    {unlocked_at = 5, cooldown = 4,speed = love.math.random(40, 60), pv = 4},
    {unlocked_at = 10, cooldown = 3, speed = love.math.random(50, 70), pv = 5},
    {unlocked_at = 15, cooldown = 2, speed = love.math.random(50, 85), pv = 6},
    {unlocked_at = 20, cooldown = 2, speed = love.math.random(50, 85), pv = 7},
    {unlocked_at = 30, cooldown = 1, speed = love.math.random(50, 100), pv = 8},
}

-----------------------
-- Game initialization
-----------------------
function love.load()
    love.graphics.setColor( 255, 255, 255 )
    love.window.setTitle( "Box War" )

    w_width, w_height = love.window.getDimensions()

    -- Load graphic stuff
    background = love.graphics.newImage( "graphics/grass1.png" )
    g_box = love.graphics.newImage( "graphics/chest.png" )
    g_thief = love.graphics.newImage( "graphics/thief_small.png" )

    BOX_SIZE = g_box:getWidth()

    -- Randomly draw box
    x_box = love.math.random( (w_width - BOX_SIZE - PADDING_AREA) )
    y_box = love.math.random( PADDING_AREA, (w_height - BOX_SIZE - PADDING_AREA) )
end

-----------------------
-- Main logic update
-----------------------
function love.update(dt)
    if(game_state == 'run') then
        update_run(dt)
    elseif(game_state == 'lose') then
        update_lose()
    end
end

function update_run(dt)
    create_ennemy()
    move_ennemies(dt)
    TEsound.cleanup()
end

function update_lose()
end

-----------------------
-- Main draw/graphic update
-----------------------
function love.draw()
    render_background()
    render_hud()
    draw_box(x_box, y_box)
    render_thieves()
end

-----------------------
-- Keyboard events
-----------------------
function love.keypressed(key)
    if key == "e" then
        for i = 1, #ennemies, 1 do
            local thief = ennemies[i]
            thief.orientation = thief.orientation + math.pi
        end
    end
end

-----------------------
-- Mouse pressed event
-----------------------
function love.mousepressed(x, y, button)
   if button == 'l' and game_state == 'run' then
        attack_on(x, y)
   end
end

function attack_on(x, y)

    local one_dead = false

    -- Check if a thief is hit
    for i = 1, #ennemies, 1 do
        local thief = ennemies[i]

        if x > (thief.x - g_thief:getWidth()/2)
            and x < (thief.x + g_thief:getWidth()/2)
            and y > (thief.y - g_thief:getHeight()/2)
            and y < (thief.y + g_thief:getHeight()/2)
            then

            TEsound.play("sound_fx/hit.wav")
            thief:hurt(1)

            if thief.dead then
                one_dead = true
                TEsound.play("sound_fx/explosion.wav")
                killed_counter = killed_counter + 1
            end
        end
    end

    -- Clean dead entities
    if one_dead then
        ennemies = _.reject(ennemies, function(key, thief)
            return thief.dead
        end)

        apply_difficulty()  -- Check for difficulty progress
    end
end

function render_background()
    for i = 0, love.graphics.getWidth() / background:getWidth() do
        for j = 0, love.graphics.getHeight() / background:getHeight() do
            love.graphics.draw(background, i * background:getWidth(), j * background:getHeight())
        end
    end
end

function render_hud()
    love.graphics.print("Killed : " .. killed_counter .. " Thieves on map : " .. #ennemies, 10, 10)
end

function render_thieves()
    for i = 1, #ennemies, 1 do
        local thief = ennemies[i]
        love.graphics.draw( g_thief, thief.x, thief.y, thief.orientation, 1, 1, g_thief:getWidth()/2, g_thief:getHeight()/2 )
    end
end

function move_ennemies(dt)
    for i = 1, #ennemies, 1 do
        local thief = ennemies[i]
        thief:update_position(dt)

        if thief.stop then
            trigger_lose()
        end
    end
end

function trigger_lose()
    game_state = 'lose'
    TEsound.play("sound_fx/lose.wav")
end

function draw_box(x, y)
    love.graphics.draw( g_box, x, y, 0, 1, 1, g_box:getWidth()/2, g_box:getHeight()/2 )
end

function create_ennemy()

    if (time_ennemy_pop == nil) then
        time_ennemy_pop = love.timer.getTime()
    end

    local diff = love.timer.getTime() - time_ennemy_pop

    if( diff > apparation_cooldown ) then
        TEsound.play("sound_fx/thief_appears.wav")

        thief = Thief:new(ennemy_id)

        -- Apparation zone
        rand_zone = love.math.random(1, 4)
        birth_x = 0
        birth_y = 0

        if rand_zone == 1 then          -- North
            birth_y = 0
            birth_x = love.math.random(w_width)
        elseif rand_zone == 2 then     -- South
            birth_y = w_height
            birth_x = love.math.random(w_width)
        elseif rand_zone == 3 then     -- East
            birth_x = 0
            birth_y = love.math.random(w_height)
        else                            -- West
            birth_x = w_width
            birth_y = love.math.random(w_height)
        end

        thief.x = birth_x
        thief.y = birth_y
        thief:set_destination(x_box, y_box) -- Go and attack the chest !! >:)

        table.insert(ennemies, thief)

        ennemy_id = ennemy_id + 1

        time_ennemy_pop = love.timer.getTime()
    end
end

function apply_difficulty()
    _.each(difficulty_levels, function(k, v)
        if v.unlocked_at == killed_counter then
            TEsound.play("sound_fx/notify.wav")
            apparation_cooldown = v.cooldown
            Thief.static.default_speed = v.speed
            Thief.static.default_pv = v.pv
        end
    end)
end