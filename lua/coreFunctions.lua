function lineLen(line)
    return text[line]:len()
end

function currCursorX()
    return love.graphics.getFont():getWidth(text[cursor.line]:sub(1, cursor.pos)) + padding
end

function selectStartX()
    return love.graphics.getFont():getWidth(text[cursor.selStart.line]:sub(1, cursor.selStart.pos)) + padding
end

