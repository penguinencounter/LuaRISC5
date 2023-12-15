---@class _PartialInstruction
---@field apply (fun(self: Instruction, state: State): nil)?
---@field decode (fun(self: Instruction, word: integer): Instruction?)?

---@generic T: Instruction
---@alias InstNew<T> fun(self: T, init: _PartialInstruction?): T

---@class Instruction
local Instruction = {}

---Create a new Instruction.
---@param init _PartialInstruction?
---@return Instruction
function Instruction:new(init)
    local o = init or {}
    o = setmetatable(o, self)
    self.__index = self
    return o --[[@as Instruction]]
end

---Run the instruction.
---@param state State
function Instruction:apply(state)
    error(":apply is abstract and no implementation was provided")
end

---Decode an instruction from a word.
---@param word integer
function Instruction:decode(word)
    error(":decode is abstract and no implementation was provided")
end


return Instruction
