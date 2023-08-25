ESX = exports["es_extended"]:getSharedObject()

local inside = {}

local function getData(identifier)
    local data = MySQL.Sync.prepare('SELECT * FROM nightclubs where owner = ?', { identifier })
    return data
end

local function sendToClub(source)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    inside[#inside+1] = src
    TriggerEvent('nightclubs:server:sendBucket', source, source)
    Wait(1000)
    SetEntityCoords(src, Config.ClubCoords.x, Config.ClubCoords.y, Config.ClubCoords.z, false, false, false, false)
    TriggerClientEvent('nightclubs:client:addinfo', src, getData(xPlayer.identifier))
    Wait(1000)
    TriggerClientEvent('nightclubs:client:loadProps', src, getData(xPlayer.identifier))
end

RegisterNetEvent('nightclubs:server:sendinside', function()
    TriggerClientEvent('nightclubs:client:inside', source, inside)
end)


RegisterNetEvent('nightclubs:server:getBucket', function()
    TriggerClientEvent('nightclubs:client:getBucket', source, GetPlayerRoutingBucket(source))
end)

RegisterNetEvent('nightclubs:server:returnEntrance', function()
    for k, v in pairs(inside) do
        if source == inside[k] then
            inside[k] = nil
        end
    end

    SetPlayerRoutingBucket(source, 0)
    SetEntityCoords(source, Config.Entrance['Blip'].coords.x, Config.Entrance['Blip'].coords.y,
    
    Config.Entrance['Blip'].coords.z, false, false, false, false)
end)

RegisterNetEvent('nightclubs:server:sendBucket', function(source, bucket)
    SetPlayerRoutingBucket(source, tonumber(bucket))
end)

RegisterNetEvent('nightclubs:server:buyObj', function(ClubData, dataType, category, name)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    if xPlayer.getMoney() >= Config.Price['Upgrades'][category][name].price then
        xPlayer.removeMoney(Config.Price['Upgrades'][category][name].price)
        ClubData.Metadata[dataType] = Config.Price['Upgrades'][category][name].name

        local data = json.encode(ClubData.Metadata)
        local id = MySQL.update.await('UPDATE nightclubs SET metadata = ? WHERE owner = ?', { data, xPlayer.identifier })

        TriggerClientEvent('nightclubs:client:removeipl', src)
        Wait(10)
        TriggerClientEvent('nightclubs:client:addinfo', src, getData(xPlayer.identifier))
        TriggerClientEvent('nightclubs:client:loadProps', src, getData(xPlayer.identifier))
        -- TriggerClientEvent('okokNotify:Alert', src, 'Nightclub', 'You\'ve upgraded your nightclub!', 7000, 'success', true)
        TriggerClientEvent('ox_lib:notify', src, 'Nightclub', 'You\'ve upgraded your nightclub!', 'success')
    elseif xPlayer.getAccount('bank').money >= Config.Price['Upgrades'][category][name].price then
        xPlayer.removeAccountMoney('bank', Config.Price['Upgrades'][category][name].price)
        ClubData.Metadata[dataType] = Config.Price['Upgrades'][category][name].name

        local data = json.encode(ClubData.Metadata)
        local id = MySQL.update.await('UPDATE nightclubs SET metadata = ? WHERE owner = ?', { data, xPlayer.identifier })

        TriggerClientEvent('nightclubs:client:removeipl', src)
        Wait(10)
        TriggerClientEvent('nightclubs:client:addinfo', src, getData(xPlayer.identifier))
        TriggerClientEvent('nightclubs:client:loadProps', src, getData(xPlayer.identifier))
        -- TriggerClientEvent('okokNotify:Alert', src, 'Nightclub', 'You\'ve upgraded your nightclub!', 7000, 'success', true)
        TriggerClientEvent('ox_lib:notify', src, 'Nightclub', 'You\'ve upgraded your nightclub!', 'success')
    else
        -- TriggerClientEvent('okokNotify:Alert', src, 'Nightclub', 'You don\'t have enough money!', 7000, 'error', true)
        TriggerClientEvent('ox_lib:notify', src, 'Nightclub', 'You don\'t have enough money!', 'success')
    end
end)

RegisterNetEvent('nightclubs:server:buy', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local ClubData = {}
    local Missions = {}
    local Employees = {}

    ClubData['name'] = 'Int01_ba_clubname_01'
    ClubData['style'] = 'Int01_ba_Style01'
    ClubData['speakers'] = 'nil'
    ClubData['podium'] = 'nil'
    ClubData['security'] = 'nil'
    ClubData['turntables'] = 'nil'
    ClubData['droplets'] = 'nil'
    ClubData['neons'] = 'nil'
    ClubData['bands'] = 'nil'
    ClubData['lasers'] = 'nil'
    ClubData['bar'] = 'Int01_ba_bar_content'
    ClubData['booze'] = 'nil'
    ClubData['worklamps'] = 'Int01_ba_Worklamps'
    ClubData['truck'] = 'Int01_ba_deliverytruck'

    Missions['posters'] = '1'
    Missions['food'] = '50'

    Employees['dancers'] = '0'
    Employees['dj'] = '0'
    Employees['tenders'] = '0'

    if xPlayer.getMoney() >= Config.Price['Base'] then
        -- TriggerClientEvent('okokNotify:Alert', src, 'Nightclub', 'You\'ve bought your nightclub in cash!', 7000, 'success', true)
        TriggerClientEvent('ox_lib:notify', src, 'Nightclub', 'You\'ve bought your nightclub in cash!', 'success')
        xPlayer.removeMoney(Config.Price['Base'])

        local data = json.encode(ClubData)
        local mission = json.encode(Missions)
        local employee = json.encode(Employees)
        local id = MySQL.insert('INSERT INTO `nightclubs` (owner, metadata, missions, employee) VALUES (?, ?, ?, ?)', { xPlayer.identifier, data, mission, employee })
        sendToClub(source)
        TriggerClientEvent('nightclubs:client:sendMail', src)
    elseif xPlayer.getAccount('bank').money >= Config.Price['Base'] then
        -- TriggerClientEvent('okokNotify:Alert', src, 'Nightclub', 'You\'ve bought your nightclub through your bank account!', 7000, 'success', true)
        TriggerClientEvent('ox_lib:notify', src, 'Nightclub', 'You\'ve bought your nightclub through your bank account!', 'success')
        xPlayer.removeAccountMoney('bank', Config.Price['Base'])

        local data = json.encode(ClubData)
        local mission = json.encode(Missions)
        local employee = json.encode(Employees)
        local id = MySQL.insert('INSERT INTO `nightclubs` (owner, metadata, missions, employee) VALUES (?, ?, ?, ?)', { xPlayer.identifier, data, mission, employee })
        sendToClub(source)
        TriggerClientEvent('nightclubs:client:sendMail', src)
    else
        -- TriggerClientEvent('okokNotify:Alert', src, 'Nightclub', 'You don\'t have enough money to buy a nightclub!', 7000, 'error', true)
        TriggerClientEvent('ox_lib:notify', src, 'Nightclub', 'You don\'t have enough money to buy a nightclub!', 'error')
    end
end)

RegisterNetEvent('nightclubs:server:create', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)

    sendToClub(src)
end)

RegisterNetEvent('nightclubs:server:getinfo', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local data = getData(xPlayer.identifier)
    TriggerClientEvent('nightclubs:client:addinfo', src, data)
end)


RegisterNetEvent('nightclubs:server:employeesFunction', function(type, hire)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local data = getData(xPlayer.identifier)
    local temp = json.decode(data.employee)

    if hire then
        temp[type] = tonumber(temp[type]) + 1
    else
        temp[type] = tonumber(temp[type]) - 1
    end

    local id = MySQL.update.await('UPDATE nightclubs SET employee = ? WHERE owner = ?', { json.encode(temp), xPlayer.identifier })
    TriggerClientEvent('nightclubs:client:update', src)
end)

-- need to do
RegisterNetEvent('nightclubs:server:handouts', function(ClubData, Employee, percentage)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local total = 0.0
    if percentage > 1 then
        return
    end

    total = total + percentage * #Config.PedSpawns.locations * Config.Earnings.admission
    total = total + Config.FoodMission.remove * Config.Earnings.food
    total = total - Config.Employee.dj.price * Config.Employee.dj.hoursworked * tonumber(Employee['dj'])
    total = total - Config.Employee.dancers.price * Config.Employee.dancers.hoursworked * tonumber(Employee['dancers'])
    total = total - Config.Employee.tenders.price * Config.Employee.tenders.hoursworked * tonumber(Employee['tenders'])

    for k,v in pairs(Config.Earnings.upgrades) do
        if Config.Earnings.upgrades[k].bonus then
            for m, v in pairs(Config.Earnings.upgrades[k].types) do
                if Config.Earnings.upgrades[k].types[m].name == ClubData[Config.Earnings.upgrades[k].name] then
                    total = total + Config.Earnings.upgrades[k].types[m].amount
                end
            end
        end
    end

    if total > 0 then
        xPlayer.addAccountMoney('bank', total)
        -- TriggerClientEvent('okokNotify:Alert', src, 'Nightclub', 'Your nightclub has earned some funds!', 7000, 'info', true)
        TriggerClientEvent('ox_lib:notify', src, 'Nightclub', 'Your nightclub has earned some funds!', 'info')
    elseif total < 0 then
        xPlayer.removeAccountMoney('bank', math.abs(total))
        -- TriggerClientEvent('okokNotify:Alert', src, 'Nightclub', 'Your nightclub\'s earnings are going negative!', 7000, 'warning', true)
        TriggerClientEvent('ox_lib:notify', src, 'Nightclub', 'Your nightclub\'s earnings are going negative!', 'warning')
    end
end)