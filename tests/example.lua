package.path = package.path .. ";five/?.lua"

local state = require "state"
local inst = require "I.base_instructions"
local impl = require "I.op.impl"

local inst1 = inst.InstI:new()
inst1:decode(0x1C08093)
impl.addi(inst1, state)


