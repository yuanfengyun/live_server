local skynet = require "skynet"
local socket = require "skynet.socket"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local urllib = require "http.url"
local table = table
local string = string

local function response(id, write, ...)
    local ok, err = httpd.write_response(write, ...)
    if not ok then
        -- if err == sockethelper.socket_error , that means socket closed.
        skynet.error(string.format("fd = %d, %s", id, err))
    end
end

local cfg = {}

local hosts = {}
local header = {}
local flv_header = nil
local flv_tags = {}
local clients = {}

local CMD = {}

function CMD.start(conf)
    if not conf then
        return false
    end

    cfg = conf
end

function CMD.tag_data(tags)
    for i,v in pairs(tags) do
        table.insert(flv_tags,v)
    end
end

function CMD.handler_http(id)
    socket.start(id)
    local read = sockethelper.readfunc(id)
    local write = sockethelper.writefunc(id)
    -- limit request body size to 8192 (you can pass nil to unlimit)
    local code, url, method, header, body = httpd.read_request(read, 8192)
    if not code or code ~= 200 then
        socket.close(id)
        return
    end

    local client = {}
            if header.host then
                table.insert(tmp, string.format("host: %s", header.host))
            end
            local path, query = urllib.parse(url)
            table.insert(tmp, string.format("path: %s", path))
            if query then
                local q = urllib.parse_query(query)
                for k, v in pairs(q) do
                    table.insert(tmp, string.format("query: %s= %s", k,v))
                end
            end
            table.insert(tmp, "-----header----")
            for k,v in pairs(header) do
                table.insert(tmp, string.format("%s = %s",k,v))
            end
            table.insert(tmp, "-----body----\n" .. body)
            response(id, write, code, table.concat(tmp,"\n"))
        end
    socket.close(id)
end

skynet.start(function()
    skynet.dispatch("lua", function (session,source,cmd,...)
        if not cmd then
            return
        end

        local f = CMD[cmd]
        if not f then
            return
        end

        if session > 0 then
            skynet.ret(skynet.pack(f(...)))
        else
            f(...)
        end
   end)
end)
