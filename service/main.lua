local skynet = require "skynet"

skynet.start(function()
    skynet.error("live server begin to start...")

    skynet.newservice("httpflv_server",8001,10)
end
)
