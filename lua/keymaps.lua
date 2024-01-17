return {
    backspace = function (cursor, text)
        if cursor.pos -1 >= 1 then
            cursor.pos = cursor.pos - 1
            text[cursor.line] = text[cursor.line]:sub(1, cursor.pos) .. text[cursor.line]:sub(cursor.pos+2, text[cursor.line]:len())
        end
    end,
    left = function (cursor, text)
        if cursor.pos -1 < 1 and cursor.line -1 > 0 then
            cursor.line = cursor.line -1
            cursor.pos = text[cursor.line]:len()
        elseif cursor.pos -1 >= 1 then
            cursor.pos = cursor.pos - 1
        end
    end,
    right = function (cursor, text)
        if cursor.pos + 1 > text[cursor.line]:len() and cursor.line +1 <= text.n then
            cursor.pos = 1
            cursor.line = cursor.line + 1
        elseif cursor.pos + 1 <= text[cursor.line]:len() then
            cursor.pos = cursor.pos + 1
        end
    end
}