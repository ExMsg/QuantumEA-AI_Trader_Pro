# **FILE: Docs/Troubleshooting.pdf (Konten Teks)**

```markdown
# QUANTUM AI TRADER PRO - TROUBLESHOOTING GUIDE

## 🚨 EMERGENCY PROCEDURES

### Immediate Stop Methods
```mql5
// 🚨 CRITICAL SITUATIONS:
1. Remove EA dari chart → INSTANT STOP
2. Disable Auto Trading (Ctrl+E) → FAST STOP  
3. Manual close all positions → CONTROLLED STOP
4. Contact broker support → BROKER ASSISTANCE
```

### Emergency Contact Information

```
📞 Quantum AI Support: adittauda808@gmail.com
📞 Broker Emergency: [Your Broker Phone]
📞 VPS Provider: [Your VPS Support]
```

## 🔧 COMMON ISSUES & SOLUTIONS

### 1. EA TIDAK TRADING

### Symptoms:

· Tidak ada order yang di-execute
· ML signals generated tapi no trades
· Log menunjukkan "Trading not allowed"

### Solutions:

```mql5
// Check List:
1. ✅ Auto Trading enabled (Ctrl+E)
2. ✅ Account leverage adequate (min 1:100)
3. ✅ Symbol trading enabled
4. ✅ Sufficient margin
5. ✅ Spread within limits (check Max_Spread parameter)
6. ✅ ML confidence above threshold
```

### Debug Steps:

```
1. Buka Journal tab - cek error messages
2. Verify RiskManager.IsTradingAllowed() return true
3. Check account permissions dengan broker
4. Test dengan demo account terlebih dahulu
```

### 2. COMPILE ERRORS

### Common Compile Errors:

```
❌ 'Statistics.mqh' not found
❌ 'RiskManager' undefined
❌ Function not defined
❌ Array out of range
```

### Solutions:

```
1. Pastikan semua file include di folder MQL5/Includes/
2. Check file names - case sensitive di beberapa system
3. Verify MQL5 version compatibility
4. Re-download complete package
```

### 3. POOR PERFORMANCE

### Symptoms:

· Win rate rendah (<60%)
· Large drawdowns
· Frequent losing streaks
· ML confidence consistently low

### Solutions:

```mql5
// Immediate Actions:
1. ↑ Increase ML_Confidence_Threshold (0.75 → 0.82)
2. ↓ Decrease Risk_Per_Trade (2.0 → 1.0)
3. ✅ Enable Use_News_Filter
4. ✅ Enable Use_Correlation_Filter

// Advanced Adjustments:
5. Adjust EMA periods berdasarkan market condition
6. Enable Use_Deep_Learning untuk accuracy lebih tinggi
7. Review backtest results untuk optimal parameters
```

### 4. ML MODEL ISSUES

### Symptoms:

· ML confidence selalu rendah
· Prediction accuracy poor
· Model tidak kunjung trained

### Solutions:

```
1. Increase ML_Lookback_Period (200 → 300)
2. Enable Use_Deep_Learning
3. Allow ML_Retrain_Hours (24 → 12 untuk faster adaptation)
4. Check data quality - pastikan historical data tersedia
```

## 📊 PERFORMANCE TROUBLESHOOTING

### Low Win Rate Analysis

```
🔍 INVESTIGATION STEPS:
1. Check market condition - trending/ranging/volatile
2. Review ML feature importance weights
3. Analyze losing trades - common patterns?
4. Verify news filter working
5. Check spread during trade execution
```

### High Drawdown Management

```
🛡️ RISK MITIGATION:
1. Immediate: Reduce Risk_Per_Trade by 50%
2. Enable stricter correlation filters
3. Set lower Daily_Risk_Limit
4. Implement smaller position sizes
5. Consider temporary trading pause
```

### Inconsistent Results

```
📈 CONSISTENCY IMPROVEMENT:
1. Use Balanced preset sebagai baseline
2. Enable all risk management features
3. Maintain stable internet connection
4. Avoid trading during major news events
5. Use VPS untuk execution consistency
```

## 🔄 SYSTEM MAINTENANCE

### Regular Maintenance Tasks

```
🔄 DAILY:
- Clear excessive log files
- Monitor system resources
- Check internet connectivity
- Verify broker connection

🔄 WEEKLY:  
- Review performance metrics
- Backup EA settings
- Update economic calendar
- Check for EA updates

🔄 MONTHLY:
- Full system health check
- Parameter re-optimization
- ML model retraining
- Comprehensive reporting
```

### VPS Optimization

```
☁️ VPS BEST PRACTICES:
- Minimum 2GB RAM dedicated
- SSD storage untuk fast execution
- Location near broker servers
- Redundant internet connections
- Regular backup procedures
```

## 📝 ERROR CODE REFERENCE

### Common MT5 Error Codes

```
134 → Not enough money
10004 → Trade context busy
10013 → Invalid stops
10014 → Invalid volume
10015 → Invalid price
10016 → Invalid trade parameters
10021 → Not enough rights
10027 → Market closed
```

### Quantum AI Specific Errors

```
QAI_001 → ML Model not initialized
QAI_002 → Risk Manager blocked trade
QAI_003 → Feature calculation failed
QAI_004 → Prediction confidence too low
QAI_005 → Correlation filter active
```

## 🛠️ ADVANCED TROUBLESHOOTING

### Debug Mode Activation

```mql5
// Untuk advanced debugging, tambahkan:
input bool Debug_Mode = true;
input int Debug_Level = 3; // 1-5, 5 most verbose

// Dalam code:
if(Debug_Mode && Debug_Level >= 3)
{
   Print("DEBUG: Feature values - ", feature1, ", ", feature2);
}
```

### Performance Logging

```mql5
// Enable detailed logging:
void Log_Performance_Metrics()
{
   if(IsNewDay())
   {
      Print("=== DAILY PERFORMANCE METRICS ===");
      Print("Win Rate: ", Calculate_Win_Rate());
      Print("ML Accuracy: ", ml_processor.Get_Model_Accuracy());
      Print("Risk Exposure: ", risk_manager.GetPortfolioRisk());
   }
}
```

### Data Quality Verification

```
📊 DATA VALIDATION:
1. Historical data completeness
2. Tick data quality assessment
3. Spread data accuracy
4. Economic calendar alignment
5. Time synchronization
```

## 🚀 OPTIMIZATION TROUBLESHOOTING

### Optimization Failures

```
❌ COMMON OPTIMIZATION ISSUES:
- Overfitting pada historical data
- Parameter ranges terlalu lebar
- Insufficient computational resources
- Poor quality tick data

✅ OPTIMIZATION BEST PRACTICES:
- Use walk-forward analysis
- Limit parameter combinations
- Validate dengan out-of-sample data
- Focus on risk-adjusted metrics
```

### Parameter Sensitivity Analysis

```
📈 SENSITIVE PARAMETERS:
1. ML_Confidence_Threshold (±0.05 impact)
2. Risk_Per_Trade (±0.5% impact)  
3. EMA periods (±3-5 periods)
4. ATR multiplier (±0.3 impact)

🎯 STABLE PARAMETERS:
- Use_News_Filter (always enable)
- Use_Correlation_Filter (recommended)
- Use_Deep_Learning (stable improvement)
```

## 📞 SUPPORT PROCEDURES

### Before Contacting Support

```
📋 INFORMATION TO GATHER:
1. EA version dan MT5 build number
2. Error messages dari Journal tab
3. Screenshot dari issue
4. Trading account number
5. Steps to reproduce problem
6. Recent performance reports
```

### Support Ticket Template

```
Subject: [URGENT/Medium/Low] - Issue Description

EA Version: 
MT5 Version: 
Broker: 
Issue Description: 
Error Messages: 
Steps to Reproduce: 
Screenshots: [Attached]
Log Files: [Attached]
```

## 🛡️ PREVENTIVE MAINTENANCE

### Preventive Measures

```
🔒 RISK PREVENTION:
1. Regular backup of settings
2. Demo testing sebelum parameter changes
3. Monitor margin levels continuously
4. Set realistic profit expectations
5. Maintain trading journal

🔄 SYSTEM PREVENTION:
1. Regular VPS maintenance
2. Monitor disk space
3. Update MT5 regularly
4. Verify internet stability
5. Check broker status
```

### Emergency Recovery Plan

```
🚨 DISASTER RECOVERY:
1. Immediate: Stop all trading
2. Assessment: Identify root cause
3. Restoration: Apply backup settings
4. Validation: Test in demo environment
5. Resumption: Gradual return to trading
```

---

Remember: Most issues can be resolved dengan proper setup dan regular maintenance.
Always test changes in demo environment sebelum live implementation.

ExMsg (0x03S) - Always Here to Help 🤝