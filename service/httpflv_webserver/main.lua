local skynet = require "skynet"
local socket = require "skynet.socket"
local httpd = require "http.httpd"
local sockethelper = require "http.sockethelper"
local urllib = require "http.url"
local table = table
local string = string

local port,n = ...
print(port,n)

skynet.start(function()
    local agent = {}
    local protocol = "http"
    for i= 1, n do
        agent[i] = skynet.newservice("httpflv_webhandler", "agent", "http")
    end
    local balance = 1
    local id = socket.listen("0.0.0.0", port)
    skynet.error(string.format("Listen web port 8001 protocol:%s", protocol))
    socket.start(id , function(id, addr)
        skynet.error(string.format("%s connected, pass it to agent :%08x", addr, agent[balance]))
        skynet.send(agent[balance], "lua", id)
        balance = balance + 1
        if balance > #agent then
            balance = 1
        end
    end)
end)
