data("iris")
data<-data.frame(iris)
iris.X<-iris[,c(1,2,3,4)]
iris.class<-iris[,"Species"]
library("Hmisc")
describe(iris.X)
boxplot(iris.X)
set.seed(123)
describe(iris.X)
Cor<-cor(as.matrix(iris.X))
ixis.x<-scale(iris.X)

result<- kmeans(iris.X,3)
result$cluster
iris$cluster<- result$cluster

view(iris)
table(iris$Species,iris$cluster)
