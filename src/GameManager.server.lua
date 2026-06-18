-- Car Tycoon - Main Game Manager
-- Server-side game initialization and event setup

local CONFIG = require(game:GetService("ServerStorage"):WaitForChild("Config"))
local MoneyManager = require(game:GetService("ServerStorage"):WaitForChild("MoneyManager"))

local GameManager = {}

-- ==================== INITIALIZATION ====================

function GameManager:Initialize()
    print("🚗 Car Tycoon - Game Manager initialized!")
    
    -- Créer les RemoteEvents s'ils n'existent pas
    self:CreateRemoteEvents()
    
    -- Setup des événements joueur
    self:SetupPlayerEvents()
    
    -- Start production loop
    self:StartProductionLoop()
end

-- ==================== REMOTE EVENTS ====================

function GameManager:CreateRemoteEvents()
    local replicatedStorage = game:GetService("ReplicatedStorage")
    
    -- Créer dossier RemoteEvents s'il n'existe pas
    if not replicatedStorage:FindFirstChild("RemoteEvents") then
        local remoteEventsFolder = Instance.new("Folder")
        remoteEventsFolder.Name = "RemoteEvents"
        remoteEventsFolder.Parent = replicatedStorage
    end
    
    local remoteEventsFolder = replicatedStorage:FindFirstChild("RemoteEvents")
    
    -- Créer les RemoteEvents
    local remoteEvents = {
        "UpdateMoneyEvent",
        "UpdateStatsEvent",
        "UnlockCarEvent",
        "AssembleCarEvent",
        "BuyUpgradeEvent",
        "HireWorkerEvent",
        "PlayerConnectedEvent"
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
    local players = game:GetService("Players")
    
    -- Joueur rejoint
    players.PlayerAdded:Connect(function(player)
        print("👤 " .. player.Name .. " a rejoint le serveur")
        
        -- Charger l'argent du joueur
        MoneyManager:LoadPlayerMoney(player)
        
        -- Envoyer les données initiales
        local initialMoney = MoneyManager:GetPlayerMoney(player)
        local updateEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("UpdateMoneyEvent")
        updateEvent:FireClient(player, initialMoney)
    end)
    
    -- Joueur part
    players.PlayerRemoving:Connect(function(player)
        print("👤 " .. player.Name .. " a quitté le serveur")
        
        -- Sauvegarder l'argent avant de partir
        MoneyManager:SavePlayerMoney(player)
        
        -- Nettoyer les données du joueur
        MoneyManager:RemovePlayer(player)
    end)
end

-- ==================== ASSEMBLY EVENT ====================

function GameManager:SetupAssemblyEvent()
    local assembleEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("AssembleCarEvent")
    
    assembleEvent.OnServerEvent:Connect(function(player, carType)
        if not player or not carType then return end
        
        local car = CONFIG:GetCarByType(carType)
        if not car then return end
        
        -- Donner l'argent au joueur
        MoneyManager:AddMoney(player, car.revenue)
        
        -- Envoyer les stats
        local statsEvent = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("UpdateStatsEvent")
        statsEvent:FireClient(player, {
            money = MoneyManager:GetPlayerMoney(player),
            carAssembled = 1
        })
    end)
    
    print("✅ Événement Assembly configuré")
end

-- ==================== PRODUCTION LOOP ====================

function GameManager:StartProductionLoop()
    print("🔄 Production loop démarrée")
    
    while true do
        wait(CONFIG.PRODUCTION_UPDATE_RATE)
        
        -- Mettre à jour la production des ouvriers
        -- À implémenter lors de la Phase 4
    end
end

-- ==================== START ====================

GameManager:Initialize()
GameManager:SetupAssemblyEvent()

return GameManager
