//+------------------------------------------------------------------+
//| Advanced Statistics Library for Machine Learning                |
//| Quantum AI Trader Pro                                          |
//+------------------------------------------------------------------+

#ifndef STATISTICS_MQH
#define STATISTICS_MQH

#include <Arrays\ArrayDouble.mqh>
#include <Math\Stat\Math.mqh>

//+------------------------------------------------------------------+
//| Statistical Functions Class                                     |
//+------------------------------------------------------------------+
class CStatistics
{
public:
    // Basic Statistical Measures
    static double Mean(const double &array[]);
    static double Median(double &array[]);
    static double Mode(double &array[]);
    static double StandardDeviation(const double &array[]);
    static double Variance(const double &array[]);
    static double Range(const double &array[]);
    
    // Advanced Statistical Measures
    static double Skewness(const double &array[]);
    static double Kurtosis(const double &array[]);
    static double Covariance(const double &array1[], const double &array2[]);
    static double Correlation(const double &array1[], const double &array2[]);
    static double RSquared(const double &y_true[], const double &y_pred[]);
    
    // Normalization and Scaling
    static void MinMaxScaler(double &array[], double min_val=0, double max_val=1);
    static void StandardScaler(double &array[]);
    static void RobustScaler(double &array[]);
    static void Normalize(double &array[]);
    
    // Probability Distributions
    static double NormalPDF(double x, double mean, double std_dev);
    static double NormalCDF(double x, double mean, double std_dev);
    static double ExponentialPDF(double x, double lambda);
    static double ExponentialCDF(double x, double lambda);
    
    // Statistical Tests
    static double ZTest(const double &array[], double hypothesized_mean);
    static double TTest(const double &array[], double hypothesized_mean);
    static bool ChiSquareTest(const double &observed[], const double &expected[], double &chi_square, double &p_value);
    
    // Time Series Analysis
    static double Autocorrelation(const double &array[], int lag);
    static double PartialAutocorrelation(const double &array[], int lag);
    static double ADFTest(const double &array[]); // Augmented Dickey-Fuller Test
    static double HurstExponent(const double &array[]);
    
    // Machine Learning Utilities
    static void OneHotEncoding(int categories[], int num_categories, double &encoded_array[][]);
    static void LabelEncoding(string categories[], int &encoded_array[]);
    static void FeatureScaling(double &features[][], int feature_index);
    static void PCA(double &data[][], int n_components, double &components[][]);
    
    // Risk Management Statistics
    static double ValueAtRisk(const double &returns[], double confidence_level);
    static double ExpectedShortfall(const double &returns[], double confidence_level);
    static double SharpeRatio(const double &returns[], double risk_free_rate=0.0);
    static double SortinoRatio(const double &returns[], double risk_free_rate=0.0);
    static double MaximumDrawdown(const double &equity_curve[]);
    static double CalmarRatio(const double &returns[], const double &equity_curve[]);
    
    // Market Statistics
    static double Volatility(const double &prices[], int period=20);
    static double HistoricalVolatility(const double &prices[], int period=252);
    static double Beta(const double &asset_returns[], const double &market_returns[]);
    static double Alpha(const double &asset_returns[], const double &market_returns[], double risk_free_rate=0.0);
    
    // Information Theory
    static double Entropy(const double &probabilities[]);
    static double InformationGain(const double &parent_entropy, const double &children_entropy[], const int children_sizes[]);
    static double KLDivergence(const double &p[], const double &q[]);
    
    // Signal Processing
    static void MovingAverage(const double &input[], int period, double &output[]);
    static void ExponentialMovingAverage(const double &input[], double alpha, double &output[]);
    static void BollingerBands(const double &input[], int period, double deviation, double &upper[], double &middle[], double &lower[]);
    
    // Matrix Operations for ML
    static void MatrixMultiply(const double &A[][], const double &B[][], double &C[][]);
    static void MatrixTranspose(const double &A[][], double &AT[][]);
    static bool MatrixInverse(double &A[][], double &invA[][]);
    static double MatrixDeterminant(double &A[][]);
    
    // Utility Functions
    static void ArrayToMatrix(const double &array[], int rows, int cols, double &matrix[][]);
    static void MatrixToArray(const double &matrix[][], double &array[]);
    static void ShuffleArray(double &array[]);
    static void TrainTestSplit(const double &data[], double train_ratio, double &train[], double &test[]);
};

//+------------------------------------------------------------------+
//| Calculate Mean of array                                         |
//+------------------------------------------------------------------+
double CStatistics::Mean(const double &array[])
{
    int size = ArraySize(array);
    if(size == 0) return 0;
    
    double sum = 0;
    for(int i = 0; i < size; i++)
        sum += array[i];
    
    return sum / size;
}

//+------------------------------------------------------------------+
//| Calculate Median of array                                       |
//+------------------------------------------------------------------+
double CStatistics::Median(double &array[])
{
    int size = ArraySize(array);
    if(size == 0) return 0;
    
    // Create a copy to avoid modifying original array
    double temp[];
    ArrayCopy(temp, array);
    ArraySort(temp);
    
    if(size % 2 == 0)
        return (temp[size/2 - 1] + temp[size/2]) / 2.0;
    else
        return temp[size/2];
}

//+------------------------------------------------------------------+
//| Calculate Standard Deviation                                    |
//+------------------------------------------------------------------+
double CStatistics::StandardDeviation(const double &array[])
{
    int size = ArraySize(array);
    if(size <= 1) return 0;
    
    double mean = Mean(array);
    double sum_squared_diff = 0;
    
    for(int i = 0; i < size; i++)
        sum_squared_diff += MathPow(array[i] - mean, 2);
    
    return MathSqrt(sum_squared_diff / (size - 1));
}

//+------------------------------------------------------------------+
//| Calculate Variance                                              |
//+------------------------------------------------------------------+
double CStatistics::Variance(const double &array[])
{
    double std_dev = StandardDeviation(array);
    return MathPow(std_dev, 2);
}

//+------------------------------------------------------------------+
//| Calculate Skewness                                              |
//+------------------------------------------------------------------+
double CStatistics::Skewness(const double &array[])
{
    int size = ArraySize(array);
    if(size < 3) return 0;
    
    double mean = Mean(array);
    double std_dev = StandardDeviation(array);
    if(std_dev == 0) return 0;
    
    double sum_cubed_diff = 0;
    for(int i = 0; i < size; i++)
        sum_cubed_diff += MathPow(array[i] - mean, 3);
    
    return (sum_cubed_diff / size) / MathPow(std_dev, 3);
}

//+------------------------------------------------------------------+
//| Calculate Kurtosis                                              |
//+------------------------------------------------------------------+
double CStatistics::Kurtosis(const double &array[])
{
    int size = ArraySize(array);
    if(size < 4) return 0;
    
    double mean = Mean(array);
    double std_dev = StandardDeviation(array);
    if(std_dev == 0) return 0;
    
    double sum_fourth_diff = 0;
    for(int i = 0; i < size; i++)
        sum_fourth_diff += MathPow(array[i] - mean, 4);
    
    return (sum_fourth_diff / size) / MathPow(std_dev, 4) - 3;
}

//+------------------------------------------------------------------+
//| Calculate Covariance between two arrays                         |
//+------------------------------------------------------------------+
double CStatistics::Covariance(const double &array1[], const double &array2[])
{
    int size1 = ArraySize(array1);
    int size2 = ArraySize(array2);
    
    if(size1 != size2 || size1 == 0) return 0;
    
    double mean1 = Mean(array1);
    double mean2 = Mean(array2);
    double sum_product = 0;
    
    for(int i = 0; i < size1; i++)
        sum_product += (array1[i] - mean1) * (array2[i] - mean2);
    
    return sum_product / (size1 - 1);
}

//+------------------------------------------------------------------+
//| Calculate Correlation Coefficient                               |
//+------------------------------------------------------------------+
double CStatistics::Correlation(const double &array1[], const double &array2[])
{
    int size1 = ArraySize(array1);
    int size2 = ArraySize(array2);
    
    if(size1 != size2 || size1 == 0) return 0;
    
    double cov = Covariance(array1, array2);
    double std_dev1 = StandardDeviation(array1);
    double std_dev2 = StandardDeviation(array2);
    
    if(std_dev1 == 0 || std_dev2 == 0) return 0;
    
    return cov / (std_dev1 * std_dev2);
}

//+------------------------------------------------------------------+
//| Min-Max Scaling normalization                                   |
//+------------------------------------------------------------------+
void CStatistics::MinMaxScaler(double &array[], double min_val=0, double max_val=1)
{
    int size = ArraySize(array);
    if(size == 0) return;
    
    double min_array = array[0];
    double max_array = array[0];
    
    // Find min and max
    for(int i = 1; i < size; i++)
    {
        if(array[i] < min_array) min_array = array[i];
        if(array[i] > max_array) max_array = array[i];
    }
    
    // Avoid division by zero
    if(max_array == min_array)
    {
        for(int i = 0; i < size; i++)
            array[i] = min_val;
        return;
    }
    
    // Scale to [min_val, max_val]
    for(int i = 0; i < size; i++)
        array[i] = min_val + (array[i] - min_array) * (max_val - min_val) / (max_array - min_array);
}

//+------------------------------------------------------------------+
//| Standard Scaling (Z-score normalization)                        |
//+------------------------------------------------------------------+
void CStatistics::StandardScaler(double &array[])
{
    int size = ArraySize(array);
    if(size == 0) return;
    
    double mean = Mean(array);
    double std_dev = StandardDeviation(array);
    
    if(std_dev == 0)
    {
        for(int i = 0; i < size; i++)
            array[i] = 0;
        return;
    }
    
    for(int i = 0; i < size; i++)
        array[i] = (array[i] - mean) / std_dev;
}

//+------------------------------------------------------------------+
//| Normal Probability Density Function                             |
//+------------------------------------------------------------------+
double CStatistics::NormalPDF(double x, double mean, double std_dev)
{
    if(std_dev <= 0) return 0;
    
    double exponent = -0.5 * MathPow((x - mean) / std_dev, 2);
    return (1.0 / (std_dev * MathSqrt(2 * M_PI))) * MathExp(exponent);
}

//+------------------------------------------------------------------+
//| Normal Cumulative Distribution Function                         |
//+------------------------------------------------------------------+
double CStatistics::NormalCDF(double x, double mean, double std_dev)
{
    if(std_dev <= 0) return 0;
    
    return 0.5 * (1 + MathErf((x - mean) / (std_dev * MathSqrt(2))));
}

//+------------------------------------------------------------------+
//| Calculate Value at Risk (VaR)                                   |
//+------------------------------------------------------------------+
double CStatistics::ValueAtRisk(const double &returns[], double confidence_level)
{
    int size = ArraySize(returns);
    if(size == 0) return 0;
    
    // Create sorted copy of returns
    double sorted_returns[];
    ArrayCopy(sorted_returns, returns);
    ArraySort(sorted_returns);
    
    // Calculate index for VaR
    int var_index = (int)MathFloor((1 - confidence_level) * size);
    var_index = MathMax(0, MathMin(var_index, size - 1));
    
    return sorted_returns[var_index];
}

//+------------------------------------------------------------------+
//| Calculate Expected Shortfall (CVaR)                             |
//+------------------------------------------------------------------+
double CStatistics::ExpectedShortfall(const double &returns[], double confidence_level)
{
    int size = ArraySize(returns);
    if(size == 0) return 0;
    
    double var = ValueAtRisk(returns, confidence_level);
    
    // Calculate average of returns worse than VaR
    double sum = 0;
    int count = 0;
    
    for(int i = 0; i < size; i++)
    {
        if(returns[i] <= var)
        {
            sum += returns[i];
            count++;
        }
    }
    
    return count > 0 ? sum / count : 0;
}

//+------------------------------------------------------------------+
//| Calculate Sharpe Ratio                                          |
//+------------------------------------------------------------------+
double CStatistics::SharpeRatio(const double &returns[], double risk_free_rate)
{
    int size = ArraySize(returns);
    if(size == 0) return 0;
    
    double mean_return = Mean(returns);
    double std_dev = StandardDeviation(returns);
    
    if(std_dev == 0) return 0;
    
    return (mean_return - risk_free_rate) / std_dev * MathSqrt(252); // Annualized
}

//+------------------------------------------------------------------+
//| Calculate Maximum Drawdown                                      |
//+------------------------------------------------------------------+
double CStatistics::MaximumDrawdown(const double &equity_curve[])
{
    int size = ArraySize(equity_curve);
    if(size == 0) return 0;
    
    double peak = equity_curve[0];
    double max_drawdown = 0;
    
    for(int i = 1; i < size; i++)
    {
        if(equity_curve[i] > peak)
            peak = equity_curve[i];
        else
        {
            double drawdown = (peak - equity_curve[i]) / peak;
            if(drawdown > max_drawdown)
                max_drawdown = drawdown;
        }
    }
    
    return max_drawdown;
}

//+------------------------------------------------------------------+
//| Calculate Volatility (Standard Deviation of returns)            |
//+------------------------------------------------------------------+
double CStatistics::Volatility(const double &prices[], int period)
{
    int size = ArraySize(prices);
    if(size <= period) return 0;
    
    // Calculate returns
    double returns[];
    ArrayResize(returns, size - 1);
    
    for(int i = 1; i < size; i++)
        returns[i-1] = (prices[i] - prices[i-1]) / prices[i-1];
    
    // Calculate standard deviation of returns
    double std_dev = StandardDeviation(returns);
    
    // Annualize if using daily data (assuming 252 trading days)
    return std_dev * MathSqrt(252);
}

//+------------------------------------------------------------------+
//| Moving Average Calculation                                      |
//+------------------------------------------------------------------+
void CStatistics::MovingAverage(const double &input[], int period, double &output[])
{
    int size = ArraySize(input);
    if(size < period || period <= 0)
    {
        ArrayResize(output, 0);
        return;
    }
    
    ArrayResize(output, size - period + 1);
    
    for(int i = 0; i <= size - period; i++)
    {
        double sum = 0;
        for(int j = 0; j < period; j++)
            sum += input[i + j];
        
        output[i] = sum / period;
    }
}

//+------------------------------------------------------------------+
//| Exponential Moving Average                                      |
//+------------------------------------------------------------------+
void CStatistics::ExponentialMovingAverage(const double &input[], double alpha, double &output[])
{
    int size = ArraySize(input);
    if(size == 0) return;
    
    ArrayResize(output, size);
    output[0] = input[0];
    
    for(int i = 1; i < size; i++)
        output[i] = alpha * input[i] + (1 - alpha) * output[i-1];
}

//+------------------------------------------------------------------+
//| Bollinger Bands Calculation                                     |
//+------------------------------------------------------------------+
void CStatistics::BollingerBands(const double &input[], int period, double deviation, 
                                double &upper[], double &middle[], double &lower[])
{
    int size = ArraySize(input);
    if(size < period || period <= 0)
    {
        ArrayResize(upper, 0);
        ArrayResize(middle, 0);
        ArrayResize(lower, 0);
        return;
    }
    
    int output_size = size - period + 1;
    ArrayResize(upper, output_size);
    ArrayResize(middle, output_size);
    ArrayResize(lower, output_size);
    
    for(int i = 0; i < output_size; i++)
    {
        // Calculate mean and standard deviation for the period
        double sum = 0;
        for(int j = 0; j < period; j++)
            sum += input[i + j];
        
        double mean = sum / period;
        
        double sum_sq = 0;
        for(int j = 0; j < period; j++)
            sum_sq += MathPow(input[i + j] - mean, 2);
        
        double std_dev = MathSqrt(sum_sq / period);
        
        middle[i] = mean;
        upper[i] = mean + deviation * std_dev;
        lower[i] = mean - deviation * std_dev;
    }
}

//+------------------------------------------------------------------+
//| Matrix Multiplication                                           |
//+------------------------------------------------------------------+
void CStatistics::MatrixMultiply(const double &A[][], const double &B[][], double &C[][])
{
    int rowsA = ArrayRange(A, 0);
    int colsA = ArrayRange(A, 1);
    int rowsB = ArrayRange(B, 0);
    int colsB = ArrayRange(B, 1);
    
    if(colsA != rowsB)
    {
        Print("Error: Matrix dimensions don't match for multiplication");
        return;
    }
    
    ArrayResize(C, rowsA);
    for(int i = 0; i < rowsA; i++)
        ArrayResize(C[i], colsB);
    
    for(int i = 0; i < rowsA; i++)
    {
        for(int j = 0; j < colsB; j++)
        {
            C[i][j] = 0;
            for(int k = 0; k < colsA; k++)
                C[i][j] += A[i][k] * B[k][j];
        }
    }
}

//+------------------------------------------------------------------+
//| Shuffle Array (Fisher-Yates algorithm)                          |
//+------------------------------------------------------------------+
void CStatistics::ShuffleArray(double &array[])
{
    int size = ArraySize(array);
    
    for(int i = size - 1; i > 0; i--)
    {
        int j = MathRand() % (i + 1);
        
        // Swap elements
        double temp = array[i];
        array[i] = array[j];
        array[j] = temp;
    }
}

//+------------------------------------------------------------------+
//| Train-Test Split for ML                                         |
//+------------------------------------------------------------------+
void CStatistics::TrainTestSplit(const double &data[], double train_ratio, double &train[], double &test[])
{
    int size = ArraySize(data);
    if(size == 0) return;
    
    // Create shuffled copy
    double shuffled_data[];
    ArrayCopy(shuffled_data, data);
    ShuffleArray(shuffled_data);
    
    int train_size = (int)MathFloor(size * train_ratio);
    int test_size = size - train_size;
    
    ArrayResize(train, train_size);
    ArrayResize(test, test_size);
    
    // Copy data to train and test arrays
    for(int i = 0; i < train_size; i++)
        train[i] = shuffled_data[i];
    
    for(int i = 0; i < test_size; i++)
        test[i] = shuffled_data[train_size + i];
}

//+------------------------------------------------------------------+
//| Calculate R-squared for regression evaluation                   |
//+------------------------------------------------------------------+
double CStatistics::RSquared(const double &y_true[], const double &y_pred[])
{
    int size = ArraySize(y_true);
    int size_pred = ArraySize(y_pred);
    
    if(size != size_pred || size == 0) return 0;
    
    double mean_true = Mean(y_true);
    double ss_total = 0;
    double ss_residual = 0;
    
    for(int i = 0; i < size; i++)
    {
        ss_total += MathPow(y_true[i] - mean_true, 2);
        ss_residual += MathPow(y_true[i] - y_pred[i], 2);
    }
    
    if(ss_total == 0) return 0;
    
    return 1 - (ss_residual / ss_total);
}

//+------------------------------------------------------------------+
//| Calculate Hurst Exponent for market efficiency                  |
//+------------------------------------------------------------------+
double CStatistics::HurstExponent(const double &array[])
{
    int size = ArraySize(array);
    if(size < 2) return 0.5;
    
    // Calculate log returns
    double returns[];
    ArrayResize(returns, size - 1);
    
    for(int i = 1; i < size; i++)
        returns[i-1] = MathLog(array[i] / array[i-1]);
    
    int max_lag = MathMin(size / 4, 100);
    double lags[], RS_values[];
    ArrayResize(lags, max_lag);
    ArrayResize(RS_values, max_lag);
    
    for(int lag = 1; lag <= max_lag; lag++)
    {
        int n = size / lag;
        if(n < 2) continue;
        
        double mean_RS = 0;
        
        for(int i = 0; i < n; i++)
        {
            double subset[];
            ArrayResize(subset, lag);
            
            for(int j = 0; j < lag; j++)
                subset[j] = returns[i * lag + j];
            
            double subset_mean = Mean(subset);
            
            // Calculate cumulative deviations
            double cumulative[];
            ArrayResize(cumulative, lag);
            cumulative[0] = subset[0] - subset_mean;
            
            for(int j = 1; j < lag; j++)
                cumulative[j] = cumulative[j-1] + (subset[j] - subset_mean);
            
            // Calculate range and standard deviation
            double min_cum = cumulative[0];
            double max_cum = cumulative[0];
            
            for(int j = 1; j < lag; j++)
            {
                if(cumulative[j] < min_cum) min_cum = cumulative[j];
                if(cumulative[j] > max_cum) max_cum = cumulative[j];
            }
            
            double range = max_cum - min_cum;
            double std_dev = StandardDeviation(subset);
            
            if(std_dev > 0)
                mean_RS += range / std_dev;
        }
        
        mean_RS /= n;
        lags[lag-1] = MathLog(lag);
        RS_values[lag-1] = MathLog(mean_RS);
    }
    
    // Perform linear regression to get Hurst exponent
    double slope, intercept;
    CLinearRegression lr;
    lr.SetData(lags, RS_values);
    
    if(lr.Calculate(slope, intercept))
        return slope;
    else
        return 0.5;
}

#endif // STATISTICS_MQH