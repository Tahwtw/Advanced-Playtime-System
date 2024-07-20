---------------------------
    -- Frameworks --
---------------------------

ESX = exports["es_extended"]:getSharedObject()

---------------------------
    -- Event Handlers --
---------------------------

-- When a player loads, fetch their playtime from the database
AddEventHandler('esx:playerLoaded', function(playerId)
    local identifier = GetPlayerIdentifier(playerId)
    exports.oxmysql:execute('SELECT playtime FROM player_playtime WHERE identifier = @identifier', {['@identifier'] = identifier}, function(result)
        if result[1] then
            TriggerClientEvent('th_playtime:updatePlaytime', playerId, result[1].playtime)
        else
            exports.oxmysql:execute('INSERT INTO player_playtime (identifier, playtime) VALUES (@identifier, 0)', {['@identifier'] = identifier})
            TriggerClientEvent('th_playtime:updatePlaytime', playerId, 0)
        end
    end)
end)

RegisterServerEvent('th_playtime:updateServerPlaytime')
AddEventHandler('th_playtime:updateServerPlaytime', function()
    local playerId = source
    local identifier = GetPlayerIdentifier(playerId)
    exports.oxmysql:execute('UPDATE player_playtime SET playtime = playtime + 1 WHERE identifier = @identifier', {['@identifier'] = identifier})
    exports.oxmysql:execute('SELECT playtime FROM player_playtime WHERE identifier = @identifier', {['@identifier'] = identifier}, function(result)
        if result[1] then
            TriggerClientEvent('th_playtime:updatePlaytime', playerId, result[1].playtime)
        end
    end)
end)

---------------------------
    -- Commands --
---------------------------

lib.addCommand({"playtime", "level", "levelup"}, {
    help = 'Display your character\'s playtime.',
}, function(source, args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local PlayerName = xPlayer.getName(source)
    local playerId = source
    local identifier = GetPlayerIdentifier(playerId)
    exports.oxmysql:execute('SELECT playtime FROM player_playtime WHERE identifier = @identifier', {['@identifier'] = identifier}, function(result)
        if result[1] then
            local hours = math.floor(result[1].playtime / 3600)
            local minutes = math.floor((result[1].playtime % 3600) / 60)
            local seconds = result[1].playtime % 60
            TriggerClientEvent('chat:addMessage', playerId, {
                color = { 0, 0, 0},
                multiline = true,
                args = {"^1[ ! ]:", "Your total character play time for ^3"..PlayerName..": ^0" .. hours .. " hours, "..minutes.." minutes, "..seconds.." seconds."}
            })
        end
    end)
end)