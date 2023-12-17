package.path = package.path .. ";five/?.lua"

local state = require "state"
local bin32 = require "bin32"
local inst = require "I.base_instructions"
local impl = require "I.op.impl"

-- addi x1, x0, #$ff
local inst1 = inst.InstI:new():decode(bin32.binary("000011111111 00000 000 00001 0010011"))
impl.addi(inst1, state)
-- xori x2, x1, -1
local inst2 = inst.InstI:new():decode(bin32.binary("111111111111 00001 111 00010 0010011"))
impl.xori(inst2, state)
-- addi x1, x1, 1
local inst3 = inst.InstI:new():decode(bin32.binary("000000000001 00001 000 00001 0010011"))
impl.addi(inst3, state)

-- lui x3, 0xdeadc
local inst4 = inst.InstU:new():decode(bin32.binary("11011110101011011100 00011 0110111"))
impl.lui(inst4, state)

-- addi x1, x0, #$eef
local inst5 = inst.InstI:new():decode(bin32.binary("111011101111 00011 000 00011 0010011"))
impl.addi(inst5, state)

local start = os.clock()
local n = 1000000
for _ = 0, n do
    local instX = inst.InstI:new():decode(bin32.binary("000000000001 11111 000 11111 0010011"))
    impl.addi(instX, state)
end
local end_ = os.clock()
-- TODO: Actual MIPS if n != 1m
print("Time to build and run ".. n .. " instructions: " .. (end_ - start) .. " or " .. (1/(end_ - start)) .. " MIPS")

local regNames = {}
for i = 0, 31 do
    table.insert(regNames, "x"..i)
end
table.insert(regNames, "pc")

print("REGISTERS:")
local i = 1
for _, name in ipairs(regNames) do
    local regi = state.registers[name]
    local s1 = name.. ": "
    local s2 = string.format("%x", regi:read())
    local spaces1 = 6 - #s1
    local spaces2 = 10 - #s2
    local sA = s1 .. (" "):rep(spaces1)
    local sB = s2 .. (" "):rep(spaces2)
    io.write(sA .. sB)
    if i % 8 == 0 then
        io.write("\n")
    end
    i = i + 1
end
io.write("\n")
