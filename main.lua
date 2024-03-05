Editor        = require("editorObject")
local keymaps = require("keymaps")
local file    = require("file")

function love.load(args)
    local filePath = args[1]
    if filePath ~= nil then
        file:openFile(filePath)
        if not Editor.txt or #Editor.txt == 0 then
            print("O arquivo está vazio e não pôde ser aberto")
            love.event.quit(1)
        else
            love.keyboard.setKeyRepeat(true)
            love.graphics.setNewFont("JetBrainsMono-Regular.ttf", 14)

            Editor.lineHeight = love.graphics.getFont():getHeight()
            Editor.padding = 12
            love.window.setMode(Editor.window.height, Editor.window.width)
            Editor:initWindow()
            Editor:updateXYAxis()
        end
    else
        Editor.txt = {
            "Please give the file path when calling the game",
            "Ex:",
            "love . /filePath/file.lua"
        }
    end
end

function love.draw()
    love.graphics.setColor(255, 255, 255)
    Editor:displayTextLineByLine()
    love.graphics.line(Editor.cursor.x, Editor.cursor.y, Editor.cursor.x, Editor.cursor.y + Editor.lineHeight)
    if Editor.selection.start.pos ~= nil then
        Editor:drawSelection()
    end
end

function love.textinput(char)
    Editor:insertCharacter(char)
end

function love.keypressed(key)
    if Editor.selection.start.pos ~= nil and not love.keyboard.isDown("lshift") and key ~= "backspace" then
        Editor:exitSelect()
    elseif keymaps[key] ~= nil then
        keymaps[key]()
    end
end
