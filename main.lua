local Game  = require 'game'
local HUD   = require 'hud'

function love.load()

    love.window.setTitle( 'Thieves !' )

    global = {}

    -- Gamestate
    global.gamestate = 'run'

    -- Graphic stuff
    global.graphics = {
        backgrounds = {
            {
                love.graphics.newImage( 'gfx/grass1.png' ),
                love.graphics.newImage( 'gfx/grass2.png' )
            }
            -- ,
            -- {
            --     love.graphics.newImage( 'gfx/sand1.png' ),
            --     love.graphics.newImage( 'gfx/sand2.png' )
            -- }
        },
        entities = {
            chest = love.graphics.newImage( 'gfx/chest.png' ),
            thief = love.graphics.newImage( 'gfx/thief_small.png' )
        }
    }

    -- Sound stuff
    global.sounds = {
        hit = love.audio.newSource( 'sfx/hit.wav', 'static' ),
        killed = love.audio.newSource( 'sfx/explosion.wav', 'static' ),
        chest = love.audio.newSource( 'sfx/lose.wav', 'static' ),
        thief_appears = love.audio.newSource( 'sfx/thief_appears.wav', 'static' ),
        lose = love.audio.newSource( 'sfx/lose.wav', 'static' )
    }

    -- Game parameters
    global.game_parameters = {
        chest_padding = {
            x = 200,
            y = 100
        }
    }

    global.game = Game:new(global)
    global.hud = HUD:new(global)
end

function love.update(dt)
    if(global.gamestate == 'run') then
        global.game:update(dt)
    end
end

function love.draw()

    -- Render game
    global.game:draw()

    -- Then render HUD
    global.hud:draw()
end

function love.mousepressed(x, y, button)
    if global.gamestate == 'run' then
        global.game:mousepressed(x, y, button)
    end
end