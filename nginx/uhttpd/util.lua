-- https://gitlab.com/rychly/uhttpd-lua-utils/-/blob/master/lua/uhttpd-request.lua

local _M = {}

function _M.uhttpd_recv_all(size)
    local content = "";
    repeat
        local rlen, rbuf = uhttpd.recv(size or 4096)
        if (rlen >= 0) then
            content = content .. rbuf
        end
    until (rlen >= 0)
    return content
end

function _M.uhttpd_urlencode(plaintext)
    return string.gsub(uhttpd.urlencode(plaintext), " ", "+")
end

function _M.uhttpd_urldecode(urlencoded)
    return string.gsub(uhttpd.urldecode(urlencoded), "%+", " ")
end

function _M.parse_form_data(form_data, content_type)
    local parsed = {}
    for form_item in string.gmatch(form_data, "[^&]+") do
        local item_parts = string.gmatch(form_item, "[^=]+")
        local item_key, item_value = item_parts(), item_parts()
        if item_key then
            parsed[_M.uhttpd_urldecode(item_key)] = _M.uhttpd_urldecode(item_value or "");
        end
    end
    return parsed
end

function _M.parse_cookie_data(cookie_data)
    local parsed = {}
    for cookie_item in string.gmatch(cookie_data, "[^;]+") do
        local item_parts = string.gmatch(cookie_item, "[^=]+")
        local item_key, item_value = string.gsub(item_parts(), "^%s*(.-)%s*$", "%1"), item_parts()
        if item_key then
            parsed[_M.uhttpd_urldecode(item_key)] = _M.uhttpd_urldecode(item_value or "");
        end
    end
    return parsed
end

function _M.get_name_status(status)

    local states = {
        s404 = " Not Found",
        s500 = " Internal Server Error",
        s405 = " Method Not Allowed",
        s403 = " Forbidden",
        s200 = " OK"
    }

    return states["s" .. status] or states.s404
end

function _M.is_correct_content_type(content_type)
    return content_type == "application/x-www-form-urlencoded"
end

function _M.cookies(env)
    return env.headers["cookie"] and _M.parse_cookie_data(env.headers["cookie"]) or {}
end

return _M
