require("editorObject.defaults")

function Editor:removeCurrChar()
    local originalText = self:getCurrLineText()
    local originalLine = self.cursor.line
    local originalPos = self.cursor.pos
    if originalPos > 0 then
        self:setCursorPos(-1)
        self.txt[originalLine] = originalText:sub(0, originalPos - 1) .. originalText:sub(originalPos + 1)
    elseif originalLine > 1 then
        self:setCursorPos(-1)
        self.txt[self.cursor.line] = self:getCurrLineText() .. originalText
        table.remove(self.txt, originalLine)
    end
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
    self:unsafeSetCursorPos(0)
    self:unsafeSetCursorLine(self.cursor.line + 1)
    self:updateXYAxis()
end

function Editor:insertCharacter(char)
    local originalText = self:getCurrLineText()
    local newText = originalText:sub(0, self.cursor.pos) .. char .. originalText:sub(self.cursor.pos + 1)

    self.txt[self.cursor.line] = newText
    self:unsafeSetCursorPos(self.cursor.pos + 1)
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
