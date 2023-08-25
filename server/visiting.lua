ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('nightclubs:server:getHostData', function(id)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(id)

    TriggerEvent('nightclubs:server:sendBucket', source, id)
    
    local data = MySQL.Sync.prepare('SELECT * FROM nightclubs where owner = ?', { xPlayer.identifier })
    SetEntityCoords(src, Config.ClubCoords.x, Config.ClubCoords.y, Config.ClubCoords.z, false, false, false, false)
    Wait(1000)
    TriggerClientEvent('nightclubs:client:loadHostData', src, data)
end)

RegisterNetEvent('nightclubs:server:alertOwner', function(ownerId, name)
    TriggerClientEvent('nightclubs:client:alertOwner', ownerId, source, name)
end)

RegisterNetEvent('nightclubs:server:getResponse', function(returnId, response)
    TriggerClientEvent('nightclubs:client:setResponse', returnId, response)
end)