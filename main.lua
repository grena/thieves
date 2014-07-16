require "TEsound"
require "thief"
require "collection"

BOX_SIZE = 48
PADDING_AREA = 50   -- Padding top area to display HUD

ennemies = {}
killed_counter = 0
ennemy_id = 1               -- Incremential id of ennemies
apparation_cooldown = 5    -- Seconds before an ennemy appears
time_ennemy_pop = nil

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
    g_thief = love.graphics.newImage( "graphics/thief.png" )

    BOX_SIZE = g_box:getWidth()

    -- Randomly draw box
    x_box = love.math.random( (w_width - BOX_SIZE - PADDING_AREA) )
    y_box = love.math.random( PADDING_AREA, (w_height - BOX_SIZE) )
end

-----------------------
-- Main logic update
-----------------------
function love.update(dt)
    create_ennemy()
    move_ennemies(dt)
    TEsound.cleanup()
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
        for i = 1, table.getn(ennemies), 1 do
            local thief = ennemies[i]
            thief.orientation = thief.orientation + math.pi
        end
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
    love.graphics.print("Killed : " .. killed_counter .. " count = " .. table.getn(ennemies), 10, 10)
end

function render_thieves()
    for i = 1, table.getn(ennemies), 1 do
        local thief = ennemies[i]
        love.graphics.draw( g_thief, thief.x, thief.y, thief.orientation, 0.3, 0.3, g_thief:getWidth()/2, g_thief:getHeight()/2 )
    end
end

function move_ennemies(dt)
    for i = 1, table.getn(ennemies), 1 do
        local thief = ennemies[i]
        thief:update_position(dt)
    end
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

        thief = Thief:new(ennemy_id, love.math.random(50, 100))

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
        thief:set_destination(x_box, y_box)

        table.insert(ennemies, thief)

        ennemy_id = ennemy_id + 1

        time_ennemy_pop = love.timer.getTime()
    end
end