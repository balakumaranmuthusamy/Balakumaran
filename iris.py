import numpy as np
import pandas as pd
import matplotlib.pyplot as plt


data = pd.read_csv('iris.csv')

summary = data.describe()

plt.boxplot(data['SepalLength'])

plt.scatter(data['SepalLength'],data['SepalWidth'])

variables = data.iloc[:,0:4]

from sklearn.cluster import KMeans

kmeans = KMeans(n_clusters = 3)

kmeans.fit(variables)

data['clusters'] = kmeans.predict(variables)

from sklearn.metrics import confusion_matrix

cm=confusion_matrix(data['Class'],data['clusters'])

data.to_csv('evaluate.csv')

from sklearn.cluster import KMeans

kmeans = KMeans(n_clusters = 3)

kmeans.fit(variables)

data['clusters'] = kmeans.predict(variables)

wcss = kmeans.inertia_





