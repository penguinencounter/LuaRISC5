local bin32 = require "bin32"

---@enum InteractRule
local RegisterInteract = {
    Accept = 0,
    Ignore = 1,
    Throw = 2,
}

---@class IntRegister
---@field can_read InteractRule
---@field can_write InteractRule
---@field value integer
local IntRegister = {
    can_read = RegisterInteract.Accept,
    can_write = RegisterInteract.Accept,
    value = 0,
}

---Create a new instance or subclass of Register.
---@param conf table?
---@return IntRegister
function IntRegister:new(conf)
    local o = conf or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local UserReg = {
    -- x0: always 0, writes ignored
    [0] = IntRegister:new {
        can_write = RegisterInteract.Ignore
    },
    ["pc"] = IntRegister:new()
}
for i = 1,31 do
    UserReg[i] = IntRegister:new()
end

