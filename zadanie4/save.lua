local json = require("dkjson")  
local Save = {}
local SAVE_FILE = "save.json"

function Save.save(data)
    local str = json.encode(data, { indent = true })
    love.filesystem.write(SAVE_FILE, str)
end

function Save.load()
    if love.filesystem.getInfo(SAVE_FILE) then
        local str = love.filesystem.read(SAVE_FILE)
        return json.decode(str)
    end
    return nil
end

return Save
