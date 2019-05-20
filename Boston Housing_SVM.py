import numpy as np
import pandas as pd
import os
#set the working directory
os.chdir('E:\Studys\Data Science\Python\Boston Housing')
#import the file
train = pd.read_csv('train.csv')
#missing vlaues
train.isnull()
train["ID"].isna().value_counts()
train["crim"].isna().value_counts()
train.isna().sum()
#summary of the data set
summary = train.describe()

train.head(20)
train.tail(20)

train['nox'].mean()
train['nox'].sum()
train['nox'].median()#using pandas directly to the data set
np.mean(train['tax'])#using Numpy
#convect into array
train_array = np.array(train)

#skewness
train.skew()
train["crim"].skew()

#frequence of the items
train["chas"].value_counts()
train["nox"].value_counts()

#scaling data
train["Log_crim"] = np.log(train["crim"])
train["z_score"] = ((train["crim"]-np.mean(train["crim"])/np.std(train["crim"])))

#using def function
def standard_scaler(var):
    mean = np.mean(var)
    std = np.std(var)
    scale_var = (var-mean)/std
    return scale_var

train_scale = standard_scaler(train)

#correlation Matrix
#numpy
correrlation_numpy = np.corrcoef(train["crim"], train["tax"])
#pandas
correlation_pandas = train.corr()

#Audit the file
train['ID'].isna().value_counts()
train['crim'].isna().value_counts()
train['zn'].isna().value_counts()
train.isna().sum()
summary= train.describe()
train.head() # gives 1st 5 rows
train.tail() # gives last 5 rows
train['tax'].mean() # using pandas to calculate mean
np.mean(train['tax']) # using numpy to calculate mean

# Tocheck for Skewness
train.skew()

train['chas'].value_counts()
train['ID'].value_counts()

train['log_crim'] = np.log(train['crim'])
train['Scale_crim']=((train['crim']-train['crim'].mean())/(train['crim'].std()))
correlation_matrix=np.corrcoef(train['crim'],train['tax'])
cor_matrix_pandas=train.corr()

#Divide the data into X & Y 

Y = train['medv']

X = train.iloc[:,1:14]

#Modelling Process

from sklearn.linear_model import LinearRegression

LR = LinearRegression()

LR.fit(X,Y)

LR.intercept_

Preds_LR = LR.predict(X)

from sklearn.metrics import mean_squared_error

mse_lr = mean_squared_error(Y,Preds_LR)

rmse_lr = np.sqrt(mse_lr)

print(mse_lr)
print(rmse_lr)


#########################Random FOrest########################


from sklearn.ensemble import RandomForestRegressor

RF = RandomForestRegressor(n_estimators=500)

RF.fit(X,Y)

Preds_RF = RF.predict(X)

rmse_rf = np.sqrt(mean_squared_error(Y,Preds_RF))


######################SVM#########################

from sklearn.svm import SVR

SVM = SVR(kernel = 'poly')

SVM.fit(X,Y)

Preds_SVM = SVM.predict(X)


rmse_SVM = np.sqrt(mean_squared_error(Y,Preds_SVM))


###################Test data ########################
##Import data set
Test = pd.read_csv('test.csv')
### Remove ID
test_data = Test.iloc[:,1:14]
## Predict Y for test data
test_data['preds_medv'] = RF.predict(test_data)
## Write the output to a CSV file
test_data.to_csv('output.csv')




































