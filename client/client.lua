---------------------------
    -- Frameworks --
---------------------------

ESX = exports["es_extended"]:getSharedObject()

---------------------------
    -- Variables --
---------------------------

local playtime = 0
local requiredPlaytime = Config.Settings.Playtime

---------------------------
    -- Event Handlers --
---------------------------

RegisterNetEvent('th_playtime:updatePlaytime')
AddEventHandler('th_playtime:updatePlaytime', function(serverPlaytime)
    playtime = serverPlaytime
end)

---------------------------
    -- Threads --
---------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(600) -- 1 second interval
        TriggerServerEvent('th_playtime:updateServerPlaytime')
    end
end)

lib.onCache('weapon', function()
    local playerData = ESX.GetPlayerData()
    
    if IsPedArmed(cache.ped, 4 | 2) then
        if playerData.job.name ~= 'police' and playtime < requiredPlaytime then
            TriggerEvent('ox_inventory:disarm', 1, true)
            TriggerEvent('chat:addMessage', {
                color = { 255, 0, 0},
                multiline = false,
                args = {"^1[ ! ]: ^0You need 3/4 hours of play time to use a weapon on this character."}
            })
        end
    end
end)