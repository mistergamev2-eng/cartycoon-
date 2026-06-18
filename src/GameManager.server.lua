-- Car Tycoon - Improved Game Manager
-- Server-side game initialization and event setup

local CONFIG = require(game:GetService("ServerStorage"):WaitForChild("Config"))
local MoneyManager = require(game:GetService("ServerStorage"):WaitForChild("MoneyManager"))
local DataManager = require(game:GetService("ServerStorage"):WaitForChild("DataManager"))

local GameManager = {}
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

-- ==================== INITIALIZATION ====================

function GameManager:Initialize()
    print("🚗 Car Tycoon - Game Manager initialized!")
    
    -- Créer les RemoteEvents
    self:CreateRemoteEvents()
    
    -- Setup des événements joueur
    self:SetupPlayerEvents()
    
    -- Setup des événements de jeu
    self:SetupGameEvents()
    
    -- Start production loop
    self:StartProductionLoop()
end

-- ==================== REMOTE EVENTS ====================

function GameManager:CreateRemoteEvents()
    if not replicatedStorage:FindFirstChild("RemoteEvents") then
        local remoteEventsFolder = Instance.new("Folder")
        remoteEventsFolder.Name = "RemoteEvents"
        remoteEventsFolder.Parent = replicatedStorage
    end
    
    local remoteEventsFolder = replicatedStorage:FindFirstChild("RemoteEvents")
    
    local remoteEvents = {
        "UpdateMoneyEvent",
        "UpdateLevelEvent",
        "UpdateStatsEvent",
        "UnlockCarEvent",
        "AssembleCarEvent",
        "BuyUpgradeEvent",
        "HireWorkerEvent"
    }
    
    for _, eventName in ipairs(remoteEvents) do
        if not remoteEventsFolder:FindFirstChild(eventName) then
            local event = Instance.new("RemoteEvent")
            event.Name = eventName
            event.Parent = remoteEventsFolder
        end
    end
    
    print("✅ RemoteEvents créés/vérifiés")
end

-- ==================== PLAYER EVENTS ====================

function GameManager:SetupPlayerEvents()
    -- Joueur rejoint
    players.PlayerAdded:Connect(function(player)
        print("👤 " .. player.Name .. " a rejoint le serveur")
        
        -- Charger les données du joueur
        local playerData = DataManager:LoadPlayerData(player)
        
        -- Mettre à jour MoneyManager avec les données du DataStore
        MoneyManager:SetPlayerMoney(player, playerData.currentMoney)
        
        -- Envoyer les données initiales au client
        local updateMoneyEvent = replicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("UpdateMoneyEvent")
        updateMoneyEvent:FireClient(player, playerData.currentMoney)
        
        local updateLevelEvent = replicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("UpdateLevelEvent")
        updateLevelEvent:FireClient(player, playerData.currentLevel)
    end)
    
    -- Joueur part
    players.PlayerRemoving:Connect(function(player)
        print("👤 " .. player.Name .. " a quitté le serveur")
        
        -- Sauvegarder les données
        DataManager:SavePlayerData(player)
        MoneyManager:SavePlayerMoney(player)
        
        -- Nettoyer
        MoneyManager:RemovePlayer(player)
        DataManager:RemovePlayer(player)
    end)
end

-- ==================== GAME EVENTS ====================

function GameManager:SetupGameEvents()
    local remoteEvents = replicatedStorage:WaitForChild("RemoteEvents")
    
    -- Assembly Event
    local assembleEvent = remoteEvents:WaitForChild("AssembleCarEvent")
    assembleEvent.OnServerEvent:Connect(function(player, carType)
        if not player or not carType then return end
        
        -- Vérifier que la voiture est débloquée
        if not DataManager:IsCarUnlocked(player, carType) then
            warn(player.Name .. " tente d'assembler une voiture non débloquée!")
            return
        end
        
        local car = CONFIG:GetCarByType(carType)
        if not car then return end
        
        -- Ajouter l'argent au joueur
        DataManager:AddMoney(player, car.revenue)
        MoneyManager:AddMoney(player, car.revenue)
        
        -- Mettre à jour les stats
        DataManager:AddCarsAssembled(player, 1)
        
        -- Envoyer les mises à jour au client
        local updateMoneyEvent = remoteEvents:WaitForChild("UpdateMoneyEvent")
        updateMoneyEvent:FireClient(player, MoneyManager:GetPlayerMoney(player))
        
        local currentLevel = DataManager:GetCurrentLevel(player)
        if currentLevel > DataManager:GetPlayerData(player).currentLevel then
            local updateLevelEvent = remoteEvents:WaitForChild("UpdateLevelEvent")
            updateLevelEvent:FireClient(player, currentLevel)
        end
    end)
    
    print("✅ Événements de jeu configurés")
end

-- ==================== PRODUCTION LOOP ====================

function GameManager:StartProductionLoop()
    print("🔄 Production loop démarrée")
    
    while true do
        wait(CONFIG.PRODUCTION_UPDATE_RATE)
        
        -- Production des ouvriers - À implémenter en Phase 4
    end
end

-- ==================== SAVE LOOP ====================

function GameManager:StartSaveLoop()
    print("💾 Save loop démarrée")
    
    while true do
        wait(60) -- Sauvegarder toutes les minutes
        
        for _, player in ipairs(players:GetPlayers()) do
            DataManager:SavePlayerData(player)
            MoneyManager:SavePlayerMoney(player)
        end
    end
end

-- ==================== START ====================

GameManager:Initialize()
GameManager:StartSaveLoop()

print("🎮 Car Tycoon Server Ready!")

return GameManager
