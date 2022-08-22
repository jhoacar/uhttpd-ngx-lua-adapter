#/bin/sh

opkg update
opkg install uhttpd lua lpeg lua-cjson luaossl luasocket unzip

PATH_LIB="/usr/lib/lua"

mkdir -p $PATH_LIB 

# Install Lapis
wget https://github.com/leafo/lapis/archive/refs/heads/master.zip -P /tmp 
unzip /tmp/master -d /tmp 
cp -r /tmp/lapis-master/lapis $PATH_LIB 
echo 'return require("lapis.init")' > $PATH_LIB/lapis.lua 
rm -rf /tmp/master /tmp/lapis-master

# Install Lapis Dependecies
wget https://raw.githubusercontent.com/kikito/ansicolors.lua/master/ansicolors.lua -O $PATH_LIB/ansicolors.lua;
wget https://raw.githubusercontent.com/Tieske/date/master/src/date.lua -O $PATH_LIB/date.lua;
wget https://raw.githubusercontent.com/leafo/etlua/master/etlua.lua -O $PATH_LIB/etlua.lua;
wget https://raw.githubusercontent.com/leafo/loadkit/master/loadkit.lua -O $PATH_LIB/loadkit.lua;
mkdir -p $PATH_LIB/resty && wget https://raw.githubusercontent.com/openresty/lua-resty-upload/master/lib/resty/upload.lua -O $PATH_LIB/resty/upload.lua

# Install Adapter
wget https://github.com/jhoacar/uhttpd-ngx-lua-adapter/archive/refs/heads/master.zip -P /tmp
unzip /tmp/master -d /tmp
cp -r /tmp/uhttpd-ngx-lua-adapter-master/nginx $PATH_LIB
rm -rf /tmp/master /tmp/uhttpd-ngx-lua-adapter-master

# Server Configuration
echo "" > /etc/config/uhttpd
uci set uhttpd.main=uhttpd
uci add_list uhttpd.main.listen_http='0.0.0.0:8080'
uci add_list uhttpd.main.listen_http='[::]:8080'
uci set uhttpd.main.home='/www' 
uci set uhttpd.main.index_file='/index.lua' 
uci set uhttpd.main.index_page='index.lua' 
uci add_list uhttpd.main.interpreter='.lua=/usr/bin/lua'
uci commit
service uhttpd restart