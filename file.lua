local file = {}

function file.getFileTxtTable(filepath)
    local newTxt = {}
    for line in io.lines(filepath, "l") do
        if line ~= nil then
            table.insert(newTxt, line)
        else
            break
        end
    end
    return newTxt
end

return file
