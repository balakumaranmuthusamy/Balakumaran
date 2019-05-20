#data import
import pandas as pd
import numpy as np
train = pd.read_csv("train.csv")
test = pd.read_csv("test.csv")
#checking missing values
train_missing = train.isnull().sum()

#Imputing missing values

##education variables
train['education'].isnull().sum()
train['education'].value_counts()
train['education'] = np.where(train['education'].isnull(),"Bachelor's",train['education'])
train['education'].isnull().sum()

#previous_year_rating
train['previous_year_rating'].isnull().sum()
np.nanmedian(train['previous_year_rating'])
train['previous_year_rating'].value_counts()
train['previous_year_rating']= np.where(train['previous_year_rating'].isnull, 
     np.nanmedian(train['previous_year_rating']),train['previous_year_rating'])
train['previous_year_rating'].isnull().sum()

#encode the data
from sklearn.preprocessing import LabelEncoder
le = LabelEncoder()
train['department'] = le.fit_transform(train['department'])
train['department'].value_counts()

train['region'] = le.fit_transform(train['region'])
train['region'].value_counts()

train['education'] = le.fit_transform(train['education'])
train['education'].value_counts()

train['gender'] = le.fit_transform(train['gender'])
train['gender'].value_counts()

train['recruitment_channel'] = le.fit_transform(train['recruitment_channel'])
train['recruitment_channel'].value_counts()

#data split
Y= train['is_promoted']
X= train.iloc[:,1:13]

from sklearn.model_selection import train_test_split

X_train, X_test, Y_train, Y_test = train_test_split(X,Y, test_size = 0.20, random_state = 123)

#Neural network
from sklearn.neural_network import MLPClassifier

MLP = MLPClassifier(hidden_layer_sizes= (30,30,30), solver = 'adam', verbose = True, max_iter = 200)

MLP.fit(X_train,Y_train)

Y_Preds_Train_MLP = MLP.predict(X_train)
Y_Preds_Test_MLP = MLP.predict(X_test)

from sklearn.metrics import confusion_matrix
cm_train_mlp = confusion_matrix(Y_train, Y_Preds_Train_MLP)
cm_test_mlp = confusion_matrix(Y_test, Y_Preds_Test_MLP)

#########################Random Forest########################

from sklearn.ensemble import RandomForestRegressor

RF = RandomForestRegressor(n_estimators=500)

RF.fit(X,Y)

Preds_RF = RF.predict(X)

cm_rf = confusion_matrix(Y,Preds_RF)

##### XG boost ######

from xgboost import XGBClassifier
XGB = XGBClassifier()
XGB.fit(X_train,Y_train)
preds_XGB = XGB.predict(X_train)


from sklearn.metrics import confusion_matrix

cm_xgb = confusion_matrix(Y_train,preds_XGB)






































