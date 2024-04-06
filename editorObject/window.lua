require("editorObject.defaults")

function Editor:initWindow()
    self.window.visibleLines = math.floor((self.window.height - (self.padding * 2)) / self.lineHeight)
    self:initLimitLines()
    self:updateLimitLines()
end

function Editor:initLimitLines()
    self.window.startLine = 1
    self.window.endLine = self.window.visibleLines
end

function Editor:updateLimitLines()
    if self.cursor.line > self.window.endLine then
        self.window.startLine = math.max(1, self.cursor.line - self.window.visibleLines + 1)
        self.window.endLine = self.cursor.line
    elseif self.cursor.line < self.window.startLine then
        self.window.startLine = self.cursor.line
        self.window.endLine = self.window.startLine + self.window.visibleLines - 1
    end
    if self.cursor.pos > self.window.startPos + self.window.visibleChars - 1 then
        self.window.startPos = self.cursor.pos - self.window.visibleChars + 1
    elseif self.cursor.pos < self.window.startPos then
        self.window.startPos = self.cursor.pos + 1
    end
    self.window.visibleLines = self.window.endLine - self.window.startLine + 1

    self.visibleText = self:getVisibleText()
end

function Editor:getVisibleText()
    local txt = {}

    for index, value in ipairs(self.txt) do
        if index >= self.window.startLine and index <= self.window.endLine then
            table.insert(txt, value:sub(self.window.startPos, self.window.startPos + self.window.visibleChars - 1))
        end
    end

    return txt
end

function Editor:getLineWidth(line)
    return love.graphics.getFont():getWidth(self.txt[line])
end

function Editor:getLineEndX(line)
    return love.graphics.getFont():getWidth(self.txt[line]) + self.padding
end

function Editor:displayTextLineByLine()
    for i, line in pairs(self.visibleText) do
        if #line > 0 then
            local lineColor = { 1, 1, 1 }

            if string.match(line, "(%-%-.+)") then
                lineColor = { 0.8, 0.8, 1.0 }
            end

            love.graphics.setColor(lineColor)
            love.graphics.print(line, self.padding, self.padding + ((i - 1) * self.lineHeight))
        end
    end
end
