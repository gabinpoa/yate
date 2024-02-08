require "lua.coreFunctions"
keymaps = {}

function keymaps.backspace (cursor, txt)
    if cursor.pos - 1 > 0 then
        cursor.pos = cursor.pos - 1
        txt[cursor.line] = txt[cursor.line]:sub(1, cursor.pos) ..
        txt[cursor.line]:sub(cursor.pos + 2, lineLen(cursor, txt))
    elseif cursor.pos == 1 then
        local lineTextAfterRemove = ""
        if lineLen(cursor, txt) > 0 then
            lineTextAfterRemove = txt[cursor.line]:sub(cursor.pos + 1, lineLen(cursor, txt))
        end
        cursor.pos = 0
        txt[cursor.line] = lineTextAfterRemove
    elseif cursor.pos == 0 and cursor.line - 1 > 0 then
        cursor.pos = txt[cursor.line - 1]:len()
        if lineLen(cursor, txt) > 0 then
            txt[cursor.line - 1] = txt[cursor.line - 1] .. txt[cursor.line]
        end
        table.remove(txt, cursor.line)
        txt.n = txt.n - 1
        cursor.line = cursor.line - 1
    end
end

function keymaps.left(cursor, txt)
    if cursor.pos - 1 < 0 and cursor.line - 1 > 0 then
        cursor.line = cursor.line - 1
        cursor.pos = lineLen(cursor, txt)
    elseif cursor.pos - 1 >= 0 then
        cursor.pos = cursor.pos - 1
    end
end

function keymaps.right(cursor, txt)
    if love.keyboard.isDown("lshift") then
            cursor.selStart.pos = cursor.pos + 1
            cursor.selStart.line = cursor.line
    end
    if cursor.pos + 1 > lineLen(cursor, txt) and cursor.line + 1 <= txt.n then    
        cursor.pos = 0
        cursor.line = cursor.line + 1
    elseif cursor.pos + 1 <= lineLen(cursor, txt) then
        cursor.pos = cursor.pos + 1
    end
end

function keymaps.up(cursor, txt)
    if cursor.line - 1 > 0 then
        cursor.line = cursor.line - 1
        if cursor.pos > lineLen(cursor, txt) then
            cursor.pos = lineLen(cursor, txt)
        end
    end
end

function keymaps.down(cursor, txt)
    if cursor.line + 1 <= txt.n then
        cursor.line = cursor.line + 1
        if cursor.pos > lineLen(cursor, txt) then
            cursor.pos = lineLen(cursor, txt)
        end
    end
end

keymaps["end"] = function (cursor, txt)
    cursor.pos = lineLen(cursor, txt)
end

function keymaps.home(cursor, _)
    cursor.pos = 0
end

keymaps["return"] = function(cursor, txt)
    local newLineText = ""
    if cursor.pos < lineLen(cursor, txt) then
        newLineText = txt[cursor.line]:sub(cursor.pos + 1, lineLen(cursor, txt))
        txt[cursor.line] = txt[cursor.line]:sub(1, cursor.pos)
    end
    table.insert(txt, cursor.line + 1, newLineText)
    cursor.line = cursor.line + 1
    cursor.pos = 0
    txt.n = txt.n + 1
end

return keymaps