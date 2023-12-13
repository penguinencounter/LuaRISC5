-- recycle.lua
-- early loading script
-- deleted items are moved to the /trash folder

---Write text with a color.
---@param text string
---@param color integer
local function color_write(text, color)
    local r = term.getTextColor()
    term.setTextColor(color)
    io.write(text)
    term.setTextColor(r)
end

local originals = {
    delete = fs.delete
}

local function is_trash(path)
    return path:match("^/trash/") ~= nil
end

---@diagnostic disable-next-line: duplicate-set-field
_G.fs.delete = function(path)
    if not is_trash(path) then
        local filename = fs.getName(path)
        while fs.exists("/trash/" .. filename) do
            filename = "_" .. filename
        end
        fs.copy(path, "/trash/" .. filename)
        color_write("Moved " .. path .. " to trash as " .. filename .. "\n", colors.lightGray)
    end
    originals.delete(path)
end
