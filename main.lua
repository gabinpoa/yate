local game = require "gameobj"
local keymaps = require "keymaps"

function love.load()
    love.keyboard.setKeyRepeat(true)
    love.graphics.setNewFont("JetBrainsMono-Regular.ttf", 14)

    game.lineHeight = love.graphics.getFont():getHeight()
    game.padding = 12
    game:updateXYAxis()
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    love.graphics.print(table.concat(game.txt, "\n"), game.padding, game.padding)
    love.graphics.line(game.cursor.x, game.cursor.y, game.cursor.x, game.cursor.y + game.lineHeight)
end

function love.keypressed(key)
    if keymaps[key] ~= nil then
        keymaps[key]()
    end
end
