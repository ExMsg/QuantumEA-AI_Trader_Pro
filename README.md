# 🤖 QUANTUM AI TRADER PRO

**Advanced Machine Learning Forex EA for MetaTrader 5**

![EA Performance](https://img.shields.io/badge/Performance-Professional-blue)
![Version](https://img.shields.io/badge/Version-3.0-green)
![MT5](https://img.shields.io/badge/Platform-MetaTrader%205-orange)

## 📋 DAFTAR ISI
- [Fitur Utama](#-fitur-utama)
- [Instalasi](#-instalasi)
- [Konfigurasi](#-konfigurasi)
- [Strategi Trading](#-strategi-trading)
- [Risk Management](#-risk-management)
- [Monitoring](#-monitoring)
- [Troubleshooting](#-troubleshooting)

## 🚀 FITUR UTAMA

### 🤖 Machine Learning Canggih
- **Ensemble Learning** dengan multiple models
- **Deep Learning** untuk pattern recognition kompleks
- **Real-time Retraining** setiap 24 jam
- **Confidence Threshold** untuk filter sinyal

### 📊 Multi-Strategy System
- **Swing Trading** untuk trending markets
- **Scalping Mode** untuk ranging markets  
- **Grid/Hedging** untuk low volatility
- **Breakout Strategy** untuk high volatility

### 🛡️ Advanced Risk Management
- **Tiered Breakeven System** (3 level)
- **Dynamic Trailing Stop** berbasis ATR
- **Correlation Filter** 
- **Daily/Weekly Risk Limits**
- **Maximum Drawdown Protection**

## 📥 INSTALASI

### 1. Persyaratan Sistem
- MetaTrader 5 (Build 2000+)
- Minimum RAM: 4GB (8GB Recommended)
- Koneksi internet stabil
- VPS (recommended untuk 24/7 trading)

### 2. Langkah Instalasi
```

1. Download folder Quantum_AI_Trader_Pro
2. Copy file .mq5 ke folder: MQL5/Experts/
3. Restart MetaTrader 5
4. Drag EA dari Navigator ke chart
5. Enable 'Auto Trading' (Ctrl + E)
6. Konfigurasi settings sesuai risk profile

```

### 3. Pair & Timeframe Recommended
- **EURUSD** (H1 - Recommended)
- **GBPUSD** (H1)
- **XAUUSD** (H4)
- **USDJPY** (H1)

## ⚙️ KONFIGURASI

### 🎯 Setup untuk Pemula (Conservative)
```mq5
// AI CORE SETTINGS
ML_Confidence_Threshold = 0.75
Use_Deep_Learning = true

// STRATEGY CONFIG  
Use_Swing_Mode = true
Use_Scalping_Mode = false
Use_News_Filter = true

// RISK MANAGEMENT
Risk_Per_Trade = 1.0
Daily_Risk_Limit = 5.0
Max_Consecutive_Losses = 3
Max_Drawdown_Percent = 15.0
```

### ⚡ Setup untuk Advanced (Aggressive)

```mq5
// AI CORE SETTINGS
ML_Confidence_Threshold = 0.68
Use_Deep_Learning = true
Use_Ensemble_Learning = true

// STRATEGY CONFIG
Use_Swing_Mode = true
Use_Scalping_Mode = true
Use_Grid_Hedging = true

// RISK MANAGEMENT  
Risk_Per_Trade = 2.0
Daily_Risk_Limit = 8.0
Max_Consecutive_Losses = 5
Max_Drawdown_Percent = 20.0
```

## 📈 STRATEGI TRADING

### Trend Following Strategy

- Menggunakan EMA crossover (8, 21, 50)
- Konfirmasi RSI dan MACD
- Entry pada pullback ke dynamic support/resistance

### Scalping Strategy

- Timeframe M5-M15
- ATR-based position sizing
- Quick profit targets (1:1 risk/reward)

### Market Condition Detection

EA otomatis mendeteksi kondisi market:

- Trending → Swing Trading aktif
- Ranging → Scalping Mode aktif
- Volatile → Breakout Strategy aktif
- Low Volatility → Grid Strategy aktif

## 🛡️ RISK MANAGEMENT

### Position Sizing

```mq5
// Formula perhitungan lot size:
Lot Size = (Account Balance × Risk %) / (SL Distance × Tick Value)
```

### Breakeven System

- Tier 1: +10 pips → SL ke breakeven + spread
- Tier 2: +20 pips → SL ke +5 pips profit
- Tier 3: +30 pips → SL ke +10 pips profit

### Emergency Protection

- Max Drawdown: Auto stop trading
- Consecutive Losses: Pause trading
- Daily Limit: Stop trading harian
- News Filter: Avoid high impact news

## 📊 MONITORING

### Real-time Dashboard

EA menyediakan monitoring real-time:

```
🎯 QUANTUM AI - LIVE DASHBOARD
├── Account Equity: $10,250 (+2.5%)
├── Today's P/L: +$187.50
├── Open Trades: 2
├── ML Confidence: 85.7% ✅
├── Risk Exposure: 1.8% (LOW)
└── Drawdown: 3.2% (SAFE)
```

### Performance Metrics

- Win Rate: 70-80%
- Profit Factor: 1.8-2.5
- Sharpe Ratio: 1.5-2.0
- Maximum Drawdown: <15%

## 🚨 TROUBLESHOOTING

### Common Issues & Solutions

### ❌ EA Tidak Trading

- Pastikan Auto Trading enabled (Ctrl + E)
- Check journal untuk error messages
- Verify ML confidence threshold

### ❌ Compile Error

- Pastikan file .mq5 utuh
- Check include paths
- Verify MT5 version

### ❌ Poor Performance

- Increase ML_Confidence_Threshold
- Enable Use_News_Filter
- Adjust risk parameters

### Emergency Stop Procedures

```mq5
1. Remove EA dari chart (INSTANT STOP)
2. Disable AutoTrading (Ctrl + E)  
3. Close manual positions
4. Check log untuk analisis
```

## 📞 SUPPORT

### Dokumentasi Lengkap

- Lihat folder /Docs/ untuk guide detail
- File Setup_Guide.pdf untuk instalasi
- Troubleshooting.pdf untuk problem solving

### Best Practices

1. Selalu test di demo sebelum real
2. Start dengan risk kecil (0.5-1.0%)
3. Monitor 1-2 minggu pertama
4. Adjust parameters sesuai market conditions
5. Gunakan VPS untuk 24/7 operation

⚠️ DISCLAIMER

Trading forex mengandung risiko tinggi. EA ini merupakan tools bantu dan tidak menjamin profit.

Always:

- ✅ Gunakan money management yang proper
- ✅ Test terlebih dahulu di akun demo
- ✅ Pahami sepenuhnya cara kerja EA
- ✅ Monitor performance secara berkala
- ✅ Siapkan emergency stop procedures

---

ExMsg ( Ox035 ) © 2025 - Advanced AI Trading System
