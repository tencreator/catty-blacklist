TenLib = {}

function TenLib:splitString(input_string, delimiter)
    local split_array = {}
    local pattern = string.format("([^%s]+)", delimiter)

    input_string:gsub(pattern, function(c)
        table.insert(split_array, c)
    end)

    return split_array
end

function TenLib:filterName(input_string)
    local newStr = input_string
    newStr = newStr:gsub("%~.-%~", "")
    newStr = newStr:gsub("%[.-%]", "")
    newStr = newStr:gsub("%(.-%)", "")

    local splitStr = {}
    splitStr = TenLib:splitString(newStr, "|")
    newStr = splitStr[#splitStr]

    return newStr
end

function TenLib:hasVal(tab, val, idx)
    for _, v in pairs(tab) do
        if idx then
            if v[idx] == val then
                return true
            end
        else
            if v == val then
                return true
            end
        end
    end

    return false
end

function TenLib:hasKey(tab, key)
    for k, _ in pairs(tab) do
        if k == key then
            return true
        end
    end

    return false
end

function split(str, split)
    local res = {}
    for i in string.gmatch(str, "([^"..split.."]+)") do
        table.insert(res, i)
    end
    return res
end

function getPlayerName(source)
    local name;

    if source == 0 then name = 'console' end
    if GetPlayerName(source) then name = GetPlayerName(source) end
    if name == nil then name = 'unknown' end

    name = TenLib:filterName(name)

    if name:sub(1, 1) == ' ' then
        name = name:sub(2)
    end

    return name
end

function getPlayerIdentifiers(source)
    local idents = GetPlayerIdentifiers(source)
    local identifiers = {}

    for _, v in pairs(idents) do
        local plat = string.sub(v, 1, string.find(v, ':') - 1)
        local id = string.sub(v, string.find(v, ':') + 1)
        identifiers[plat] = id
    end

    return identifiers
end

function getDiscordRoles(source)
    local discord = GetPlayerIdentifiers(source)['discord']
    local roles = nil

    if (Config.Discord.useBadgerDiscordApi) then
        roles = exports['badger_discord_api']:getDiscordRoles(source)
    else
        if discord then
            for _, v in pairs(Config.Discord.guilds) do
                local endpoint = string.format('https://discord.com/api/v9/guilds/%s/members/%s', v.id, discord)
                local headers = {["Content-Type"] = "application/json", ["Authorization"] = string.format('Bot %s', Config.Discord.token)}

                PerformHttpRequest(endpoint, function (err, res, _)
                    if err == 200 then
                        local data = json.decode(res)
                        if data.roles then
                            roles = data.roles
                        end
                    else
                        Debug(true, 'Error getting user roles: '..err)
                    end
                end, 'GET', '', headers)
            end
        else
            return {}
        end
    end

    while not roles do
        Wait(100)
    end

    return roles
end

function getRoleId(role)
    if type(role) == 'number' then
        return role
    end

    if type(role) ~= "string" then
        return nil
    end

    if type(role) == "string" then
        if tonumber(role) then
            return tonumber(role)
        end
    end

    for _, v in pairs(Config.Discord.guilds) do
        if v.roles[role] then
            return v.roles[role]
        end
    end

    return nil
end

function checkEqual(r1, r2)
    if (Config.Discord.useBadgerDiscordApi) then
        return exports['badger_discord_api']:checkEqual(r1, r2)
    end

    local r1ID = GetRoleId(r1)
    local r2ID = GetRoleId(r2)

    if not (r1ID and r2ID) and (tonumber(r1ID) == nil) then return false end
    if (r1ID == r2ID) or (tonumber(r1ID) == tonumber(r2ID)) then return true end

    return false
end

function getPermsTable(source, perms, table)
    local allowed = {}
    local idents = getPlayerIdentifiers(source)
    local discordRoles = GetPlayerDiscordRoles(source)

    for k,v in pairs(table) do
        local ace = v.ace
        local identifiers = v.identifiers
        local discord = v.discord
        local jobs = v.jobs

        if (perms.ace) then
            for _,v in pairs(ace) do
                if IsAceAllowed(source, v) then
                    allowed[k] = true
                    break
                end
            end
        end

        if (perms.identifiers) then
            for _,v in pairs(identifiers) do
                if TenLib:hasKey(identifiers, v) then
                    allowed[k] = true
                    break
                end
            end
        end

        if (perms.discord) then
            for _,v in pairs(discord) do
                for _,r in pairs(discordRoles) do
                    if checkEqual(r, v) then
                        allowed[k] = true
                        break
                    end
                end
            end
        end

        if (perms.jobs) then
            for _,v in pairs(jobs) do
                if Config.Permissions.hasJob(source, v[1]) then
                    allowed[k] = true
                    break
                end
            end
        end
    end

    return allowed
end