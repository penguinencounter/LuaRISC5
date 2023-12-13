
-- computer readable metadata. do not remove.
--@VERSION=7@

local Installer = {
    selfref = "https://penguinencounter.github.io/LuaRISC5/jumpload/install.lua",
    http_headers = {
        ["Cache-Control"] = "no-cache",
        ["Pragma"] = "no-cache",
    },
    refresh_tac = math.floor(os.time("utc") * 60 * 60),
    version = 7,  -- ENSURE THIS MATCHES THE HEADER

    sources = {
        main = "https://penguinencounter.github.io/LuaRISC5/jumpload/jumpload.lua"
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
        binary = true
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
    local content = "WIP"
end
