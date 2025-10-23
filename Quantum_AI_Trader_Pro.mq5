//+------------------------------------------------------------------+
//|                QUANTUM AI TRADER PRO                           |
//|            Supercharged Machine Learning EA                    |
//+------------------------------------------------------------------+

#property copyright "Quantum AI Trader Pro"
#property version   "3.0"
#property description "Advanced ML-Powered Trading System with Multiple Strategies"

//--- Includes
#include <Trade/Trade.mqh>
#include <Math/Stat/Math.mqh>
#include <Arrays/ArrayDouble.mqh>

//--- Custom Includes
#include "Libraries/Statistics.mqh"
#include "Includes/RiskManager.mqh"
#include "Includes/ML_Processor.mqh"

//--- Input Parameters
input group "=== AI CORE SETTINGS ==="
input int ML_Lookback_Period = 200;
input double ML_Confidence_Threshold = 0.78;
input bool Use_Deep_Learning = true;
input int ML_Retrain_Hours = 24;

input group "=== MULTI-STRATEGY CONFIG ==="
input bool Use_Scalping_Mode = false;
input bool Use_Swing_Mode = true;
input bool Use_Grid_Hedging = false;
input bool Use_News_Filter = true;
input bool Use_Sentiment_Analysis = true;

input group "=== ADVANCED RISK MANAGEMENT ==="
input double Risk_Per_Trade = 1.0;
input double Daily_Risk_Limit = 5.0;
input int Max_Consecutive_Losses = 3;
input bool Use_Adaptive_SL_TP = true;
input bool Use_Correlation_Filter = true;
input double Max_Drawdown_Percent = 15.0;

input group "=== TECHNICAL INDICATORS ==="
input int EMA_Fast = 8;
input int EMA_Slow = 21;
input int EMA_Trend = 50;
input int RSI_Period = 14;
input int ATR_Period = 14;
input int Bollinger_Period = 20;
input double Bollinger_Deviation = 2.0;

//--- Global Variables
CMLProcessor        ml_processor;
CRiskManager        risk_manager;
CTrade             trade;
Math               math;

//--- Trading Variables
double equity_start, daily_profit, weekly_profit;
int consecutive_losses = 0, total_trades_today = 0;
datetime last_trade_time = 0, session_start_time = 0;

//--- ML Variables
double ml_weights[15];
double ml_predictions[5];
double ml_confidence = 0.0;
bool ml_model_ready = false;
datetime last_retrain_time = 0;

//--- Advanced Risk Management
double current_drawdown = 0.0, max_drawdown = 0.0;

//--- Market Condition Enum
enum ENUM_MARKET_CONDITION
{
   MARKET_NORMAL,
   MARKET_VOLATILE,
   MARKET_NEWS,
   MARKET_GAP,
   MARKET_HOLIDAY,
   TRENDING_BULLISH,
   TRENDING_BEARISH,
   RANGING,
   LOW_VOLATILITY
};

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
   Print("=== QUANTUM AI TRADER PRO INITIALIZATION ===");
   
   // Initialize Risk Manager
   risk_manager.Initialize(Risk_Per_Trade, Daily_Risk_Limit, Max_Drawdown_Percent, 
                          Max_Consecutive_Losses, Use_Correlation_Filter, Use_News_Filter);
   
   // Initialize ML Processor dengan Risk Manager
   if(!ml_processor.Initialize(GetPointer(risk_manager)))
   {
      Print("❌ ML Processor initialization failed!");
      return INIT_FAILED;
   }
   
   // Initialize Advanced ML Model
   if(!Initialize_Advanced_ML())
   {
      Print("Error: ML Model initialization failed!");
      return INIT_FAILED;
   }
   
   // Initialize trading variables
   equity_start = AccountInfoDouble(ACCOUNT_BALANCE);
   session_start_time = TimeCurrent();
   
   // Set up timer untuk continuous monitoring
   EventSetTimer(1);
   
   Print("✅ Quantum AI Trader Pro Successfully Activated");
   Print("🤖 ML Model Ready | Confidence Threshold: ", ML_Confidence_Threshold);
   Print("🛡️ Risk Management Active | Max Drawdown: ", Max_Drawdown_Percent, "%");
   Print("💰 Account Balance: $", equity_start);
   
   return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   EventKillTimer();
   
   Print("=== QUANTUM AI TRADER PRO SHUTDOWN ===");
   Generate_Final_Report();
   
   switch(reason)
   {
      case REASON_ACCOUNT:
         Print("Shutdown reason: Account changed");
         break;
      case REASON_REMOVE:
         Print("Shutdown reason: EA removed from chart");
         break;
      case REASON_RECOMPILE:
         Print("Shutdown reason: EA recompiled");
         break;
      case REASON_CHARTCHANGE:
         Print("Shutdown reason: Symbol or timeframe changed");
         break;
      case REASON_PARAMETERS:
         Print("Shutdown reason: Input parameters changed");
         break;
      case REASON_INITFAILED:
         Print("Shutdown reason: Initialization failed");
         break;
   }
}

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
{
   // Check for new bar untuk strategy execution
   if(IsNewBar())
   {
      // Update ML Model periodically
      if(Should_Retrain_ML())
      {
         ml_processor.Retrain_ML_Model();
         Retrain_ML_Model();
      }
         
      // Calculate advanced ML signals
      ml_processor.Calculate_Advanced_ML_Signal();
      
      // Execute multi-strategy manager
      Multi_Strategy_Manager();
      
      // Update monitoring systems
      Update_Monitoring_Systems();
   }
   
   // Real-time position management (every tick)
   Advanced_Position_Manager();
   
   // Real-time risk monitoring
   RealTime_Risk_Manager();
}

//+------------------------------------------------------------------+
//| Timer function for background tasks                             |
//+------------------------------------------------------------------+
void OnTimer()
{
   // Update risk metrics every second
   risk_manager.UpdateDrawdown();
   
   // Generate hourly report
   static datetime last_hourly_report = 0;
   if(TimeCurrent() - last_hourly_report >= 3600)
   {
      Generate_Hourly_Report();
      last_hourly_report = TimeCurrent();
   }
}

//+------------------------------------------------------------------+
//| Trade transaction handler                                       |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                       const MqlTradeRequest& request,
                       const MqlTradeResult& result)
{
   if(trans.type == TRADE_TRANSACTION_DEAL_ADD)
   {
      ulong ticket = trans.deal;
      if(HistoryDealSelect(ticket))
      {
         ENUM_DEAL_ENTRY entry_type = (ENUM_DEAL_ENTRY)HistoryDealGetInteger(ticket, DEAL_ENTRY);
         double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
         
         if(entry_type == DEAL_ENTRY_IN)
         {
            Print("🎯 New Position Opened: Ticket #", ticket);
            risk_manager.UpdateConsecutiveLosses(false);
         }
         else if(entry_type == DEAL_ENTRY_OUT)
         {
            risk_manager.UpdateProfitStats(profit);
            
            if(profit < 0)
            {
               consecutive_losses++;
               Print("❌ Consecutive Losses: ", consecutive_losses);
            }
            else
            {
               consecutive_losses = 0;
               Print("✅ Winning Trade Closed: +$", profit);
            }
            
            // Update ML model based on trade result
            ml_processor.Update_Feature_Weights(profit > 0);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Advanced ML Initialization                                      |
//+------------------------------------------------------------------+
bool Initialize_Advanced_ML()
{
   ArrayResize(ml_weights, 15);
   
   double base_weights[15] = {
      0.12,  // RSI Momentum
      0.15,  // MACD Trend
      0.11,  // EMA Cross
      0.08,  // Volume Analysis
      0.09,  // Volatility (ATR)
      0.07,  // Price Action
      0.06,  // Support/Resistance
      0.05,  // Market Session
      0.04,  // Time of Day
      0.05,  // Correlation Strength
      0.03,  // News Impact
      0.04,  // Sentiment Analysis
      0.03,  // Economic Calendar
      0.04,  // Order Book Imbalance
      0.04   // Market Regime
   };
   
   ArrayCopy(ml_weights, base_weights);
   
   ml_model_ready = true;
   last_retrain_time = TimeCurrent();
   
   Print("🧠 Advanced ML Model Initialized");
   Print("   - Feature Weights: ", ArraySize(ml_weights), " indicators");
   Print("   - Deep Learning: ", Use_Deep_Learning ? "Enabled" : "Disabled");
   
   return true;
}

//+------------------------------------------------------------------+
//| Multi-Strategy Manager                                         |
//+------------------------------------------------------------------+
void Multi_Strategy_Manager()
{
   if(!ml_model_ready) return;
   
   double current_signal = ml_processor.Get_Current_Signal();
   double ml_confidence = ml_processor.Get_ML_Confidence();
   
   if(ml_confidence < ML_Confidence_Threshold)
   {
      Print("⚠️ Low ML Confidence: ", ml_confidence, " < ", ML_Confidence_Threshold);
      return;
   }
   
   // Check market conditions
   ENUM_MARKET_CONDITION market_state = Analyze_Market_Condition();
   
   // Calculate position size based on ML confidence
   double base_lot_size = risk_manager.CalculatePositionSize(_Symbol, 
                       risk_manager.CalculateDynamicStopLoss(_Symbol, 
                           current_signal > 0 ? ORDER_TYPE_BUY : ORDER_TYPE_SELL));
   
   // Adjust lot size based on ML confidence
   double confidence_multiplier = 0.5 + (ml_confidence / 2.0);
   double lot_size = base_lot_size * confidence_multiplier;
   lot_size = NormalizeDouble(lot_size, 2);
   
   Print("🎯 Strategy Decision:");
   Print("   - Signal: ", current_signal);
   Print("   - Confidence: ", ml_confidence);
   Print("   - Market Condition: ", EnumToString(market_state));
   Print("   - Lot Size: ", lot_size);
   
   // Execute strategies based on market conditions and ML signal
   switch(market_state)
   {
      case TRENDING_BULLISH:
         if(Use_Swing_Mode && current_signal > 0.2)
            Execute_Advanced_Trade(true, ml_confidence, "Swing-Bullish");
         break;
         
      case TRENDING_BEARISH:
         if(Use_Swing_Mode && current_signal < -0.2)
            Execute_Advanced_Trade(false, ml_confidence, "Swing-Bearish");
         break;
         
      case RANGING:
         if(Use_Scalping_Mode && MathAbs(current_signal) > 0.3)
            Execute_Advanced_Trade(current_signal > 0, ml_confidence, "Scalping");
         break;
         
      case MARKET_VOLATILE:
         if(Use_Swing_Mode && MathAbs(current_signal) > 0.4)
            Execute_Advanced_Trade(current_signal > 0, ml_confidence, "Breakout");
         break;
         
      case LOW_VOLATILITY:
         if(Use_Grid_Hedging && MathAbs(current_signal) > 0.2)
            Execute_Advanced_Trade(current_signal > 0, ml_confidence, "Grid");
         break;
         
      default:
         if(MathAbs(current_signal) > 0.3)
            Execute_Advanced_Trade(current_signal > 0, ml_confidence, "Default");
         break;
   }
}

//+------------------------------------------------------------------+
//| Advanced Trade Execution                                       |
//+------------------------------------------------------------------+
void Execute_Advanced_Trade(bool is_buy, double confidence, string strategy_name)
{
   if(!risk_manager.IsTradingAllowed())
   {
      Print("❌ Trading not allowed by Risk Manager");
      return;
   }
   
   double stop_loss_pips = risk_manager.CalculateDynamicStopLoss(_Symbol, 
                               is_buy ? ORDER_TYPE_BUY : ORDER_TYPE_SELL);
   double take_profit_pips = stop_loss_pips * 2.0; // 1:2 Risk/Reward
   
   double lot_size = risk_manager.CalculatePositionSize(_Symbol, stop_loss_pips);
   
   // Adjust lot size based on strategy and confidence
   if(strategy_name == "Scalping")
      lot_size *= 0.5; // Smaller lots for scalping
   else if(strategy_name == "Swing-Bullish" || strategy_name == "Swing-Bearish")
      lot_size *= 1.2; // Larger lots for swing trades
   
   lot_size = NormalizeDouble(lot_size, 2);
   
   // Calculate SL and TP prices
   double current_price = is_buy ? SymbolInfoDouble(_Symbol, SYMBOL_ASK) 
                                 : SymbolInfoDouble(_Symbol, SYMBOL_BID);
   double sl_price, tp_price;
   
   if(is_buy)
   {
      sl_price = current_price - (stop_loss_pips * 10 * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
      tp_price = current_price + (take_profit_pips * 10 * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
   }
   else
   {
      sl_price = current_price + (stop_loss_pips * 10 * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
      tp_price = current_price - (take_profit_pips * 10 * SymbolInfoDouble(_Symbol, SYMBOL_POINT));
   }
   
   if(is_buy)
      Execute_Buy(lot_size, sl_price, tp_price, strategy_name);
   else
      Execute_Sell(lot_size, sl_price, tp_price, strategy_name);
}

//+------------------------------------------------------------------+
//| Execute Buy Order                                              |
//+------------------------------------------------------------------+
void Execute_Buy(double lot_size, double sl, double tp, string strategy_name="ML Signal")
{
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   
   double ask_price = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   
   // Validasi order dengan risk manager
   if(!risk_manager.CanOpenTrade(_Symbol, ORDER_TYPE_BUY, lot_size))
   {
      Print("❌ Risk Manager blocked BUY order");
      return;
   }
   
   ZeroMemory(request);
   ZeroMemory(result);
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lot_size;
   request.type = ORDER_TYPE_BUY;
   request.price = ask_price;
   request.sl = sl;
   request.tp = tp;
   request.deviation = 10;
   request.magic = 12345;
   request.comment = StringFormat("QAI-%s-Conf:%.2f", strategy_name, ml_processor.Get_ML_Confidence());
   
   if(OrderSend(request, result))
   {
      Print("✅ BUY Order Executed:");
      Print("   - Ticket: #", result.order);
      Print("   - Strategy: ", strategy_name);
      Print("   - Lots: ", lot_size);
      Print("   - Price: ", ask_price);
      Print("   - SL: ", sl, " | TP: ", tp);
      Print("   - ML Confidence: ", ml_processor.Get_ML_Confidence());
      
      last_trade_time = TimeCurrent();
      total_trades_today++;
   }
   else
   {
      Print("❌ BUY Order Failed: Error ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Execute Sell Order                                             |
//+------------------------------------------------------------------+
void Execute_Sell(double lot_size, double sl, double tp, string strategy_name="ML Signal")
{
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   
   double bid_price = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   
   // Validasi order dengan risk manager
   if(!risk_manager.CanOpenTrade(_Symbol, ORDER_TYPE_SELL, lot_size))
   {
      Print("❌ Risk Manager blocked SELL order");
      return;
   }
   
   ZeroMemory(request);
   ZeroMemory(result);
   
   request.action = TRADE_ACTION_DEAL;
   request.symbol = _Symbol;
   request.volume = lot_size;
   request.type = ORDER_TYPE_SELL;
   request.price = bid_price;
   request.sl = sl;
   request.tp = tp;
   request.deviation = 10;
   request.magic = 12345;
   request.comment = StringFormat("QAI-%s-Conf:%.2f", strategy_name, ml_processor.Get_ML_Confidence());
   
   if(OrderSend(request, result))
   {
      Print("✅ SELL Order Executed:");
      Print("   - Ticket: #", result.order);
      Print("   - Strategy: ", strategy_name);
      Print("   - Lots: ", lot_size);
      Print("   - Price: ", bid_price);
      Print("   - SL: ", sl, " | TP: ", tp);
      Print("   - ML Confidence: ", ml_processor.Get_ML_Confidence());
      
      last_trade_time = TimeCurrent();
      total_trades_today++;
   }
   else
   {
      Print("❌ SELL Order Failed: Error ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Advanced Position Manager                                      |
//+------------------------------------------------------------------+
void Advanced_Position_Manager()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
      {
         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
         double current_price = PositionGetDouble(POSITION_PRICE_CURRENT);
         double profit = PositionGetDouble(POSITION_PROFIT);
         double sl = PositionGetDouble(POSITION_SL);
         double tp = PositionGetDouble(POSITION_TP);
         
         // Advanced Breakeven System
         Manage_Advanced_Breakeven(ticket, type, open_price, current_price, profit);
         
         // Dynamic Trailing Stop
         Manage_Dynamic_Trailing(ticket, type, current_price, profit);
         
         // Time-Based Exit
         Manage_Time_Based_Exit(ticket);
         
         // ML-Based Exit Signal
         if(Should_Exit_Position(type))
         {
            Close_Position(ticket, "ML Exit Signal");
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Advanced Breakeven System                                      |
//+------------------------------------------------------------------+
void Manage_Advanced_Breakeven(ulong ticket, ENUM_POSITION_TYPE type, 
                              double open_price, double current_price, double profit)
{
   double profit_pips = risk_manager.CalculatePips(_Symbol, open_price, current_price);
   double current_sl = PositionGetDouble(POSITION_SL);
   
   if(current_sl != open_price) return; // Already moved from original SL
   
   // Tiered Breakeven System
   if(profit_pips >= 10)  // Tier 1: Move to breakeven + spread
   {
      double new_sl = open_price + (type == POSITION_TYPE_BUY ? 5*_Point : -5*_Point);
      Modify_SL(ticket, new_sl);
      Print("🎯 Tier 1 Breakeven Activated for ticket #", ticket);
   }
   else if(profit_pips >= 20) // Tier 2: Move to +5 pips
   {
      double new_sl = open_price + (type == POSITION_TYPE_BUY ? 10*_Point : -10*_Point);
      Modify_SL(ticket, new_sl);
      Print("🎯 Tier 2 Breakeven Activated for ticket #", ticket);
   }
   else if(profit_pips >= 30) // Tier 3: Move to +10 pips
   {
      double new_sl = open_price + (type == POSITION_TYPE_BUY ? 15*_Point : -15*_Point);
      Modify_SL(ticket, new_sl);
      Print("🎯 Tier 3 Breakeven Activated for ticket #", ticket);
   }
}

//+------------------------------------------------------------------+
//| Dynamic Trailing Stop                                          |
//+------------------------------------------------------------------+
void Manage_Dynamic_Trailing(ulong ticket, ENUM_POSITION_TYPE type, 
                           double current_price, double profit)
{
   double atr = iATR(_Symbol, PERIOD_H1, ATR_Period);
   double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
   double current_sl = PositionGetDouble(POSITION_SL);
   double profit_pips = risk_manager.CalculatePips(_Symbol, open_price, current_price);
   
   // Only trail if in significant profit
   if(profit_pips > 20)
   {
      double trail_distance = atr * 0.75; // 75% of ATR
      double new_sl = 0;
      
      if(type == POSITION_TYPE_BUY)
      {
         new_sl = current_price - trail_distance;
         if(new_sl > current_sl && new_sl > open_price)
         {
            Modify_SL(ticket, new_sl);
            Print("📈 Trailing Stop Updated for BUY #", ticket, " to ", new_sl);
         }
      }
      else
      {
         new_sl = current_price + trail_distance;
         if(new_sl < current_sl && new_sl < open_price)
         {
            Modify_SL(ticket, new_sl);
            Print("📉 Trailing Stop Updated for SELL #", ticket, " to ", new_sl);
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Modify Stop Loss                                               |
//+------------------------------------------------------------------+
void Modify_SL(ulong ticket, double new_sl)
{
   MqlTradeRequest request = {0};
   MqlTradeResult result = {0};
   
   ZeroMemory(request);
   ZeroMemory(result);
   
   request.action = TRADE_ACTION_SLTP;
   request.position = ticket;
   request.sl = new_sl;
   request.magic = 12345;
   
   if(OrderSend(request, result))
   {
      Print("✅ SL Modified for ticket #", ticket, " to ", new_sl);
   }
   else
   {
      Print("❌ SL Modification Failed for ticket #", ticket, " Error: ", GetLastError());
   }
}

//+------------------------------------------------------------------+
//| Close Position                                                 |
//+------------------------------------------------------------------+
void Close_Position(ulong ticket, string reason="Manual")
{
   if(PositionSelectByTicket(ticket))
   {
      double volume = PositionGetDouble(POSITION_VOLUME);
      string symbol = PositionGetString(POSITION_SYMBOL);
      
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY)
         trade.Sell(volume, symbol);
      else
         trade.Buy(volume, symbol);
         
      Print("🔒 Position Closed: Ticket #", ticket, " | Reason: ", reason);
   }
}

//+------------------------------------------------------------------+
//| Time-Based Exit Management                                     |
//+------------------------------------------------------------------+
void Manage_Time_Based_Exit(ulong ticket)
{
   if(PositionSelectByTicket(ticket))
   {
      datetime open_time = (datetime)PositionGetInteger(POSITION_TIME);
      double current_time = TimeCurrent();
      double hours_open = (current_time - open_time) / 3600.0;
      
      // Close positions open too long
      if(hours_open > 48) // 2 days
      {
         Close_Position(ticket, "Time-Based Exit (48h+)");
      }
      // Close before weekend if not in significant profit
      else if(TimeDayOfWeek(TimeCurrent()) == 5 && TimeHour(TimeCurrent()) >= 20) // Friday 8PM
      {
         double profit = PositionGetDouble(POSITION_PROFIT);
         if(profit < 0)
         {
            Close_Position(ticket, "Weekend Exit");
         }
      }
   }
}

//+------------------------------------------------------------------+
//| Should Exit Position Based on ML Signal                       |
//+------------------------------------------------------------------+
bool Should_Exit_Position(ENUM_POSITION_TYPE type)
{
   double current_signal = ml_processor.Get_Current_Signal();
   double ml_confidence = ml_processor.Get_ML_Confidence();
   
   // Exit if ML signal strongly opposes current position
   if(type == POSITION_TYPE_BUY && current_signal < -0.5 && ml_confidence > 0.7)
      return true;
   if(type == POSITION_TYPE_SELL && current_signal > 0.5 && ml_confidence > 0.7)
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| Real-Time Risk Manager                                         |
//+------------------------------------------------------------------+
void RealTime_Risk_Manager()
{
   double current_equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double current_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   
   // Calculate current drawdown
   current_drawdown = ((equity_start - current_equity) / equity_start) * 100;
   max_drawdown = MathMax(max_drawdown, current_drawdown);
   
   // Emergency stop conditions
   if(max_drawdown >= Max_Drawdown_Percent)
   {
      risk_manager.CloseAllPositions();
      Print("🚨 EMERGENCY STOP: Max Drawdown Reached (", max_drawdown, "%)");
      ExpertRemove();
      return;
   }
   
   if(consecutive_losses >= Max_Consecutive_Losses)
   {
      Print("⚠️ Trading Paused: ", consecutive_losses, " consecutive losses");
      return;
   }
   
   // Daily risk limit check
   if(risk_manager.IsDailyLimitReached())
   {
      Print("📉 Daily Risk Limit Reached. Stopping trading for today.");
      return;
   }
}

//+------------------------------------------------------------------+
//| Market Condition Analysis                                      |
//+------------------------------------------------------------------+
ENUM_MARKET_CONDITION Analyze_Market_Condition()
{
   double atr = iATR(_Symbol, PERIOD_H1, ATR_Period);
   double atr_normalized = atr / SymbolInfoDouble(_Symbol, SYMBOL_POINT);
   
   // Trend analysis
   double ema_fast = iEMA(_Symbol, PERIOD_H1, EMA_Fast, 0, PRICE_CLOSE);
   double ema_slow = iEMA(_Symbol, PERIOD_H1, EMA_Slow, 0, PRICE_CLOSE);
   double ema_trend = iEMA(_Symbol, PERIOD_H1, EMA_Trend, 0, PRICE_CLOSE);
   
   bool is_uptrend = (ema_fast > ema_slow) && (ema_slow > ema_trend);
   bool is_downtrend = (ema_fast < ema_slow) && (ema_slow < ema_trend);
   
   // Volatility analysis
   if(atr_normalized > 20.0)
      return MARKET_VOLATILE;
   else if(atr_normalized < 5.0)
      return LOW_VOLATILITY;
   else if(is_uptrend)
      return TRENDING_BULLISH;
   else if(is_downtrend)
      return TRENDING_BEARISH;
   else
      return RANGING;
}

//+------------------------------------------------------------------+
//| Update Monitoring Systems                                      |
//+------------------------------------------------------------------+
void Update_Monitoring_Systems()
{
   // Update performance metrics
   Update_Performance_Metrics();
   
   // Check for daily/weekly reset
   Check_Time_Reset();
}

//+------------------------------------------------------------------+
//| Update Performance Metrics                                     |
//+------------------------------------------------------------------+
void Update_Performance_Metrics()
{
   static datetime last_update = 0;
   if(TimeCurrent() - last_update < 300) // Update every 5 minutes
      return;
   
   double current_equity = AccountInfoDouble(ACCOUNT_EQUITY);
   daily_profit = current_equity - equity_start;
   
   Print("📊 Performance Update:");
   Print("   - Equity: $", current_equity);
   Print("   - Daily P/L: $", daily_profit);
   Print("   - Drawdown: ", current_drawdown, "%");
   Print("   - Open Trades: ", PositionsTotal());
   Print("   - ML Confidence: ", ml_processor.Get_ML_Confidence());
   
   last_update = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Check Time Reset for Daily/Weekly                              |
//+------------------------------------------------------------------+
void Check_Time_Reset()
{
   MqlDateTime current_time;
   TimeCurrent(current_time);
   static int last_day = current_time.day;
   
   if(current_time.day != last_day)
   {
      risk_manager.ResetDaily();
      total_trades_today = 0;
      last_day = current_time.day;
      Print("🔄 Daily reset completed");
   }
   
   // Weekly reset (simplified)
   if(TimeCurrent() - session_start_time > 7 * 24 * 60 * 60)
   {
      risk_manager.ResetWeekly();
      session_start_time = TimeCurrent();
      Print("🔄 Weekly reset completed");
   }
}

//+------------------------------------------------------------------+
//| Generate Hourly Report                                         |
//+------------------------------------------------------------------+
void Generate_Hourly_Report()
{
   Print("=== HOURLY REPORT ===");
   risk_manager.GenerateRiskReport();
   Print("=== END HOURLY REPORT ===");
}

//+------------------------------------------------------------------+
//| Generate Final Report                                          |
//+------------------------------------------------------------------+
void Generate_Final_Report()
{
   Print("=== FINAL TRADING REPORT ===");
   Print("Session Duration: ", (TimeCurrent() - session_start_time) / 3600, " hours");
   Print("Total Trades Today: ", total_trades_today);
   Print("Final Drawdown: ", current_drawdown, "%");
   Print("Max Drawdown: ", max_drawdown, "%");
   Print("Final ML Confidence: ", ml_processor.Get_ML_Confidence());
   Print("=== END FINAL REPORT ===");
}

//+------------------------------------------------------------------+
//| Retrain ML Model                                               |
//+------------------------------------------------------------------+
void Retrain_ML_Model()
{
   Print("🔄 Retraining ML Model...");
   ml_processor.Retrain_ML_Model();
   last_retrain_time = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Check if Should Retrain ML                                     |
//+------------------------------------------------------------------+
bool Should_Retrain_ML()
{
   return (TimeCurrent() - last_retrain_time) > (ML_Retrain_Hours * 3600);
}

//+------------------------------------------------------------------+
//| Calculate ML Confidence (Wrapper)                              |
//+------------------------------------------------------------------+
double Calculate_ML_Confidence(double &features[])
{
   return ml_processor.Calculate_ML_Confidence(features);
}

//+------------------------------------------------------------------+
//| Update Prediction History (Wrapper)                            |
//+------------------------------------------------------------------+
void Update_Prediction_History(double signal)
{
   ml_processor.Update_Prediction_History(signal);
}

//+------------------------------------------------------------------+
//| Utility Functions                                              |
//+------------------------------------------------------------------+
bool IsNewBar()
{
   static datetime last_bar = 0;
   datetime current_bar = iTime(_Symbol, _Period, 0);
   
   if(last_bar != current_bar)
   {
      last_bar = current_bar;
      return true;
   }
   return false;
}

//+------------------------------------------------------------------+
//| Enum to String Converter                                       |
//+------------------------------------------------------------------+
string EnumToString(ENUM_MARKET_CONDITION condition)
{
   switch(condition)
   {
      case MARKET_NORMAL: return "NORMAL";
      case MARKET_VOLATILE: return "VOLATILE";
      case MARKET_NEWS: return "NEWS";
      case MARKET_GAP: return "GAP";
      case MARKET_HOLIDAY: return "HOLIDAY";
      case TRENDING_BULLISH: return "TRENDING_BULLISH";
      case TRENDING_BEARISH: return "TRENDING_BEARISH";
      case RANGING: return "RANGING";
      case LOW_VOLATILITY: return "LOW_VOLATILITY";
      default: return "UNKNOWN";
   }
}
//+------------------------------------------------------------------+