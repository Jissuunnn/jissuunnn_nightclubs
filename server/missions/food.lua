ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('nightclubs:server:foodGetData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `owner` = ?', { xPlayer.identifier })
    local tmp = json.decode(data)
    TriggerClientEvent('nightclubs:client:foodSetUp', src, tmp)
end)

RegisterNetEvent('nightclubs:server:foodSet', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local tmp = json.encode(data)
    local id = MySQL.update.await('UPDATE nightclubs SET missions = ? WHERE owner = ?', { tmp, xPlayer.identifier })
end)

RegisterNetEvent('nightclubs:server:foodJoinServer', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `owner` = ?', { xPlayer.identifier })
    local tmp = json.decode(data)

    TriggerClientEvent('nightclubs:client:foodJoinSet', src, tmp)
end)

RegisterNetEvent('nightclubs:server:buy', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `owner` = ?', { xPlayer.identifier })
    local tmp = json.decode(data)

    TriggerClientEvent('nightclubs:client:foodJoinSet', src, tmp)
end)