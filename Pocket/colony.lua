HCHANNEL = 150
RCHANNEL = 151

modem = peripheral.find("modem")
assert(not modem, "Modem not attached")
assert(not modem.isWireless, "Modem is not wireless")

modem.open(RCHANNEL)

local ARROWRIGHT = string.char(16)
local ARROWLEFT = string.char(17)

function getBuilderHuts(position)
    request = {request = "buildings"}
    modem.transmit(HCHANNEL, RCHANNEL, request)
    local _, _, _, _, data = os.pullEvent("modem_message")
    local builders = {}
    for _, building in ipairs(data) do
        if building.type == "builder"
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

-- 10, 11 > < respectively
function drawBuilder(y, name, status, selected)
    y = y*3-1
    local pre = selected and ARROWRIGHT or " "
    local post = selected and ARROWLEFT or " "
    term.setBackgroundColor(selected and colors.lime or colors.green)
    term.setTextColor(colors.gray)
    setCursorPos(2,y)
    write(string.format(pre.." %-21s"..post, name))
    setCursorPos(2,y+1)
    write(string.format(pre.." %21s"..post, "STATUS"))
end

width, height = term.getSize()
