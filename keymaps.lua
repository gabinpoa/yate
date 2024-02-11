local game = require "gameobj"
local keymaps = {}

function keymaps.backspace()
    game:removeSelOrCurr()
end

function keymaps.left()
    game:moveCursor(function()
        game:setCursorPos(-1)
    end)
end

function keymaps.right()
    game:moveCursor(function()
        game:setCursorPos(1)
    end)
end

function keymaps.up()
    game:moveCursor(function()
        game:setCursorLine(-1)
    end)
end

function keymaps.down()
    game:moveCursor(function()
        game:setCursorLine(1)
    end)
end

keymaps["end"] = function()
    game:moveCursor(function()
        game.cursor.pos = game:currLineLen()
    end)
end

function keymaps.home()
    game:moveCursor(function()
        game.cursor.pos = 0
    end)
end

keymaps["return"] = function()
    game:addNewLine()
end

return keymaps
