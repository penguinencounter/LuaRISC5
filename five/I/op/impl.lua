local bin32 = require "bin32"
local export = {}

---ADDI instruction
---@param instr I.InstI
---@param state State
function export.addi(instr, state)
    state.registers['x' .. instr.rd]:write(state.registers['x' .. instr.rs1]:read() + instr.imm)
end

---SLTI instruction
---@param instr I.InstI
---@param state State
function export.slti(instr, state)
    state.registers['x' .. instr.rd]:write(
        (bin32.twoc2real(state.registers['x' .. instr.rs1]:read()) < bin32.twoc2real(instr.imm))
        and 1 or 0
    )
end

---SLTIU instruction
---@param instr I.InstI
---@param state State
function export.sltiu(instr, state)
    state.registers['x' .. instr.rd]:write(
        (state.registers['x' .. instr.rs1]:read() < instr.imm)
        and 1 or 0
    )
end

return export
