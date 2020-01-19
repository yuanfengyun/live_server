local skynet = require "skynet"

local port,n = ...
local listener

skynet.start(function()
    listener = skynet.newservice("httpflv_webserver",8001,2)
end)
