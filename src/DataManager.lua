-- Car Tycoon - Data Manager
-- Handles all player data saving and loading with DataStore

local CONFIG = require(game:GetService("ServerStorage"):WaitForChild("Config"))
local DataStoreService = game:GetService("DataStoreService")

local DataManager = {}
local dataStore = DataStoreService:GetDataStore(CONFIG.DATASTORE_KEY)
local playerData = {} -- Cache des données joueur {userId = playerData}

-- ==================== DATA LOADING ====================

function DataManager:LoadPlayerData(player)
    if not player then return nil end
    
    local userId = player.UserId
    local success, data = pcall(function()
        return dataStore:GetAsync("PlayerData_" .. userId)
    end)
    
    if success and data then
        playerData[userId] = data
        print("✅ Données chargées pour " .. player.Name)
        return data
    else
        -- Créer des données par défaut
        local newData = self:GetDefaultData()
        playerData[userId] = newData
        print("📝 Nouvelles données créées pour " .. player.Name)
        return newData
    end
end

-- ==================== DATA SAVING ====================

function DataManager:SavePlayerData(player)
    if not player then return false end
    
    local userId = player.UserId
    if not playerData[userId] then return false end
    
    local success, err = pcall(function()
        dataStore:SetAsync("PlayerData_" .. userId, playerData[userId])
    end)
    
    if success then
        print("💾 Données sauvegardées pour " .. player.Name)
        return true
    else
        warn("❌ Erreur sauvegarde: " .. err)
        return false
    end
end

-- ==================== DATA GETTERS ====================

function DataManager:GetPlayerData(player)
    if not player then return nil end
    return playerData[player.UserId]
end

function DataManager:GetDefaultData()
    return {
        totalMoney = 0,
        currentMoney = 0,
        selectedCar = "SEDAN",
        unlockedCars = {"SEDAN"},
        assemblyLineLevel = 1,
        parkingLevel = 1,
        workerCount = 0,
        totalCarsAssembled = 0,
        totalEarnings = 0,
        lastJoinTime = os.time(),
        currentLevel = 1,
        lastLogoutTime = os.time()
    }
end

-- ==================== DATA UPDATES ====================

function DataManager:AddMoney(player, amount)
    if not player or not amount then return false end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    playerData[userId].currentMoney = playerData[userId].currentMoney + amount
    playerData[userId].totalMoney = playerData[userId].totalMoney + amount
    
    return true
end

function DataManager:SpendMoney(player, amount)
    if not player or not amount then return false end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    if playerData[userId].currentMoney >= amount then
        playerData[userId].currentMoney = playerData[userId].currentMoney - amount
        return true
    end
    
    return false
end

function DataManager:GetMoney(player)
    if not player then return 0 end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    return playerData[userId].currentMoney
end

function DataManager:CanAfford(player, cost)
    return self:GetMoney(player) >= cost
end

-- ==================== CAR UNLOCKS ====================

function DataManager:UnlockCar(player, carType)
    if not player or not carType then return false end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    local unlockedCars = playerData[userId].unlockedCars
    
    -- Vérifier si déjà débloqué
    for _, car in ipairs(unlockedCars) do
        if car == carType then
            return false
        end
    end
    
    table.insert(unlockedCars, carType)
    print("🔓 " .. carType .. " débloqué pour " .. player.Name)
    return true
end

function DataManager:IsCarUnlocked(player, carType)
    if not player or not carType then return false end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    for _, car in ipairs(playerData[userId].unlockedCars) do
        if car == carType then
            return true
        end
    end
    
    return false
end

-- ==================== UPGRADE LEVELS ====================

function DataManager:BuyAssemblyLineUpgrade(player)
    if not player then return false end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    local currentLevel = playerData[userId].assemblyLineLevel
    if currentLevel >= #CONFIG.ASSEMBLY_LINE_UPGRADES then
        return false -- Déjà au max
    end
    
    playerData[userId].assemblyLineLevel = currentLevel + 1
    return true
end

function DataManager:GetAssemblyLineLevel(player)
    if not player then return 1 end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    return playerData[userId].assemblyLineLevel
end

-- ==================== WORKERS ====================

function DataManager:HireWorker(player)
    if not player then return false end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    local currentWorkers = playerData[userId].workerCount
    if currentWorkers >= CONFIG.WORKER_SYSTEM.maxWorkers then
        return false -- Déjà au max
    end
    
    playerData[userId].workerCount = currentWorkers + 1
    return true
end

function DataManager:GetWorkerCount(player)
    if not player then return 0 end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    return playerData[userId].workerCount
end

-- ==================== STATS ====================

function DataManager:AddCarsAssembled(player, count)
    if not player or not count then return false end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    playerData[userId].totalCarsAssembled = playerData[userId].totalCarsAssembled + count
    return true
end

function DataManager:GetCurrentLevel(player)
    if not player then return 1 end
    
    local userId = player.UserId
    if not playerData[userId] then
        playerData[userId] = self:GetDefaultData()
    end
    
    local money = playerData[userId].totalMoney
    local level = CONFIG:GetFactoryLevel(money)
    
    playerData[userId].currentLevel = level.level
    return level.level
end

-- ==================== CLEANUP ====================

function DataManager:RemovePlayer(player)
    if player then
        playerData[player.UserId] = nil
    end
end

return DataManager
