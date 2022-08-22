#!/usr/bin/lua

-- local lapis = require("lapis")

require("nginx.uhttpd.adapter")

ngx.print("Hello world!")

-- local app = lapis.Application()

-- app:match("/", function(self)
--     return "Hello world!"
-- end)

-- lapis.serve(app)
