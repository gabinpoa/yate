require "lua.coreFunctions"
keymaps = {}

function keymaps.backspace ()
    if cursor.pos - 1 > 0 then
        cursor.pos = cursor.pos - 1
        text[cursor.line] = text[cursor.line]:sub(1, cursor.pos) ..
        text[cursor.line]:sub(cursor.pos + 2, lineLen(cursor, text))
    elseif cursor.pos == 1 then
        local lineTextAfterRemove = ""
        if lineLen(cursor, text) > 0 then
            lineTextAfterRemove = text[cursor.line]:sub(cursor.pos + 1, lineLen(cursor, text))
        end
        cursor.pos = 0
        text[cursor.line] = lineTextAfterRemove
    elseif cursor.pos == 0 and cursor.line - 1 > 0 then
        cursor.pos = text[cursor.line - 1]:len()
        if lineLen(cursor, text) > 0 then
            text[cursor.line - 1] = text[cursor.line - 1] .. text[cursor.line]
        end
        table.remove(text, cursor.line)
        text.n = text.n - 1
        cursor.line = cursor.line - 1
    end
end

function keymaps.left()
    if cursor.pos - 1 < 0 and cursor.line - 1 > 0 then
        cursor.line = cursor.line - 1
        cursor.pos = lineLen(cursor, text)
    elseif cursor.pos - 1 >= 0 then
        cursor.pos = cursor.pos - 1
    end
end

function keymaps.right()
    if love.keyboard.isDown("lshift") then
            cursor.selStart.pos = cursor.pos + 1
            cursor.selStart.line = cursor.line
    end
    if cursor.pos + 1 > lineLen(cursor, text) and cursor.line + 1 <= text.n then    
        cursor.pos = 0
        cursor.line = cursor.line + 1
    elseif cursor.pos + 1 <= lineLen(cursor, text) then
        cursor.pos = cursor.pos + 1
    end
end

function keymaps.up()
    if cursor.line - 1 > 0 then
        cursor.line = cursor.line - 1
        if cursor.pos > lineLen(cursor, text) then
            cursor.pos = lineLen(cursor, text)
        end
    end
end

function keymaps.down()
    if cursor.line + 1 <= text.n then
        cursor.line = cursor.line + 1
        if cursor.pos > lineLen(cursor, text) then
            cursor.pos = lineLen(cursor, text)
        end
    end
end

keymaps["end"] = function ()
    cursor.pos = lineLen(cursor, text)
end

function keymaps.home()
    cursor.pos = 0
end

keymaps["return"] = function()
    local newLineText = ""
    if cursor.pos < lineLen(cursor, text) then
        newLineText = text[cursor.line]:sub(cursor.pos + 1, lineLen(cursor, text))
        text[cursor.line] = text[cursor.line]:sub(1, cursor.pos)
    end
    table.insert(text, cursor.line + 1, newLineText)
    cursor.line = cursor.line + 1
    cursor.pos = 0
    text.n = text.n + 1
end

return keymaps