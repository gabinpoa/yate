local game = {
    cursor = {
        pos = 0,
        line = 1,
        x = 0,
        y = 0,
    },
    selection = {
        start = {
            pos = nil,
            line = nil,
            x = 0,
            y = 0,
        },
        closing = {
            pos = nil,
            line = nil,
            x = 0,
            y = 0,
        },
    },
    txt = {},
    padding = 0,
    lineHeight = 0,
}

function game:getCurrLineText()
    return self.txt[self.cursor.line]
end

function game:getCursorX()
    return love.graphics.getFont():getWidth(self.txt[self.cursor.line]:sub(0, self.cursor.pos)) + self.padding
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

function game:getSelectionX(extremity)
    return love.graphics.getFont():getWidth(self.txt[self.selection[extremity].line]:sub(0, self.selection[extremity]
            .pos)) +
        self.padding
end

function game:getSelectionY(extremity)
    return (self.selection[extremity].line - 1) * self.lineHeight + self.padding
end

function game:updateSelectionEnd()
    self.selection.closing.pos = self.cursor.pos
    self.selection.closing.line = self.cursor.line

    self.selection.closing.x = self:getSelectionX("closing")
    self.selection.closing.y = self:getSelectionY("closing")
end

function game:initSelect()
    self.selection.start.pos = self.cursor.pos
    self.selection.start.line = self.cursor.line

    self.selection.start.x = self:getSelectionX("start")
    self.selection.start.y = self:getSelectionY("start")
end

function game:exitSelect()
    self.selection.start.pos = nil
    self.selection.start.line = nil
    self.selection.closing.pos = nil
    self.selection.closing.line = nil
end

function game:removeSelected()
    local selection = self:getFirstLastPosLine()

    if selection.lines == 0 then
        game:removeOneLineSelected()
    else
        self.txt[selection.first.line] = self.txt[selection.first.line]:sub(0, selection.first.pos)
        for i = 1, selection.lines - 1 do
            table.remove(self.txt, selection.first.line + i)
            selection.last.line = selection.last.line - 1
        end
        self.txt[selection.first.line] = self.txt[selection.first.line] ..
            self.txt[selection.last.line]:sub(selection.last.pos + 1)
        table.remove(self.txt, selection.last.line)
        self.cursor.line = selection.first.line
        self.cursor.pos = selection.first.pos
        game:exitSelect()
        game:updateXYAxis()
    end
end

function game:removeOneLineSelected()
    local originalText = self.txt[self.selection.start.line]
    local newText
    if self.selection.start.pos < self.selection.closing.pos then
        newText = originalText:sub(0, self.selection.start.pos) ..
            originalText:sub(self.selection.closing.pos + 1)

        self:updateCursorAfterRemoveSelected(#originalText - #newText)
    else
        newText = originalText:sub(0, self.selection.closing.pos) ..
            originalText:sub(self.selection.start.pos + 1)
    end
    self.txt[self.selection.start.line] = newText
    self:exitSelect()
    self:updateXYAxis()
end

function game:updateCursorAfterRemoveSelected(textLengthDiff)
    self.cursor.pos = self.cursor.pos - textLengthDiff
end

function game:removeSelOrCurr()
    if self.selection.start.pos == nil then
        self:removeCurrChar()
    else
        self:removeSelected()
    end
end

function game:getLinesSelectedDiff()
    return self.selection.closing.line - self.selection.start.line
end

function game:getFirstLastPosLine()
    local diff = self:getLinesSelectedDiff()
    local first, last = self.selection.start, self.selection.closing
    if diff < 0 then
        first, last = last, first
        diff = diff * (-1)
    end
    return { lines = diff, first = first, last = last }
end

function game:getLineWidth(line)
    return love.graphics.getFont():getWidth(self.txt[line])
end

function game:getLineEndX(line)
    return love.graphics.getFont():getWidth(self.txt[line]) + self.padding
end

function game:drawSelection()
    local selection = self:getFirstLastPosLine()

    love.graphics.setColor(0, 10, 255, 0.4)

    if selection.lines == 0 then
        love.graphics.rectangle(
            "fill",
            selection.first.x,
            selection.first.y,
            selection.last.x - selection.first.x,
            self.lineHeight
        )
    else
        love.graphics.rectangle(
            "fill",
            selection.first.x,
            selection.first.y,
            self:getLineEndX(selection.first.line) - selection.first.x,
            self.lineHeight
        )
        local counter = selection.lines
        while counter > 1 do
            love.graphics.rectangle(
                "fill",
                self.padding,
                (selection.first.line + (selection.lines - counter + 1) - 1) * self.lineHeight + self.padding,
                self:getLineWidth(selection.first.line + (selection.lines - counter + 1)),
                self.lineHeight
            )
            counter = counter - 1
        end
        love.graphics.rectangle(
            "fill",
            selection.last.x,
            selection.last.y,
            self.padding - selection.last.x,
            self.lineHeight
        )
    end
end

function game:moveCursor(callback)
    local shiftIsDown = love.keyboard.isDown("lshift")

    if shiftIsDown and self.selection.start.pos ~= nil then
        callback()
        game:updateSelectionEnd()
    elseif shiftIsDown then
        game:initSelect()
        callback()
        game:updateSelectionEnd()
    else
        callback()
    end
    game:updateXYAxis()
end

return game
