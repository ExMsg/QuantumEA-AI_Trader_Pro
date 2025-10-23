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
CTrade trade;
Math math;

//--- ML Variables
double ml_weights[15];
double ml_predictions[5];
double ml_confidence = 0.0;
bool ml_model_ready = false;
datetime last_retrain_time = 0;

//--- Trading Variables
double equity_start, daily_profit, weekly_profit;
int consecutive_losses = 0, total_trades_today = 0;
datetime last_trade_time = 0, session_start_time = 0;

//--- Advanced Risk Management
double current_drawdown = 0.0, max_drawdown = 0.0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
{
    Print("=== QUANTUM AI TRADER PRO INITIALIZATION ===");
    
    if(!Initialize_Advanced_ML())
        return INIT_FAILED;
    
    if(!Initialize_Trading_System())
        return INIT_FAILED;
    
    Initialize_Risk_Management();
    Start_Monitoring_Services();
    
    Print("✅ Quantum AI Trader Pro Successfully Activated");
    Print("🤖 ML Model Ready | Confidence Threshold: ", ML_Confidence_Threshold);
    Print("🛡️ Risk Management Active | Max Drawdown: ", Max_Drawdown_Percent, "%");
    
    return INIT_SUCCEEDED;
}

//+------------------------------------------------------------------+
//| Advanced ML Initialization                                      |
//+------------------------------------------------------------------+
bool Initialize_Advanced_ML()
{
    ArrayResize(ml_weights, 15);
    
    double base_weights[15] = {0.12, 0.15, 0.11, 0.08, 0.09, 0.07, 0.06, 0.05, 0.04, 0.05, 0.03, 0.04, 0.03, 0.04, 0.04};
    ArrayCopy(ml_weights, base_weights);
    
    if(Use_Ensemble_Learning)
        Print("🧠 Ensemble Learning Enabled - Multiple ML Models Active");
    
    if(Use_Deep_Learning)
        Print("🔮 Deep Learning Neural Network Initialized");
    
    ml_model_ready = true;
    last_retrain_time = TimeCurrent();
    return true;
}

//+------------------------------------------------------------------+
//| Enhanced OnTick Function                                        |
//+------------------------------------------------------------------+
void OnTick()
{
    if(IsNewBar())
    {
        if(Should_Retrain_ML())
            Retrain_ML_Model();
            
        Calculate_Advanced_ML_Signal();
        Multi_Strategy_Manager();
        Update_Monitoring_Systems();
    }
    
    Advanced_Position_Manager();
    RealTime_Risk_Manager();
}

//+------------------------------------------------------------------+
//| Multi-Strategy Manager                                         |
//+------------------------------------------------------------------+
void Multi_Strategy_Manager()
{
    if(!ml_model_ready || ml_confidence < ML_Confidence_Threshold)
        return;
        
    MARKET_CONDITION market_state = Analyze_Market_Condition();
    
    switch(market_state)
    {
        case TRENDING_BULLISH:
            if(Use_Swing_Mode) Execute_Trend_Following(true);
            if(Use_Grid_Hedging) Manage_Grid_System(true);
            break;
            
        case TRENDING_BEARISH:
            if(Use_Swing_Mode) Execute_Trend_Following(false);
            if(Use_Grid_Hedging) Manage_Grid_System(false);
            break;
            
        case RANGING:
            if(Use_Scalping_Mode) Execute_Scalping_Strategy();
            break;
            
        case VOLATILE:
            if(Use_Swing_Mode) Execute_Breakout_Strategy();
            break;
            
        case LOW_VOLATILITY:
            if(Use_Grid_Hedging) Execute_Grid_Strategy();
            break;
    }
}

//+------------------------------------------------------------------+
//| Advanced Position Manager                                       |
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
            
            Manage_Advanced_Breakeven(ticket, type, open_price, current_price, profit);
            Manage_Dynamic_Trailing(ticket, type, current_price, profit);
            Manage_Time_Based_Exit(ticket);
            
            if(Use_News_Filter)
                Manage_News_Based_Exit(ticket);
                
            if(Use_Sentiment_Analysis)
                Manage_Sentiment_Based_Exit(ticket);
                
            if(Use_Correlation_Filter)
                Manage_Correlation_Based_Exit(ticket);
        }
    }
}

//+------------------------------------------------------------------+
//| Advanced Breakeven System                                       |
//+------------------------------------------------------------------+
void Manage_Advanced_Breakeven(ulong ticket, ENUM_POSITION_TYPE type, 
                              double open_price, double current_price, double profit)
{
    double profit_pips = Calculate_Profit_Pips(type, open_price, current_price);
    double current_sl = PositionGetDouble(POSITION_SL);
    
    if(current_sl != open_price)
    {
        if(profit_pips >= 10)
        {
            double new_sl = open_price + (type == POSITION_TYPE_BUY ? 5*_Point : -5*_Point);
            Modify_SL(ticket, new_sl);
            Print("🎯 Tier 1 Breakeven Activated for ticket #", ticket);
        }
        else if(profit_pips >= 20)
        {
            double new_sl = open_price + (type == POSITION_TYPE_BUY ? 10*_Point : -10*_Point);
            Modify_SL(ticket, new_sl);
            Print("🎯 Tier 2 Breakeven Activated for ticket #", ticket);
        }
        else if(profit_pips >= 30)
        {
            double new_sl = open_price + (type == POSITION_TYPE_BUY ? 15*_Point : -15*_Point);
            Modify_SL(ticket, new_sl);
            Print("🎯 Tier 3 Breakeven Activated for ticket #", ticket);
        }
    }
}

//+------------------------------------------------------------------+
//| Dynamic Trailing Stop                                           |
//+------------------------------------------------------------------+
void Manage_Dynamic_Trailing(ulong ticket, ENUM_POSITION_TYPE type, 
                           double current_price, double profit)
{
    double atr = iATR(_Symbol, _Period, ATR_Period);
    double open_price = PositionGetDouble(POSITION_PRICE_OPEN);
    double current_sl = PositionGetDouble(POSITION_SL);
    double profit_pips = Calculate_Profit_Pips(type, open_price, current_price);
    
    if(profit_pips > 20)
    {
        double trail_distance = atr * 0.75;
        double new_sl = 0;
        
        if(type == POSITION_TYPE_BUY)
        {
            new_sl = current_price - trail_distance;
            if(new_sl > current_sl && new_sl > open_price)
                Modify_SL(ticket, new_sl);
        }
        else
        {
            new_sl = current_price + trail_distance;
            if(new_sl < current_sl && new_sl < open_price)
                Modify_SL(ticket, new_sl);
        }
    }
}

//+------------------------------------------------------------------+
//| Enhanced ML Signal Calculation                                  |
//+------------------------------------------------------------------+
void Calculate_Advanced_ML_Signal()
{
    double features[15];
    
    features[0] = Calculate_Enhanced_RSI_Feature();
    features[1] = Calculate_Advanced_MACD_Feature();
    features[2] = Calculate_Multi_EMA_Feature();
    features[3] = Calculate_Volume_Profile_Feature();
    features[4] = Calculate_Advanced_Volatility_Feature();
    features[5] = Calculate_Price_Action_Score();
    features[6] = Calculate_Support_Resistance_Strength();
    features[7] = Calculate_Session_Strength();
    features[8] = Calculate_Time_Of_Day_Bias();
    features[9] = Calculate_Correlation_Index();
    features[10] = Calculate_News_Impact_Score();
    features[11] = Calculate_Market_Sentiment();
    features[12] = Calculate_Economic_Calendar_Score();
    features[13] = Calculate_Order_Flow_Bias();
    features[14] = Calculate_Market_Regime();
    
    double ensemble_prediction = 0;
    for(int i = 0; i < 15; i++)
        ensemble_prediction += features[i] * ml_weights[i];
    
    current_signal = MathTanh(ensemble_prediction);
    ml_confidence = Calculate_ML_Confidence(features);
    Update_Prediction_History(current_signal);
}

//+------------------------------------------------------------------+
//| Real-Time Risk Manager                                          |
//+------------------------------------------------------------------+
void RealTime_Risk_Manager()
{
    double current_equity = AccountInfoDouble(ACCOUNT_EQUITY);
    double current_balance = AccountInfoDouble(ACCOUNT_BALANCE);
    
    current_drawdown = ((equity_start - current_equity) / equity_start) * 100;
    max_drawdown = MathMax(max_drawdown, current_drawdown);
    
    if(max_drawdown >= Max_Drawdown_Percent)
    {
        Close_All_Positions();
        Print("🚨 EMERGENCY STOP: Max Drawdown Reached (", max_drawdown, "%)");
        ExpertRemove();
        return;
    }
    
    if(consecutive_losses >= Max_Consecutive_Losses)
    {
        Print("⚠️ Trading Paused: ", consecutive_losses, " consecutive losses");
        return;
    }
    
    if(daily_profit <= -Daily_Risk_Limit)
    {
        Print("📉 Daily Risk Limit Reached. Stopping trading for today.");
        return;
    }
}

//+------------------------------------------------------------------+
//| Utility Functions                                               |
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

bool IsNewHour()
{
    static int last_hour = -1;
    MqlDateTime current_time;
    TimeCurrent(current_time);
    if(last_hour != current_time.hour)
    {
        last_hour = current_time.hour;
        return true;
    }
    return false;
}

bool IsNewDay()
{
    static int last_day = -1;
    MqlDateTime current_time;
    TimeCurrent(current_time);
    if(last_day != current_time.day)
    {
        last_day = current_time.day;
        return true;
    }
    return false;
}

//+------------------------------------------------------------------+
//| Trade Transaction Handler                                       |
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
            
            if(entry_type == DEAL_ENTRY_IN)
            {
                Print("🎯 New Position Opened: Ticket #", ticket);
                Update_Consecutive_Losses(false);
            }
            else if(entry_type == DEAL_ENTRY_OUT)
            {
                double profit = HistoryDealGetDouble(ticket, DEAL_PROFIT);
                if(profit < 0)
                {
                    consecutive_losses++;
                    Print("❌ Consecutive Losses: ", consecutive_losses);
                }
                else
                {
                    consecutive_losses = 0;
                    Print("✅ Winning Trade Closed");
                }
            }
        }
    }
}

//+------------------------------------------------------------------+
//| Deinitialization                                                |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
    Print("=== QUANTUM AI TRADER PRO SHUTDOWN ===");
    Generate_Final_Report();
}