Test<- read.csv("E:\\Studys\\Data Science\\R Studio\\Titanic\\test.csv", header = TRUE,sep = ",",na.strings = c(""))
Train<-read.csv("E:\\Studys\\Data Science\\R Studio\\Titanic\\train.csv", header = TRUE,sep = ",",na.strings = c(""))
summary(Train)
describe(Train)
str(Train)
boxplot(Train$Age)
library(e1071)
library(Hmisc)
boxplot(Train$Fare)
skewness(Train$Fare)
describe(Train$Fare)
#convect to factor
Train$Survived<- as.factor(Train$Survived)
Train$Pclass<-as.factor(Train$Pclass)
str(Train)
#imputting the missing value
describe(Train$Age) 
Train$Age<-ifelse(is.na(Train$Age),median(Train$Age,na.rm = TRUE),Train$Age)
describe(Train$Age) 
is.na(Train$Age)
#Missing value Imputation for the Embarked
sum(is.na(Train$Embarked))
table(Train$Embarked)
Train$Embarked<-as.character(Train$Embarked)
Train$Embarked<- ifelse(is.na(Train$Embarked),'S',Train$Embarked)
sum(is.na(Train$Embarked))
table(Train$Embarked)
Train$Embarked<-as.factor(Train$Embarked)
names(Train)
#####Clustering ######
Train_cluster<- subset(Train,select = c(Age,Parch,SibSp,Fare))
view(Train_cluster)
describe(Train_cluster)
Train_scale<-scale(Train_cluster)
Train_scale<-as.data.frame(Train_scale)
describe(Train_scale)

#distance matrix 
distance<- get_dist(Train_cluster)

fviz_dist(distance)
#KMeans

Cluster_table<-kmeans(Train_cluster, centers = 2, nstart = 25)

#assing the clusters
Train_cluster$clusters <- Cluster_table$cluster

fviz_cluster(Cluster_table, data = Train_cluster)

#ELBOW method
Elbow<- function(k){
  kmeans(Train_cluster,k,nstart = 10)$tot.withinss
}

k.values<- 1:15

Elbow_values<- map_dbl(k.values, Elbow)
plot(k.values, Elbow_values)




#distance matrix with scale data
distance<- get_dist(Train_scale)

fviz_dist(distance)
#KMeans

Scale_Cluster_table<-kmeans(Train_scale, centers = 4, nstart = 25)

#assing the clusters
Train_scale$clusters <- Scale_Cluster_table$cluster

fviz_cluster(Scale_Cluster_table, data = Train_scale)

#ELBOW method
Elbow<- function(k){
  kmeans(Train_scale,k,nstart = 10)$tot.withinss
}

k.values<- 1:15

Elbow_values<- map_dbl(k.values, Elbow)
plot(k.values, Elbow_values)


#####-------------Confusion Matrix--------####
table(Train$Survived,Train_cluster$clusters)
table(Train$Survived,Train_scale$clusters)
