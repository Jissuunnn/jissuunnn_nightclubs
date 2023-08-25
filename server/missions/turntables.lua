ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('nightclubs:server:equiptmentGetMissionData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local club = MySQL.prepare.await('SELECT `metadata` FROM `nightclubs` WHERE `owner` = ?', { xPlayer.identifier })
    TriggerClientEvent('nightclubs:client:equiptmentStartMission', src, club)
end)

RegisterNetEvent('nightclubs:server:effectSetData', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local club = MySQL.prepare.await('SELECT `metadata` FROM `nightclubs` WHERE `owner` = ?', { xPlayer.identifier })
    local tempData = json.decode(club)
    
    if tempData['turntables'] == tostring(nil) then
        tempData['turntables'] = 'Int01_ba_dj01'
    end
    if tempData['droplets'] == tostring(nil) then
        tempData['droplets'] = 'DJ_01_Lights_01'
    end
    if tempData['speakers'] == tostring(nil) then
        tempData['speakers'] = 'Int01_ba_equipment_setup'
    end
    
    local rtrn = json.encode(tempData)
    local id = MySQL.update.await('UPDATE nightclubs SET metadata = ? WHERE owner = ?', { rtrn, xPlayer.identifier })
end)