Config = {}
Config.Permissions = {}

Config.Discord = {
    useBadgerDiscordApi = true,

    guilds = {
        {
            guild = '000000000000000',
            roles = {
                ['NAME'] = 000000000000000
            }
        }
    }

    token = 'TOKEN'
}

Config.Permissions.Admin = {
    Ace = {
        enabled = false,
        list = {'blacklist.admin'}
    },

    identifiers = {
        enabled = false,
        list = {'steam:xxx', 'license:xxx', 'fivem:xxx'}
    },

    discord = {
        enabled = false,
        list = {'000000000000000'} -- Uses role IDs
    },

    jobs = {
        enabled = false,
        list = {
            {'STAFF', 400}
        }
    }
}

Config.Permissions.Vehicles = {
    Ace = true,
    identifiers = true,
    discord = true,
    jobs = true,

    pubcop = {
        check = true,
        VehicleSpawnCode = 'PUBCOP' 
    },

    vehicles = {
        ['SPAWNCODE'] = {
            ace = {'blacklist.vehicle.SPAWNCODE'},
            identifiers = {'steam:xxx', 'license:xxx', 'fivem:xxx'},
            discord = {'000000000000000'},
            jobs = {
                {'STAFF', 400}
            }
        }
    }
}

Config.Permissions.Weapons = {
    Ace = true,
    identifiers = true,
    discord = true,
    jobs = true,

    weapons = {
        ['WEAPON_PISTOL'] = {
            ace = {'blacklist.weapon.WEAPON_PISTOL'},
            identifiers = {'steam:xxx', 'license:xxx', 'fivem:xxx'},
            discord = {'000000000000000'},
            jobs = {
                {'STAFF', 400}
            }
        }
    }
}

Config.Permissions.Peds = {
    Ace = true,
    identifiers = true,
    discord = true,
    jobs = true,

    peds = {
        ['PED_NAME'] = {
            ace = {'blacklist.ped.PED_NAME'},
            identifiers = {'steam:xxx', 'license:xxx', 'fivem:xxx'},
            discord = {'000000000000000'},
            jobs = {
                {'STAFF', 400}
            }
        }
    }
}

Config.Permissions.hasJob = function(source, job, rank)
    rank = rank or 1
    if (GetResourceState('knight-duty') == 'started') then
        local job = job:upper()
        local uData = exports['knight-duty']:GetUnitInfo(source)

        if (uData and uData.job == job and uData.rank >= rank) then
            return true
        end
    end

    return false
end

Config.Notify = {
    vehicleDisallowed = 'You are not allowed to use this vehicle.',
    weaponDisallowed = 'You are not allowed to use this weapon.',
    pedDisallowed = 'You are not allowed to use this ped.',
    func = function(type, msg, length)
        if not (msg) then return end
        type = type or 'error'
        length = length or 5000

        exports['mythic_notify']:SendAlert(type, msg)
    end
}

Config.OpenMenu = {
    enabled = false, -- NOT FINISHED YET
    command = 'blacklistui'
}