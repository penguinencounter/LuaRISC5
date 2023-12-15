local bin32 = require "bin32"

---@enum I.RegisterInteract
local RegisterInteract = {
    Accept = 0,
    Ignore = 1,
    Throw = 2,
}

---@class I._PartialIntRegister
---@field can_read I.RegisterInteract?
---@field can_write I.RegisterInteract?
---@field value integer?

---@class I.IntRegister
---@field can_read I.RegisterInteract
---@field can_write I.RegisterInteract
---@field value integer
local IntRegister = {
    can_read = RegisterInteract.Accept,
    can_write = RegisterInteract.Accept,
    value = 0,
}

---Read from the register.
---@return integer
function IntRegister:read()
    if self.can_read == RegisterInteract.Ignore then
        return 0
    elseif self.can_read == RegisterInteract.Throw then
        error("Attempt to read from write-only register")
    else
        return self.value
    end
end

---Write to the register.
---@param value integer
function IntRegister:write(value)
    if self.can_write == RegisterInteract.Ignore then
        return
    elseif self.can_write == RegisterInteract.Throw then
        error("Attempt to write to read-only register")
    else
        self.value = bin32.trim(value, 32)
    end
end

---Create a new instance or subclass of Register.
---@param conf I._PartialIntRegister?
---@return I.IntRegister
function IntRegister:new(conf)
    local o = conf or {}
    setmetatable(o, self)
    self.__index = self
    return o --[[@as I.IntRegister]]
end

return {
    IntRegister = IntRegister,
    RegisterInteract = RegisterInteract,
}
