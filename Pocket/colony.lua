HCHANNEL = 150
RCHANNEL = 151

modem = peripheral.find("modem")
assert(modem, "Modem not attached")
assert(modem.isWireless, "Modem is not wireless")

modem.open(RCHANNEL)

term.setCursorBlink(false)

local ARROWRIGHT = string.char(16)
local ARROWLEFT = string.char(17)

function getBuilderHuts(position)
    request = {request = "buildings"}
    modem.transmit(HCHANNEL, RCHANNEL, request)
    local _, _, _, _, data = os.pullEvent("modem_message")
    local builders = {}
    for _, building in ipairs(data) do
        if building.type == "builder" then
            local builder = {}
            builder.name = building.citizens[1].name
            builder.x = building.location.x
            builder.y = building.location.y
            builder.z = building.location.z
        end
        table.insert(builders,builder)
    end
    return builders
end

function getBuilderResources(position)
    request = {request = "builder"}
    modem.transmit(HCHANNEL, RCHANNEL, request)
    local _, _, _, _, data = os.pullEvent("modem_message")
    return data
end

function drawBuilder(y, name, status, selected)
    y = y*3-1
    local pre = selected and ARROWRIGHT or " "
    local post = selected and ARROWLEFT or " "
    term.setBackgroundColor(selected and colors.lime or colors.green)
    term.setTextColor(colors.gray)
    term.setCursorPos(2,y)
    term.write(string.format(pre.." %-21s"..post, name))
    term.setCursorPos(2,y+1)
    term.write(string.format(pre.."%21s "..post, "STATUS"))
end

drawBuilder(1, "Bobert B. Brown", "SUPPLY", false)
drawBuilder(2, "Nib G. Gur", "IDLE", true)
drawBuilder(3, "Octavia C. Cutter", "GOOD", false)

os.pullEvent("char")
