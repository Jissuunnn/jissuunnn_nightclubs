ESX = exports["es_extended"]:getSharedObject()

local inside = {}
local response

RegisterNetEvent('nightclubs:client:visitClub', function()
    local input = lib.inputDialog('Ask to visit a club', { 'Server ID of who you want to visit' })
    if not input then return end
    local host = input[1]
    TriggerEvent('nightclubs:client:askHost', tonumber(host))
end)

RegisterNetEvent('nightclubs:client:inside', function(data)
    inside = data
end)

RegisterNetEvent('nightclubs:client:alertOwner', function(returnId, name)
    local alert = lib.alertDialog({
        header = 'Someone would like to enter your nightclub!',
        content = name .. ' would like to visit your club',
        centered = true,
        cancel = true
    })
    TriggerServerEvent('nightclubs:server:getResponse', returnId, alert)
end)

RegisterNetEvent('nightclubs:client:setResponse', function(responseE)
    response = responseE
end)

RegisterNetEvent('nightclubs:client:askHost', function(id)
    TriggerServerEvent('nightclubs:server:sendinside')
    Wait(1000)
    if not inside then
        -- exports['okokNotify']:Alert('Nightclub', 'No one is inside the club!', 7000, 'error', true)
        lib.notify({ title = 'Nightclub', description = 'No one is inside the club!', type = 'error', duration = 7000 })
        return
    end
    for k, v in pairs(inside) do
        if id == inside[k] then
            local Player = ESX.GetPlayerData()
            TriggerServerEvent('nightclubs:server:alertOwner', id, ESX.PlayerData.firstName)
            while response == nil do
                Wait(1)
            end
            if response == 'confirm' then
                -- exports['okokNotify']:Alert('Nightclub', 'The club owner allowed you in!', 7000, 'success', true)
                lib.notify({ title = 'Nightclub', description = 'The club owner allowed you in!', type = 'success', duration = 7000 })
                TriggerServerEvent('nightclubs:server:getHostData', id)
                response = nil
            else
                -- exports['okokNotify']:Alert('Nightclub', 'The club owner won\'t let you in!', 7000, 'error', true)
                lib.notify({ title = 'Nightclub', description = 'The club owner won\'t let you in!', type = 'error', duration = 7000 })
            end
        end
    end
    if response == nil then
        -- exports['okokNotify']:Alert('Nightclub', 'ID is wrong or doesn\'t exist!', 7000, 'error', true)
        lib.notify({ title = 'Nightclub', description = 'ID is wrong or doesn\'t exist!', type = 'error', duration = 7000 })
    end
end)

RegisterNetEvent('nightclubs:client:loadHostData', function(props)
    TriggerEvent('nightclubs:client:removeipl')
    Wait(2000)
    local tempData = json.decode(props.metadata)

    RequestIpl('ba_int_placement_ba_interior_0_dlc_int_01_ba_milo_')
    --name
    ActivateInteriorEntitySet(271617, tostring(tempData['name']))
    --style
    ActivateInteriorEntitySet(271617, tempData['style'])
    --podium
    if tempData['podium'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['podium'])
    end
    -- security
    if tempData['security'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['security'])
    end
    -- turntables
    if tempData['turntables'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['turntables'])
    end
    --droplets
    if tempData['droplets'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['droplets'])
    end
    --neons
    if tempData['neons'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['neons'])
    end
    --bands
    if tempData['bands'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['bands'])
    end
    --lasers
    if tempData['lasers'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['lasers'])
    end
    --bar
    if tempData['bar'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['bar'])
    end
    --booze
    if tempData['booze'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['booze'])
    end
    --worklamps
    -- if tempData['worklamps'] ~= nil then
    --     ActivateInteriorEntitySet(271617, tempData['worklamps'])
    -- end
    --truck
    if tempData['truck'] ~= nil then
        ActivateInteriorEntitySet(271617, tempData['truck'])
    end
end)
