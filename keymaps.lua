require "coreFunctions"
local game = require "gameobj"
local keymaps = {}

function keymaps.backspace()
    game:removeCurrChar()
end

function keymaps.left()
    game:setCursorPos(-1)
end

function keymaps.right()
    game:setCursorPos(1)
end

function keymaps.up()
    game:setCursorLine(-1)
end

function keymaps.down()
    game:setCursorLine(1)
end

keymaps["end"] = function()
    game.cursor.pos = game:currLineLen()
    game:updateXYAxis()
end

function keymaps.home()
    game.cursor.pos = 0
    game:updateXYAxis()
end

keymaps["return"] = function()
    game:addNewLine()
end

return keymaps
