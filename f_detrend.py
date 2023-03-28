import numpy as np
import pandas as pd
import statsmodels.api as sm
from statsmodels.formula.api import ols


def detrend_fuction(df,variable,date_cuts,date0,dateT,date_dict,extended=False,test=False):
    # Unpack
    date_cuts_t,date_cuts_t1 = date_cuts
    n_chunks = len(date_cuts_t)
    trend_coefs = []
    linear_trends = []
    predict_all = []

    linear_trends_down, linear_trends_up = [], []
    predict_all_down, predict_all_up = [], []
    covs = []

    # Peprate dependent variables
    qt_dict = {}
    for dt in date_dict.keys():
        qt_dict[dt] = int(dt[-1])

    df['quarter'] = df.dates.map(qt_dict)
    df['t'] = df.index
    
    # Run regressions
    for date in range(n_chunks):
        if date_cuts_t1[date] == dateT:
            data_buff = df.loc[date_dict[date_cuts_t[date]]:date_dict[date0]].copy()
        else:
            data_buff = df.loc[date_dict[date_cuts_t[date]]:date_dict[date_cuts_t1[date]]].copy()

        T = data_buff.quarter.size

        fit = ols('{} ~ C(quarter) + t'.format(variable), data=data_buff).fit()
        b0, b_q2, b_q3, b_q4, trend_coeff = fit.params
        sd_b0, sd_b_q2, sd_b_q3, sd_b_q4, sd_trend_coeff = fit.bse
        trend_coefs.append(trend_coeff)
        covs.append(fit.mse_resid)
        
        if date_cuts_t1[date] == dateT:
            data_buff = df.loc[date_dict[date_cuts_t[date]]:date_dict[date_cuts_t1[date]]].copy()
    
        q2_dum = (data_buff.quarter==2).astype(int)
        q3_dum = (data_buff.quarter==3).astype(int)
        q4_dum = (data_buff.quarter==4).astype(int)
        Q = np.vstack((q2_dum,q3_dum,q4_dum))
        
        linear_trends.append(b0+trend_coeff*data_buff.t)    
        predict_all.append(b0 + trend_coeff *data_buff.t + np.dot(fit.params[1:4],Q))

        linear_trends_up.append((b0+2*sd_b0)+(trend_coeff+2*sd_trend_coeff)*data_buff.t)    
        predict_all_up.append((b0+2*sd_b0)+(trend_coeff+2*sd_trend_coeff)*data_buff.t + \
                                np.dot((fit.params[1:4]+2*fit.bse[1:4]),Q))

        linear_trends_down.append((b0-2*sd_b0)+(trend_coeff-2*sd_trend_coeff)*data_buff.t)    
        predict_all_down.append((b0-2*sd_b0)+(trend_coeff-2*sd_trend_coeff)*data_buff.t + \
                                np.dot((fit.params[1:4]-2*fit.bse[1:4]),Q))
    
    # Pack for export    
    series_trend = np.hstack(linear_trends)
    series_predicted = np.hstack(predict_all)

    series_predicted_up, series_predicted_down = np.hstack(predict_all_up), np.hstack(predict_all_down)

    if extended==0:
        return series_trend,series_predicted

    elif test:
        return series_trend,series_predicted, covs
    else:
        return series_trend,series_predicted, series_predicted_up, series_predicted_down