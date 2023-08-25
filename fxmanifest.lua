fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Conversion of "sqrl-nightclubs" to ESX'
version '1.0'
author 'Jissuunnn1215 (original Author: Sqrl)'

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua',
    '@es_extended/imports.lua'
}

client_scripts {
    'client/main.lua',
    'client/menus.lua',
    'client/missions/posters.lua',
    'client/missions/turntables.lua',
    'client/missions/food.lua',
    'client/visiting.lua',
}

server_script {
    'server/main.lua',
    'server/missions/posters.lua',
    'server/missions/turntables.lua',
    'server/missions/food.lua',
    'server/visiting.lua',
    '@oxmysql/lib/MySQL.lua',
}