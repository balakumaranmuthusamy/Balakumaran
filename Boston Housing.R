train<- read.csv("E:\\Studys\\Data Science\\R Studio\\Boston Housing\\train.csv" , header = TRUE, sep = ',' , na.strings = c(""))
test<- read.csv("E:\\Studys\\Data Science\\R Studio\\Boston Housing\\test.csv" , header = TRUE, sep = ',' , na.strings = c(""))
str(train)
dim(train)
summary(train)
library(e1071)
cor(train$crim,train$medv)
Correlation_matrix <- cor(train)
boxplot(train)
skewness(train$medv)
skewness(train$zn)
skewness(train$indus)
skewness(train$chas)
skewness(train$nox)
skewness(train$rm)
skewness(train$age)
skewness(train$dis)
skewness(train$rad)
skewness(train$tax)
skewness(train$ptratio)
skewness(train$black)
skewness(train$lstat)
skewness(train$crim)
train$chas <- as.factor(train$chas)
names(train)
Linear_model<- lm(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat, data = train)
summary(Linear_model)
boxplot(Linear_model$residuals)        
Linear_model$fitted.values
train$pred<- predict(Linear_model,train) # adding the Predicted Vaule to the model
View(train)
#calculating the Residual vaule
train$resid<- train$medv-train$pred
train$Sqresid <- train$resid*train$resid
mean_squared_error <- mean(train$Sqresid)
root_mean_squared_error <- sqrt(mean_squared_error)
#log transformation
skewness(train$medv)
skewness(train$zn)
skewness(train$indus)
skewness(train$chas)
skewness(train$nox)
skewness(train$rm)
skewness(train$age)
skewness(train$dis)
skewness(train$rad)
skewness(train$tax)
skewness(train$ptratio)
skewness(train$black)
skewness(train$lstat)
skewness(train$crim)
crim_log<- log(train)
zn_log
indus_log
chas_log
nox_log
rm_log
age_log
dis_log
rad_log
tax_log
ptratio_log
black_log
lstat_log
train$crim_log<-log(train$crim)
train$zn_log<-log(train$zn)
train$indus_log<-log(train$indus)
train$chas_log<-log(train$chas)
train$nox_log<-log(train$nox)
train$rm_log<-log(train$rm)
train$age_log<-log(train$age)
train$dis_log<-log(train$dis)
train$rad_log<-log(train$rad)
train$tax_log<-log(train$tax)
train$ptratio_log<-log(train$ptratio)
train$black_log<-log(train$black)
train$lstat_log<-log(train$lstat)
train$medv_log<- log(train$medv)
skewness(train$crim_log)
skewness(train$zn_log)
skewness(train$indus_log)
skewness(train$chas_log)
skewness(train$nox_log)
skewness(train$rm_log)
skewness(train$age_log)
skewness(train$dis_log)
skewness(train$rad_log)
skewness(train$tax_log)
skewness(train$ptratio_log)
train$zn_log<-ifelse(train$zn_log== -Inf, 0, train$zn_log)


Linear_model_log<- lm(medv~crim_log+zn+indus+chas+nox+rm+age_log+dis+rad_log+tax_log+ptratio_log+black_log+lstat_log
, data = train)
summary(Linear_model_log)
train$pred_log_ln<- predict(Linear_model_log,train)
train$resid_log_ln <- train$medv-train$pred_log_ln
train$Sqresid_log_ln <- train$resid_log_ln*train$resid_log_ln
mean_squared_error_log_ln <- mean(train$Sqresid_log_ln)
root_mean_squared_error_log_ln <- sqrt(mean_squared_error_log_ln)

#########Decision tree#####
library(party)
png(file = "Decision_tree")
model_tree<- ctree(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat, data = train)
plot(model_tree)
dev.off()
summary(model_tree)
model_tree$fitted.values
train$pred_tree<- predict(model_tree,train)
train$resid_tree<- train$medv-train$pred_tree
train$Sqresid_tree <- train$resid_tree*train$resid_tree
mean_squared_error_tree <- mean(train$Sqresid_tree)
root_mean_squared_error_tree <- sqrt(mean_squared_error_tree)

######Ramdom forest######
library(randomForest)
model_rf<-randomForest(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat,ntrees=500, data = train)
train$pred_rf<- predict(model_rf,train)
train$resid_rf<- train$medv-train$pred_rf
train$Sqresid_rf <- train$resid_rf*train$resid_rf
mean_squared_error_rf <- mean(train$Sqresid_rf)
root_mean_squared_error_rf <- sqrt(mean_squared_error_rf)



#######Random_forest_log_data#####
model_rf_log<-randomForest(medv~crim_log+zn+indus+chas+nox+rm+age_log+dis+rad_log+tax_log+ptratio_log+black_log+lstat_log
, data = train)
train$pred_rf_log<- predict(model_rf_log,train)
train$resid_rf_log<- train$medv-train$pred_rf_log
train$Sqresid_rf_log <- train$resid_rf_log*train$resid_rf_log
mean_squared_error_rf_log <- mean(train$Sqresid_rf_log)
root_mean_squared_error_rf_log <- sqrt(mean_squared_error_rf_log)



########SVM######
model_svm<- svm(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat, data = train)
model_svm
train$pred_svm<- predict(model_svm,train)
rmse_svm<- sqrt(mean((train$medv-train$pred_svm)^2))
train$resid_svm<- train$medv-train$pred_svm
train$Sqresid_svm <- train$resid_svm*train$resid_svm
mean_squared_error_svm <- mean(train$Sqresid_svm)
root_mean_squared_error_svm <- sqrt(mean_squared_error_svm)
model_svm_different<- svm(medv~crim+zn+indus+chas+nox+rm+age+dis+rad+tax+ptratio+black+lstat,kernal = polynomial, data = train)

#######applying in the test data######

test$chas <- as.factor(test$chas)
str(test)

test$value<- predict(model_rf,test)
write.csv(test, 'final_Boston_housing')
