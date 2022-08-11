# OpenWRT uHTTPd server adapter for NGINX Lua module

## Basic Usage for Lapis framework integration

## Packages necessary

`opkg install uhttpd luci uhttpd-mod-lua lpeg lua-cjson luaossl luafilesystem luasocket unzip`

## Instalation

### We set the library path

`PATH_LIB="/usr/share/lua"`

## Lapis Instalation

```sh
    wget https://github.com/leafo/lapis/archive/refs/heads/master.zip -P /tmp && \
    unzip /tmp/master -d /tmp && \
    mkdir -p $PATH_LIB && \
    cp -r /tmp/lapis-master/lapis $PATH_LIB && \
    echo 'return require("lapis.init")' > $PATH_LIB/lapis.lua && \
    rm -rf /tmp/master /tmp/lapis-master
```

## Lapis dependencies

```bash
    wget https://raw.githubusercontent.com/kikito/ansicolors.lua/master/ansicolors.lua -O $PATH_LIB/ansicolors.lua;`

    wget https://raw.githubusercontent.com/Tieske/date/master/src/date.lua -O $PATH_LIB/date.lua;

    wget https://raw.githubusercontent.com/leafo/etlua/master/etlua.lua -O $PATH_LIB/etlua.lua;

    wget https://raw.githubusercontent.com/leafo/loadkit/master/loadkit.lua -O $PATH_LIB/loadkit.lua;

    mkdir -p $PATH_LIB/resty && wget https://raw.githubusercontent.com/openresty/lua-resty-upload/master/lib/resty/upload.lua -O $PATH_LIB/resty/upload.lua

```

## Install Adapter

### You can copy the uhttpd folder in the $PATH_LIB or run this command to get from the repository

```bash
    wget https://github.com/jhoacar/uhttpd-ngx-lua-adapter/archive/refs/heads/master.zip -P /tmp && \
    unzip /tmp/master -d /tmp && \
    mkdir -p $PATH_LIB && \
    cp -r /tmp/uhttpd-ngx-lua-adapter-master/uhttpd $PATH_LIB && \
    rm -rf /tmp/master /tmp/uhttpd-ngx-lua-adapter-master
```

### /etc/config/uhttpd

```
...
config uhttpd 'main'
	list listen_http '0.0.0.0:8080'
	list listen_http '[::]:8080'
	option home '/app'
	list lua_prefix '/=/app/index.lua'
...
```

### /app/index.lua

```lua
#!/usr/bin/lua

require "luci.http"

function handle_request(env)
   -- Using this global variable is loaded ngx variable environment
    env = vars
    require("uhttpd.adapter")

    local lapis = require("lapis")
    local app = lapis.Application()

    app:match("/", function(self)
      return "Hello world!"
    end)
    
    lapis.serve(app)
end
```