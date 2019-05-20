import numpy as np
import pandas as pd
#train dataset
train = pd.read_csv('train.csv')
test = pd.read_csv('test.csv')
train.isnull().sum()
#set X & Y
Y = train['label']
X = train.iloc[:,1:]
#data split for train 
from sklearn.model_selection import train_test_split

X_train, X_test, y_train, y_test = train_test_split(X,Y, test_size = 0.2, random_state = 42)

#scaler
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
scaler.fit(X_train)
X_train = scaler.transform(X_train)
X_test = scaler.transform(X_test)

#Neural network
from sklearn.neural_network import MLPClassifier

MLP = MLPClassifier(hidden_layer_sizes= (5,5,5), solver = 'adam', verbose = True)

MLP.fit(X_train,y_train)

Y_Preds_Train_MLP = MLP.predict(X_train)
Y_Preds_Test_MLP = MLP.predict(X_test)

from sklearn.metrics import confusion_matrix
cm_train_mlp = confusion_matrix(y_train, Y_Preds_Train_MLP)
cm_test_mlp = confusion_matrix(y_test, Y_Preds_Test_MLP)

#increating the layer and iteration
MLP = MLPClassifier(hidden_layer_sizes= (10,10,10), solver = 'adam', verbose = True)

MLP.fit(X_train,y_train)


Y_Preds_Train_MLP = MLP.predict(X_train)
Y_Preds_Test_MLP = MLP.predict(X_test)

from sklearn.metrics import confusion_matrix
cm_train_mlp = confusion_matrix(y_train, Y_Preds_Train_MLP)
cm_test_mlp = confusion_matrix(y_test, Y_Preds_Test_MLP)

#increating the layer and iteration
MLP = MLPClassifier(hidden_layer_sizes= (30,30,30), solver = 'adam', verbose = True, max_iter = 300)

MLP.fit(X_train,y_train)


Y_Preds_Train_MLP = MLP.predict(X_train)
Y_Preds_Test_MLP = MLP.predict(X_test)

from sklearn.metrics import confusion_matrix
cm_train_mlp = confusion_matrix(y_train, Y_Preds_Train_MLP)
cm_test_mlp = confusion_matrix(y_test, Y_Preds_Test_MLP)


#increating the layer and iteration
MLP = MLPClassifier(hidden_layer_sizes= (50,50,50), solver = 'adam', verbose = True, max_iter = 300)

MLP.fit(X_train,y_train)


Y_Preds_Train_MLP = MLP.predict(X_train)
Y_Preds_Test_MLP = MLP.predict(X_test)

from sklearn.metrics import confusion_matrix
cm_train_mlp = confusion_matrix(y_train, Y_Preds_Train_MLP)
cm_test_mlp = confusion_matrix(y_test, Y_Preds_Test_MLP)

#increating the layer and iteration
MLP = MLPClassifier(hidden_layer_sizes= (50,50,50), solver = 'lbfgs', verbose = True, max_iter = 300)

MLP.fit(X_train,y_train)


Y_Preds_Train_MLP = MLP.predict(X_train)
Y_Preds_Test_MLP = MLP.predict(X_test)

from sklearn.metrics import confusion_matrix
cm_train_mlp = confusion_matrix(y_train, Y_Preds_Train_MLP)
cm_test_mlp = confusion_matrix(y_test, Y_Preds_Test_MLP)

#testing data set 
test_scale = scaler.transform(test)

preds_test = MLP.predict(test_scale)

preds_test = pd.DataFrame(preds_test)

preds_test.to_csv('output.csv')











