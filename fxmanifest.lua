fx_version 'cerulean'
games { 'gta5' }

author 'TenCreator'
version '1.0.0'
description 'Catty Blacklist - A blacklist system for FiveM servers with a GUI that allows you to add, remove, and view blacklisted vehicles, weapons and peds.'

client_scripts {
    'client/*.lua'
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
    'config.lua'
}

files {
    -- 'ui/index.html',
    -- 'ui/style.css',
    -- 'ui/main.js',
    -- 'files/*'
}

-- ui_page 'ui/index.html'