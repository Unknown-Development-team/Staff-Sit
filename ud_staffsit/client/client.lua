-- Command to set you the source's bucket. Example: /setbucket 5 would set you and only you to routing bucket 5
RegisterCommand(Config.selfBucket, function(source, args, rawCommand)
    local bucket = tonumber(args[1])
    TriggerServerEvent('ud:setBucket', bucket)
end)

-- Command to set multiple players to a bucket, Example: /commaneName 1 2 3 would set yourself, and the players with the server ID's 1, 2 and 3 to a uniqe routing bucket
RegisterCommand(Config.startSit, function(source, args, rawCommand)
    local player = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(player)
    local targetArgs = string.sub(rawCommand, string.len(Config.startSit) + 1)
    local targets = {}

    for target in string.gmatch(targetArgs, '%d+') do
        table.insert(targets, tonumber(target))
    end

    for i = 1, #targets do
        SetEntityCoords(targets[i], playerCoords.x, playerCoords.y, playerCoords.x, true, false, false, false)
    end

    TriggerServerEvent('ud:staffSit', targets)
end)

-- Command to reset multiple players buckets back to 0. Example: /commandName 1 2 3 would set yourself, and the players with the server ID's 1, 2 and 3 back to routing bucket 0
RegisterCommand(Config.resetSit, function(source, args, rawCommand)
    local targetArgs = string.sub(rawCommand, string.len(Config.resetSit) + 1)
    local targets = {}

    for target in string.gmatch(targetArgs, '%d+') do
        table.insert(targets, tonumber(target))
    end

    TriggerServerEvent('ud:resetBuckets', targets)
end)