function lineLen(line)
	return text[line]:len()
end

function currCursorX()
	return love.graphics.getFont():getWidth(text[cursor.line]:sub(1, cursor.pos)) + padding
end