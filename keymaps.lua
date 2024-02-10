local game = require "gameobj"
local keymaps = {}

function keymaps.backspace()
    game:removeCurrChar()
end

function keymaps.left()
    if love.keyboard.isDown("lshift") then
        game:initSelect()
    end
    game:setCursorPos(-1)
end

function keymaps.right()
    if love.keyboard.isDown("lshift") then
        game:initSelect()
    end
    game:setCursorPos(1)
end

function keymaps.up()
    if love.keyboard.isDown("lshift") then
        game:initSelect()
    end
    game:setCursorLine(-1)
end

function keymaps.down()
    if love.keyboard.isDown("lshift") then
        game:initSelect()
    end
    game:setCursorLine(1)
end

keymaps["end"] = function()
    if love.keyboard.isDown("lshift") then
        game:initSelect()
    end
    game.cursor.pos = game:currLineLen()
    game:updateXYAxis()
end

function keymaps.home()
    if love.keyboard.isDown("lshift") then
        game:initSelect()
    end
    game.cursor.pos = 0
    game:updateXYAxis()
end

keymaps["return"] = function()
    game:addNewLine()
end

return keymaps
