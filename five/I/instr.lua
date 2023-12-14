-- Instruction encoders decoders.

-- Test: 00000001110001011000010110010011 addi a1, a1, 28
--       012345678901|rs1|   |rd-||instr| addi a1, a1, 28

---@class InstR
local InstR = {
    opcode = 0,
    rd = 0,
    funct3 = 0,
    rs1 = 0,
    rs2 = 0,
    funct7 = 0,
}

---Create a new R-type instruction.
---@param conf table?
---@return InstR
function InstR:new(conf)
    local o = conf or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

local And = InstR:new {
    opcode = 0x33,
    funct3 = 0x07,
    funct7 = 0x00,
    
}