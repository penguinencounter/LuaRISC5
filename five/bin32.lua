-- 32 bit integer manipluation tools
local c = require "compatibility"

local export = {}

export.LOW = 0x00000000
export.HIGH = 0xffffffff


---Perform sign extension up to 32 bits.
---@param value integer input value.
---@param inbound_size integer size of the input value in bits.
---@return integer
function export.sext(value, inbound_size)
    local sign_bit = c.bits.band(value, c.bits.lshift(1, inbound_size - 1))
    if sign_bit == 0 then
        -- do nothing for positive numbers
        return value
    else
        -- do sign extension. add (32 - inbound_size) ones to the left.
        local mask = c.bits.lshift(c.bits.lshift(1, 32 - inbound_size) - 1, inbound_size)
        return c.bits.bor(value, mask)
    end
end

function export.trim(value, size)
    return c.bits.band(value, c.bits.lshift(1, size) - 1)
end

function export.twoc2real(value)
    local sign_bit = c.bits.band(value, c.bits.lshift(1, 31))
    if sign_bit == 0 then
        return value
    else
        return c.bits.extract(value, 0, 31) - c.bits.lshift(1, 31)
    end
end

---Binary string to integer.
---@param bstr string
---@return integer
function export.binary(bstr)
    local value = 0
    for i = 1, #bstr do
        local ch = bstr:sub(i, i)
        if ch == "1" then
            value = c.bits.bor(c.bits.lshift(value, 1), 1)
        elseif ch == "0" then
            value = c.bits.lshift(value, 1)
        end
    end
    return value
end


return export
