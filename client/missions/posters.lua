ESX = exports["es_extended"]:getSharedObject()

local blips = {}
local zones = {}
local data
local controlListen = false
local count = 0
local foodProgress = false

local function removeClose(k)
    RemoveBlip(blips[k])
    zones[k]:remove()
end

local function loading(k)
    local success = lib.skillCheck({'easy', 'easy', 'medium', 'easy'}, {'w', 'a', 's', 'd'})
    
    if success then
        if lib.progressCircle({
            duration = 7000,
            position = 'bottom',
            label = 'Hanging poster...',
            useWhileDead = false,
            canCancel = false,
            disable = {
                car = true,
            },
            anim = {
                scenario = 'WORLD_HUMAN_HAMMERING',
            },
            prop = {},
        }) then
            removeClose(k)
            count = count + 1
            Wait(1000)
            if #blips == count then
                TriggerServerEvent('nightclubs:server:posterSetData')
                -- exports['okokNotify']:Alert('Nightclub', 'You\'ve hanged all of the posters!', 7000, 'success', true)
                lib.notify({ title = 'Nightclub', description = 'You\'ve hanged all of the posters!', type = 'success', duration = 7000 }) 
                MISSION_PROGRESS =  false
                zones = nil
                blips = nil
                count = 0
                foodProgress = false
            end
        end
    else
        -- exports['okokNotify']:Alert('', 'Try again!', 7000, 'error', true)
        lib.notify({ title = '', description = 'Try again!', type = 'error', duration = 7000 }) 
    end
end

local function createBase(num)
    for k, v in pairs(Config.PosterMission.place[tonumber(num)].location) do
        blips[k] = AddBlipForCoord(Config.PosterMission.place[tonumber(num)].location[k].coords.x,
            Config.PosterMission.place[tonumber(num)].location[k].coords.y,
            Config.PosterMission.place[tonumber(num)].location[k].coords.z)
        SetBlipColour(blips[k], Config.PosterMission.blip.color)
        SetBlipSprite(blips[k], Config.PosterMission.blip.sprite)
        SetBlipScale(blips[k], .6)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(Config.PosterMission.blip.name)
        EndTextCommandSetBlipName(blips[k])

        zones[k] = lib.zones.box({
            coords = vec3(Config.PosterMission.place[tonumber(num)].location[k].coords.x, Config.PosterMission.place[tonumber(num)].location[k].coords.y, Config.PosterMission.place[tonumber(num)].location[k].coords.z),
            size = vec3(2, 2, 2),
            debug = false,
            onEnter = function()
                controlListen = true
            end,
            inside = function()
                while controlListen do
                    lib.showTextUI('[E] - Hang Poster')
                    if IsControlJustReleased(0, 38) then
                        lib.hideTextUI()
                        loading(k)
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
end

RegisterNetEvent('nightclubs:client:posterGetData', function(missionData)
    data = json.decode(missionData)
    if tonumber(data['posters']) < 4 then
        if not MISSION_PROGRESS then
            foodProgress = true
            MISSION_PROGRESS =  true
            createBase(data['posters'])
            -- exports['okokNotify']:Alert('Nightclub', 'Head outside and hang posters for advertisement!', 7000, 'info', true)
            lib.notify({ title = 'Nightclub', description = 'Head outside and hang posters for advertisement!', type = 'info', duration = 7000 })
        else
            -- exports['okokNotify']:Alert('Nightclub', 'You already have a mission going!', 7000, 'warning', true)
            lib.notify({ title = 'Nightclub', description = 'You already have a mission going!', type = 'warning', duration = 7000 })
        end
    else
        -- exports['okokNotify']:Alert('Nightclub', 'You\'ve already put the maximum posters outside!', 7000, 'warning', true)
        lib.notify({ title = 'Nightclub', description = 'You\'ve already put the maximum posters outside!', type = 'warning', duration = 7000 })
    end
end)

RegisterNetEvent('esx:onPlayerDeath', function()
    if foodProgress then
        for k, v in pairs(blips) do
            RemoveBlip(blips[k])
            zones[k]:remove()
        end
        zones = nil
        blips = nil
        foodProgress = false
    end
end)