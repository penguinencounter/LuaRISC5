-- name should sort early.
local function pname()
    return shell.getRunningProgram():match("[^/]+$")
end

local function startup_tool()
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
end


---@param args string[]
local function cmdline(args)
    local iwr = function(...) io.stderr:write(...) end
    if #args == 0 then
        iwr("Usage: " .. pname() .. " <command>\n")
        iwr("command:\n")
        iwr("  uninstall\n")
        return false
    end
    if #args == 1 then
        local key = args[1]
        local switch_cases = {
            ["uninstall"] = function()
                fs.delete(shell.getRunningProgram())
                term.setTextColor(colors.lime)
                io.write("Uninstall success! Reboot to remove traces from environment.\n")
                return true
            end
        }
        local default = function()
            iwr("unknown command: " .. key .. "\n")
            return false
        end
        return (switch_cases[key] or default)()
    end
    iwr("too many arguments\n")
    return false
end


_G.run_once = _G.run_once or {}
if not run_once.startup_jumpload_lua then
    _G.run_once.startup_jumpload_lua = true
    startup_tool()
else
    local original_color = term.getTextColor()
    local ok = cmdline({...})
    term.setTextColor(original_color)
    -- signal an error to the shell
    if not ok then error("", 0) end
end
