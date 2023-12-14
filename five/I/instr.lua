local Instruction = require "instruction"
local c = require "compatibility"

-- Instruction encoders decoders.

-- Test: 00000001110001011000010110010011 addi a1, a1, 28
--       012345678901|rs1|   |rd-||instr| addi a1, a1, 28


---@class I.InstR : Instruction
---@field opcode integer
---@field rd integer
---@field funct3 integer
---@field rs1 integer
---@field rs2 integer
---@field funct7 integer
local InstR = Instruction:new {
    opcode = 0,
    rd = 0,
    funct3 = 0,
    rs1 = 0,
    rs2 = 0,
    funct7 = 0,
}

---Decode an R-type instruction from a word.
---@param word integer
function InstR:decode(word)
    self.opcode = c.bits.extract(word, 0, 7)
    self.rd = c.bits.extract(word, 7, 5)
    self.funct3 = c.bits.extract(word, 12, 3)
    self.rs1 = c.bits.extract(word, 15, 5)
    self.rs2 = c.bits.extract(word, 20, 5)
    self.funct7 = c.bits.extract(word, 25, 7)
end


---@class I.InstI : Instruction
---@field opcode integer
---@field rd integer
---@field funct3 integer
---@field rs1 integer
---@field imm integer
local InstI = Instruction:new {
    opcode = 0,
    rd = 0,
    funct3 = 0,
    rs1 = 0,
    imm = 0,
}

---Decode an I-type instruction from a word.
---@param word integer
function InstI:decode(word)
    self.opcode = c.bits.extract(word, 0, 7)
    self.rd = c.bits.extract(word, 7, 5)
    self.funct3 = c.bits.extract(word, 12, 3)
    self.rs1 = c.bits.extract(word, 15, 5)
    self.imm = c.bits.extract(word, 20, 12)
end


---@class I.InstS : Instruction
---@field opcode integer
---@field imm integer
---@field funct3 integer
---@field rs1 integer
---@field rs2 integer
local InstS = Instruction:new {
    opcode = 0,
    imm = 0,
    funct3 = 0,
    rs1 = 0,
    rs2 = 0,
}

---Decode an S-type instruction from a word.
---@param word integer
function InstS:decode(word)
    self.opcode = c.bits.extract(word, 0, 7)
    local imm_low = c.bits.extract(word, 7, 5)
    local imm_high = c.bits.extract(word, 25, 7)
    self.imm = c.bits.bor(c.bits.lshift(imm_high, 5), imm_low)
    self.funct3 = c.bits.extract(word, 12, 3)
    self.rs1 = c.bits.extract(word, 15, 5)
    self.rs2 = c.bits.extract(word, 20, 5)
end


---@class I.InstB : Instruction
---@field opcode integer
---@field imm integer
---@field funct3 integer
---@field rs1 integer
---@field rs2 integer
local InstB = Instruction:new {
    opcode = 0,
    imm = 0,
    funct3 = 0,
    rs1 = 0,
    rs2 = 0,
}

---Decode an B-type instruction from a word.
---@param word integer
function InstB:decode(word)
    self.opcode = c.bits.extract(word, 0, 7)
    local imm = c.bits.extract(word, 8, 4)
    imm = c.bits.bor(imm, c.bits.lshift(c.bits.extract(word, 25, 6), 4))
    imm = c.bits.bor(imm, c.bits.lshift(c.bits.extract(word, 7, 1), 10))
    imm = c.bits.bor(imm, c.bits.lshift(c.bits.extract(word, 31, 1), 11))
    imm = c.bits.lshift(imm, 1) -- there is no low bit.
    self.funct3 = c.bits.extract(word, 12, 3)
    self.rs1 = c.bits.extract(word, 15, 5)
    self.rs2 = c.bits.extract(word, 20, 5)
end


---@class I.InstU : Instruction
---@field opcode integer
---@field rd integer
---@field imm integer
local InstU = Instruction:new {
    opcode = 0,
    rd = 0,
    imm = 0,
}

---Decode an U-type instruction from a word.
---@param word integer
function InstU:decode(word)
    self.opcode = c.bits.extract(word, 0, 7)
    self.rd = c.bits.extract(word, 7, 5)
    self.imm = c.bits.lshift(c.bits.extract(word, 12, 20), 12)
end