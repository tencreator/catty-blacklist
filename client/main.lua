local disallowedVehicles = {}
local disallowedWeapons = {}
local disallowedPeds = {}

local lastVeh = nil
local lastWeap = nil
local lastPed = nil

local updatedVehicles = false
local updatedWeapons = false
local updatedPeds = false

RegisterNetEvent('catty:blacklist:updateVehicles')
RegisterNetEvent('catty:blacklist:updateWeapons')
RegisterNetEvent('catty:blacklist:updatePeds')

AddEventHandler('catty:blacklist:updateVehicles', function(vehicles)
    disallowedVehicles = vehicles
    updatedVehicles = true
end)

AddEventHandler('catty:blacklist:updateWeapons', function(weapons)
    disallowedWeapons = weapons
    updatedWeapons = true
end)

AddEventHandler('catty:blacklist:updatePeds', function(peds)
    disallowedPeds = peds
    updatedPeds = true
end)

local function checkPed(ped)
    local ped = GetPlayerPed(-1)
    
    if (lastPed == ped and not updatedPeds) then
        return
    else
        lastPed = ped
        updatedPeds = false
    end
    
    for i = 1, #disallowedPeds do
        if (IsPedModel(ped, disallowedPeds[i])) then
            RequestModel('mp_m_freemode_01')
            
            while not HasModelLoaded('mp_m_freemode_01') do
                Wait(0)
            end

            SetPlayerModel(PlayerId(), 'mp_m_freemode_01')
            SetModelAsNoLongerNeeded('mp_m_freemode_01')

            Notify('error', Config.Notify.pedDisallowed)
        end
    end
end

local function checkWeapon(ped)
    function TableInclude(tab, val)
        for i = 1, #tab do
            if (tab[i] == val) then
                return true
            end
        end
        return false
    end

    local weapon = GetSelectedPedWeapon(ped)

    if (lastWeap == weapon and not updatedWeapons) then
        return
    else
        lastWeap = weapon
        updatedWeapons = false
    end

    if (weapon ~= (nil)) then
        if (TableInclude(disallowedWeapons, weapon)) then
            RemoveWeaponFromPed(ped, weapon)
            Notify('error', Config.Notify.weaponDisallowed)
        end
    end
end


local function checkVehicle(ped)
    function TableInclude(tab, val)
        for i = 1, #tab do
            if (string.upper(tab[i]) == string.upper(val)) then
                return true
            end
        end
        return false
    end

    local veh = nil

    if (IsPedInAnyVehicle(ped, false)) then
        veh = GetVehiclePedIsUsing(ped)
    else
        veh = GetVehiclePedIsTryingToEnter(ped)
    end

    if (lastVeh == veh and not updatedVehicles) then
        return
    else
        lastVeh = veh
        updatedVehicles = false
    end

    local model = GetDisplayNameFromVehicleModel(GetEntityModel(veh))

    if (model ~= (nil or 'CARNOTFOUND')) then
        if (TableInclude(disallowedVehicles, model)) then
            DeleteEntity(veh)
            ClearPedTasksImmediately(ped)
            Notify('error', Config.Notify.vehicleDisallowed)
        end
    end

    updatedVehicles = false
end

local function checkPubcop(ped)
    if (not Config.Permissions.Vehicles.pubcop.check) then
        return
    end

    if (GetResourceState('knight-duty') ~= 'started') and (exports['knight-duty']:getUnit() == (nil or false) and (exports['knight-duty']:getUnit().dept ~= 'PUBCOP') then
        return
    end

    if (IsPedInAnyVehicle(ped, false) and (GetPedInVehicleSeat(GetVehiclePedIsIn(ped, false), -1) == ped)) then
        local veh = GetVehiclePedIsIn(ped, false)

        if (veh) then
            if (GetVehicleClass(veh) == 18 and not (string.upper(GetDisplayNameFromVehicleModel(GetEntityModel(veh))) == Config.Permissions.Vehicles.pubcop.VehicleSpawnCode)) then
                DeleteEntity(veh)
                ClearPedTasksImmediately(ped)

                Notify('error', Config.Notify.vehicleDisallowed)

                RequestModel(Config.Permissions.Vehicles.pubcop.VehicleSpawnCode)
                while not HasModelLoaded(Config.Permissions.Vehicles.pubcop.VehicleSpawnCode) do
                    Wait(0)
                end

                local veh = CreateVehicle(Config.Permissions.Vehicles.pubcop.VehicleSpawnCode, GetEntityCoords(ped), GetEntityHeading(ped), true, false)
                SetPedIntoVehicle(ped, veh, -1)
            end
        end
    end
end

function Notify(type, msg, length)
    if not (msg) then return end
    type = type or 'error'
    length = length or 5000

    if (Config.Notify.script == 'mythic_notify') then
        exports['mythic_notify']:SendAlert(type, msg, length)
    end
end

CreateThread(function()
    TriggerServerEvent('catty:blacklist:requestBlacklists')
    while true do
        Wait(1000)

        local pId = PlayerPedId()
        checkVehicle(pId)
        checkWeapon(pId)
        checkPed(pId)
        checkPubcop(pId)
    end
end)