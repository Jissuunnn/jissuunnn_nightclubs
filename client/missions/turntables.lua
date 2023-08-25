ESX = exports["es_extended"]:getSharedObject()

local blips = {}
local zones = {}
local obj = {}
local count = 0
local base = 0
local effectProgress = false
local controlListen

local function removeStuff(k)
    RemoveBlip(blips[k])
    zones[k]:remove()
    DeleteObject(obj[k])
end

local function loading(k)
    local success = lib.skillCheck({'easy', 'easy', 'medium', 'easy'}, {'w', 'a', 's', 'd'})
    
    if success then
        if lib.progressCircle({
            duration = 3000,
            position = 'bottom',
            label = 'Taking equipment...',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                dict = 'random@domestic',
                clip = 'pickup_low',
            },
            prop = {},
        }) then
            removeStuff(k)
            count = count + 1
            Wait(1000)
            if base == count then
                TriggerServerEvent('nightclubs:server:effectSetData')
                -- exports['okokNotify']:Alert('Nightclub', 'You picked up all the equipments!', 7000, 'success', true)
                lib.notify({ title = 'Nightclub', description = 'You picked up all the equipments!', type = 'success', duration = 7000 }) 
                MISSION_PROGRESS =  false
                zones = nil
                blips = nil
                count = 0
                effectProgress = false
            end
        end
    else
        -- exports['okokNotify']:Alert('', 'Try again!', 7000, 'error', true)
        lib.notify({ title = '', description = 'Try again!', type = 'error', duration = 7000 }) 
    end
end

local function createStuff(num)
    RequestModel('pbus2')
    while not HasModelLoaded('pbus2') do
        Citizen.Wait(1)
    end

    obj[num] = CreateObject('pbus2', Config.EffectsMission.place[num].coords.x, Config.EffectsMission.place[num].coords.y, Config.EffectsMission.place[num].coords.z - 1.5, true, true, false)
    SetEntityAsMissionEntity(obj[num], true, true)
    SetEntityHeading(obj[num], Config.EffectsMission.place[num].coords.w)
    FreezeEntityPosition(obj[num], true)

    blips[num] = AddBlipForCoord(Config.EffectsMission.place[num].coords.x, Config.EffectsMission.place[num].coords.y,
        Config.EffectsMission.place[num].coords.z)
    SetBlipColour(blips[num], Config.EffectsMission.blip.color)
    SetBlipSprite(blips[num], Config.PosterMission.blip.sprite)
    SetBlipScale(blips[num], .6)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.PosterMission.blip.name .. '-' .. Config.EffectsMission.place[num].name)
    EndTextCommandSetBlipName(blips[num])

    zones[num] = lib.zones.box({
        coords = vec3(Config.EffectsMission.place[num].coords.x, Config.EffectsMission.place[num].coords.y, Config.EffectsMission.place[num].coords.z),
        size = vec3(12, 6, 6),
        debug = false,
        onEnter = function()
            controlListen = true
        end,
        inside = function()
            while controlListen do
                lib.showTextUI('[E] - Pick up equipment')
                if IsControlJustReleased(0, 38) then
                    lib.hideTextUI()
                    loading(num)
                    controlListen = false
                end
                Wait(1)
            end
        end,
        onExit = function()
            lib.hideTextUI()
        end
    })
end

RegisterNetEvent('nightclubs:client:equiptmentStartMission', function(data)
    local tempData = json.decode(data) 
    if ((tempData['turntables'] ~= tostring(nil)) and (tempData['droplets'] ~= tostring(nil)) and (tempData['speakers'] ~= tostring(nil))) then
        -- exports['okokNotify']:Alert('Nightclub', 'You already have the lights, turntables and speakers!', 7000, 'warning', true)
        lib.notify({ title = 'Nightclub', description = 'You already have the lights, turntables and speakers!', type = 'warning', duration = 7000 }) 
        return
    else
        MISSION_PROGRESS = true
        effectProgress = true
        TriggerServerEvent('nightclubs:server:returnEntrance')
        lib.notify({ title = 'Nightclub', description = 'Go to the marked location and pick up the equipment!', type = 'info', duration = 7000 }) 
        for k, v in pairs(Config.EffectsMission.place) do
            -- exports['okokNotify']:Alert('Nightclub', 'Go to the marked locations and pick up the equipment!', 7000, 'info', true)
            -- lib.notify({ title = 'Nightclub', description = 'Go to the marked location and pick up the equipment!', type = 'info', duration = 7000 }) 
            if tempData[Config.EffectsMission.place[k].name] == tostring(nil) then
                base = base + 1
                createStuff(k)
            end
        end
    end
end)
