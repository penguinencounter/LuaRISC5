local iR = require "I.register"

---@alias state.RegisterSet {[string]: I.IntRegister}

---@class State
---@field registers state.RegisterSet

---Initialize VM state.
---@return State
local function _init()
    ---@type State
    local State = {
        registers = {
            x0 = iR.IntRegister:new {
                can_write = iR.RegisterInteract.Ignore,
                value = 0,
            },
            pc = iR.IntRegister:new {
                can_read = iR.RegisterInteract.Ignore,
                value = 0,
            },
        }
    }
    for i = 1, 31 do
        local name = "x" .. i
        State.registers[name] = iR.IntRegister:new {
            value = 0,
        }
    end
    return State
end

local state = _init()

return state