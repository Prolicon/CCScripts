local HCHANNEL = 150
local RCHANNEL = 151

local modem = peripheral.find("modem")
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

function drawBuilder(n, selected)
    y = n*3-1
    local pre = selected and ARROWRIGHT or " "
    local post = selected and ARROWLEFT or " "
    term.setBackgroundColor(selected and colors.lime or colors.green)
    term.setTextColor(colors.gray)
    term.setCursorPos(2,y)
    term.write(string.format(pre.." %-21s"..post, builders[n].name))
    term.setCursorPos(2,y+1)
    term.write(string.format(pre.."%21s "..post, builders[n].status))
end

local bPage = {pos = 1}

function bPage.input(key)
    if key == keys.w or key == keys.up then
        drawBuilder(bPage.pos, false)
        bPage.pos = bPage.pos >= #builders and 1 or bPage.pos + 1
        drawBuilder(bPage.pos, "IDLE", true)
    elseif key == keys.s or key == keys.down then
        drawBuilder(bPage.pos, false)
        bPage.pos = bPage.pos <= 1 and #builders or bPage.pos - 1
        drawBuilder(bPage.pos, true)
    end
end

function bPage.render()
    term.clear()
    for pos, builder in ipairs(builder) do
        drawBuilder(pos, pos == bPage.pos)
    end
end

local builders = {}
builders[1] = {name = "Bobert B. Brown", status = "idle"}
builders[2] = {name = "Nib G. Gur", status = "good"}
builders[3] = {name = "Octavia C. Cutter", status = "supply"}

currentPage = bPage
currentPage.render()

while true do
    _, key, isHeld = os.pullEvent("key")
    if key == keys.backspace then break end
    currentPage.input(key)
end

-- Reset on exit
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.setCursorPos(1,1)
term.clear()
