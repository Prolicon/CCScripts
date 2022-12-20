local src = "https://raw.githubusercontent.com/Prolicon/CCScripts/main/"

local packages = {
pac = "pac.lua";
colonyserver = "servers/colony.lua";
colony = "programs/colony.lua";
}

args = { ... }

for _, arg in ipairs(args) then
    local package = packages[arg]
    if package then
        shell.run("wget " .. src .. package .. " " .. arg .. ".lua")
    end
end
