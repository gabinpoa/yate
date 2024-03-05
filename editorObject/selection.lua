require("editorObject.defaults")

function Editor:getSelectionX(extremity)
    return love.graphics.getFont():getWidth(self.txt[self.selection[extremity].line]:sub(0, self.selection[extremity]
            .pos)) +
        self.padding
end

function Editor:getSelectionY(extremity)
    return (self.selection[extremity].line - 1) * self.lineHeight + self.padding
end

function Editor:updateSelectionEnd()
    self.selection.closing.pos = self.cursor.pos
    self.selection.closing.line = self.cursor.line

    self.selection.closing.x = self:getSelectionX("closing")
    self.selection.closing.y = self:getSelectionY("closing")
end

function Editor:initSelect()
    self.selection.start.pos = self.cursor.pos
    self.selection.start.line = self.cursor.line

    self.selection.start.x = self:getSelectionX("start")
    self.selection.start.y = self:getSelectionY("start")
end

function Editor:exitSelect()
    self.selection.start.pos = nil
    self.selection.start.line = nil
    self.selection.closing.pos = nil
    self.selection.closing.line = nil
end

function Editor:removeSelected()
    local selection = self:getFirstLastPosLine()

    if selection.lines == 0 then
        Editor:removeOneLineSelected()
    else
        self.txt[selection.first.line] = self.txt[selection.first.line]:sub(0, selection.first.pos)
        for i = 1, selection.lines - 1 do
            table.remove(self.txt, selection.first.line + i)
            selection.last.line = selection.last.line - 1
        end
        self.txt[selection.first.line] = self.txt[selection.first.line] ..
            self.txt[selection.last.line]:sub(selection.last.pos + 1)
        table.remove(self.txt, selection.last.line)
        self:unsafeSetCursorLine(selection.first.line)
        self:unsafeSetCursorPos(selection.first.pos)
        Editor:exitSelect()
        Editor:updateXYAxis()
    end
end

function Editor:removeOneLineSelected()
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

function Editor:updateCursorAfterRemoveSelected(textLengthDiff)
    self:unsafeSetCursorPos(self.cursor.pos - textLengthDiff)
end

function Editor:getLinesSelectedDiff()
    return self.selection.closing.line - self.selection.start.line
end

function Editor:getFirstLastPosLine()
    local diff = self:getLinesSelectedDiff()
    local first, last = self.selection.start, self.selection.closing
    if diff < 0 then
        first, last = last, first
        diff = diff * (-1)
    end
    return { lines = diff, first = first, last = last }
end

function Editor:drawSelection()
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
