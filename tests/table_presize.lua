-- Prealloc, LOADNIL 1, 15
local x = {nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil}
-- Prealloc, 15x LOADTRUE (2..17)
local y = {true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true}
-- No prealloc, 5 rehashes
local z = {}
for i = 1, 16 do
  z[i] = true
end
