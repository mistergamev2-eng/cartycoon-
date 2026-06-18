# 📁 Car Tycoon - Structure du projet

## Organisation des fichiers Roblox

```
StarterPlayer/
├── StarterCharacterScripts/
│   └── (vide - les joueurs n'ont pas besoin de scripts)
│
├── StarterGui/
│   └── MainUI (ScreenGui)
│       ├── TopBar (Frame)
│       │   ├── MoneyDisplay (TextLabel)
│       │   ├── LevelDisplay (TextLabel)
│       │   └── StatsDisplay (TextLabel)
│       │
│       ├── MainScreen (Frame)
│       │   ├── AssembleButton (TextButton)
│       │   ├── CurrentCarDisplay (TextLabel)
│       │   ├── ProductionMeter (ProgressBar)
│       │   └── SelectedCarUI (ImageLabel)
│       │
│       ├── ShopMenu (ScrollingFrame)
│       │   ├── AssemblyLineTab
│       │   ├── WorkersTab
│       │   ├── ParkingTab
│       │   └── CarsTab
│       │
│       └── MainUI_LocalScript (LocalScript)
│           └── Handles UI updates and user input
│
└── StarterPlayer_LocalScript (LocalScript)
    └── Initialization and event listeners

ServerScriptService/
├── GameManager.server.lua
│   └── Main server script - initializes systems
│
├── Systems/
│   ├── MoneyManager.lua
│   │   ├── AddMoney(player, amount)
│   │   ├── SpendMoney(player, amount)
│   │   ├── GetPlayerMoney(player)
│   │   └── Money validation & anti-cheat
│   │
│   ├── CarAssembly.lua
│   │   ├── AssembleCar(player, carType)
│   │   ├── GetAssemblyTime(player)
│   │   ├── IsAssemblyReady(player)
│   │   └── Assembly cooldown management
│   │
│   ├── UpgradeSystem.lua
│   │   ├── BuyUpgrade(player, upgradeType, level)
│   │   ├── GetUpgradeLevel(player, upgradeType)
│   │   ├── CanAffordUpgrade(player, cost)
│   │   └── Upgrade validation
│   │
│   ├── WorkerSystem.lua
│   │   ├── HireWorker(player)
│   │   ├── GetWorkerCount(player)
│   │   ├── UpdateWorkerProduction(player)
│   │   └── Passive income calculation
│   │
│   ├── DataManager.lua
│   │   ├── SavePlayerData(player)
│   │   ├── LoadPlayerData(player)
│   │   ├── GetDefaultData()
│   │   └── DataStore interactions
│   │
│   └── OfflineEarnings.lua
│       ├── CalculateOfflineEarnings(player, timeDiff)
│       ├── GetLastLogoutTime(player)
│       └── Apply offline earnings on login
│
├── Events/
│   └── RemoteEvents and RemoteFunctions setup
│
└── Config/
    └── GameConfig.lua
        └── Configuration constants and tables

ReplicatedStorage/
├── Config/
│   ├── CarModels.lua
│   ├── UpgradePrices.lua
│   ├── GameConstants.lua
│   └── (Contains shared game balance)
│
├── RemoteEvents/
│   ├── AssembleCarEvent
│   ├── BuyUpgradeEvent
│   ├── UpdateUIEvent
│   ├── PlayerMoneyUpdate
│   └── (Other necessary remotes)
│
└── Modules/ (Optional, for utility functions)
    ├── Utils.lua
    └── Helpers.lua
```

---

## 🔄 Flux de données

### Lors d'un clic sur "Assemble"
```
Client Click → RemoteEvent:FireServer("AssembleCar", carType)
                    ↓
            CarAssembly.AssembleCar()
                    ↓
            Validation (cooldown, player exists)
                    ↓
            MoneyManager.AddMoney()
                    ↓
            RemoteEvent:FireAllClients("MoneyUpdate", newMoney)
                    ↓
            UI Update sur Client
```

### Lors d'un achat d'amélioration
```
Client Click → RemoteEvent:FireServer("BuyUpgrade", upgradeType, level)
                    ↓
            UpgradeSystem.BuyUpgrade()
                    ↓
            MoneyManager.SpendMoney()
                    ↓
            Update player data
                    ↓
            RemoteEvent:FireClient("UpgradeNotification", success)
                    ↓
            UI Refresh
```

### Production passive (Ouvriers)
```
Server Loop (1 sec intervals)
    ↓
WorkerSystem.UpdateWorkerProduction()
    ↓
For each worker: Check production timer
    ↓
If ready: AssembleCar() (passive)
    ↓
MoneyManager.AddMoney()
    ↓
RemoteEvent:FireAllClients("ProductionUpdate")
    ↓
UI Update
```

---

## 📋 Scripts à créer (ordre recommandé)

### **Phase 2 : Structure de base**
1. ✅ `Config.lua` - Constantes et équilibre
2. ✅ `MoneyManager.lua` - Gestion de l'argent
3. ✅ `MainUI_LocalScript.lua` - UI client
4. ✅ `GameManager.server.lua` - Initialisation

### **Phase 3 : Mécanique principale**
5. ✅ `CarAssembly.lua` - Système d'assemblage
6. ✅ `DataManager.lua` - Sauvegarde/chargement

### **Phase 4 : Déblocages & améliorations**
7. ✅ `UpgradeSystem.lua` - Achat d'améliorations
8. ✅ `WorkerSystem.lua` - Ouvriers automatiques

### **Phase 5 : Polish**
9. ✅ `OfflineEarnings.lua` - Gains hors-ligne
10. ✅ Animations et effets visuels

---

## 🔌 RemoteEvents nécessaires

```lua
-- Dans ReplicatedStorage > RemoteEvents

AssembleCarEvent (RemoteEvent)
  Client → Server: carType
  Server → Client: success, earnedMoney

BuyUpgradeEvent (RemoteEvent)
  Client → Server: upgradeType, level
  Server → Client: success, newCost

HireWorkerEvent (RemoteEvent)
  Client → Server: (aucun param)
  Server → Client: success, newWorkerCount

UpdateMoneyEvent (RemoteEvent)
  Server → Client: newMoney

UpdateStatsEvent (RemoteEvent)
  Server → Client: stats (table)

UnlockCarEvent (RemoteEvent)
  Server → Client: carType

LoadPlayerDataEvent (RemoteFunction)
  Client ← Server: playerData (on load)
```

---

## 💾 Structure DataStore

```lua
-- Key format: "PlayerCarTycoonData_v1:" .. userId

{
  totalMoney = 125000,
  currentMoney = 45000,
  selectedCar = "SPORTS",
  
  unlockedCars = {"SEDAN", "SPORTS"},
  
  assemblyLineLevel = 2,
  parkingLevel = 1,
  workerCount = 1,
  
  totalCarsAssembled = 523,
  totalEarnings = 125000,
  lastJoinTime = 1234567890,
  
  currentLevel = 2,
  
  -- Timestamps pour offline earnings
  lastLogoutTime = 1234567890
}
```

---

## 🚀 Checklist d'implémentation

### Phase 2 (Structure de base)
- [ ] Config.lua créé et complet
- [ ] MoneyManager opérationnel
- [ ] UI basique affichée
- [ ] Argent s'affiche correctement

### Phase 3 (Mécanique principale)
- [ ] Clic assemble une voiture
- [ ] Animation simple fonctionne
- [ ] Cooldown fonctionne
- [ ] Argent gagné et affiché

### Phase 4 (Progression)
- [ ] Menu d'achat affichée
- [ ] Achat d'améliorations fonctionne
- [ ] Déblocages de modèles fonctionnent
- [ ] Données sauvegardées/chargées

### Phase 5 (Automatisation)
- [ ] Ouvriers produisent automatiquement
- [ ] Gains hors-ligne calculés
- [ ] UI mise à jour en temps réel
- [ ] Pas de bugs critiques

### Phase 6 (Polish)
- [ ] Effets visuels ajoutés
- [ ] Sons ajoutés
- [ ] UI peaufinée
- [ ] Équilibrage final
