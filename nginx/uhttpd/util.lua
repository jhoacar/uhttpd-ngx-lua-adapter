-- https://gitlab.com/rychly/uhttpd-lua-utils/-/blob/master/lua/uhttpd-request.lua
local util = {}

function util.getenv()

    local handler = io.popen("env")
    local content = handler:read("*all")
    handler:close()

    local env = {
        headers = {}
    }

    for line in content:gmatch("[^\r\n]+") do
        for key, value in line:gmatch("([%u_]+)=(.+)") do
            local header = key:match("^HTTP_(.+)")
            if type(header) == "string" then
                env.headers[header:lower():gsub("_", "-")] = value
            end
            env[key] = value
        end
    end

    return env
end

function util.read_body(size)
    local content = io.stdin:read("*all")
    io.stdin:close()
    return content
end

function util.urldecode(str)
    str = string.gsub(str, "+", " ")
    str = string.gsub(str, "%%(%x%x)", function(h)
        return string.char(tonumber(h, 16))
    end)
    return str
end

function util.parse_form_data(form_data, content_type)
    local parsed = {}
    for form_item in string.gmatch(form_data, "[^&]+") do
        local item_parts = string.gmatch(form_item, "[^=]+")
        local item_key, item_value = item_parts(), item_parts()
        if item_key then
            parsed[util.urldecode(item_key)] = util.urldecode(item_value or "");
        end
    end
    return parsed
end

function util.get_name_status(status)

    local states = {
        s404 = " Not Found",
        s500 = " Internal Server Error",
        s405 = " Method Not Allowed",
        s403 = " Forbidden",
        s200 = " OK"
    }
    return states["s" .. status] or states.s404
end

return util
