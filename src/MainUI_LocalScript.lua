-- Car Tycoon - Main UI Client Script (Improved)
-- LocalScript in StarterGui > MainUI

local CONFIG = require(game:GetService("ServerStorage"):WaitForChild("Config"))
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==================== UI VARIABLES ====================

local currentMoney = 0
local selectedCar = "SEDAN"
local isAssembling = false
local assemblyCountdown = 0

-- ==================== SETUP UI ====================

local mainUI = script.Parent
if not mainUI:IsA("ScreenGui") then
    error("MainUI_LocalScript doit être dans une ScreenGui!")
end

-- ==================== CREATE TOP BAR ====================

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0.08, 0)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
topBar.BorderSizePixel = 0
topBar.Parent = mainUI

-- Money Label
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(0.4, 0, 1, 0)
moneyLabel.Position = UDim2.new(0.05, 0, 0, 0)
moneyLabel.BackgroundTransparency = 1
moneyLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
moneyLabel.TextSize = 20
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.Text = "$0"
moneyLabel.Parent = topBar

-- Level Label
local levelLabel = Instance.new("TextLabel")
levelLabel.Name = "LevelLabel"
levelLabel.Size = UDim2.new(0.3, 0, 1, 0)
levelLabel.Position = UDim2.new(0.5, 0, 0, 0)
levelLabel.BackgroundTransparency = 1
levelLabel.TextColor3 = Color3.fromRGB(100, 150, 255)
levelLabel.TextSize = 20
levelLabel.Font = Enum.Font.GothamBold
levelLabel.Text = "Niveau: 1"
levelLabel.Parent = topBar

-- ==================== CREATE MAIN SCREEN ====================

local mainScreen = Instance.new("Frame")
mainScreen.Name = "MainScreen"
mainScreen.Size = UDim2.new(1, 0, 0.92, 0)
mainScreen.Position = UDim2.new(0, 0, 0.08, 0)
mainScreen.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainScreen.BorderSizePixel = 0
mainScreen.Parent = mainUI

-- Car Display
local carDisplay = Instance.new("TextLabel")
carDisplay.Name = "CarDisplay"
carDisplay.Size = UDim2.new(1, 0, 0.15, 0)
carDisplay.Position = UDim2.new(0, 0, 0.05, 0)
carDisplay.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
carDisplay.BorderSizePixel = 0
carDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
carDisplay.TextSize = 24
carDisplay.Font = Enum.Font.GothamBold
carDisplay.Text = "🚗 Sedan Classique"
carDisplay.Parent = mainScreen

-- Assemble Button
local assembleButton = Instance.new("TextButton")
assembleButton.Name = "AssembleButton"
assembleButton.Size = UDim2.new(0.6, 0, 0.3, 0)
assembleButton.Position = UDim2.new(0.2, 0, 0.25, 0)
assembleButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
assembleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
assembleButton.TextSize = 28
assembleButton.Font = Enum.Font.GothamBold
assembleButton.Text = "ASSEMBLER\n+$100"
assembleButton.BorderSizePixel = 0
assembleButton.Parent = mainScreen

-- Progress Bar Background
local progressBarBg = Instance.new("Frame")
progressBarBg.Name = "ProgressBarBg"
progressBarBg.Size = UDim2.new(0.6, 0, 0.08, 0)
progressBarBg.Position = UDim2.new(0.2, 0, 0.58, 0)
progressBarBg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
progressBarBg.BorderSizePixel = 0
progressBarBg.Parent = mainScreen

-- Progress Bar Fill
local progressBarFill = Instance.new("Frame")
progressBarFill.Name = "Fill"
progressBarFill.Size = UDim2.new(0, 0, 1, 0)
progressBarFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
progressBarFill.BorderSizePixel = 0
progressBarFill.Parent = progressBarBg

-- Shop Button (Bottom)
local shopButton = Instance.new("TextButton")
shopButton.Name = "ShopButton"
shopButton.Size = UDim2.new(0.4, 0, 0.1, 0)
shopButton.Position = UDim2.new(0.3, 0, 0.85, 0)
shopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
shopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
shopButton.TextSize = 18
shopButton.Font = Enum.Font.GothamBold
shopButton.Text = "🛒 SHOP"
shopButton.BorderSizePixel = 0
shopButton.Parent = mainScreen

-- ==================== FUNCTIONS ====================

local function UpdateMoneyDisplay(amount)
    currentMoney = amount
    moneyLabel.Text = CONFIG:FormatMoney(amount)
end

local function UpdateLevelDisplay(level)
    levelLabel.Text = "Niveau: " .. level
end

local function GetAssemblyTime()
    local car = CONFIG:GetCarByType(selectedCar)
    if not car then return CONFIG.BASE_ASSEMBLY_TIME end
    return car.assemblyTime
end

local function GetCarRevenue()
    local car = CONFIG:GetCarByType(selectedCar)
    if not car then return 0 end
    return car.revenue
end

-- ==================== ASSEMBLY EVENT ====================

assembleButton.MouseButton1Click:Connect(function()
    if isAssembling then return end
    
    isAssembling = true
    local duration = GetAssemblyTime()
    assembleButton.Text = "..."
    
    -- Envoyer au serveur
    local assembleEvent = replicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AssembleCarEvent")
    assembleEvent:FireServer(selectedCar)
    
    -- Animation de la barre de progression
    local startTime = tick()
    
    while tick() - startTime < duration and isAssembling do
        local elapsed = tick() - startTime
        local progress = math.min(elapsed / duration, 1)
        progressBarFill:TweenSize(UDim2.new(progress, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.05)
        wait(0.05)
    end
    
    progressBarFill:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.1)
    assembleButton.Text = "ASSEMBLER\n+" .. CONFIG:FormatMoney(GetCarRevenue())
    isAssembling = false
end)

-- ==================== SHOP BUTTON ====================

shopButton.MouseButton1Click:Connect(function()
    print("📂 Shop ouvert (à implémenter en Phase 4)")
end)

-- ==================== SERVER EVENTS ====================

local function WaitForRemoteEvents()
    local remoteEvents = replicatedStorage:WaitForChild("RemoteEvents")
    
    -- Money Update
    local updateMoneyEvent = remoteEvents:WaitForChild("UpdateMoneyEvent")
    updateMoneyEvent.OnClientEvent:Connect(function(amount)
        UpdateMoneyDisplay(amount)
    end)
    
    -- Level Update
    local updateLevelEvent = remoteEvents:FindFirstChild("UpdateLevelEvent")
    if updateLevelEvent then
        updateLevelEvent.OnClientEvent:Connect(function(level)
            UpdateLevelDisplay(level)
        end)
    end
    
    print("✅ Événements client configurés")
end

-- ==================== INITIALIZATION ====================

print("✅ Main UI chargé")
UpdateMoneyDisplay(0)
UpdateLevelDisplay(1)

-- Wait for server to be ready
task.delay(0.5, function()
    WaitForRemoteEvents()
end)
