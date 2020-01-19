local M = {}

function bytes_to_int(str,big_enddian)
    local t = string.byte(str)
    local a = 1
    local b = len(t)
    if not big_enddian then
        a,b = b,a
    end

    local ret = 0
    for i=1,len(t) do
        ret = (ret << 8) + t[i]
    end
    return ret
end

return M
