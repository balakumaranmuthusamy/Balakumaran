data<- USArrests
str(data)
summary(data)
describe(data)
skewness(data$Murder)
skewness(data$Assault)
skewness(data$UrbanPop)
skewness(data$Rape)
#scaling value
data_scale<-scale(data)
str(data_scale)
view(data_scale)
data_scale_D<- as.data.frame(data_scale)
skewness(data_scale_D$Murder)
skewness(data_scale_D$Assault)
skewness(data_scale_D$UrbanPop)
skewness(data_scale_D$Rape)
#distance matrix
distance<- get_dist(data_scale_D)

fviz_dist(distance)

#KMeans
K2<-kmeans(data_scale_D, centers = 2, nstart = 25)
K3<-kmeans(data_scale_D, centers = 3, nstart = 25)
K4<-kmeans(data_scale_D, centers = 4, nstart = 25)
K5<-kmeans(data_scale_D, centers = 5, nstart = 25)



#assing the clusters
data$clusters <- K2$cluster

data_scale_D$clusters<- K2$cluster
set.seed(123)
fviz_cluster(K2, data = data_scale_D)
fviz_cluster(K3, data = data_scale_D)
fviz_cluster(K4, data = data_scale_D)
fviz_cluster(K5, data = data_scale_D)
#ELBOW method
wss<- function(k){
  kmeans(data,k,nstart = 10)$tot.withinss
}

k.values<- 1:15

wss_values<- map_dbl(k.values, wss)
plot(k.values, wss_values)
