if (Config.OpenMenu.enabled) then
    RegisterCommand(Config.OpenMenu.command, function(source, args, raw)
        TriggerClientEvent('catty:blacklist:toggleUI', source)
    end)
end