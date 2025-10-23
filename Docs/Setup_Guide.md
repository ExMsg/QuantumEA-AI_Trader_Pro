# QUANTUM AI TRADER PRO - SETUP GUIDE

## 📋 DAFTAR ISI
1. [Persyaratan Sistem](#1-persyaratan-sistem)
2. [Instalasi EA](#2-instalasi-ea)
3. [Konfigurasi Awal](#3-konfigurasi-awal)
4. [Pengaturan Preset](#4-pengaturan-preset)
5. [Menjalankan EA](#5-menjalankan-ea)
6. [Monitoring](#6-monitoring)
7. [Optimisasi](#7-optimisasi)
8. [Maintenance](#8-maintenance)

## 1. PERSYARATAN SISTEM

### 1.1 Minimum Requirements

### 1.1 Minimum Requirements
```

· MetaTrader 5 (Build 2000+)
· Windows 10/11 (64-bit)
· RAM: 4GB (8GB Recommended)
· CPU: Dual Core 2.0GHz+
· Internet: Stable 10Mbps+
· Storage: 1GB free space

```

### 1.2 Recommended Setup
```

✅ MetaTrader 5 Build 2400+
✅ Windows 11 64-bit
✅ RAM 8GB atau lebih
✅ CPU Quad Core 3.0GHz+
✅ VPS dengan koneksi fiber
✅ Monitor 1080p atau lebih tinggi

```

### 1.3 Broker Requirements
```

· Execution: Instant atau Market Execution
· Spread: < 3 pips untuk major pairs
· Commission: Reasonable (max $7 round turn)
· Leverage: Minimum 1:100
· Symbols: EURUSD, GBPUSD, USDJPY tersedia

```

## 2. INSTALASI EA

### 2.1 Step-by-Step Installation

#### Step 1: Download File
```

1. Download package Quantum_AI_Trader_Pro.zip
2. Extract ke folder yang diinginkan
3. Verifikasi file structure:
   Quantum_AI_Trader_Pro/
   ├── Quantum_AI_Trader_Pro.mq5
   ├── Includes/
   │   ├── Statistics.mqh
   │   ├── RiskManager.mqh
   │   └── ML_Processor.mqh
   ├── Presets/
   │   ├── Conservative.set
   │   ├── Balanced.set
   │   └── Aggressive.set
   └── Backtests/
   └── Optimization_Results.xml

```

#### Step 2: Copy ke MT5
```

1. Buka MetaTrader 5
2. Klik File → Open Data Folder
3. Navigasi ke folder MQL5/Experts/
4. Copy file Quantum_AI_Trader_Pro.mq5
5. Buat folder Includes/ dan copy file .mqh
6. Buat folder Presets/ dan copy file .set

```

#### Step 3: Compile EA
```

1. Buka MetaEditor (F4)
2. Buka file Quantum_AI_Trader_Pro.mq5
3. Klik Compile (F7) atau tekan F7
4. Pastikan tidak ada error:
   ✅ 0 error, 0 warning
   ✅ Compile successful
   ✅ File .ex5 tergenerate

```

### 2.2 Verification Steps
```mql5
// Cek di Journal tab:
- "Quantum AI Trader Pro.mq5 compiled successfully"
- Tidak ada error message
- File .ex5 created di Experts folder
```

3. KONFIGURASI AWAL

3.1 Chart Setup

```
📊 Recommended Chart Settings:
- Symbol: EURUSD
- Timeframe: H1 (Optimal)
- Chart Type: Candlestick
- Template: Default
- Auto Scroll: Enabled
- Chart Shift: Disabled
```

3.2 EA Attachment

```
1. Buka chart EURUSD H1
2. Drag EA dari Navigator ke chart
3. Enable parameter:
   ✅ Allow Algo Trading
   ✅ Allow DLL Imports
   ✅ Allow WebRequest
   ✅ Confirm EXE Execution
```

3.3 Initial Parameters

```ini
[Common Settings]
Enable_Alerts = true
Enable_Email_Notifications = false
Enable_Push_Notifications = true
Max_Spread = 3.0
```

4. PENGATURAN PRESET

4.1 Memilih Preset yang Tepat

Untuk Pemula (Conservative)

```
✅ Risk Per Trade: 0.5%
✅ ML Confidence: 0.82
✅ Max Drawdown: 10%
✅ Expected Return: 25-35% per tahun
```

Untuk Trader Berpengalaman (Balanced)

```
✅ Risk Per Trade: 1.0%
✅ ML Confidence: 0.75
✅ Max Drawdown: 15%
✅ Expected Return: 40-50% per tahun
```

Untuk Expert (Aggressive)

```
✅ Risk Per Trade: 2.0%
✅ ML Confidence: 0.68
✅ Max Drawdown: 25%
✅ Expected Return: 60-80% per tahun
```

4.2 Load Preset

```
1. Klik kanan EA di chart
2. Pilih 'Properties'
3. Klik 'Load' button
4. Pilih file dari folder Presets/
5. Klik 'OK' untuk apply
```

5. MENJALANKAN EA

5.1 Startup Sequence

```
1. Enable Auto Trading (Ctrl+E)
2. Pastikan koneksi internet stabil
3. Check account balance dan margin
4. Verify symbol permissions
5. Klik 'OK' pada EA properties
```

5.2 Initial Monitoring (30 Menit Pertama)

```
✅ Check Journal tab untuk error
✅ Verify ML model initialized
✅ Monitor first signal generation
✅ Confirm risk management active
✅ Check spread dan execution
```

5.3 Normal Operation Signs

```
🎯 NORMAL OPERATION:
- Log messages setiap bar baru
- ML confidence calculations
- Risk management updates
- Trade executions dengan confirmation
```

6. MONITORING

6.1 Real-time Monitoring

```mql5
// Check setiap 1-2 jam:
1. Equity curve progression
2. Open positions dan P/L
3. ML confidence levels
4. Risk exposure
5. Error messages
```

6.2 Daily Checklist

```
☑️ Morning Check (08:00):
- Review overnight performance
- Check news calendar
- Verify system status

☑️ Midday Check (13:00):
- Monitor open trades
- Check drawdown levels
- Review ML accuracy

☑️ Evening Check (20:00):
- Daily P/L summary
- Position management
- Prepare for next day
```

6.3 Weekly Review

```
📊 Every Monday:
- Weekly performance report
- Compare dengan backtest results
- Adjust parameters jika diperlukan
- Backup settings dan results
```

7. OPTIMISASI

7.1 Parameter Optimization

```mql5
// Parameters untuk di-optimize:
- ML_Confidence_Threshold (0.65-0.85)
- Risk_Per_Trade (0.5-2.0)
- EMA_Fast (5-15)
- EMA_Slow (15-30)
- ATR_Period (10-20)
```

7.2 Optimization Protocol

```
1. Pilih periode 2+ tahun
2. Gunakan M1 modeling dengan real ticks
3. Test multiple market conditions
4. Validasi dengan out-of-sample data
5. Forward test sebelum live
```

7.3 Performance Metrics

```
✅ Win Rate: >70%
✅ Profit Factor: >1.8
✅ Max Drawdown: <15%
✅ Sharpe Ratio: >1.5
✅ Recovery Factor: >3.0
```

8. MAINTENANCE

8.1 Regular Maintenance

```
🔄 Daily:
- Clear log files jika terlalu besar
- Monitor system resources
- Check VPS performance

🔄 Weekly:
- Update economic calendar
- Review ML model performance
- Backup trading results

🔄 Monthly:
- Full system review
- Parameter re-optimization
- Update EA jika ada versi baru
```

8.2 Troubleshooting Common Issues

EA Tidak Trading

```
1. Check Auto Trading enabled
2. Verify account leverage
3. Check symbol permissions
4. Review ML confidence threshold
```

Performance Drop

```
1. Increase ML confidence threshold
2. Enable news filter
3. Adjust risk parameters
4. Check market conditions
```

8.3 Emergency Procedures

```mql5
// Emergency Stop Methods:
1. Remove EA dari chart (INSTANT)
2. Disable Auto Trading (Ctrl+E)
3. Close all positions manually
4. Contact support jika diperlukan
```

🚀 QUICK START CHECKLIST

Pre-Flight Checklist

```
☑️ MT5 installed dan updated
☑️ Broker account funded
☑️ EA compiled successfully
☑️ Preset loaded sesuai risk profile
☑️ Auto Trading enabled
☑️ Internet connection stable
☑️ VPS running (jika digunakan)
```

First Week Monitoring

```
☑️ Monitor first 10-20 trades
☑️ Verify risk management working
☑️ Check ML accuracy
☑️ Review daily reports
☑️ Adjust parameters jika diperlukan
```

📞 SUPPORT RESOURCES

Documentation

· Docs/Setup_Guide.pdf (This file)
· Docs/Troubleshooting.pdf
· Docs/Backtest_Analysis.pdf

Community & Support

· Quantum AI User Forum
· Official Support Email: support@quantum-ai.com
· Telegram Support Group
· Video Tutorials Channel

Important Notes

```
⚠️ SELALU test di demo sebelum real
⚠️ PAHAMI risk parameters sepenuhnya
⚠️ MONITOR performance regularly
⚠️ BACKUP settings dan results
⚠️ UPDATE EA versi terbaru
```

---

Quantum AI Trader Pro © 2024 - Advanced AI Trading System
Trading involves risk. Past performance doesn't guarantee future results.
