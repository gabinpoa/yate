require("editorObject.defaults")

function Editor:removeCurrChar()
    local originalText = self:getCurrLineText()
    local originalLine = self.cursor.line
    local originalPos = self.cursor.pos
    local newPos
    local newLine
    if originalPos > 0 then
        self.txt[originalLine] = originalText:sub(0, originalPos - 1) .. originalText:sub(originalPos + 1)
        newPos = originalPos - 1
        newLine = originalLine
    elseif originalLine > 1 then
        newPos = self:getSomeLineLen(originalLine - 1)
        newLine = originalLine - 1
        self.txt[originalLine - 1] = self:getLineText(originalLine - 1) .. originalText
        table.remove(self.txt, originalLine)
    end
    self:moveCursor(function()
        self:unsafeSetCursorPos(newPos)
        self:unsafeSetCursorLine(newLine)
    end)
end

function Editor:addNewLine()
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
    self:moveCursor(function()
        self:unsafeSetCursorPos(0)
        self:unsafeSetCursorLine(self.cursor.line + 1)
    end)
    self:updateXYAxis()
end

function Editor:insertCharacter(char)
    local originalText = self:getCurrLineText()
    local newText = originalText:sub(0, self.cursor.pos) .. char .. originalText:sub(self.cursor.pos + 1)

    self.txt[self.cursor.line] = newText
    self:moveCursor(function()
        self:unsafeSetCursorPos(self.cursor.pos + 1)
    end)
    self:updateXYAxis()
end

function Editor:removeSelOrCurr()
    if self.selection.start.pos == nil then
        self:removeCurrChar()
    else
        self:removeSelected()
    end
end

function Editor:currLineLen()
    return #self.txt[self.cursor.line]
end

function Editor:getSomeLineLen(line)
    return #self.txt[line]
end
