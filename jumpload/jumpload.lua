-- name should sort early.

local iC = term.getTextColor()
term.clear()
term.setTextColor(colors.lime)
term.setCursorPos(1, 1)
io.write("Preparing hooks.\n")
local originals = {
    shell_exit = shell.exit,
}

local should_run_shell = true
---@diagnostic disable-next-line: duplicate-set-field
shell.exit = function()
    should_run_shell = false
    originals.shell_exit()
end

local early_loading_dir = "/.early_load"
if fs.exists(early_loading_dir) and fs.isDir(early_loading_dir) then
    term.setTextColor(colors.lime)
    io.write("Early loading scripts:\n")
    for _, name in ipairs(fs.list(early_loading_dir)) do
        term.setTextColor(colors.lime)
        io.write("+ " .. name .. "\n")
        term.setTextColor(colors.green)
        local ok = shell.run(early_loading_dir .. "/" .. name)
        if not ok then
            term.setTextColor(colors.red)
            io.write("Failed to run " .. name .. ", ENTER...\n")
            read()
        end
    end
end

term.setTextColor(colors.lime)
io.write("Startup scripts:\n")
local function pname()
    return shell.getRunningProgram():match("[^/]+$")
end
for _, name in ipairs(fs.list("/startup")) do
    if name > pname() then
        -- we need shebang support here
        term.setTextColor(colors.lime)
        io.write("+ " .. name .. "\n")
        term.setTextColor(colors.green)
        local ok = shell.run("/startup/" .. name)
        if not ok then
            term.setTextColor(colors.red)
            io.write("Failed to run " .. name .. ", ENTER...\n")
            read()
        end
    end
end
term.setTextColor(iC)
if should_run_shell then
    shell.run("shell")
else
    term.setTextColor(colors.orange)
    io.write("Goodbye\n")
end
os.shutdown()


