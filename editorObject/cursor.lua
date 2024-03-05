require("editorObject.defaults")

function Editor:getCurrLineText()
    return self.txt[self.cursor.line]
end

function Editor:getCursorX()
    return love.graphics.getFont():getWidth(self.txt[self.cursor.line]:sub(0, self.cursor.pos)) + self.padding
end

function Editor:getCursorY()
    return (self.cursor.line - self.window.startLine) * self.lineHeight + self.padding
end

function Editor:updateXYAxis()
    self.cursor.x = self:getCursorX()
    self.cursor.y = self:getCursorY()
end

function Editor:setCursorPos(num)
    local newPos = self.cursor.pos + num
    if newPos > self:currLineLen() and self.cursor.line < #self.txt then
        newPos = 0
        self.cursor.line = self.cursor.line + 1
    elseif newPos < 0 and self.cursor.line > 1 then
        self.cursor.line = self.cursor.line - 1
        newPos = self:currLineLen()
    end
    self.cursor.pos = newPos
    self:updateXYAxis()
    self:updateLimitLines()
end

function Editor:unsafeSetCursorPos(pos)
    self.cursor.pos = pos
    self:updateLimitLines()
end

function Editor:setCursorLine(num)
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
    self:updateLimitLines()
end

function Editor:unsafeSetCursorLine(line)
    self.cursor.line = line
    self:updateLimitLines()
end

function Editor:moveCursor(callback)
    local shiftIsDown = love.keyboard.isDown("lshift")

    if shiftIsDown and self.selection.start.pos ~= nil then
        callback()
        Editor:updateSelectionEnd()
    elseif shiftIsDown then
        Editor:initSelect()
        callback()
        Editor:updateSelectionEnd()
    else
        callback()
    end
    Editor:updateXYAxis()
end
