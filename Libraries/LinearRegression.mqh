//+------------------------------------------------------------------+
//| Linear Regression Library                                       |
//+------------------------------------------------------------------+

#ifndef LINEARREGRESSION_MQH
#define LINEARREGRESSION_MQH

class CLinearRegression
{
private:
    double m_x[], m_y[];
    int m_size;
    
public:
    CLinearRegression() : m_size(0) {}
    
    void SetData(double &x[], double &y[])
    {
        ArrayCopy(m_x, x);
        ArrayCopy(m_y, y);
        m_size = ArraySize(x);
    }
    
    bool Calculate(double &slope, double &intercept)
    {
        if(m_size < 2) return false;
        
        double sum_x = 0, sum_y = 0, sum_xy = 0, sum_xx = 0;
        
        for(int i = 0; i < m_size; i++)
        {
            sum_x += m_x[i];
            sum_y += m_y[i];
            sum_xy += m_x[i] * m_y[i];
            sum_xx += m_x[i] * m_x[i];
        }
        
        double denominator = m_size * sum_xx - sum_x * sum_x;
        if(denominator == 0) return false;
        
        slope = (m_size * sum_xy - sum_x * sum_y) / denominator;
        intercept = (sum_y - slope * sum_x) / m_size;
        
        return true;
    }
};

#endif