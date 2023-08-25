ESX = exports["es_extended"]:getSharedObject()

local blips = {}
local zones = {}
local controlListen = false
local count = 0
local foodProgress = false
local data = nil
local setdata

local function removeClose(k)
    RemoveBlip(blips[k])
    zones[k]:remove()
end

function getFood()
    print(setdata)
    if data == nil then
        TriggerServerEvent('nightclubs:server:foodJoinServer')
        Wait(7000)
        return data['food']
    end
    return data['food']
end

local function loading(k)
    local success = lib.skillCheck({'easy', 'easy', 'medium', 'easy'}, {'w', 'a', 's', 'd'})

    if success then
        if lib.progressCircle({
            duration = 3000,
            position = 'bottom',
            label = 'Picking up food and drinks...',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = 'random@domestic',
                clip = 'pickup_low'
            },
        }) then
            removeClose(k)
            count = count + 1
            Wait(1000)
            if #blips == count then
                -- exports['okokNotify']:Alert('Nightclub', 'You picked up all the foods and drinks!', 7000, 'success', true)
                lib.notify({ title = 'Nightclub', description = 'You picked up all the foods and drinks!', type = 'success', duration = 7000 })
                data['food'] = Config.FoodMission.max
                MISSION_PROGRESS = false
                --zones = nil
                --blips = nil
                count = 0
                foodProgress = false
            end
        end
    else
        -- exports['okokNotify']:Alert('', 'Try again!', 7000, 'error', true)
        lib.notify({ title = '', description = 'Try again!', type = 'error', duration = 7000 }) 
    end
end

RegisterNetEvent('nightclubs:client:foodReplinish', function()
    MISSION_PROGRESS = true
    for k, v in pairs(Config.FoodMission.locations) do
        blips[k] = AddBlipForCoord(Config.FoodMission.locations[k].coords.x, Config.FoodMission.locations[k].coords.y, Config.FoodMission.locations[k].coords.z)
        SetBlipColour(blips[k], Config.FoodMission.blip.color)
        SetBlipSprite(blips[k], Config.FoodMission.blip.sprite)
        SetBlipScale(blips[k], .6)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.FoodMission.blip.name)
        EndTextCommandSetBlipName(blips[k])

        zones[k] = lib.zones.box({
            coords = vec3(Config.FoodMission.locations[k].coords.x, Config.FoodMission.locations[k].coords.y, Config.FoodMission.locations[k].coords.z),
            size = vec3(4, 4, 4),
            debug = false,
            onEnter = function()
                controlListen = true
            end,
            inside = function()
                while controlListen do
                    lib.showTextUI('[E] - Pick Up Food And Drinks')
                    if IsControlJustReleased(0, 38) then
                        lib.hideTextUI()
                        loading(k)
                        controlListen = false
                    end
                    Wait(1)

                    controlListen = true
                end
            end,
            onExit = function()
                lib.hideTextUI()
            end
        })
    end
end)

RegisterNetEvent('nightclubs:client:foodSetUp', function(dataa)
    data = dataa
    if tonumber(data['food']) ~= Config.FoodMission.max then
        if not MISSION_PROGRESS then
            -- exports['okokNotify']:Alert('Nightclub', 'Pick up all the foods at the given locations!', 7000, 'info', true)
            lib.notify({ title = 'Nightclub', description = 'Pick up all the foods at the given locations!', type = 'info', duration = 7000 })
            TriggerEvent('nightclubs:client:foodReplinish')
        else
            -- exports['okokNotify']:Alert('Nightclub', 'You already have a mission going!', 7000, 'warning', true)
            lib.notify({ title = 'Nightclub', description = 'You already have a mission going!', type = 'warning', duration = 7000 })
        end
    else
        -- exports['okokNotify']:Alert('Nightclub', 'You already have enough food!', 7000, 'warning', true)
        lib.notify({ title = 'Nightclub', description = 'You already have enough food!', type = 'warning', duration = 7000 })
    end
end)

RegisterNetEvent('esx:playerLoaded', function()
    TriggerServerEvent('nightclubs:server:foodJoinServer')
end)

RegisterNetEvent('nightclubs:client:foodJoinSet', function(d)
    Wait(5000)
    data = d
    if data == nil then
        setdata = false
    elseif data ~= nil then
        setdata = true
    end
end)

local ranThread = false
CreateThread(function()
    while true do
        if CLUB_OWNED then
            if setdata then
                if data['food'] ~= tostring(nil) then
                    if GetClockHours() == Config.FoodMission.time and not ranThread then
                        ranThread = true
                        local tmp = tonumber(data['food']) - Config.FoodMission.remove
                        if tmp < Config.FoodMission.min then
                            -- exports['okokNotify']:Alert('Nightclub', 'You\'re running low on food! Replenish now!', 7000, 'warning', true)
                            lib.notify({ title = 'Nightclub', description = 'You\'re running low on food! Replenish now!', type = 'warning', duration = 7000 })
                        end
                        data['food'] = tmp
                        TriggerServerEvent('nightclubs:server:foodSet', data)
                    end
                end
            end
        end
        if GetClockHours() == 0 then
            ranThread = false
        end
        Wait(10000)
    end
end)
