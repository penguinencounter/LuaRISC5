local bin32 = require "bin32"
local bits = (require "compatibility").bits
local export = {}

--- INTEGER COMPUATIONAL INSTRUCTIONS --
-- I-type --

---@param instr I.InstI
---@param state State
function export.addi(instr, state)
    state.registers['x' .. instr.rd]:write(state.registers['x' .. instr.rs1]:read() + instr.imm)
end

---@param instr I.InstI
---@param state State
function export.slti(instr, state)
    state.registers['x' .. instr.rd]:write(
        (bin32.twoc2real(state.registers['x' .. instr.rs1]:read()) < bin32.twoc2real(instr.imm))
        and 1 or 0
    )
end

---@param instr I.InstI
---@param state State
function export.sltiu(instr, state)
    state.registers['x' .. instr.rd]:write(
        (state.registers['x' .. instr.rs1]:read() < instr.imm)
        and 1 or 0
    )
end

---@param instr I.InstI
---@param state State
function export.andi(instr, state)
    state.registers['x' .. instr.rd]:write(
        bits.band(state.registers['x' .. instr.rs1]:read(), instr.imm)
    )
end

---@param instr I.InstI
---@param state State
function export.ori(instr, state)
    state.registers['x' .. instr.rd]:write(
        bits.bor(state.registers['x' .. instr.rs1]:read(), instr.imm)
    )
end

---@param instr I.InstI
---@param state State
function export.xori(instr, state)
    state.registers['x' .. instr.rd]:write(
        bits.bxor(state.registers['x' .. instr.rs1]:read(), instr.imm)
    )
end

---@param instr I.InstI
---@param state State
function export.slli(instr, state)
    state.registers['x' .. instr.rd]:write(
        bits.lshift(state.registers['x' .. instr.rs1]:read(), bits.extract(instr.imm, 0, 5))
    )
end

---@param instr I.InstI
---@param state State
function export.srli(instr, state)
    state.registers['x' .. instr.rd]:write(
        bits.rshift(state.registers['x' .. instr.rs1]:read(), bits.extract(instr.imm, 0, 5))
    )
end

---@param instr I.InstI
---@param state State
function export.srai(instr, state)
    state.registers['x' .. instr.rd]:write(
        bits.arshift(state.registers['x' .. instr.rs1]:read(), bits.extract(instr.imm, 0, 5))
    )
end

-- U-type --

---@param instr I.InstU
---@param state State
function export.lui(instr, state)
    state.registers['x' .. instr.rd]:write(instr.imm)
end

---@param instr I.InstU
---@param state State
function export.auipc(instr, state)
    state.registers['x' .. instr.rd]:write(instr.imm + state.registers.pc:read())
end


return export
