local game    = require("gameobj")
local keymaps = require("keymaps")
local file    = require("file")

function love.load(args)
    local filePath = args[1]
    game.txt = file.getFileTxtTable(filePath)

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
        game:drawSelection()
    end
end

function love.textinput(char)
    game:insertCharacter(char)
end

function love.keypressed(key)
    if game.selection.start.pos ~= nil and not love.keyboard.isDown("lshift") and key ~= "backspace" then
        game:exitSelect()
    elseif keymaps[key] ~= nil then
        keymaps[key]()
    end
end
