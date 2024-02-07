return {
    backspace = function(cursor, text)
        if cursor.pos - 1 > 0 then
            cursor.pos = cursor.pos - 1
            text[cursor.line] = text[cursor.line]:sub(1, cursor.pos) ..
                text[cursor.line]:sub(cursor.pos + 2, text[cursor.line]:len())
        elseif cursor.pos == 1 then
            local lineTextAfterRemove = ""
            if text[cursor.line]:len() > 0 then
                lineTextAfterRemove = text[cursor.line]:sub(cursor.pos + 1, text[cursor.line]:len())
            end
            cursor.pos = 0
            text[cursor.line] = lineTextAfterRemove
        elseif cursor.pos == 0 and cursor.line - 1 > 0 then
            cursor.pos = text[cursor.line - 1]:len()
            if text[cursor.line]:len() > 0 then
                text[cursor.line - 1] = text[cursor.line - 1] .. text[cursor.line]
            end
            table.remove(text, cursor.line)
            text.n = text.n - 1
            cursor.line = cursor.line - 1
        end
    end,
    left = function(cursor, text)
        if cursor.pos - 1 < 0 and cursor.line - 1 > 0 then
            cursor.line = cursor.line - 1
            cursor.pos = text[cursor.line]:len()
        elseif cursor.pos - 1 >= 0 then
            cursor.pos = cursor.pos - 1
        end
    end,
    right = function(cursor, text)
        if cursor.pos + 1 > text[cursor.line]:len() and cursor.line + 1 <= text.n then
            cursor.pos = 0
            cursor.line = cursor.line + 1
        elseif cursor.pos + 1 <= text[cursor.line]:len() then
            cursor.pos = cursor.pos + 1
        end
    end,
    up = function(cursor, text)
        if cursor.line - 1 > 0 then
            cursor.line = cursor.line - 1
            if cursor.pos > text[cursor.line]:len() then
                cursor.pos = text[cursor.line]:len()
            end
        end
    end,
    down = function(cursor, text)
        if cursor.line + 1 <= text.n then
            cursor.line = cursor.line + 1
            if cursor.pos > text[cursor.line]:len() then
                cursor.pos = text[cursor.line]:len()
            end
        end
    end,
    ["end"] = function(cursor, text)
        cursor.pos = text[cursor.line]:len()
    end,
    home = function(cursor, _)
        cursor.pos = 0
    end,
    ["return"] = function(cursor, text)
        local newLineText = ""
        if cursor.pos < text[cursor.line]:len() then
            newLineText = text[cursor.line]:sub(cursor.pos + 1, text[cursor.line]:len())
            text[cursor.line] = text[cursor.line]:sub(1, cursor.pos)
        end
        table.insert(text, cursor.line + 1, newLineText)
        cursor.line = cursor.line + 1
        cursor.pos = 0
        text.n = text.n + 1
    end
}
