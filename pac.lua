local src = "https://raw.githubusercontent.com/Prolicon/CCScripts/main/"

local packages = {
pac = "pac.lua";
colonyserver = "servers/colony.lua";
colony = "programs/colony.lua";
}

args = { ... }

for _, arg in ipairs(args) do
    local package = packages[arg]
    if package then
        local filepath = arg .. ".lua"
        if fs.exists(filepath) then fs.delete(filepath) end
        shell.run("wget " .. src .. package .. " " .. filepath)
    end
end
