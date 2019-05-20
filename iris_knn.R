data("iris")
iris<-data.frame(iris)
iris.X<-iris[,c(1,2,3,4)]
iris.class<-iris[,"Species"]

iris_scale<-scale(iris.X)

iris.X_train<- iris_scale[1:130,]
iris.Y_train<-iris[1:130,5]

iris.X_test<- iris_scale[131:150,]
iris.Y_test<- iris[131:150,5]

model1<- knn(train = iris.X_train, test = iris.X_train, cl=iris.Y_train)

table(iris.Y_train,model1)


#####testing

model2<- knn(train=iris.X_train, test = iris.X_test, cl= iris.Y_train)

table(iris.Y_test,model2)
####PCA model#####
prin_comp<-prcomp(iris.X_train, scale. = T)
IRIS_PCA_Train<- prin_comp$x
prin_comp



