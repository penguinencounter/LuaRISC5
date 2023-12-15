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


return export
