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
    if game.selection.start.pos ~= nil then
        love.graphics.setColor(0, 0, 255, 0.4)
        love.graphics.rectangle("fill", game.selection.start.x, game.selection.start.y,
            game.selection.closing.x - game.selection.start.x, game.lineHeight + 2)
    end
end

function love.textinput(char)
    game:insertCharacter(char)
end

function love.keyreleased(key)
    if key == "lshift" and game.selection.start.pos ~= nil and game.selection.isMovingSelect == true then
        game:stopSelect()
    end
end

function love.keypressed(key)
    if keymaps[key] ~= nil then
        keymaps[key]()
    end
end
