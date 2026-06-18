# ⚙️ Car Tycoon - Configuration & Équilibre

Ce fichier contient toutes les constantes et valeurs d'équilibre du jeu.

---

## 💵 PRIX ET REVENUS

### Modèles de voitures
```lua
CARS = {
    SEDAN = {
        revenue = 100,
        assemblyTime = 5,
        unlockCost = 0, -- Débloqué au démarrage
        unlockMilestone = 0
    },
    SPORTS = {
        revenue = 500,
        assemblyTime = 4,
        unlockCost = 5000,
        unlockMilestone = 10000 -- Argent total gagné
    },
    LUXURY = {
        revenue = 2000,
        assemblyTime = 3,
        unlockCost = 50000,
        unlockMilestone = 100000
    },
    SUPERCAR = {
        revenue = 10000,
        assemblyTime = 2,
        unlockCost = 500000,
        unlockMilestone = 1000000
    },
    ELECTRIC = {
        revenue = 15000,
        assemblyTime = 1.5,
        unlockCost = 2000000,
        unlockMilestone = 5000000
    },
    CONCEPT = {
        revenue = 50000,
        assemblyTime = 1,
        unlockCost = 10000000,
        unlockMilestone = 25000000
    }
}
```

---

## 🏭 AMÉLIORATIONS

### Chaîne de montage (Assembly Line)
```lua
ASSEMBLY_LINE_UPGRADES = {
    {level = 1, cost = 0, timeReduction = 0},     -- Base (5 sec)
    {level = 2, cost = 2500, timeReduction = 1},  -- 4 sec
    {level = 3, cost = 10000, timeReduction = 2}, -- 3 sec
    {level = 4, cost = 50000, timeReduction = 3}, -- 2 sec
    {level = 5, cost = 200000, timeReduction = 4},-- 1.5 sec
    {level = 6, cost = 1000000, timeReduction = 5}-- 1 sec (max)
}

BASE_ASSEMBLY_TIME = 5 -- secondes
MIN_ASSEMBLY_TIME = 1  -- seconde (minimum)
```

### Ouvriers automatiques (Workers)
```lua
WORKER_SYSTEM = {
    maxWorkers = 20,
    productionPerWorker = 1, -- voiture par X secondes
    productionInterval = 15, -- 15 secondes
    
    costs = {
        {id = 1, cost = 50000},
        {id = 2, cost = 100000},
        {id = 3, cost = 250000},
        {id = 4, cost = 500000},
        {id = 5, cost = 1000000},
        {id = 6, cost = 2000000},
        {id = 7, cost = 2000000},
        {id = 8, cost = 2000000},
        {id = 9, cost = 2000000},
        {id = 10, cost = 2000000},
        -- Workers 11-20: 5,000,000 each
    }
}

-- Générer le reste automatiquement
for i = 11, 20 do
    table.insert(WORKER_SYSTEM.costs, {id = i, cost = 5000000})
end
```

### Parking / Zone de stockage
```lua
PARKING_UPGRADES = {
    {level = 1, capacity = 10, cost = 0},
    {level = 2, capacity = 20, cost = 5000},
    {level = 3, capacity = 50, cost = 25000},
    {level = 4, capacity = 100, cost = 100000} -- max
}
```

---

## 📊 NIVEAUX D'USINE

```lua
FACTORY_LEVELS = {
    {
        level = 1,
        name = "Atelier manuel",
        minMoney = 0,
        maxMoney = 10000,
        unlockWorkers = 0,
        unlockedCars = {"SEDAN"}
    },
    {
        level = 2,
        name = "Mini-usine",
        minMoney = 10000,
        maxMoney = 100000,
        unlockWorkers = 1,
        unlockedCars = {"SEDAN", "SPORTS"}
    },
    {
        level = 3,
        name = "Usine classique",
        minMoney = 100000,
        maxMoney = 1000000,
        unlockWorkers = 3,
        unlockedCars = {"SEDAN", "SPORTS", "LUXURY"}
    },
    {
        level = 4,
        name = "Mégausine",
        minMoney = 1000000,
        maxMoney = 5000000,
        unlockWorkers = 5,
        unlockedCars = {"SEDAN", "SPORTS", "LUXURY", "SUPERCAR"}
    },
    {
        level = 5,
        name = "Usine high-tech",
        minMoney = 5000000,
        maxMoney = 25000000,
        unlockWorkers = 10,
        unlockedCars = {"SEDAN", "SPORTS", "LUXURY", "SUPERCAR", "ELECTRIC"}
    },
    {
        level = 6,
        name = "Mégacorporation",
        minMoney = 25000000,
        maxMoney = math.huge,
        unlockWorkers = 20,
        unlockedCars = {"SEDAN", "SPORTS", "LUXURY", "SUPERCAR", "ELECTRIC", "CONCEPT"}
    }
}
```

---

## 🌍 PERSISTANCE (DataStore)

```lua
DATASTORE_KEY = "PlayerCarTycoonData_v1"

DEFAULT_PLAYER_DATA = {
    totalMoney = 0,
    currentMoney = 0,
    selectedCar = "SEDAN",
    
    -- Déblocages
    unlockedCars = {"SEDAN"},
    
    -- Améliorations
    assemblyLineLevel = 1,
    parkingLevel = 1,
    workerCount = 0,
    
    -- Stats
    totalCarsAssembled = 0,
    totalEarnings = 0,
    lastJoinTime = 0,
    
    -- Progression
    currentLevel = 1
}
```

---

## ⏱️ GAINS HORS-LIGNE (Offline Earnings)

```lua
OFFLINE_EARNINGS = {
    enabled = true,
    maxOfflineHours = 24, -- Maximum 24 heures de production
    
    -- Calcul : 
    -- offlineEarnings = (workers * carRevenuePerWorker * timePassed) / productionInterval
}
```

---

## 🎮 GAMEPLAY CONSTANTS

```lua
-- Animations et délais
CLICK_FEEDBACK_DURATION = 0.5 -- secondes (animation au clic)
MONEY_POPUP_DURATION = 1 -- seconde (affichage du revenu)
MONEY_POPUP_RISE_HEIGHT = 50 -- pixels

-- UI
UI_UPDATE_RATE = 0.1 -- Update l'affichage 10x par seconde
PRODUCTION_UPDATE_RATE = 1 -- Update la production 1x par seconde

-- Limites
MAX_MONEY_DISPLAY = 999999999999 -- Affichage limité (à l'écran)
MONEY_FORMAT_THRESHOLD = 1000000 -- Afficher en millions au-delà
```

---

## 📈 BALANCING NOTES

### Ratio de progression
- **Early game** : Progression rapide (satisfaisant)
- **Mid game** : Progression moyenne (15-30 min par niveau)
- **Late game** : Progression lente (plusieurs heures)

### Revenu vs Coût
- **Sedan** : 100$ / 5s = 20$/sec
- **SuperCar** : 10000$ / 2s = 5000$/sec (250x plus)
- **Concept** : 50000$ / 1s = 50000$/sec (2500x plus)

### Temps estimé par niveau
- Niveau 1→2 : 30 min (facile)
- Niveau 2→3 : 1-2h
- Niveau 3→4 : 3-5h
- Niveau 4→5 : 8-12h
- Niveau 5→6 : 20+ h

---

## 🔧 TODO : À AJUSTER

- [ ] Tester l'équilibre en jeu réel
- [ ] Ajuster les prix si progression trop rapide/lente
- [ ] Valider les temps d'assemblage
- [ ] Équilibrer les gains des ouvriers
- [ ] Tester les gains hors-ligne
