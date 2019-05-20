import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

dateparse = lambda dates: pd.datetime.strptime(dates,'%Y-%m')
data = pd.read_csv('AirPassengers.csv', parse_dates=['Month'], index_col='Month', 
                   date_parser=dateparse)

data.head()

data.index

plt.plot(data)

from statsmodels.tsa.stattools import adfuller

moving_avg = data.rolling(3).mean()
plt.plot(data)
plt.plot(moving_avg, color='red')

addtest = adfuller(data['#Passengers'], autolag='AIC')

from statsmodels.tsa.seasonal import seasonal_decompose

decomposition = seasonal_decompose(data['#Passengers'])

trend = decomposition.trend

seasonal = decomposition.seasonal                                        

residual = decomposition.resid

plt.plot(trend, label='Trend')

plt.plot(seasonal, label= 'Seasonal')

plt.plot(residual, label= 'Residuals')

from statsmodels.tsa.arima_model import ARIMA

model = ARIMA(data['#Passengers'], order=(2,1,0))
                   
results_AR = model.fit()

predictions = pd.Series(results_AR.fittedvalues, copy=True)

plt.plot(data['#Passengers'])
plt.plot(results_AR.fittedvalues, color='red')












