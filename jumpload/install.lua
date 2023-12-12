
-- computer readable metadata. do not remove.
--@VERSION=1@

local Installer = {
    selfref = "https://raw.githubusercontent.com/penguinencounter/LuaRISC5/main/jumpload/install.lua",
    version = 1,  -- ENSURE THIS MATCHES THE HEADER
}
if not http then
    -- http might be disabled
    io.stderr:write("This installer requires network access.\n")
    io.stderr:write("If you have server file access, check the ComputerCraft configuration\n")
    io.stderr:write("to enable HTTP.\n")
    return 1
end

---Make a GET request.
---@param url any
---@return boolean
---@return string
local function get(url)
    local resp = http.get(url)
    if resp then
        local data = resp.readAll()
        resp.close()
        return true, data or ""
    else
        printError("failed to get "..url)
        return false, ""
    end
end

local function check_version()
    local ok, installfile = get(Installer.selfref)
    if not ok then
        error("couldn't check for updates", 0)
    end
    local version_no = installfile:match("%-%-@VERSION=(%d+)@")
    if tonumber(version_no) > Installer.version then
        io.write("Downloading a new installer...")
        local n = 0
        while fs.exists("/.tmp" .. tostring(n) .. ".lua") do
            n = n + 1
        end
        local path = "/.tmp" .. tostring(n) .. ".lua"
        local handle = fs.open(path, "w")
        
    end
end


local update = check_version()
