-- Car Tycoon - Game Configuration
-- All game constants, prices, and balance values

local CONFIG = {}

-- ==================== CARS ====================
CONFIG.CARS = {
    SEDAN = {
        name = "Sedan Classique",
        revenue = 100,
        assemblyTime = 5,
        unlockCost = 0,
        unlockMilestone = 0,
        description = "La voiture pour débuter"
    },
    SPORTS = {
        name = "Sports Car",
        revenue = 500,
        assemblyTime = 4,
        unlockCost = 5000,
        unlockMilestone = 10000,
        description = "Plus rapide et plus rentable"
    },
    LUXURY = {
        name = "Luxury Sedan",
        revenue = 2000,
        assemblyTime = 3,
        unlockCost = 50000,
        unlockMilestone = 100000,
        description = "Le confort et la vitesse"
    },
    SUPERCAR = {
        name = "SuperCar",
        revenue = 10000,
        assemblyTime = 2,
        unlockCost = 500000,
        unlockMilestone = 1000000,
        description = "Performance maximale"
    },
    ELECTRIC = {
        name = "Electric Vehicle",
        revenue = 15000,
        assemblyTime = 1.5,
        unlockCost = 2000000,
        unlockMilestone = 5000000,
        description = "L'avenir est ici"
    },
    CONCEPT = {
        name = "Concept Car",
        revenue = 50000,
        assemblyTime = 1,
        unlockCost = 10000000,
        unlockMilestone = 25000000,
        description = "Le futur en voiture"
    }
}

-- ==================== ASSEMBLY LINE UPGRADES ====================
CONFIG.ASSEMBLY_LINE_UPGRADES = {
    {level = 1, cost = 0, timeReduction = 0, name = "Atelier basique"},
    {level = 2, cost = 2500, timeReduction = 1, name = "Chaîne semi-automatique"},
    {level = 3, cost = 10000, timeReduction = 2, name = "Chaîne automatique"},
    {level = 4, cost = 50000, timeReduction = 3, name = "Chaîne ultra-rapide"},
    {level = 5, cost = 200000, timeReduction = 4, name = "Chaîne robotisée"},
    {level = 6, cost = 1000000, timeReduction = 5, name = "Chaîne IA"}
}

CONFIG.BASE_ASSEMBLY_TIME = 5 -- secondes
CONFIG.MIN_ASSEMBLY_TIME = 1 -- seconde (minimum)

-- ==================== WORKERS ====================
CONFIG.WORKER_SYSTEM = {
    maxWorkers = 20,
    productionPerWorker = 1,
    productionInterval = 15, -- 15 secondes pour 1 voiture
}

-- Worker costs
CONFIG.WORKER_COSTS = {}
for i = 1, 5 do
    table.insert(CONFIG.WORKER_COSTS, {id = i, cost = 50000 * (2 ^ (i - 1))})
end
for i = 6, 10 do
    table.insert(CONFIG.WORKER_COSTS, {id = i, cost = 2000000})
end
for i = 11, 20 do
    table.insert(CONFIG.WORKER_COSTS, {id = i, cost = 5000000})
end

-- ==================== PARKING ====================
CONFIG.PARKING_UPGRADES = {
    {level = 1, capacity = 10, cost = 0},
    {level = 2, capacity = 20, cost = 5000},
    {level = 3, capacity = 50, cost = 25000},
    {level = 4, capacity = 100, cost = 100000}
}

-- ==================== FACTORY LEVELS ====================
CONFIG.FACTORY_LEVELS = {
    {
        level = 1,
        name = "Atelier manuel",
        minMoney = 0,
        maxMoney = 10000,
        maxWorkers = 0,
        unlockedCars = {"SEDAN"}
    },
    {
        level = 2,
        name = "Mini-usine",
        minMoney = 10000,
        maxMoney = 100000,
        maxWorkers = 1,
        unlockedCars = {"SEDAN", "SPORTS"}
    },
    {
        level = 3,
        name = "Usine classique",
        minMoney = 100000,
        maxMoney = 1000000,
        maxWorkers = 3,
        unlockedCars = {"SEDAN", "SPORTS", "LUXURY"}
    },
    {
        level = 4,
        name = "Mégausine",
        minMoney = 1000000,
        maxMoney = 5000000,
        maxWorkers = 5,
        unlockedCars = {"SEDAN", "SPORTS", "LUXURY", "SUPERCAR"}
    },
    {
        level = 5,
        name = "Usine high-tech",
        minMoney = 5000000,
        maxMoney = 25000000,
        maxWorkers = 10,
        unlockedCars = {"SEDAN", "SPORTS", "LUXURY", "SUPERCAR", "ELECTRIC"}
    },
    {
        level = 6,
        name = "Mégacorporation",
        minMoney = 25000000,
        maxMoney = math.huge,
        maxWorkers = 20,
        unlockedCars = {"SEDAN", "SPORTS", "LUXURY", "SUPERCAR", "ELECTRIC", "CONCEPT"}
    }
}

-- ==================== DEFAULT PLAYER DATA ====================
CONFIG.DEFAULT_PLAYER_DATA = {
    totalMoney = 0,
    currentMoney = 0,
    selectedCar = "SEDAN",
    unlockedCars = {"SEDAN"},
    assemblyLineLevel = 1,
    parkingLevel = 1,
    workerCount = 0,
    totalCarsAssembled = 0,
    totalEarnings = 0,
    lastJoinTime = 0,
    currentLevel = 1,
    lastLogoutTime = 0
}

-- ==================== GAMEPLAY CONSTANTS ====================
CONFIG.DATASTORE_KEY = "PlayerCarTycoonData_v1"
CONFIG.CLICK_FEEDBACK_DURATION = 0.5
CONFIG.MONEY_POPUP_DURATION = 1
CONFIG.MONEY_POPUP_RISE_HEIGHT = 50
CONFIG.UI_UPDATE_RATE = 0.1
CONFIG.PRODUCTION_UPDATE_RATE = 1
CONFIG.MAX_MONEY_DISPLAY = 999999999999
CONFIG.MONEY_FORMAT_THRESHOLD = 1000000

-- ==================== OFFLINE EARNINGS ====================
CONFIG.OFFLINE_EARNINGS = {
    enabled = true,
    maxOfflineHours = 24
}

-- ==================== UTILITY FUNCTIONS ====================

function CONFIG:GetCarByType(carType)
    return self.CARS[carType]
end

function CONFIG:GetAssemblyTimeByLevel(level)
    if level > #self.ASSEMBLY_LINE_UPGRADES then
        level = #self.ASSEMBLY_LINE_UPGRADES
    end
    return self.BASE_ASSEMBLY_TIME - self.ASSEMBLY_LINE_UPGRADES[level].timeReduction
end

function CONFIG:GetWorkerCost(workerNumber)
    if workerNumber > #self.WORKER_COSTS then
        return self.WORKER_COSTS[#self.WORKER_COSTS].cost
    end
    return self.WORKER_COSTS[workerNumber].cost
end

function CONFIG:GetFactoryLevel(money)
    for i = #self.FACTORY_LEVELS, 1, -1 do
        if money >= self.FACTORY_LEVELS[i].minMoney then
            return self.FACTORY_LEVELS[i]
        end
    end
    return self.FACTORY_LEVELS[1]
end

function CONFIG:FormatMoney(amount)
    if amount >= self.MONEY_FORMAT_THRESHOLD then
        return "$" .. string.format("%.2fM", amount / 1000000)
    end
    return "$" .. string.format("%.0f", amount)
end

return CONFIG
