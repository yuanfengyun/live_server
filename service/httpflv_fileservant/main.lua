local skynet = require "skynet"

local header = nil
local tags = {}
local clients = {}

local CMD = {}

function CMD.start(filename)
    local file = io.open (filename,"rb")
    header = file.read(9)
    if not header then
        return false
    end

    skynet.timeout(2,function()
        local tag_header = file.read(11)
        local tag_data_len = string.byte(tag_header.sub(tag_header,2,5))
        local tag_data = file.read(tag_data_len+4)
        table.insert(tags,tag_header..tag_data)
    end)

    skynet.timeout(10,function()
        local t = tags
        tags = {}
        for k,v in pairs(t) do
            skynet.send(k,"lua","tag_data",tags)
        end
    end)
end

function CMD.register_client(source)
    clients[source] = true
    return header
end

skynet.start(function()
    skynet.dispatch("lua",function(session,source,cmd,...)

    end)
end)

