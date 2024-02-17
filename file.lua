local file = {
    filePath = nil
}

function file:getFileTxtTable()
    local fileObj, err = io.open(self.filePath, "r")
    if fileObj == nil then
        print("The given path either don't exists or is not a file")
        print(err)
        love.event.quit(1)
        return { "" }
    else
        local newTxt = {}
        for line in fileObj:lines("*l") do
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
    local fileToSave, err = io.open(self.filePath, "w")
    if err then
        print(err)
    end

    local newStringContent = table.concat(txt, "\n")

    if fileToSave ~= nil then
        fileToSave:write(newStringContent, "\n")
        fileToSave:close()
    end
end

return file
