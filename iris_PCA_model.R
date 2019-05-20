data("iris")
iris_df<- data.frame(iris)

iris.X<- iris[,c(1,2,3,4)]
iris.Y<- iris[,"Species"]

#######-----------PCA model

PCA_model <- prcomp(iris.X,scale. = T)
summary(PCA_model)

iris_dataset<- as.data.frame(PCA_model$x)

iris_dataset$Class<- iris.Y

library(randomForest)

model_1 <- randomForest(Class~., data = iris_dataset)

iris_dataset$preds <- predict(model_1, iris_dataset)

table(iris_dataset$preds, iris_dataset$preds)
