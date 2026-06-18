# 🚗 Car Manufacturing Tycoon - Design Document

## 📌 Vue d'ensemble du jeu

**Car Manufacturing Tycoon** est un jeu idle/clicker sur Roblox où les joueurs construisent et gèrent une usine automobile. L'objectif est de progresser des assemblages manuels vers une usine entièrement automatisée.

### 🎯 Boucle de gameplay principale
1. Cliquez pour assembler une voiture → Gagnez de l'argent
2. Achetez des améliorations (chaîne de montage, ouvriers)
3. Débloquez de nouveaux modèles de voitures
4. Évoluez vers une production passive
5. Recommencez avec un niveau supérieur

---

## 🚙 Modèles de voitures

| # | Nom | Revenu | Temps d'assemblage | Prix de déblocage | Déblocage |
|----|-----|--------|-------------------|-------------------|-----------|
| 1 | **Sedan Classique** | $100 | 5 sec | - | Démarrage |
| 2 | **Sports Car** | $500 | 4 sec | $5,000 | Niveau 2 |
| 3 | **Luxury Sedan** | $2,000 | 3 sec | $50,000 | Niveau 3 |
| 4 | **SuperCar** | $10,000 | 2 sec | $500,000 | Niveau 4 |
| 5 | **Electric Vehicle** | $15,000 | 1.5 sec | $2,000,000 | Niveau 5 |
| 6 | **Concept Car** | $50,000 | 1 sec | $10,000,000 | Niveau 6 |

---

## 💰 Système de progression

### **Niveaux de l'usine**

#### **Niveau 1 : Atelier manuel** (0$ - 10,000$)
- Assemblage au clic uniquement
- 1 modèle (Sedan)
- UI basique
- **Objectif** : Gagner 10,000$ → Débloquer Niveau 2

#### **Niveau 2 : Mini-usine** (10,000$ - 100,000$)
- Débloquez chaîne de montage (−1 sec)
- Débloquez Sports Car (+$500/voiture)
- 1 ouvrier automatique disponible
- **Objectif** : Gagner 100,000$ → Débloquer Niveau 3

#### **Niveau 3 : Usine classique** (100,000$ - 1,000,000$)
- Chaîne avancée (−2 sec total)
- Débloquez Luxury Sedan
- Jusqu'à 3 ouvriers automatiques
- Zone de parking pour 20 voitures
- **Objectif** : Gagner 1,000,000$ → Débloquer Niveau 4

#### **Niveau 4 : Mégausine** (1,000,000$ - 5,000,000$)
- Chaîne ultra-rapide (−3 sec total)
- Débloquez SuperCar
- Jusqu'à 5 ouvriers automatiques
- Zone de parking pour 50 voitures
- Vente automatique
- **Objectif** : Gagner 5,000,000$ → Débloquer Niveau 5

#### **Niveau 5 : Usine high-tech** (5,000,000$ - 25,000,000$)
- Robotique complète
- Débloquez Electric Vehicle
- Jusqu'à 10 ouvriers automatiques
- Production entièrement passive possible
- Gains même hors-ligne
- **Objectif** : Gagner 25,000,000$ → Débloquer Niveau 6

#### **Niveau 6 : Mégacorporation** (25,000,000$+)
- Débloquez Concept Car
- Jusqu'à 20 ouvriers automatiques
- Production maximale
- Gains constants hors-ligne
- **Endgame** : Continu

---

## 🛠️ Système d'améliorations

### **Chaîne de montage**
```
Niveau 1 : 5 sec (base)
Niveau 2 : 4 sec → 2,500$ chacune
Niveau 3 : 3 sec → 10,000$ chacune
Niveau 4 : 2 sec → 50,000$ chacune
Niveau 5 : 1.5 sec → 200,000$ chacune
Niveau 6 : 1 sec → 1,000,000$ (max)
```

### **Ouvriers automatiques**
```
1er ouvrier : 50,000$ (+1 voiture/15 sec)
2ème ouvrier : 100,000$ (+1 voiture/15 sec)
3ème ouvrier : 250,000$ (+1 voiture/15 sec)
4ème ouvrier : 500,000$ (+1 voiture/15 sec)
5ème ouvrier : 1,000,000$ (+1 voiture/15 sec)
6-10ème : 2,000,000$ chacun
11-20ème : 5,000,000$ chacun (max)
```

### **Parking / Zone de stockage**
```
Niveau 1 : 10 places (base)
Niveau 2 : 20 places → 5,000$ chacune
Niveau 3 : 50 places → 25,000$ chacune
Niveau 4 : 100 places → 100,000$ chacune (max)
```

---

## 📊 Systèmes majeurs

### **1. Assemblage au clic**
- Clic sur bouton "Assemble" → Animation courte → Revenu
- Cooldown basé sur modèle et améliorations
- Affichage du revenu gagné

### **2. Production passive**
- Ouvriers assembling automatiquement
- 1 ouvrier = 1 voiture/15 sec
- Affichage en temps réel de la production

### **3. Déblocages progressifs**
- Débloquez modèles en atteignant des seuils de revenu
- Débloquez améliorations avec l'argent
- Interface visuelle claire

### **4. Persistance des données**
- Sauvegarde : Argent, modèles débloqués, améliorations achetées
- DataStore Roblox
- Chargement à la connexion

### **5. Gains hors-ligne**
- Calcul de l'argent pendant l'absence
- Basé sur production passive (ouvriers)
- Maximum 12-24 heures

### **6. UI/Affichage**
- Compteur d'argent en temps réel
- Stats de production (voitures/sec, revenu/sec)
- Menu des améliorations
- Liste des modèles débloqués
- Progression visuelle

---

## 🎨 Expérience utilisateur

### **Nouveau joueur (1ère heure)**
- Tutorial simple : "Cliquez pour assembler"
- Progression rapide (5-10 min pour débloquer 2e modèle)
- Sensation de satisfaction précoce

### **Joueur intermédiaire (1-10 heures)**
- Choix stratégiques : améliorations vs nouveaux modèles
- Déblocages réguliers
- Première vague de production passive

### **Joueur avancé (10+ heures)**
- Optimisation de production
- Gains passifs importants
- Défis secondaires (si implémentés)

---

## 📈 Courbe d'équilibrage

- **Début** : Progression rapide (satisfaisant)
- **Milieu** : Ralentissement graduel (encourage les achats)
- **Fin** : Croissance exponentielle (objectif lointain mais atteignable)

**Durée estimée par niveau** :
- Niveau 1-2 : 30 min
- Niveau 2-3 : 1-2h
- Niveau 3-4 : 3-5h
- Niveau 4-5 : 8-12h
- Niveau 5-6 : 20+ heures

---

## 🔮 Fonctionnalités futures (non prioritaires)

- [ ] Système de trading entre joueurs
- [ ] Customisation des voitures
- [ ] Compétitions/leaderboards
- [ ] Quêtes journalières
- [ ] Cosmétiques payants
- [ ] Événements spéciaux
