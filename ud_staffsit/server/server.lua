local QBCore = exports['qb-core']:GetCoreObject()

local function permsCheck(source)
    local roles = exports.Badger_Discord_API:GetDiscordRoles(source)
    for i = 1, #roles do
        if roles[i] == Config.allowedRole then
            return true
        end
    end
    return false
end

RegisterNetEvent('ud:setBucket', function(bucket)
    local hasPerms = permsCheck(source)

    if hasPerms then
        SetPlayerRoutingBucket(source, bucket)
        SetRoutingBucketPopulationEnabled(bucket, false)
        TriggerClientEvent('chat:addMessage', source, {
            color = {25, 255, 25},
            multiline = true,
            args = {'[Success!]', 'Your Routing Bucket Has Been Set To ' .. bucket .. '!'}
        })
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 25, 25},
            multiline = true,
            args = {'[Denied]', 'Invalid Permission! If this is a mistake please open a ticket.'}
        })
    end
end)

RegisterNetEvent('ud:staffSit', function(targets)
    local source = source
    local hasPerms = permsCheck(source)

    if hasPerms then
        local players = QBCore.Functions.GetPlayers()
        local bucket = Config.buckets
        
        -- Set the source player's bucket first
        SetPlayerRoutingBucket(source, bucket)
        SetRoutingBucketPopulationEnabled(bucket, false)
        
        local successfulTargets = {}
        local failedTargets = {}

        for i = 1, #targets do
            local targetId = tonumber(targets[i])
            local playerPed = GetPlayerPed(targetId)
            if playerPed and DoesEntityExist(playerPed) then
                SetPlayerRoutingBucket(targetId, bucket)
                table.insert(successfulTargets, targetId)
            else
                table.insert(failedTargets, targetId)
            end
        end

        -- Notify about successful targets
        if #successfulTargets > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = {25, 255, 25},
                multiline = true,
                args = {'[Success!]', 'Your Routing Bucket Along With Player(s) ' .. table.concat(successfulTargets, ", ") .. ' Has Been Set To ' .. bucket .. '!'}
            })
        end

        -- Notify about failed targets
        if #failedTargets > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 25, 25},
                multiline = true,
                args = {'[Failed Action!]', 'Player(s) ' .. table.concat(failedTargets, ", ") .. ' Not Found!'}
            })
        end

        Config.buckets = Config.buckets - 1
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 25, 25},
            multiline = true,
            args = {'[Denied!]', 'Invalid Permissions! If this is a mistake please open a ticket.'}
        })
    end
end)

RegisterNetEvent('ud:resetBuckets', function(targets)
    local source = source
    local hasPerms = permsCheck(source)

    if hasPerms then
        local players = QBCore.Functions.GetPlayers()
        local successfulResets = {source}  -- Include the source player
        local failedResets = {}

        -- Reset the source player's bucket first
        SetPlayerRoutingBucket(source, 0)

        for i = 1, #targets do
            local targetId = tonumber(targets[i])
            local playerPed = GetPlayerPed(targetId)
            if playerPed and DoesEntityExist(playerPed) then
                SetPlayerRoutingBucket(targetId, 0)
                table.insert(successfulResets, targetId)
            else
                table.insert(failedResets, targetId)
            end
        end

        -- Notify about successful resets
        if #successfulResets > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = {25, 255, 25},
                multiline = true,
                args = {'[Success!]', 'Your Routing Bucket Along With Player(s) ' .. table.concat(successfulResets, ", ") .. ' Has Been Reset To 0!'}
            })
        end

        -- Notify about failed resets
        if #failedResets > 0 then
            TriggerClientEvent('chat:addMessage', source, {
                color = {255, 25, 25},
                multiline = true,
                args = {'[Failed Action!]', 'Player(s) ' .. table.concat(failedResets, ", ") .. ' Not Found!'}
            })
        end
    else
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 25, 25},
            multiline = true,
            args = {'[Denied!]', 'Invalid Permissions! If this is a mistake please open a ticket.'}
        })
    end
end)
