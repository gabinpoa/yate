return {
    backspace = function(cursor, text)
        if cursor.pos - 1 > 0 then
            cursor.pos = cursor.pos - 1
            text[cursor.line] = text[cursor.line]:sub(1, cursor.pos) ..
                text[cursor.line]:sub(cursor.pos + 2, text[cursor.line]:len())
        elseif cursor.pos == 1 then
            cursor.pos = 0
            text[cursor.line] = ""
        elseif cursor.pos == 0 and cursor.line - 1 > 0 then
            table.remove(text, cursor.line)
            text.n = text.n - 1
            cursor.line = cursor.line - 1
            cursor.pos = text[cursor.line]:len()
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
    end
}
