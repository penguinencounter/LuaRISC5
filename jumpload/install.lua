
-- computer readable metadata. do not remove.
--@VERSION=3@

local Installer = {
    selfref = "https://raw.githubusercontent.com/penguinencounter/LuaRISC5/main/jumpload/install.lua",
    version = 3,  -- ENSURE THIS MATCHES THE HEADER
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
    local ok, installfile = get(Installer.selfref)
    if not ok then
        error("couldn't check for updates", 0)
    end
    local version_no = installfile:match("%-%-@VERSION=(%d+)@")
    if tonumber(version_no) > Installer.version then
        io.write("Downloading installer upgrade...\n")
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

        io.write("Replacing...\n")
        local self_path = shell.getRunningProgram()
        fs.delete(self_path)
        fs.copy(path, self_path)
        fs.delete(path)
        io.write("Starting new installer.\n")
        shell.run(self_path)
        return false, ""
    end
    return true, ""
end


color_write("Checking for installer updates...", colors.lightBlue)
local uptodate, msg = check_version()
if not uptodate then
    io.stderr:write(msg .. "\n")
    return
else
    color_write("Installer looks OK!", colors.lime)
end
