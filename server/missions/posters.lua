ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('nightclubs:server:posterGetMissionData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `owner` = ?', { xPlayer.identifier })
    TriggerClientEvent('nightclubs:client:posterGetData', src, data)
end)

RegisterNetEvent('nightclubs:server:posterSetData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local data = MySQL.prepare.await('SELECT `missions` FROM `nightclubs` WHERE `owner` = ?', { xPlayer.identifier })
    local temp = json.decode(data)
    temp['posters'] = temp['posters'] + 1

    local rtn = json.encode(temp)
    local id = MySQL.update.await('UPDATE nightclubs SET missions = ? WHERE owner = ?', { rtn, xPlayer.identifier })
end)