require("editorObject")
local file = {
    filePath = nil
}

function file:openFile(path)
    Editor.txt = self:getFileTxtTable(path)
end

function file:getFileTxtTable(path)
    local fileObj, err = io.open(path, "r")

    local newTxt = {}

    if fileObj == nil then
        print("The given path either don't exists or is not a file")
        print(err)
        love.event.quit(1)
        return newTxt
    else
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
