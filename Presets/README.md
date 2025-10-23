# QUANTUM AI TRADER PRO - PRESETS GUIDE

## 📊 PRESET COMPARISON

| Parameter | Conservative | Balanced | Aggressive |
|-----------|-------------|----------|------------|
| **Risk per Trade** | 0.5% | 1.0% | 2.0% |
| **Daily Risk Limit** | 3.0% | 5.0% | 8.0% |
| **Max Drawdown** | 10% | 15% | 25% |
| **ML Confidence** | 0.82 | 0.75 | 0.68 |
| **Trading Frequency** | Low | Medium | High |
| **Win Rate** | 75-85% | 70-80% | 65-75% |
| **Recommended For** | Beginners | Most Traders | Experts |

## 🎯 HOW TO USE PRESETS

### Method 1: Manual Input
1. Open EA Properties
2. Click "Load" button
3. Select desired .set file
4. Click "OK" to apply

### Method 2: Auto Load via Code
```mql5
// In OnInit() function
string preset_file = "Presets/Balanced.set";
LoadParametersFromFile(preset_file);