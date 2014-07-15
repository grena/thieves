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

function love.load()
    love.graphics.setColor( 255, 255, 255 )
    love.window.setTitle( "Box War" )

    w_width, w_height = love.window.getDimensions()

    background = love.graphics.newImage( "graphics/grass1.png" )
    da_box = love.graphics.newImage( "graphics/chest.png" )
    g_thief = love.graphics.newImage( "graphics/thief.png" )

    BOX_SIZE = da_box:getWidth()

    -- Randomly draw box
    x_box = love.math.random( (w_width - BOX_SIZE - PADDING_AREA) )
    y_box = love.math.random( PADDING_AREA, (w_height - BOX_SIZE) )
end

function love.update(dt)
    create_ennemy()
    move_ennemies()
    TEsound.cleanup()
end

function love.draw()
    render_background()
    render_hud()
    draw_box(x_box, y_box)
    render_thieves()
end

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
        love.graphics.draw( g_thief, thief.x, thief.y, thief.orientation, 0.3, 0.3 )
    end
end

function move_ennemies()
    for i = 1, table.getn(ennemies), 1 do
        local thief = ennemies[i]

        if(thief.x == x_box and thief.y == y_box) then goto continue end

        thief.x = thief.x + (0.1 * thief.speed)
        thief.y = thief.y + (0.1 * thief.speed)

        ::continue::
    end
end

function draw_box(x, y)
    love.graphics.draw( da_box, x, y )
end

function create_ennemy()

    if (time_ennemy_pop == nil) then
        time_ennemy_pop = love.timer.getTime()
    end

    local diff = love.timer.getTime() - time_ennemy_pop

    if( diff > apparation_cooldown ) then
        TEsound.play("sound_fx/thief_appears.wav")

        thief = Thief:new(ennemy_id, love.math.random(10))
        thief.x = love.math.random(50)
        thief.y = love.math.random(50)

        table.insert(ennemies, thief)

        ennemy_id = ennemy_id + 1

        time_ennemy_pop = love.timer.getTime()
    end
end