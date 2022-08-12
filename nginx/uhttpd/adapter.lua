-- Full documentation: https://github.com/openresty/lua-nginx-module#nginx-api-for-lua
local util = require "nginx.uhttpd.util"
local req_body = nil

ngx = {}
ngx.ctx = {}
ngx.var = {
    request_method = env.REQUEST_METHOD,
    request_uri = env.REQUEST_URI,
    server_addr = env.SERVER_ADDR,
    server_port = env.SERVER_PORT,
    scheme = env.HTTPS and "https" or "http",
    remote_addr = env.REMOTE_ADDR,
    http_host = env.HTTP_HOST,
    host = env.HTTP_HOST,
    http_referer = env.HTTP_HOST,
    args = env.QUERY_STRING,
    content_type = env.CONTENT_TYPE
}
ngx.req = {
    read_body = function()
        if util.is_correct_content_type(env.CONTENT_TYPE) and not req_body then
            req_body = util.uhttpd_recv_all(env.CONTENT_LENGTH)
            return req_body
        end
        return ""
    end,
    get_body_data = function()
        return req_body or ""
    end,
    get_headers = function()
        return env.headers or {}
    end,
    get_post_args = function(max)
        return req_body and util.parse_form_data(req_body, env.CONTENT_TYPE) or {}
    end,
    get_uri_args = function(max)
        return env.QUERY_STRING and util.parse_form_data(env.QUERY_STRING) or {}
    end,
    socket = function()
        return nil, "module uhttpd socket not supported"
    end
}
ngx.update_time = function()

end
ngx.now = function()
    return os.clock()
end
ngx.escape_uri = nil
ngx.sleep = 0
local contentType = "Content-Type"
ngx.header = {}
ngx.header[contentType] = "text/html"
ngx.status = 200
local status_sent = false
local headers_sent = false
ngx.print = function(content)

    if not status_sent then
        uhttpd.send("Status: " .. ngx.status .. util.get_name_status(ngx.status) .. "\r\n")
        status_sent = true
    end

    if not headers_sent then
        for key, value in pairs(ngx.header) do
            uhttpd.send(key .. ": " .. value .. "\r\n")
        end
        uhttpd.send("\r\n\r\n")
        headers_sent = true
    end
    uhttpd.send(content)
end

