local game = require "gameobj"
local file = require "file"
local keymaps = {}

-- cursor movements

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

-- text content interaction

function keymaps.backspace()
    game:removeSelOrCurr()
end

keymaps["return"] = function()
    game:addNewLine()
end

-- filesystem interaction

function keymaps.s()
    if love.keyboard.isDown("lctrl") then
        file:save(game.txt)
    end
end

return keymaps
