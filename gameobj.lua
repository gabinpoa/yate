local game = {
    cursor = {
        pos = 0,
        line = 1,
        x = 0,
        y = 0,
        selStart = {
            pos = nil,
            line = nil,
        },
    },
    txt = {
        "hey guys",
        "its me"
    },
    padding = 0,
    lineHeight = 0,
}

function game:getCurrLineText()
    return self.txt[self.cursor.line]
end

function game:getCursorX()
    return love.graphics.getFont():getWidth(self.txt[self.cursor.line]:sub(1, self.cursor.pos)) + self.padding
end

function game:getCursorY()
    return (self.cursor.line - 1) * self.lineHeight + self.padding
end

function game:currLineLen()
    return #self.txt[self.cursor.line]
end

function game:updateXYAxis()
    self.cursor.x = self:getCursorX()
    self.cursor.y = self:getCursorY()
end

function game:setCursorPos(num)
    local newPos = self.cursor.pos + num
    if newPos > self:currLineLen() and self.cursor.line < #self.txt then
        newPos = 0
        self.cursor.line = self.cursor.line + 1
    elseif newPos < 0 and self.cursor.line > 1 then
        self.cursor.line = self.cursor.line - 1
        newPos = self:currLineLen()
    elseif newPos < 0 or newPos > self:currLineLen() then
        newPos = self.cursor.pos
    end
    self.cursor.pos = newPos
    self:updateXYAxis()
end

function game:setCursorLine(num)
    local newLine = self.cursor.line + num
    local newPos = self.cursor.pos
    if newLine < 1 or newLine > #self.txt then
        newLine = self.cursor.line
    end
    self.cursor.line = newLine
    if newPos > self:currLineLen() then
        newPos = self:currLineLen()
    end
    self.cursor.pos = newPos
    self:updateXYAxis()
end

function game:removeCurrChar()
    local originalText = self:getCurrLineText()
    local originalLine = self.cursor.line
    local originalPos = self.cursor.pos
    self:setCursorPos(-1)
    if originalPos > 0 then
        self.txt[originalLine] = originalText:sub(0, originalPos - 1) .. originalText:sub(originalPos + 1)
    elseif originalLine > 1 then
        self.txt[self.cursor.line] = self:getCurrLineText() .. originalText
        table.remove(self.txt, originalLine)
    end
end

function game:addNewLine()
    local newLineText = (function()
        if self.cursor.pos == self:currLineLen() then
            return ""
        else
            local originalText = self:getCurrLineText()

            self.txt[self.cursor.line] = originalText:sub(0, self.cursor.pos)

            return originalText:sub(self.cursor.pos + 1)
        end
    end)()
    table.insert(self.txt, self.cursor.line + 1, newLineText)
    self.cursor.pos = 0
    self.cursor.line = self.cursor.line + 1
    self:updateXYAxis()
end

function game:insertCharacter(char)
    local originalText = self:getCurrLineText()
    local newText = originalText:sub(0, self.cursor.pos) .. char .. originalText:sub(self.cursor.pos + 1)

    self.txt[self.cursor.line] = newText
    self.cursor.pos = self.cursor.pos + 1
    self:updateXYAxis()
end

return game
