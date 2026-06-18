-- Car Tycoon - Money Management System
-- Handles all money transactions and DataStore

local CONFIG = require(game:GetService("ServerStorage"):WaitForChild("Config"))
local DataStoreService = game:GetService("DataStoreService")

local MoneyManager = {}
local playerMoney = {} -- Cache des argents joueur {userId = amount}
local dataStore = DataStoreService:GetDataStore(CONFIG.DATASTORE_KEY)

-- ==================== MONEY OPERATIONS ====================

function MoneyManager:AddMoney(player, amount)
    if not player or not amount or amount < 0 then return false end
    
    local userId = player.UserId
    if not playerMoney[userId] then
        playerMoney[userId] = 0
    end
    
    playerMoney[userId] = playerMoney[userId] + amount
    
    -- Envoyer l'update au client
    local updateEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("UpdateMoneyEvent")
    updateEvent:FireClient(player, playerMoney[userId])
    
    return true
end

function MoneyManager:SpendMoney(player, amount)
    if not player or not amount or amount < 0 then return false end
    
    local userId = player.UserId
    if not playerMoney[userId] then
        playerMoney[userId] = 0
    end
    
    if playerMoney[userId] >= amount then
        playerMoney[userId] = playerMoney[userId] - amount
        
        -- Envoyer l'update au client
        local updateEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("UpdateMoneyEvent")
        updateEvent:FireClient(player, playerMoney[userId])
        
        return true
    end
    
    return false
end

function MoneyManager:GetPlayerMoney(player)
    if not player then return 0 end
    return playerMoney[player.UserId] or 0
end

function MoneyManager:CanAfford(player, cost)
    return self:GetPlayerMoney(player) >= cost
end

function MoneyManager:SetPlayerMoney(player, amount)
    if player then
        playerMoney[player.UserId] = amount
        local updateEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("UpdateMoneyEvent")
        updateEvent:FireClient(player, amount)
    end
end

-- ==================== DATASTORE OPERATIONS ====================

function MoneyManager:SavePlayerMoney(player)
    if not player then return false end
    
    local success, err = pcall(function()
        local userId = player.UserId
        local money = playerMoney[userId] or 0
        dataStore:SetAsync("Money_" .. userId, money)
    end)
    
    if not success then
        warn("Erreur sauvegarde argent: " .. err)
        return false
    end
    
    return true
end

function MoneyManager:LoadPlayerMoney(player)
    if not player then return false end
    
    local success, money = pcall(function()
        return dataStore:GetAsync("Money_" .. player.UserId)
    end)
    
    if success and money then
        playerMoney[player.UserId] = money
        local updateEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("UpdateMoneyEvent")
        updateEvent:FireClient(player, money)
        return true
    end
    
    -- Si pas de donnée, initialiser avec 0
    playerMoney[player.UserId] = 0
    return false
end

-- ==================== CLEANUP ====================

function MoneyManager:RemovePlayer(player)
    if player then
        playerMoney[player.UserId] = nil
    end
end

return MoneyManager
