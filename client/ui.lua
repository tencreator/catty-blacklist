local uiOpen = false

local function toggleUI()
    local action = nil
    if (uiOpen) then
        uiOpen = false
        action = 'close'
    else
        uiOpen = true
        action = 'open'
    end

    SetNuiFocus(uiOpen, uiOpen)

    SendNUIMessage({
        type = action or 'close'
    })
end

RegisterNetEvent('catty:blacklist:toggleUI')
RegisterNetEvent('catty:blacklist:loadList')
RegisterNetEvent('catty:blacklist:loadBlacklistedItem')

AddEventHandler('catty:blacklist:toggleUI', function()
    toggleUI()
end)

AddEventHandler('catty:blacklist:loadList', function(title, list)
    SendNUIMessage({
        type = 'loadList',
        title = title,
        list = list
    })
end)

AddEventHandler('catty:blacklist:loadBlacklistedItem', function(item)
    SendNUIMessage({
        type = 'loadBlacklistedItem',
        item = item
    })
end)

RegisterNUICallback('close', function(data, cb)
    toggleUI()
    cb('ok')
end)

RegisterNUICallback('switchList', function(data, cb)
    TriggerServerEvent('catty:blacklist:switchList', data.list)

    SendNUIMessage({
        type = 'loadList',
        title = 'Test',
        list = {
            {id = 1, name = 'Test 1'},
            {id = 2, name = 'Test 2'},
            {id = 3, name = 'Test 3'},
            {id = 4, name = 'Test 4'}
        }
    })

    cb('ok')
end)

RegisterNUICallback('loadBlacklistedItem', function(data, cb)
    TriggerServerEvent('catty:blacklist:loadBlacklistedItem', data.id)

    print(json.encode(data))

    cb('ok')
end)