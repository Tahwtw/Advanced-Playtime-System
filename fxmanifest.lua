-- FX Information --
fx_version   'cerulean'
lua54        'true'
game         'gta5'

-- Resource Information --
name         'th_playtime'
version      '1.0.0'
author       'Tah'
description  'Advanced Playtime System.'

-- Manifest --
dependencies {
  '/server:5181',
  '/onesync'
}

shared_scripts{
  '@ox_lib/init.lua',
  'config/config.lua'
}

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  'server/*.lua'
}

client_scripts {
  'client/*.lua'
}