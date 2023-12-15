local Instruction = require "instruction"
local c = require "compatibility"
local bits = c.bits
local bin32 = require "bin32"

-- Instruction encoders decoders.

-- Test: 00000001110000001000000010010011 addi a1, a1, 28
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

---@type InstNew<I.InstR>
InstR.new = Instruction.new

---Decode an R-type instruction from a word.
---@param word integer
function InstR:decode(word)
    self.opcode = bits.extract(word, 0, 7)
    self.rd = bits.extract(word, 7, 5)
    self.funct3 = bits.extract(word, 12, 3)
    self.rs1 = bits.extract(word, 15, 5)
    self.rs2 = bits.extract(word, 20, 5)
    self.funct7 = bits.extract(word, 25, 7)
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

---@type InstNew<I.InstI>
InstI.new = Instruction.new

---Decode an I-type instruction from a word.
---@param word integer
function InstI:decode(word)
    self.opcode = bits.extract(word, 0, 7)
    self.rd = bits.extract(word, 7, 5)
    self.funct3 = bits.extract(word, 12, 3)
    self.rs1 = bits.extract(word, 15, 5)
    self.imm = bin32.sext(bits.extract(word, 20, 12), 12)
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

---@type InstNew<I.InstS>
InstS.new = Instruction.new

---Decode an S-type instruction from a word.
---@param word integer
function InstS:decode(word)
    self.opcode = bits.extract(word, 0, 7)
    local imm_low = bits.extract(word, 7, 5)
    local imm_high = bits.extract(word, 25, 7)
    self.imm = bin32.sext(bits.bor(bits.lshift(imm_high, 5), imm_low), 12)
    self.funct3 = bits.extract(word, 12, 3)
    self.rs1 = bits.extract(word, 15, 5)
    self.rs2 = bits.extract(word, 20, 5)
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

---@type InstNew<I.InstB>
InstB.new = Instruction.new

---Decode an B-type instruction from a word.
---@param word integer
function InstB:decode(word)
    self.opcode = bits.extract(word, 0, 7)
    local imm = bits.extract(word, 8, 4)
    imm = bits.bor(imm, bits.lshift(bits.extract(word, 25, 6), 4))
    imm = bits.bor(imm, bits.lshift(bits.extract(word, 7, 1), 10))
    imm = bits.bor(imm, bits.lshift(bits.extract(word, 31, 1), 11))
    imm = bits.lshift(imm, 1) -- there is no low bit.
    self.imm = bin32.sext(imm, 13)
    self.funct3 = bits.extract(word, 12, 3)
    self.rs1 = bits.extract(word, 15, 5)
    self.rs2 = bits.extract(word, 20, 5)
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

---@type InstNew<I.InstU>
InstU.new = Instruction.new

---Decode an U-type instruction from a word.
---@param word integer
function InstU:decode(word)
    self.opcode = bits.extract(word, 0, 7)
    self.rd = bits.extract(word, 7, 5)
    self.imm = bits.lshift(bits.extract(word, 12, 20), 12)
end


---@class I.InstJ : Instruction
---@field opcode integer
---@field rd integer
---@field imm integer
local InstJ = Instruction:new {
    opcode = 0,
    rd = 0,
    imm = 0,
}

---@type InstNew<I.InstJ>
InstJ.new = Instruction.new

---Decode an J-type instruction from a word.
---@param word integer
function InstJ:decode(word)
    self.opcode = bits.extract(word, 0, 7)
    self.rd = bits.extract(word, 7, 5)
    local im = bits.extract(word, 21, 10)
    im = bits.bor(im, bits.lshift(bits.extract(word, 20, 1), 10))
    im = bits.bor(im, bits.lshift(bits.extract(word, 12, 8), 11))
    im = bits.bor(im, bits.lshift(bits.extract(word, 31, 1), 19))
    im = bits.lshift(im, 1) -- there is no low bit.
    self.imm = bin32.sext(im, 21)
end

return {
    InstR = InstR,
    InstI = InstI,
    InstS = InstS,
    InstB = InstB,
    InstU = InstU,
    InstJ = InstJ,
}
