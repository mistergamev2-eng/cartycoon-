-- Car Tycoon - Main UI Client Script
-- LocalScript in StarterGui > MainUI

local CONFIG = require(game:GetService("ServerStorage"):WaitForChild("Config"))
local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local player = players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ==================== UI SETUP ====================

local mainUI = script.Parent -- MainUI ScreenGui
local screenSize = mainUI.AbsoluteSize

-- Variables pour l'UI
local currentMoney = 0
local selectedCar = "SEDAN"
local isAssemblying = false
local assemblyCountdown = 0

-- ==================== CREATE UI ELEMENTS ====================

-- TopBar pour afficher l'argent
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0.1, 0)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.BorderSizePixel = 0
topBar.Parent = mainUI

-- Affichage argent
local moneyLabel = Instance.new("TextLabel")
moneyLabel.Name = "MoneyLabel"
moneyLabel.Size = UDim2.new(0.5, 0, 1, 0)
moneyLabel.Position = UDim2.new(0.05, 0, 0, 0)
moneyLabel.BackgroundTransparency = 1
moneyLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
moneyLabel.TextSize = 24
moneyLabel.Font = Enum.Font.GothamBold
moneyLabel.Text = "$0"
moneyLabel.Parent = topBar

-- Main Screen - Bouton d'assemblage
local mainScreen = Instance.new("Frame")
mainScreen.Name = "MainScreen"
mainScreen.Size = UDim2.new(0.8, 0, 0.7, 0)
mainScreen.Position = UDim2.new(0.1, 0, 0.15, 0)
mainScreen.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainScreen.BorderSizePixel = 0
mainScreen.Parent = mainUI

-- Affichage de la voiture sélectionnée
local carDisplay = Instance.new("TextLabel")
carDisplay.Name = "CarDisplay"
carDisplay.Size = UDim2.new(1, 0, 0.3, 0)
carDisplay.Position = UDim2.new(0, 0, 0, 0)
carDisplay.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
carDisplay.BorderSizePixel = 0
carDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
carDisplay.TextSize = 28
carDisplay.Font = Enum.Font.GothamBold
carDisplay.Text = "🚗 " .. CONFIG:GetCarByType(selectedCar).name
carDisplay.Parent = mainScreen

-- Bouton Assembler
local assembleButton = Instance.new("TextButton")
assembleButton.Name = "AssembleButton"
assembleButton.Size = UDim2.new(0.8, 0, 0.35, 0)
assembleButton.Position = UDim2.new(0.1, 0, 0.35, 0)
assembleButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
assembleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
assembleButton.TextSize = 32
assembleButton.Font = Enum.Font.GothamBold
assembleButton.Text = "ASSEMBLER"
assembleButton.BorderSizePixel = 0
assembleButton.Parent = mainScreen

-- Barre de progression
local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0.8, 0, 0.1, 0)
progressBar.Position = UDim2.new(0.1, 0, 0.75, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
progressBar.BorderSizePixel = 0
progressBar.Parent = mainScreen

local progressBarFill = Instance.new("Frame")
progressBarFill.Name = "Fill"
progressBarFill.Size = UDim2.new(0, 0, 1, 0)
progressBarFill.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
progressBarFill.BorderSizePixel = 0
progressBarFill.Parent = progressBar

-- ==================== MONEY UPDATE ====================

local function UpdateMoneyDisplay(amount)
    currentMoney = amount
    moneyLabel.Text = CONFIG:FormatMoney(amount)
end

-- Écouter les mises à jour d'argent du serveur
local updateMoneyEvent = replicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("UpdateMoneyEvent")
updateMoneyEvent.OnClientEvent:Connect(function(amount)
    UpdateMoneyDisplay(amount)
end)

-- ==================== ASSEMBLY BUTTON ====================

local function GetAssemblyTime()
    local car = CONFIG:GetCarByType(selectedCar)
    if not car then return CONFIG.BASE_ASSEMBLY_TIME end
    return car.assemblyTime
end

assembleButton.MouseButton1Click:Connect(function()
    if isAssemblying then return end
    
    isAssemblying = true
    assemblyCountdown = GetAssemblyTime()
    
    -- Envoyer au serveur
    local assembleEvent = replicatedStorage:WaitForChild("RemoteEvents"):WaitForChild("AssembleCarEvent")
    assembleEvent:FireServer(selectedCar)
    
    -- Animation de la barre
    local startTime = tick()
    local duration = GetAssemblyTime()
    
    while tick() - startTime < duration and isAssemblying do
        local elapsed = tick() - startTime
        local progress = elapsed / duration
        progressBarFill:TweenSize(UDim2.new(progress, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.05)
        wait(0.05)
    end
    
    progressBarFill:TweenSize(UDim2.new(0, 0, 1, 0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.1)
    isAssemblying = false
end)

-- ==================== INITIALIZATION ====================

print("✅ Main UI Client Script chargé")
UpdateMoneyDisplay(0)
