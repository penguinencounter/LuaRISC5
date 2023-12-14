local alloc = {}

local start = os.clock()
for i = 1, 1000000 do
    alloc[i] = 1.5
end
local done = os.clock()
print("Cold writes:", done - start)


local start2 = os.clock()
for i = 1, 1000000 do
    alloc[i] = 2.5
end
local done2 = os.clock()
print("Warm writes:", done2 - start2, (done2 - start2) / (done - start), "pct")
