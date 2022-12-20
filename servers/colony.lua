CHANNEL = 150

modem = peripheral.find("modem")
assert(modem, "Modem not attached")
assert(modem.isWireless, "Modem is not wireless")

colony = peripheral.find("colonyIntegrator")
assert(colony, "Colony manager not attached")
assert(colony.isInColony(), "Colony is not found")

modem.open(CHANNEL)

API = {}

function API.buildings(data)
    return colony.getBuildings()
end

function API.builder(data)
    if data.position then
        return colony.getBuilderResources(data.position)
    end
end

function API.orders(data)
    return colony.getWorkOrders()
end

while true do
    local _, _, _, replyTo, data, distance = os.pullEvent("modem_message")
    if type(data) ~= "table" then
        error(string.format("[Colony] Bad request from %d blocks away in channel %d", distance, channel))
    else
        local handler = API[data.request]
        if handler then
            local response = handler(data)
            modem.transmit(replyTo, CHANNEL, response)
        end
    end
end
