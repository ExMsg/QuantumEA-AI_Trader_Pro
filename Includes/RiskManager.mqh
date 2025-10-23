//+------------------------------------------------------------------+
//| Advanced Risk Management System                                |
//| Quantum AI Trader Pro                                          |
//+------------------------------------------------------------------+

#ifndef RISKMANAGER_MQH
#define RISKMANAGER_MQH

#include <Trade/Trade.mqh>
#include <Arrays/ArrayDouble.mqh>
#include <Arrays/ArrayString.mqh>

//+------------------------------------------------------------------+
//| Risk Management Enumerations                                    |
//+------------------------------------------------------------------+
enum ENUM_RISK_PROFILE
{
   RISK_CONSERVATIVE,    // Conservative - 0.5% risk per trade
   RISK_MODERATE,        // Moderate - 1.0% risk per trade  
   RISK_AGGRESSIVE,      // Aggressive - 2.0% risk per trade
   RISK_PROFESSIONAL     // Professional - Adaptive risk
};

enum ENUM_MARKET_CONDITION
{
   MARKET_NORMAL,        // Normal market conditions
   MARKET_VOLATILE,      // High volatility
   MARKET_NEWS,          // News events
   MARKET_GAP,           // Gap situations
   MARKET_HOLIDAY        // Holiday/thin volume
};

//+------------------------------------------------------------------+
//| Advanced Risk Management Class                                 |
//+------------------------------------------------------------------+
class CRiskManager
{
private:
   CTrade           m_trade;
   double           m_initial_balance;
   double           m_daily_profit;
   double           m_weekly_profit;
   double           m_max_drawdown;
   double           m_current_drawdown;
   int              m_consecutive_losses;
   int              m_total_trades_today;
   datetime         m_last_trade_time;
   datetime         m_session_start;
   string           m_correlation_pairs[6];
   
   // Risk parameters
   double           m_risk_per_trade;
   double           m_daily_risk_limit;
   double           m_max_drawdown_percent;
   int              m_max_consecutive_losses;
   bool             m_use_correlation_filter;
   bool             m_use_news_filter;
   
   // Statistics
   double           m_win_rate;
   int              m_total_wins;
   int              m_total_losses;
   double           m_largest_win;
   double           m_largest_loss;
   double           m_average_win;
   double           m_average_loss;
   
public:
   // Constructor & Destructor
                     CRiskManager();
                    ~CRiskManager();
   
   // Initialization
   void              Initialize(double risk_per_trade, double daily_limit, 
                               double max_drawdown, int max_consecutive_losses,
                               bool use_correlation=true, bool use_news=true);
   void              ResetDaily();
   void              ResetWeekly();
   
   // Risk Assessment
   bool              IsTradingAllowed();
   bool              CanOpenTrade(string symbol, ENUM_ORDER_TYPE type, double lot_size);
   double            CalculatePositionSize(string symbol, double stop_loss_pips, double risk_percent=0);
   double            CalculateDynamicStopLoss(string symbol, ENUM_ORDER_TYPE type, double atr_multiplier=1.5);
   double            CalculateDynamicTakeProfit(string symbol, ENUM_ORDER_TYPE type, double risk_reward_ratio=2.0);
   
   // Money Management
   double            GetOptimalLotSize(string symbol, double stop_loss_pips);
   double            GetMaxLotSize(string symbol);
   double            GetMarginRequired(string symbol, double lot_size);
   double            GetFreeMargin();
   double            GetMarginLevel();
   
   // Drawdown Management
   double            GetCurrentDrawdown();
   double            GetMaxDrawdown();
   bool              IsDrawdownLimitReached();
   void              UpdateDrawdown();
   
   // Daily/Weekly Limits
   double            GetDailyProfit();
   double            GetWeeklyProfit();
   bool              IsDailyLimitReached();
   bool              IsWeeklyLimitReached();
   void              UpdateProfitStats(double profit);
   
   // Consecutive Losses Management
   int               GetConsecutiveLosses();
   void              UpdateConsecutiveLosses(bool is_win);
   bool              IsMaxConsecutiveLossesReached();
   
   // Correlation Management
   bool              ArePairsCorrelated(string pair1, string pair2, double threshold=0.7);
   bool              HasCorrelatedPosition(string symbol, ENUM_ORDER_TYPE type);
   int               CountCorrelatedPositions(string symbol);
   double            GetCorrelationExposure();
   
   // Market Condition Analysis
   ENUM_MARKET_CONDITION GetMarketCondition(string symbol);
   bool              IsHighVolatilityPeriod(string symbol);
   bool              IsNewsEventSoon(int minutes_before=30);
   bool              IsMarketClosed(string symbol);
   
   // Position Management
   bool              ShouldCloseEarly(ulong ticket, string reason);
   bool              ShouldMoveToBreakeven(ulong ticket);
   bool              ShouldTrailStop(ulong ticket);
   double            GetOptimalTrailingDistance(string symbol);
   
   // Risk Reporting
   void              GenerateRiskReport();
   string            GetRiskStatus();
   double            GetPortfolioRisk();
   double            GetSingleTradeRisk(string symbol, double lot_size);
   
   // Emergency Procedures
   void              CloseAllPositions();
   void              CloseWorstPerformingPosition();
   void              HedgePositions();
   void              ReducePositionSizes(double factor);
   
   // Advanced Features
   double            CalculateKellyCriterion();
   double            CalculateOptimalF();
   void              AdjustRiskBasedOnVolatility(string symbol);
   bool              IsOverLeveraged();
   
   // Utility Functions
   double            CalculatePips(string symbol, double price1, double price2);
   double            GetPointValue(string symbol);
   double            GetSpread(string symbol);
   bool              IsSpreadAcceptable(string symbol, int max_spread=3);
   
private:
   // Helper functions
   double            CalculatePortfolioVariance();
   double            GetPairCorrelation(string pair1, string pair2);
   bool              IsTradingSession(string symbol);
   double            GetVolatilityRatio(string symbol);
   void              UpdateWinRateStats(bool is_win, double profit);
};

//+------------------------------------------------------------------+
//| Constructor                                                     |
//+------------------------------------------------------------------+
CRiskManager::CRiskManager()
{
   m_initial_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   m_daily_profit = 0;
   m_weekly_profit = 0;
   m_max_drawdown = 0;
   m_current_drawdown = 0;
   m_consecutive_losses = 0;
   m_total_trades_today = 0;
   m_last_trade_time = 0;
   m_session_start = TimeCurrent();
   
   // Initialize correlation pairs
   m_correlation_pairs[0] = "EURUSD";
   m_correlation_pairs[1] = "GBPUSD";
   m_correlation_pairs[2] = "USDCHF";
   m_correlation_pairs[3] = "USDJPY";
   m_correlation_pairs[4] = "USDCAD";
   m_correlation_pairs[5] = "AUDUSD";
   
   // Initialize statistics
   m_win_rate = 0;
   m_total_wins = 0;
   m_total_losses = 0;
   m_largest_win = 0;
   m_largest_loss = 0;
   m_average_win = 0;
   m_average_loss = 0;
}

//+------------------------------------------------------------------+
//| Destructor                                                      |
//+------------------------------------------------------------------+
CRiskManager::~CRiskManager()
{
   GenerateRiskReport();
}

//+------------------------------------------------------------------+
//| Initialize Risk Manager                                         |
//+------------------------------------------------------------------+
void CRiskManager::Initialize(double risk_per_trade, double daily_limit, 
                            double max_drawdown, int max_consecutive_losses,
                            bool use_correlation=true, bool use_news=true)
{
   m_risk_per_trade = risk_per_trade;
   m_daily_risk_limit = daily_limit;
   m_max_drawdown_percent = max_drawdown;
   m_max_consecutive_losses = max_consecutive_losses;
   m_use_correlation_filter = use_correlation;
   m_use_news_filter = use_news;
   
   Print("=== RISK MANAGER INITIALIZED ===");
   Print("Risk per Trade: ", m_risk_per_trade, "%");
   Print("Daily Risk Limit: ", m_daily_risk_limit, "%");
   Print("Max Drawdown: ", m_max_drawdown_percent, "%");
   Print("Max Consecutive Losses: ", m_max_consecutive_losses);
   Print("Correlation Filter: ", m_use_correlation_filter ? "Enabled" : "Disabled");
   Print("News Filter: ", m_use_news_filter ? "Enabled" : "Disabled");
}

//+------------------------------------------------------------------+
//| Check if trading is allowed                                     |
//+------------------------------------------------------------------+
bool CRiskManager::IsTradingAllowed()
{
   // Check drawdown limit
   if(IsDrawdownLimitReached())
   {
      Print("🚨 Trading stopped: Max drawdown reached!");
      return false;
   }
   
   // Check consecutive losses
   if(IsMaxConsecutiveLossesReached())
   {
      Print("⚠️ Trading paused: Max consecutive losses reached!");
      return false;
   }
   
   // Check daily limit
   if(IsDailyLimitReached())
   {
      Print("📉 Trading stopped: Daily risk limit reached!");
      return false;
   }
   
   // Check margin level
   if(GetMarginLevel() < 100) // Less than 100% margin level
   {
      Print("💰 Trading paused: Low margin level!");
      return false;
   }
   
   // Check if over leveraged
   if(IsOverLeveraged())
   {
      Print("⚖️ Trading paused: Over leveraged!");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Check if specific trade can be opened                          |
//+------------------------------------------------------------------+
bool CRiskManager::CanOpenTrade(string symbol, ENUM_ORDER_TYPE type, double lot_size)
{
   if(!IsTradingAllowed())
      return false;
   
   // Check spread
   if(!IsSpreadAcceptable(symbol))
   {
      Print("Spread too high for ", symbol);
      return false;
   }
   
   // Check correlation
   if(m_use_correlation_filter && HasCorrelatedPosition(symbol, type))
   {
      Print("Correlated position exists for ", symbol);
      return false;
   }
   
   // Check news filter
   if(m_use_news_filter && IsNewsEventSoon())
   {
      Print("High impact news event soon - avoiding trade");
      return false;
   }
   
   // Check market condition
   ENUM_MARKET_CONDITION condition = GetMarketCondition(symbol);
   if(condition == MARKET_NEWS || condition == MARKET_GAP)
   {
      Print("Market condition not favorable for trading");
      return false;
   }
   
   // Check margin requirements
   double margin_required = GetMarginRequired(symbol, lot_size);
   double free_margin = GetFreeMargin();
   
   if(margin_required > free_margin * 0.8) // Use max 80% of free margin
   {
      Print("Insufficient margin for trade");
      return false;
   }
   
   return true;
}

//+------------------------------------------------------------------+
//| Calculate position size based on risk                          |
//+------------------------------------------------------------------+
double CRiskManager::CalculatePositionSize(string symbol, double stop_loss_pips, double risk_percent=0)
{
   if(risk_percent == 0)
      risk_percent = m_risk_per_trade;
   
   double account_balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double risk_amount = account_balance * risk_percent / 100.0;
   
   double point_value = GetPointValue(symbol);
   double loss_in_points = stop_loss_pips * 10; // Convert pips to points
   
   if(loss_in_points == 0 || point_value == 0)
      return 0.01; // Minimum lot size
   
   double lot_size = risk_amount / (loss_in_points * point_value);
   
   // Apply volatility adjustment
   double volatility_ratio = GetVolatilityRatio(symbol);
   lot_size *= volatility_ratio;
   
   // Ensure lot size is within limits
   double max_lot = GetMaxLotSize(symbol);
   double min_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MIN);
   
   lot_size = MathMin(lot_size, max_lot);
   lot_size = MathMax(lot_size, min_lot);
   
   lot_size = NormalizeDouble(lot_size, 2);
   
   Print("Position Size Calculation:");
   Print(" - Symbol: ", symbol);
   Print(" - Risk: ", risk_amount, " USD (", risk_percent, "%)");
   Print(" - Stop Loss: ", stop_loss_pips, " pips");
   Print(" - Calculated Lot Size: ", lot_size);
   
   return lot_size;
}

//+------------------------------------------------------------------+
//| Calculate dynamic stop loss based on ATR                       |
//+------------------------------------------------------------------+
double CRiskManager::CalculateDynamicStopLoss(string symbol, ENUM_ORDER_TYPE type, double atr_multiplier=1.5)
{
   int atr_handle = iATR(symbol, PERIOD_H1, 14);
   double atr_value = 0;
   
   if(CopyBuffer(atr_handle, 0, 0, 1, atr_value) > 0)
   {
      double stop_loss_pips = atr_value * atr_multiplier / SymbolInfoDouble(symbol, SYMBOL_POINT);
      stop_loss_pips = NormalizeDouble(stop_loss_pips, 1);
      
      // Adjust based on market volatility
      double volatility_ratio = GetVolatilityRatio(symbol);
      stop_loss_pips *= volatility_ratio;
      
      return stop_loss_pips;
   }
   
   return 50; // Default 50 pips if ATR fails
}

//+------------------------------------------------------------------+
//| Calculate dynamic take profit                                  |
//+------------------------------------------------------------------+
double CRiskManager::CalculateDynamicTakeProfit(string symbol, ENUM_ORDER_TYPE type, double risk_reward_ratio=2.0)
{
   double stop_loss_pips = CalculateDynamicStopLoss(symbol, type);
   return stop_loss_pips * risk_reward_ratio;
}

//+------------------------------------------------------------------+
//| Get maximum lot size for symbol                                |
//+------------------------------------------------------------------+
double CRiskManager::GetMaxLotSize(string symbol)
{
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double max_risk_lot = balance * 0.02 / 1000; // 2% risk assumption
  
   double broker_max_lot = SymbolInfoDouble(symbol, SYMBOL_VOLUME_MAX);
   double margin_limited_lot = GetFreeMargin() * 0.5 / GetMarginRequired(symbol, 1.0);
   
   return MathMin(MathMin(max_risk_lot, broker_max_lot), margin_limited_lot);
}

//+------------------------------------------------------------------+
//| Get margin required for trade                                  |
//+------------------------------------------------------------------+
double CRiskManager::GetMarginRequired(string symbol, double lot_size)
{
   double margin_required = 0;
   
   if(OrderCalcMargin(ORDER_TYPE_BUY, symbol, lot_size, 
                      SymbolInfoDouble(symbol, SYMBOL_ASK), margin_required))
   {
      return margin_required;
   }
   
   return 0;
}

//+------------------------------------------------------------------+
//| Get free margin                                                |
//+------------------------------------------------------------------+
double CRiskManager::GetFreeMargin()
{
   return AccountInfoDouble(ACCOUNT_MARGIN_FREE);
}

//+------------------------------------------------------------------+
//| Get margin level                                               |
//+------------------------------------------------------------------+
double CRiskManager::GetMarginLevel()
{
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double margin = AccountInfoDouble(ACCOUNT_MARGIN);
   
   if(margin == 0) return 1000; // No positions, high margin level
   
   return (equity / margin) * 100;
}

//+------------------------------------------------------------------+
//| Update and get current drawdown                                |
//+------------------------------------------------------------------+
double CRiskManager::GetCurrentDrawdown()
{
   UpdateDrawdown();
   return m_current_drawdown;
}

//+------------------------------------------------------------------+
//| Get maximum drawdown                                           |
//+------------------------------------------------------------------+
double CRiskManager::GetMaxDrawdown()
{
   return m_max_drawdown;
}

//+------------------------------------------------------------------+
//| Check if drawdown limit is reached                             |
//+------------------------------------------------------------------+
bool CRiskManager::IsDrawdownLimitReached()
{
   UpdateDrawdown();
   return (m_current_drawdown >= m_max_drawdown_percent);
}

//+------------------------------------------------------------------+
//| Update drawdown calculations                                   |
//+------------------------------------------------------------------+
void CRiskManager::UpdateDrawdown()
{
   double equity = AccountInfoDouble(ACCOUNT_EQUITY);
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   
   if(balance == 0) return;
   
   m_current_drawdown = ((balance - equity) / balance) * 100;
   m_max_drawdown = MathMax(m_max_drawdown, m_current_drawdown);
}

//+------------------------------------------------------------------+
//| Get daily profit                                               |
//+------------------------------------------------------------------+
double CRiskManager::GetDailyProfit()
{
   return m_daily_profit;
}

//+------------------------------------------------------------------+
//| Get weekly profit                                              |
//+------------------------------------------------------------------+
double CRiskManager::GetWeeklyProfit()
{
   return m_weekly_profit;
}

//+------------------------------------------------------------------+
//| Check if daily limit is reached                                |
//+------------------------------------------------------------------+
bool CRiskManager::IsDailyLimitReached()
{
   MqlDateTime today, last_trade;
   TimeCurrent(today);
   TimeToStruct(m_last_trade_time, last_trade);
   
   // Reset daily profit if new day
   if(today.day != last_trade.day)
   {
      ResetDaily();
   }
   
   return (m_daily_profit <= -m_daily_risk_limit);
}

//+------------------------------------------------------------------+
//| Check if weekly limit is reached                               |
//+------------------------------------------------------------------+
bool CRiskManager::IsWeeklyLimitReached()
{
   // Simple weekly reset - in practice, you'd want more sophisticated logic
   if(TimeCurrent() - m_session_start > 7 * 24 * 60 * 60)
   {
      ResetWeekly();
   }
   
   return (m_weekly_profit <= -m_daily_risk_limit * 5); // 5x daily limit
}

//+------------------------------------------------------------------+
//| Reset daily statistics                                         |
//+------------------------------------------------------------------+
void CRiskManager::ResetDaily()
{
   m_daily_profit = 0;
   m_total_trades_today = 0;
   m_last_trade_time = TimeCurrent();
   Print("Daily statistics reset");
}

//+------------------------------------------------------------------+
//| Reset weekly statistics                                        |
//+------------------------------------------------------------------+
void CRiskManager::ResetWeekly()
{
   m_weekly_profit = 0;
   m_session_start = TimeCurrent();
   Print("Weekly statistics reset");
}

//+------------------------------------------------------------------+
//| Get consecutive losses count                                   |
//+------------------------------------------------------------------+
int CRiskManager::GetConsecutiveLosses()
{
   return m_consecutive_losses;
}

//+------------------------------------------------------------------+
//| Update consecutive losses tracking                             |
//+------------------------------------------------------------------+
void CRiskManager::UpdateConsecutiveLosses(bool is_win)
{
   if(is_win)
   {
      m_consecutive_losses = 0;
   }
   else
   {
      m_consecutive_losses++;
   }
}

//+------------------------------------------------------------------+
//| Check if max consecutive losses reached                        |
//+------------------------------------------------------------------+
bool CRiskManager::IsMaxConsecutiveLossesReached()
{
   return (m_consecutive_losses >= m_max_consecutive_losses);
}

//+------------------------------------------------------------------+
//| Check if pairs are correlated                                  |
//+------------------------------------------------------------------+
bool CRiskManager::ArePairsCorrelated(string pair1, string pair2, double threshold=0.7)
{
   if(pair1 == pair2) return true;
   
   double correlation = GetPairCorrelation(pair1, pair2);
   return (MathAbs(correlation) >= threshold);
}

//+------------------------------------------------------------------+
//| Check if correlated position exists                            |
//+------------------------------------------------------------------+
bool CRiskManager::HasCorrelatedPosition(string symbol, ENUM_ORDER_TYPE type)
{
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
      {
         string position_symbol = PositionGetString(POSITION_SYMBOL);
         ENUM_POSITION_TYPE position_type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         
         if(ArePairsCorrelated(symbol, position_symbol) && position_type == type)
         {
            return true;
         }
      }
   }
   return false;
}

//+------------------------------------------------------------------+
//| Count correlated positions                                     |
//+------------------------------------------------------------------+
int CRiskManager::CountCorrelatedPositions(string symbol)
{
   int count = 0;
   for(int i = 0; i < PositionsTotal(); i++)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
      {
         string position_symbol = PositionGetString(POSITION_SYMBOL);
         if(ArePairsCorrelated(symbol, position_symbol))
         {
            count++;
         }
      }
   }
   return count;
}

//+------------------------------------------------------------------+
//| Get correlation exposure                                       |
//+------------------------------------------------------------------+
double CRiskManager::GetCorrelationExposure()
{
   double total_exposure = 0;
   int position_count = PositionsTotal();
   
   if(position_count == 0) return 0;
   
   for(int i = 0; i < position_count; i++)
   {
      ulong ticket1 = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket1))
      {
         string symbol1 = PositionGetString(POSITION_SYMBOL);
         double volume1 = PositionGetDouble(POSITION_VOLUME);
         
         for(int j = i + 1; j < position_count; j++)
         {
            ulong ticket2 = PositionGetTicket(j);
            if(PositionSelectByTicket(ticket2))
            {
               string symbol2 = PositionGetString(POSITION_SYMBOL);
               double volume2 = PositionGetDouble(POSITION_VOLUME);
               
               if(ArePairsCorrelated(symbol1, symbol2))
               {
                  total_exposure += (volume1 + volume2) / 2.0;
               }
            }
         }
      }
   }
   
   return total_exposure;
}

//+------------------------------------------------------------------+
//| Get market condition                                           |
//+------------------------------------------------------------------+
ENUM_MARKET_CONDITION CRiskManager::GetMarketCondition(string symbol)
{
   if(IsNewsEventSoon())
      return MARKET_NEWS;
   
   if(IsHighVolatilityPeriod(symbol))
      return MARKET_VOLATILE;
   
   if(IsMarketClosed(symbol))
      return MARKET_HOLIDAY;
   
   return MARKET_NORMAL;
}

//+------------------------------------------------------------------+
//| Check for high volatility period                               |
//+------------------------------------------------------------------+
bool CRiskManager::IsHighVolatilityPeriod(string symbol)
{
   double atr = iATR(symbol, PERIOD_H1, 14);
   double atr_normalized = atr / SymbolInfoDouble(symbol, SYMBOL_POINT);
   
   return (atr_normalized > 20); // More than 20 pips ATR
}

//+------------------------------------------------------------------+
//| Check for upcoming news events                                 |
//+------------------------------------------------------------------+
bool CRiskManager::IsNewsEventSoon(int minutes_before=30)
{
   // This is a simplified version. In practice, you'd integrate with a news API
   // or economic calendar data
   
   MqlDateTime current_time;
   TimeCurrent(current_time);
   
   // Check for major news times (simplified)
   int hour = current_time.hour;
   int min = current_time.min;
   
   // Example: Assume news at 8:30, 10:00, 13:30, 15:00 EST
   // Convert to your broker time
   
   // This is a placeholder - implement proper news integration
   return false;
}

//+------------------------------------------------------------------+
//| Check if market is closed                                      |
//+------------------------------------------------------------------+
bool CRiskManager::IsMarketClosed(string symbol)
{
   MqlDateTime current_time;
   TimeCurrent(current_time);
   int day_of_week = current_time.day_of_week;
   int hour = current_time.hour;
   
   // Weekend check
   if(day_of_week == 0 || day_of_week == 6) // Sunday or Saturday
      return true;
   
   // Major holidays (simplified - add more as needed)
   if(current_time.mon == 1 && current_time.day == 1) // New Year
      return true;
   
   // Market session checks (simplified)
   string symbol_base = StringSubstr(symbol, 0, 3);
   string symbol_quote = StringSubstr(symbol, 3, 3);
   
   // Check if both markets are open
   // This is simplified - implement proper market hours for each currency
   
   return false;
}

//+------------------------------------------------------------------+
//| Update profit statistics                                       |
//+------------------------------------------------------------------+
void CRiskManager::UpdateProfitStats(double profit)
{
   m_daily_profit += profit;
   m_weekly_profit += profit;
   m_total_trades_today++;
   m_last_trade_time = TimeCurrent();
   
   bool is_win = (profit > 0);
   UpdateConsecutiveLosses(is_win);
   UpdateWinRateStats(is_win, profit);
}

//+------------------------------------------------------------------+
//| Update win rate statistics                                     |
//+------------------------------------------------------------------+
void CRiskManager::UpdateWinRateStats(bool is_win, double profit)
{
   if(is_win)
   {
      m_total_wins++;
      m_largest_win = MathMax(m_largest_win, profit);
      m_average_win = (m_average_win * (m_total_wins - 1) + profit) / m_total_wins;
   }
   else
   {
      m_total_losses++;
      m_largest_loss = MathMin(m_largest_loss, profit);
      m_average_loss = (m_average_loss * (m_total_losses - 1) + profit) / m_total_losses;
   }
   
   int total_trades = m_total_wins + m_total_losses;
   if(total_trades > 0)
   {
      m_win_rate = (double)m_total_wins / total_trades * 100;
   }
}

//+------------------------------------------------------------------+
//| Generate risk report                                           |
//+------------------------------------------------------------------+
void CRiskManager::GenerateRiskReport()
{
   Print("=== QUANTUM AI RISK MANAGEMENT REPORT ===");
   Print("Account Balance: $", AccountInfoDouble(ACCOUNT_BALANCE));
   Print("Equity: $", AccountInfoDouble(ACCOUNT_EQUITY));
   Print("Free Margin: $", GetFreeMargin());
   Print("Margin Level: ", GetMarginLevel(), "%");
   Print("Current Drawdown: ", GetCurrentDrawdown(), "%");
   Print("Max Drawdown: ", GetMaxDrawdown(), "%");
   Print("Daily P/L: $", GetDailyProfit());
   Print("Weekly P/L: $", GetWeeklyProfit());
   Print("Consecutive Losses: ", GetConsecutiveLosses());
   Print("Win Rate: ", m_win_rate, "%");
   Print("Total Wins: ", m_total_wins);
   Print("Total Losses: ", m_total_losses);
   Print("Largest Win: $", m_largest_win);
   Print("Largest Loss: $", m_largest_loss);
   Print("Average Win: $", m_average_win);
   Print("Average Loss: $", m_average_loss);
   Print("Correlation Exposure: ", GetCorrelationExposure());
   Print("=== END REPORT ===");
}

//+------------------------------------------------------------------+
//| Get risk status string                                         |
//+------------------------------------------------------------------+
string CRiskManager::GetRiskStatus()
{
   string status = "🟢 NORMAL";
   
   if(IsDrawdownLimitReached())
      status = "🔴 CRITICAL - Max Drawdown";
   else if(IsMaxConsecutiveLossesReached())
      status = "🟡 WARNING - Max Consecutive Losses";
   else if(IsDailyLimitReached())
      status = "🟡 WARNING - Daily Limit";
   else if(GetMarginLevel() < 200)
      status = "🟡 WARNING - Low Margin";
   
   return status;
}

//+------------------------------------------------------------------+
//| Calculate pips between two prices                              |
//+------------------------------------------------------------------+
double CRiskManager::CalculatePips(string symbol, double price1, double price2)
{
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   double diff = MathAbs(price1 - price2);
   return diff / (point * 10); // Convert points to pips
}

//+------------------------------------------------------------------+
//| Get point value for symbol                                     |
//+------------------------------------------------------------------+
double CRiskManager::GetPointValue(string symbol)
{
   double tick_size = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_SIZE);
   double tick_value = SymbolInfoDouble(symbol, SYMBOL_TRADE_TICK_VALUE);
   double point = SymbolInfoDouble(symbol, SYMBOL_POINT);
   
   if(tick_size > 0 && point > 0)
      return tick_value * point / tick_size;
   
   return 0;
}

//+------------------------------------------------------------------+
//| Get current spread                                             |
//+------------------------------------------------------------------+
double CRiskManager::GetSpread(string symbol)
{
   return SymbolInfoInteger(symbol, SYMBOL_SPREAD) * SymbolInfoDouble(symbol, SYMBOL_POINT);
}

//+------------------------------------------------------------------+
//| Check if spread is acceptable                                  |
//+------------------------------------------------------------------+
bool CRiskManager::IsSpreadAcceptable(string symbol, int max_spread=3)
{
   double spread = GetSpread(symbol) / SymbolInfoDouble(symbol, SYMBOL_POINT);
   return (spread <= max_spread);
}

//+------------------------------------------------------------------+
//| Get volatility ratio for symbol                                |
//+------------------------------------------------------------------+
double CRiskManager::GetVolatilityRatio(string symbol)
{
   double current_atr = iATR(symbol, PERIOD_H1, 14);
   double avg_atr = iATR(symbol, PERIOD_D1, 14); // Use daily ATR as baseline
  
   if(avg_atr == 0) return 1.0;
  
   double ratio = current_atr / avg_atr;
  
   // Cap the ratio between 0.5 and 2.0
   return MathMin(MathMax(ratio, 0.5), 2.0);
}

//+------------------------------------------------------------------+
//| Check if account is over leveraged                             |
//+------------------------------------------------------------------+
bool CRiskManager::IsOverLeveraged()
{
   double leverage = AccountInfoInteger(ACCOUNT_LEVERAGE);
   double margin_level = GetMarginLevel();
   
   // More conservative leverage check for high leverage accounts
   if(leverage > 100 && margin_level < 500)
      return true;
   
   if(leverage > 50 && margin_level < 300)
      return true;
   
   if(leverage > 10 && margin_level < 200)
      return true;
   
   return false;
}

//+------------------------------------------------------------------+
//| Close all positions (emergency procedure)                      |
//+------------------------------------------------------------------+
void CRiskManager::CloseAllPositions()
{
   for(int i = PositionsTotal() - 1; i >= 0; i--)
   {
      ulong ticket = PositionGetTicket(i);
      if(PositionSelectByTicket(ticket))
      {
         string symbol = PositionGetString(POSITION_SYMBOL);
         double volume = PositionGetDouble(POSITION_VOLUME);
         ENUM_POSITION_TYPE type = (ENUM_POSITION_TYPE)PositionGetInteger(POSITION_TYPE);
         
         if(type == POSITION_TYPE_BUY)
            m_trade.Sell(volume, symbol);
         else
            m_trade.Buy(volume, symbol);
      }
   }
   Print("🚨 EMERGENCY: All positions closed!");
}

//+------------------------------------------------------------------+
//| Get pair correlation (simplified version)                      |
//+------------------------------------------------------------------+
double CRiskManager::GetPairCorrelation(string pair1, string pair2)
{
   // This is a simplified correlation calculation
   // In practice, you'd use historical price data
  
   // Pre-defined correlation matrix for major pairs
   string pairs[6] = {"EURUSD", "GBPUSD", "USDCHF", "USDJPY", "USDCAD", "AUDUSD"};
   double correlation_matrix[6][6] = {
      {1.0,  0.8,  -0.9,  0.6,  -0.7,  0.7},  // EURUSD
      {0.8,  1.0,  -0.8,  0.5,  -0.6,  0.8},  // GBPUSD
      {-0.9, -0.8,  1.0, -0.7,   0.8, -0.6},  // USDCHF
      {0.6,  0.5,  -0.7,  1.0,  -0.5,  0.4},  // USDJPY
      {-0.7, -0.6,  0.8, -0.5,   1.0, -0.7},  // USDCAD
      {0.7,  0.8,  -0.6,  0.4,  -0.7,  1.0}   // AUDUSD
   };
  
   int idx1 = -1, idx2 = -1;
   for(int i = 0; i < 6; i++)
   {
      if(pairs[i] == pair1) idx1 = i;
      if(pairs[i] == pair2) idx2 = i;
   }
  
   if(idx1 >= 0 && idx2 >= 0)
      return correlation_matrix[idx1][idx2];
  
   return 0; // Unknown correlation
}

#endif // RISKMANAGER_MQH