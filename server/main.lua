local basePath = GetResourcePath(GetCurrentResourceName()).."/files/"
function ReadFile(path)
    local file = io.open(path, "r")
    local content = file:read("*a")
    file:close()
    return content
end

function WriteFile(path, content)
    local file = io.open(path, "w")
    file:write(content)
    file:close()
end

local vehiclePerms = {
    ace = Config.Permissions.Vehicles.Ace,
    identifiers = Config.Permissions.Vehicles.Identifiers,,
    discord = Config.Permissions.Vehicles.Discord,
    jobs = Config.Permissions.Vehicles.Jobs
}

local weaponPerms = {
    ace = Config.Permissions.Weapons.Ace,
    identifiers = Config.Permissions.Weapons.Identifiers,
    discord = Config.Permissions.Weapons.Discord,
    jobs = Config.Permissions.Weapons.Jobs
}

local pedPerms = {
    ace = Config.Permissions.Peds.Ace,
    identifiers = Config.Permissions.Peds.Identifiers,
    discord = Config.Permissions.Peds.Discord,
    jobs = Config.Permissions.Peds.Jobs
}

function getPlyPerms(souce)
    local vehicles = getPermsTable(source, vehiclePerms, Config.Permissions.Vehicles.vehicles)
    local weapons = getPermsTable(source, weaponPerms, Config.Permissions.Weapons.weapons)
    local peds = getPermsTable(source, pedPerms, Config.Permissions.Peds.peds)

    TriggerClientEvent('catty:blacklist:updateVehicles', source, vehicles)
    TriggerClientEvent('catty:blacklist:updateWeapons', source, weapons)
    TriggerClientEvent('catty:blacklist:updatePeds', source, peds)
end

CreateThread(function()
    while true do
        Wait(15 * 60 * 1000)

        for _, player in ipairs(GetPlayers()) do
            local source = player
            getPlyPerms(source)
        end
    end
end)

AddEventHandler('onresourcestart', function(resouce)
    if (resource == GetCurrentResourceName())
        for _, player in ipairs(GetPlayers()) do
            local source = player
            getPlyPerms(source)
        end
    end
end)

RegisterNetEvent('catty:blacklist:requestBlacklists')
AddEventHandler('catty:blacklist:requestBlacklists', function()
    local source = source
    getPlyPerms(source)
end)