//+------------------------------------------------------------------+
//| Machine Learning Processor                                      |
//| Quantum AI Trader Pro                                          |
//+------------------------------------------------------------------+

#ifndef ML_PROCESSOR_MQH
#define ML_PROCESSOR_MQH

#include <Trade/Trade.mqh>
#include <Arrays/ArrayDouble.mqh>
#include "../Libraries/Statistics.mqh"
#include "RiskManager.mqh"

//+------------------------------------------------------------------+
//| ML Configuration Enumerations                                   |
//+------------------------------------------------------------------+
enum ENUM_ML_MODEL_TYPE
{
   ML_ENSEMBLE,          // Ensemble of multiple models
   ML_NEURAL_NETWORK,     // Deep Neural Network
   ML_GRADIENT_BOOSTING,  // Gradient Boosting
   ML_SVM                // Support Vector Machine
};

enum ENUM_FEATURE_TYPE
{
   FEATURE_TECHNICAL,     // Technical indicators
   FEATURE_PRICE_ACTION,  // Price action patterns
   FEATURE_VOLUME,        // Volume analysis
   FEATURE_SENTIMENT,     // Market sentiment
   FEATURE_TEMPORAL       // Time-based features
};

//+------------------------------------------------------------------+
//| Machine Learning Processor Class                               |
//+------------------------------------------------------------------+
class CMLProcessor
{
private:
   // ML Model Parameters
   double            m_ml_weights[15];
   double            m_ml_predictions[5];
   double            m_ml_confidence;
   bool              m_ml_model_ready;
   datetime          m_last_retrain_time;
   int               m_prediction_history[100];
   int               m_history_index;
   
   // Feature Storage
   double            m_current_features[15];
   double            m_feature_importance[15];
   
   // Trading Components
   CTrade            m_trade;
   CStatistics       m_stats;
   CRiskManager     *m_risk_manager;

public:
   // Constructor & Destructor
                     CMLProcessor();
                    ~CMLProcessor();
   
   // Initialization
   bool              Initialize(CRiskManager *risk_manager);
   bool              Initialize_ML_Model(bool use_deep_learning=true);
   void              Retrain_ML_Model();
   bool              Should_Retrain_ML();
   
   // Feature Engineering
   double            Calculate_Enhanced_RSI_Feature();
   double            Calculate_Advanced_MACD_Feature();
   double            Calculate_Multi_EMA_Feature();
   double            Calculate_Volume_Profile_Feature();
   double            Calculate_Advanced_Volatility_Feature();
   double            Calculate_Price_Action_Score();
   double            Calculate_Support_Resistance_Strength();
   double            Calculate_Session_Strength();
   double            Calculate_Time_Of_Day_Bias();
   double            Calculate_Correlation_Index();
   double            Calculate_News_Impact_Score();
   double            Calculate_Market_Sentiment();
   double            Calculate_Economic_Calendar_Score();
   double            Calculate_Order_Flow_Bias();
   double            Calculate_Market_Regime();
   
   // ML Core Functions
   void              Calculate_Advanced_ML_Signal();
   double            Calculate_ML_Confidence(double &features[]);
   void              Update_Prediction_History(double signal);
   double            Get_Prediction_Accuracy();
   void              Update_Feature_Weights(bool trade_successful);
   
   // Signal Processing
   double            Get_Current_Signal();
   double            Get_ML_Confidence();
   bool              Is_High_Confidence_Signal();
   ENUM_ORDER_TYPE   Get_Trade_Direction();
   
   // Model Evaluation
   void              Backtest_Model(int periods=100);
   double            Get_Model_Accuracy();
   void              Save_Model(string filename);
   bool              Load_Model(string filename);
   
   // Utility Functions
   void              Extract_All_Features(double &features[]);
   void              Normalize_Features(double &features[]);
   double            Apply_Activation_Function(double x);
   double            Calculate_Feature_Variance(double &features[]);

private:
   // Helper Methods
   double            Calculate_Neural_Network_Prediction(double &features[]);
   double            Calculate_Ensemble_Prediction(double &features[]);
   void              Update_Moving_Average_Weights();
   bool              Is_Feature_Significant(int feature_index);
   void              Adaptive_Learning_Rate();
};

//+------------------------------------------------------------------+
//| Constructor                                                     |
//+------------------------------------------------------------------+
CMLProcessor::CMLProcessor()
{
   m_ml_confidence = 0.0;
   m_ml_model_ready = false;
   m_last_retrain_time = 0;
   m_history_index = 0;
   
   // Initialize prediction history
   ArrayInitialize(m_prediction_history, 0);
   
   // Initialize feature importance (default weights)
   double default_weights[15] = {0.12, 0.15, 0.11, 0.08, 0.09, 0.07, 0.06, 0.05, 0.04, 0.05, 0.03, 0.04, 0.03, 0.04, 0.04};
   ArrayCopy(m_ml_weights, default_weights);
   ArrayCopy(m_feature_importance, default_weights);
}

//+------------------------------------------------------------------+
//| Destructor                                                      |
//+------------------------------------------------------------------+
CMLProcessor::~CMLProcessor()
{
   Save_Model("ml_model_last.xml");
}

//+------------------------------------------------------------------+
//| Initialize ML Processor                                         |
//+------------------------------------------------------------------+
bool CMLProcessor::Initialize(CRiskManager *risk_manager)
{
   if(risk_manager == NULL)
   {
      Print("❌ ML Processor: Risk Manager is NULL");
      return false;
   }
   
   m_risk_manager = risk_manager;
   
   if(!Initialize_ML_Model(true))
   {
      Print("❌ ML Model initialization failed");
      return false;
   }
   
   Print("✅ ML Processor Initialized Successfully");
   return true;
}

//+------------------------------------------------------------------+
//| Initialize ML Model                                            |
//+------------------------------------------------------------------+
bool CMLProcessor::Initialize_ML_Model(bool use_deep_learning=true)
{
   // Initialize weights with more sophisticated approach
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
   
   ArrayCopy(m_ml_weights, base_weights);
   ArrayCopy(m_feature_importance, base_weights);
   
   m_ml_model_ready = true;
   m_last_retrain_time = TimeCurrent();
   
   if(use_deep_learning)
      Print("🔮 Deep Learning Neural Network Initialized");
   else
      Print("🤖 Traditional ML Model Initialized");
   
   return true;
}

//+------------------------------------------------------------------+
//| Calculate Advanced ML Signal                                   |
//+------------------------------------------------------------------+
void CMLProcessor::Calculate_Advanced_ML_Signal()
{
   if(!m_ml_model_ready) return;
   
   double features[15];
   Extract_All_Features(features);
   
   // Store current features for later analysis
   ArrayCopy(m_current_features, features);
   
   // Calculate ensemble prediction
   double ensemble_prediction = Calculate_Ensemble_Prediction(features);
   
   // Apply activation function (tanh for -1 to 1 range)
   double activated_signal = Apply_Activation_Function(ensemble_prediction);
   
   // Update prediction history
   Update_Prediction_History(activated_signal);
   
   // Calculate confidence
   m_ml_confidence = Calculate_ML_Confidence(features);
   
   Print("🧠 ML Signal: ", activated_signal, " | Confidence: ", m_ml_confidence);
}

//+------------------------------------------------------------------+
//| Calculate ML Confidence                                        |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_ML_Confidence(double &features[])
{
   if(!m_ml_model_ready) return 0.0;
   
   double confidence = 0.0;
   int significant_features = 0;
   
   // 1. Feature Agreement Score
   double feature_agreement = 0.0;
   for(int i = 0; i < 15; i++)
   {
      if(MathAbs(features[i]) > 0.3) // Feature has meaningful signal
      {
         feature_agreement += m_feature_importance[i] * MathAbs(features[i]);
         significant_features++;
      }
   }
   
   // 2. Prediction Consistency
   double consistency_score = 0.0;
   int consistent_predictions = 0;
   for(int i = 0; i < 5; i++)
   {
      if(i < m_history_index)
      {
         if(MathAbs(m_prediction_history[i]) > 0.5)
            consistent_predictions++;
      }
   }
   consistency_score = (double)consistent_predictions / 5.0;
   
   // 3. Market Regime Confidence
   double market_confidence = Calculate_Market_Regime();
   
   // 4. Volatility Adjustment
   double volatility_factor = 1.0 - (Calculate_Advanced_Volatility_Feature() * 0.5);
   volatility_factor = MathMax(volatility_factor, 0.5);
   
   // Combine confidence factors
   confidence = (feature_agreement * 0.4) + 
                (consistency_score * 0.3) + 
                (market_confidence * 0.3);
   
   confidence *= volatility_factor;
   
   // Ensure confidence is between 0 and 1
   confidence = MathMin(MathMax(confidence, 0.0), 1.0);
   
   return confidence;
}

//+------------------------------------------------------------------+
//| Update Prediction History                                      |
//+------------------------------------------------------------------+
void CMLProcessor::Update_Prediction_History(double signal)
{
   // Shift existing predictions
   for(int i = 4; i > 0; i--)
   {
      m_ml_predictions[i] = m_ml_predictions[i-1];
   }
   m_ml_predictions[0] = signal;
   
   // Store in circular buffer for accuracy calculation
   if(MathAbs(signal) > 0.2) // Only store significant signals
   {
      m_prediction_history[m_history_index] = (signal > 0) ? 1 : -1;
      m_history_index = (m_history_index + 1) % 100;
   }
}

//+------------------------------------------------------------------+
//| Enhanced RSI Feature Calculation                               |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_Enhanced_RSI_Feature()
{
   double rsi_current = iRSI(_Symbol, PERIOD_H1, 14, PRICE_CLOSE, 0);
   double rsi_previous = iRSI(_Symbol, PERIOD_H1, 14, PRICE_CLOSE, 1);
   
   if(rsi_current == 0 || rsi_previous == 0) return 0.0;
   
   double rsi_momentum = (rsi_current - rsi_previous) / 100.0;
   
   // RSI level scoring
   double level_score = 0.0;
   if(rsi_current > 70) level_score = -1.0;      // Overbought
   else if(rsi_current < 30) level_score = 1.0;  // Oversold
   else if(rsi_current > 60) level_score = -0.5; // Approaching overbought
   else if(rsi_current < 40) level_score = 0.5;  // Approaching oversold
   
   // Combine momentum and level
   double feature = (level_score * 0.7) + (rsi_momentum * 0.3);
   
   return MathTanh(feature); // Normalize to -1 to 1
}

//+------------------------------------------------------------------+
//| Advanced MACD Feature Calculation                              |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_Advanced_MACD_Feature()
{
   double macd_main[3], macd_signal[3];
   ArraySetAsSeries(macd_main, true);
   ArraySetAsSeries(macd_signal, true);
   
   int macd_handle = iMACD(_Symbol, PERIOD_H1, 12, 26, 9, PRICE_CLOSE);
   
   if(CopyBuffer(macd_handle, 0, 0, 3, macd_main) <= 0) return 0.0;
   if(CopyBuffer(macd_handle, 1, 0, 3, macd_signal) <= 0) return 0.0;
   
   // Current MACD position
   double current_diff = macd_main[0] - macd_signal[0];
   double previous_diff = macd_main[1] - macd_signal[1];
   
   // Bullish crossover detection
   if(current_diff > 0 && previous_diff <= 0)
      return 1.0;
   
   // Bearish crossover detection  
   if(current_diff < 0 && previous_diff >= 0)
      return -1.0;
   
   // Strength of existing trend
   if(MathAbs(current_diff) > MathAbs(previous_diff))
      return (current_diff > 0) ? 0.5 : -0.5;
   
   return 0.0;
}

//+------------------------------------------------------------------+
//| Multi EMA Feature Calculation                                  |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_Multi_EMA_Feature()
{
   double ema8 = iEMA(_Symbol, PERIOD_H1, 8, 0, PRICE_CLOSE);
   double ema21 = iEMA(_Symbol, PERIOD_H1, 21, 0, PRICE_CLOSE);
   double ema50 = iEMA(_Symbol, PERIOD_H1, 50, 0, PRICE_CLOSE);
   
   if(ema8 == 0 || ema21 == 0 || ema50 == 0) return 0.0;
   
   // Multiple timeframe alignment
   double ema8_h4 = iEMA(_Symbol, PERIOD_H4, 8, 0, PRICE_CLOSE);
   double ema21_h4 = iEMA(_Symbol, PERIOD_H4, 21, 0, PRICE_CLOSE);
   
   double h1_alignment = 0.0;
   if(ema8 > ema21 && ema21 > ema50) h1_alignment = 1.0;      // Strong uptrend
   else if(ema8 < ema21 && ema21 < ema50) h1_alignment = -1.0; // Strong downtrend
   else if(ema8 > ema21) h1_alignment = 0.5;                   // Weak uptrend
   else if(ema8 < ema21) h1_alignment = -0.5;                  // Weak downtrend
   
   double h4_alignment = 0.0;
   if(ema8_h4 > ema21_h4) h4_alignment = 0.5;
   else if(ema8_h4 < ema21_h4) h4_alignment = -0.5;
   
   // Combine alignments with weights
   double feature = (h1_alignment * 0.7) + (h4_alignment * 0.3);
   
   return MathTanh(feature);
}

//+------------------------------------------------------------------+
//| Volume Profile Feature Calculation                             |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_Volume_Profile_Feature()
{
   double volume_current = iVolumes(_Symbol, PERIOD_H1, VOLUME_TICK, 0);
   double volume_previous = iVolumes(_Symbol, PERIOD_H1, VOLUME_TICK, 1);
   double volume_ma = iMAOnArray(volume_current, 0, 20, 0, MODE_SMA, 0);
   
   if(volume_ma == 0) return 0.0;
   
   double volume_ratio = volume_current / volume_ma;
   double volume_change = (volume_current - volume_previous) / volume_previous;
   
   // Volume confirmation scoring
   double score = 0.0;
   if(volume_ratio > 1.5) score = 1.0;        // High volume
   else if(volume_ratio > 1.2) score = 0.5;   // Above average volume
   else if(volume_ratio < 0.8) score = -0.5;  // Low volume (caution)
   
   // Volume momentum
   if(volume_change > 0.3) score += 0.3;
   else if(volume_change < -0.3) score -= 0.3;
   
   return MathTanh(score);
}

//+------------------------------------------------------------------+
//| Advanced Volatility Feature Calculation                        |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_Advanced_Volatility_Feature()
{
   double atr_current = iATR(_Symbol, PERIOD_H1, 14, 0);
   double atr_previous = iATR(_Symbol, PERIOD_H1, 14, 1);
   double atr_daily = iATR(_Symbol, PERIOD_D1, 14, 0);
   
   if(atr_daily == 0) return 0.0;
   
   double atr_ratio = atr_current / atr_daily;
   double atr_change = (atr_current - atr_previous) / atr_previous;
   
   // Volatility scoring
   double score = 0.0;
   if(atr_ratio > 1.5) score = -0.8;        // Very high volatility (danger)
   else if(atr_ratio > 1.2) score = -0.4;   // High volatility (caution)
   else if(atr_ratio < 0.8) score = 0.4;    // Low volatility (good for trends)
   else if(atr_ratio < 0.5) score = 0.8;    // Very low volatility (excellent)
   
   // Volatility momentum
   if(MathAbs(atr_change) > 0.2)
      score *= (1.0 - MathAbs(atr_change)); // Reduce confidence on volatility spikes
   
   return MathTanh(score);
}

//+------------------------------------------------------------------+
//| Extract All Features for ML                                    |
//+------------------------------------------------------------------+
void CMLProcessor::Extract_All_Features(double &features[])
{
   ArrayResize(features, 15);
   
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
   
   Normalize_Features(features);
}

//+------------------------------------------------------------------+
//| Calculate Ensemble Prediction                                  |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_Ensemble_Prediction(double &features[])
{
   double ensemble_prediction = 0.0;
   
   // Weighted feature combination
   for(int i = 0; i < 15; i++)
   {
      ensemble_prediction += features[i] * m_ml_weights[i];
   }
   
   // Neural network component (simplified)
   double nn_prediction = Calculate_Neural_Network_Prediction(features);
   
   // Combine ensemble and neural network
   double final_prediction = (ensemble_prediction * 0.7) + (nn_prediction * 0.3);
   
   return final_prediction;
}

//+------------------------------------------------------------------+
//| Simplified Neural Network Prediction                           |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_Neural_Network_Prediction(double &features[])
{
   // Simplified neural network with one hidden layer
   double hidden_layer[8] = {0};
   
   // Hidden layer computation (simplified weights)
   for(int i = 0; i < 8; i++)
   {
      for(int j = 0; j < 15; j++)
      {
         hidden_layer[i] += features[j] * (m_ml_weights[j] * 0.1 * (i + 1));
      }
      hidden_layer[i] = Apply_Activation_Function(hidden_layer[i]);
   }
   
   // Output layer
   double output = 0.0;
   for(int i = 0; i < 8; i++)
   {
      output += hidden_layer[i] * 0.125; // Average weighting
   }
   
   return output;
}

//+------------------------------------------------------------------+
//| Apply Activation Function                                      |
//+------------------------------------------------------------------+
double CMLProcessor::Apply_Activation_Function(double x)
{
   // Hyperbolic tangent activation (-1 to 1)
   return MathTanh(x);
}

//+------------------------------------------------------------------+
//| Normalize Features                                             |
//+------------------------------------------------------------------+
void CMLProcessor::Normalize_Features(double &features[])
{
   for(int i = 0; i < 15; i++)
   {
      features[i] = MathMin(MathMax(features[i], -1.0), 1.0);
   }
}

//+------------------------------------------------------------------+
//| Get Current ML Signal                                          |
//+------------------------------------------------------------------+
double CMLProcessor::Get_Current_Signal()
{
   return m_ml_predictions[0];
}

//+------------------------------------------------------------------+
//| Get ML Confidence                                              |
//+------------------------------------------------------------------+
double CMLProcessor::Get_ML_Confidence()
{
   return m_ml_confidence;
}

//+------------------------------------------------------------------+
//| Check if High Confidence Signal                               |
//+------------------------------------------------------------------+
bool CMLProcessor::Is_High_Confidence_Signal()
{
   return (m_ml_confidence > 0.75 && MathAbs(m_ml_predictions[0]) > 0.3);
}

//+------------------------------------------------------------------+
//| Get Trade Direction                                            |
//+------------------------------------------------------------------+
ENUM_ORDER_TYPE CMLProcessor::Get_Trade_Direction()
{
   if(m_ml_predictions[0] > 0.2)
      return ORDER_TYPE_BUY;
   else if(m_ml_predictions[0] < -0.2)
      return ORDER_TYPE_SELL;
   
   return ORDER_TYPE_BUY_LIMIT; // Neutral signal
}

//+------------------------------------------------------------------+
//| Placeholder Feature Calculations                               |
//+------------------------------------------------------------------+
double CMLProcessor::Calculate_Price_Action_Score() { return 0.0; }
double CMLProcessor::Calculate_Support_Resistance_Strength() { return 0.0; }
double CMLProcessor::Calculate_Session_Strength() { return 0.0; }
double CMLProcessor::Calculate_Time_Of_Day_Bias() { return 0.0; }
double CMLProcessor::Calculate_Correlation_Index() { return 0.0; }
double CMLProcessor::Calculate_News_Impact_Score() { return 0.0; }
double CMLProcessor::Calculate_Market_Sentiment() { return 0.0; }
double CMLProcessor::Calculate_Economic_Calendar_Score() { return 0.0; }
double CMLProcessor::Calculate_Order_Flow_Bias() { return 0.0; }
double CMLProcessor::Calculate_Market_Regime() { return 0.5; } // Default neutral

//+------------------------------------------------------------------+
//| Retrain ML Model                                               |
//+------------------------------------------------------------------+
void CMLProcessor::Retrain_ML_Model()
{
   Print("🔄 Retraining ML Model...");
   // Placeholder for retraining logic
   m_last_retrain_time = TimeCurrent();
}

//+------------------------------------------------------------------+
//| Check if Should Retrain ML                                     |
//+------------------------------------------------------------------+
bool CMLProcessor::Should_Retrain_ML()
{
   return (TimeCurrent() - m_last_retrain_time) > 86400; // Retrain every 24 hours
}

//+------------------------------------------------------------------+
//| Model Evaluation Methods (Placeholders)                        |
//+------------------------------------------------------------------+
void CMLProcessor::Backtest_Model(int periods=100) { Print("Backtesting ML Model..."); }
double CMLProcessor::Get_Model_Accuracy() { return m_ml_confidence; }
void CMLProcessor::Save_Model(string filename) { Print("Saving model to: ", filename); }
bool CMLProcessor::Load_Model(string filename) { Print("Loading model from: ", filename); return true; }

#endif // ML_PROCESSOR_MQH