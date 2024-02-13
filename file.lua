local file = {
    filePath = nil
}

function file:getFileTxtTable()
    local fileInfo = love.filesystem.getInfo(self.filePath, "file")
    if fileInfo == nil then
        print("The given path either don't exists or is not a file")
        love.event.quit(0)
    else
        local newTxt = {}
        for line in io.lines(self.filePath, "l") do
            if line ~= nil then
                table.insert(newTxt, line)
            else
                break
            end
        end
        return newTxt
    end
end

function file:save(txt)
    local fileToSave = io.open(self.filePath, "w")

    local newStringContent = table.concat(txt, "\n")

    if fileToSave ~= nil then
        fileToSave:write(newStringContent, "\n")
        fileToSave:close()
    end
end

return file
