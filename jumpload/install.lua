
-- computer readable metadata. do not remove.
--@VERSION=9@

local Installer = {
    selfref = "https://penguinencounter.github.io/LuaRISC5/jumpload/install.lua",
    http_headers = {
        ["Cache-Control"] = "no-cache",
        ["Pragma"] = "no-cache",
    },
    refresh_tac = math.floor(os.time("utc") * 60 * 60),
    version = 9,  -- ENSURE THIS MATCHES THE HEADER
    output_name = "jumpload.lua",

    sources = {
        main = "https://penguinencounter.github.io/LuaRISC5/jumpload/jumpload.lua"
    },
    d_to_create = {
        "/.early_load",
        "/startup"
    }
}

---Write text with a color.
---@param text string
---@param color integer
local function color_write(text, color)
    local r = term.getTextColor()
    term.setTextColor(color)
    io.write(text)
    term.setTextColor(r)
end

if not http then
    -- http might be disabled
    io.stderr:write("This installer requires network access.\n")
    io.stderr:write("If you have server file access, check the ComputerCraft configuration\n")
    io.stderr:write("to enable HTTP.\n")
    io.stderr:write("If you don't have server file access, get a portable installer.\n")
    return 1
end

---Make a GET request.
---@param url any
---@return boolean
---@return string
local function get(url)
    local resp = http.get {
        url = url,
        binary = true,
        headers = Installer.http_headers
    }
    if resp then
        local data = resp.readAll()
        resp.close()
        return true, data or ""
    else
        printError("failed to get "..url)
        return false, ""
    end
end

---Check if this version of the installer is current.
---@return boolean current should we continue running?
---@return string message what message should be displayed?
local function check_version()
    local ok, installfile = get(Installer.selfref .. "?" .. Installer.refresh_tac)
    if not ok then
        error("couldn't check for updates", 0)
    end
    local version_no = installfile:match("%-%-@VERSION=(%d+)@")
    if tonumber(version_no) > Installer.version then
        color_write("out of date.\n", colors.orange)
        color_write("Downloading installer upgrade...\n", colors.orange)
        local n = 0
        while fs.exists("/.tmp" .. tostring(n) .. ".lua") do
            n = n + 1
        end
        local path = "/.tmp" .. tostring(n) .. ".lua"
        local handle = fs.open(path, "wb")
        if not handle then
            error("couldn't open temporary file for writing", 0)
        end
        handle.write(installfile)
        handle.close()
        io.write()

        color_write("Replacing... ", colors.green)
        local self_path = shell.getRunningProgram()
        if fs.attributes(self_path).isReadOnly then
            color_write("can't write; running live\n", colors.yellow)
            shell.run(path)
            color_write("cleaning up temporaries\n", colors.yellow)
            fs.delete(path)
            return false, ""
        else
            fs.delete(self_path)
            fs.copy(path, self_path)
            fs.delete(path)
            color_write("Starting new installer.\n", colors.green)
            shell.run(self_path)
            return false, ""
        end
    end
    return true, ""
end


color_write("Checking for installer updates... ", colors.lightBlue)
local uptodate, msg = check_version()
if not uptodate then
    io.stderr:write(msg .. "\n")
    return
else
    color_write("looks OK!", colors.lime)
end


local function install()
    -- Backup existing startups
    if fs.exists("/startup") and not fs.isDir("/startup") then
        color_write("Moving existing startup, ", colors.yellow)
        local oH = fs.open("/startup", "rb")
        if oH then
            local d = oH.readAll()
            oH.close()
            fs.delete("/startup")
            fs.makeDir("/startup")
            local wH = fs.open("/startup/30_startup", "wb")
            if wH then
                wH.write(d)
                wH.close()
                color_write("ok.\n", colors.lime)
            else
                color_write("failed to open output.\n", colors.red)
            end
        else
            color_write("failed to open input.\n", colors.red)
        end
    end

    if fs.exists("/startup.lua") and not fs.isDir("/startup.lua") then
        color_write("Moving existing startup.lua, ", colors.yellow)
        local oH = fs.open("/startup.lua", "rb")
        if oH then
            local d = oH.readAll()
            oH.close()
            fs.delete("/startup.lua")
            fs.makeDir("/startup")
            local wH = fs.open("/startup/31_startup.lua", "wb")
            if wH then
                wH.write(d)
                wH.close()
                color_write("ok.\n", colors.lime)
            else
                color_write("failed to open output.\n", colors.red)
            end
        else
            color_write("failed to open input.\n", colors.red)
        end
    end

    for _, item in ipairs(Installer.d_to_create) do
        if not fs.exists(item) then
            fs.makeDir(item)
        end
    end

    local req_ok, to_install = get(Installer.sources.main .. "?" .. Installer.refresh_tac)
    if not req_ok then
        error("download failed", 0)
    end
    -- number of exclamation points (!)
    local screaming = 1
    for _, name in ipairs(fs.list("/startup")) do
        local this_sc = #name:match("^(!*)")
        if this_sc + 1 > screaming then
            screaming = this_sc + 1
        end
    end
    local target_name = "/startup/" .. ("!"):rep(screaming) .. "_" .. Installer.output_name
    if fs.exists(target_name) then
        fs.delete(target_name)
    end
    local handl = fs.open(target_name, "wb")
    if not handl then
        error("could not open output file for writing", 0)
    end
    handl.write(to_install)
    handl.close()
    
    color_write("Install success! ", colors.lime)
    color_write("Restart to apply changes.\n", colors.yellow)
end

install()
