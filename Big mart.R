#import the data set (Train and Test)
train<- read.csv("E:\\Studys\\Data Science\\R Studio\\Big mart sales\\Train.csv",header = TRUE, sep = ',', na.strings = c(""))
test<- read.csv("E:\\Studys\\Data Science\\R Studio\\Big mart sales\\Test.csv",header = TRUE, sep = ',', na.strings = c(""))
SampleSubmission<- read.csv("E:\\R Studio\\Big mart sales\\SampleSubmission.csv",header = TRUE, sep = ',', na.strings = c(""))
test
View(test)
#Audit the data
str(train)
#checking for the missing value
sum(is.na(train))
sum(is.na(train$Item_Identifier))
sum(is.na(train$Item_Weight))
sum(is.na(train$Item_Fat_Content))
sum(is.na(train$Item_Visibility))
sum(is.na(train$Item_Type))
sum(is.na(train$Item_MRP))
sum(is.na(train$Outlet_Identifier))
sum(is.na(train$Outlet_Establishment_Year))
sum(is.na(train$Outlet_Size))
sum(is.na(train$Outlet_Location_Type))
sum(is.na(train$Outlet_Type))
sum(is.na(train$Item_Outlet_Sales))
#HMISC Library also use to audit the data
install.packages("Hmisc")
library("Hmisc")
describe(train)
#To check skewness intall the below package
install.packages('e1071')
library(e1071)
skewness(train$Item_Weight)
skewness(train$Item_MRP)
#data summary
summary(train) 
#missing value for the Item_weight
train$Item_Weight<- ifelse(is.na(train$Item_Weight),median(train$Item_Weight,na.rm = TRUE),train$Item_Weight)
summary(train$Item_Weight)
summary(train) #checking the data
#Missing vaule for the Outlet_size
table(train$Outlet_Size)
train$Outlet_Size<- as.character(train$Outlet_Size)
train$Outlet_Size<- ifelse(is.na(train$Outlet_Size),"Medium",train$Outlet_Size)
table(train$Outlet_Size)
#Handling Inconsistency in the Item_fat_Content
table(train$Item_Fat_Content)
train$Item_Fat_Content<- as.character(train$Item_Fat_Content)
train$Item_Fat_Content<- ifelse(train$Item_Fat_Content=="LF","Low Fat",train$Item_Fat_Content)
train$Item_Fat_Content<- ifelse(train$Item_Fat_Content=="low fat","Low Fat",train$Item_Fat_Content)
train$Item_Fat_Content<- ifelse(train$Item_Fat_Content=="reg","Regular",train$Item_Fat_Content)
table(train$Item_Fat_Content)
summary(train)
#creation of the new variable
train$YOB<- 2018 - train$Outlet_Establishment_Year
View(train)
#skewness Check
boxplot(train$Item_Weight)
skewness(train$Item_Weight)
boxplot(train$Item_Visibility)
skewness(train$Item_Visibility)
boxplot(train$Item_MRP)
skewness(train$Item_MRP)
boxplot(train$Item_Outlet_Sales)
skewness(train$Item_Outlet_Sales)
#Bivariate analysis - correlation
cor(train$Item_Weight,train$Item_MRP)
cor(train$Item_Weight,train$Item_Visibility)
cor(train$Item_Weight,train$Item_Outlet_Sales)
cor(train$Item_MRP,train$Item_Outlet_Sales)
#Muitivariate analysis
##### Linear model ###

names(train)
Model <- lm(Item_Outlet_Sales~Item_Weight+Item_Fat_Content+Item_Visibility+Item_Type+Item_MRP+Outlet_Size
            +YOB+Outlet_Location_Type+Outlet_Type,data = train)
summary(Model)
boxplot(Model$residuals)#To see the outlayers in the model
# to see the predicted Y value
Model$fitted.values
train$pred<- predict(Model,train) # adding the Predicted Vaule to the model
View(train)
#calculating the Residual vaule
train$resid<- train$Item_Outlet_Sales-train$pred
train$Sqresid <- train$resid*train$resid
mean_squared_error <- mean(train$Sqresid)
root_mean_squared_error <- sqrt(mean_squared_error)
#############----------Decision Trees---------################
png(file = 'decision_tree.png')
names(train)
str(train)
model_tree<- ctree(Item_Outlet_Sales~Item_Weight+Item_Visibility+Item_Type+Item_MRP+YOB+Outlet_Location_Type+Outlet_Type,data = train)
#Plot Tree
plot(model_tree)
dev.off()
summary(model_tree)
model_tree
model_tree$fitted.values
train$pred_tree<- predict(model_tree,train) # adding the Predicted Vaule to the model
View(train)
#calculating the Residual vaule
train$resid_tree<- train$Item_Outlet_Sales-train$pred_tree
train$Sqresid_tree <- train$resid_tree*train$resid_tree
mean_squared_error_tree <- mean(train$Sqresid_tree)
root_mean_squared_error_tree <- sqrt(mean_squared_error_tree)

##### random forest #####
library(randomForest)

model_rf<- randomForest(Item_Outlet_Sales~Item_Weight+Item_Visibility+Item_Type+Item_MRP+YOB+Outlet_Location_Type+Outlet_Type,data = train)

model_rf
model_rf$fitted.values
train$pred_rf<- predict(model_rf,train) # adding the Predicted Vaule to the model
View(train)
#calculating the Residual vaule
train$resid_rf<- train$Item_Outlet_Sales-train$pred_rf
train$Sqresid_rf <- train$resid_rf*train$resid_rf
mean_squared_error_rf <- mean(train$Sqresid_rf)
root_mean_squared_error_rf <- sqrt(mean_squared_error_rf)

##########SVM#####

model_svm<- svm(Item_Outlet_Sales~Item_Weight+Item_Visibility+Item_Type+Item_MRP+YOB+Outlet_Location_Type+Outlet_Type,data = train)
model_svm
model_svm$fitted.values
train$pred_svm<- predict(model_svm,train) # adding the Predicted Vaule to the model
View(train)
#calculating the Residual vaule
train$resid_svm<- train$Item_Outlet_Sales-train$pred_svm
train$Sqresid_svm <- train$resid_svm*train$resid_svm
mean_squared_error_svm <- mean(train$Sqresid_svm)
root_mean_squared_error_svm <- sqrt(mean_squared_error_svm)

###### test data ###
sum(is.na(test))
sum(is.na(test$Item_Identifier))
sum(is.na(test$Item_Weight))
sum(is.na(test$Item_Fat_Content))
sum(is.na(test$Item_Visibility))
sum(is.na(test$Item_Type))
sum(is.na(test$Item_MRP))
sum(is.na(test$Outlet_Identifier))
sum(is.na(test$Outlet_Establishment_Year))
sum(is.na(test$Outlet_Size))
sum(is.na(test$Outlet_Location_Type))
sum(is.na(test$Outlet_Type))
sum(is.na(test$Item_Outlet_Sales))
#HMISC Library also use to audit the data
install.packages("Hmisc")
library("Hmisc")
describe(test)
#To check skewness intall the below package
install.packages('e1071')
library(e1071)
skewness(test$Item_Weight)
skewness(test$Item_MRP)
#data summary
summary(test) 
#missing value for the Item_weight
test$Item_Weight<- ifelse(is.na(test$Item_Weight),median(test$Item_Weight,na.rm = TRUE),test$Item_Weight)
summary(test$Item_Weight)
summary(test) #checking the data
#Missing vaule for the Outlet_size
table(test$Outlet_Size)
test$Outlet_Size<- as.character(test$Outlet_Size)
test$Outlet_Size<- ifelse(is.na(test$Outlet_Size),"Medium",test$Outlet_Size)
table(test$Outlet_Size)
#Handling Inconsistency in the Item_fat_Content
table(test$Item_Fat_Content)
test$Item_Fat_Content<- as.character(test$Item_Fat_Content)
test$Item_Fat_Content<- ifelse(test$Item_Fat_Content=="LF","Low Fat",test$Item_Fat_Content)
test$Item_Fat_Content<- ifelse(test$Item_Fat_Content=="low fat","Low Fat",test$Item_Fat_Content)
test$Item_Fat_Content<- ifelse(test$Item_Fat_Content=="reg","Regular",test$Item_Fat_Content)
table(test$Item_Fat_Content)
summary(test)
#creation of the new variable
test$YOB<- 2018 - test$Outlet_Establishment_Year
View(test)
#skewness Check
boxplot(test$Item_Weight)
skewness(test$Item_Weight)
boxplot(test$Item_Visibility)
skewness(test$Item_Visibility)
boxplot(test$Item_MRP)
skewness(test$Item_MRP)
boxplot(test$Item_Outlet_Sales)
skewness(test$Item_Outlet_Sales)
#Bivariate analysis - correlation
cor(test$Item_Weight,test$Item_MRP)
cor(test$Item_Weight,test$Item_Visibility)
cor(test$Item_Weight,test$Item_Outlet_Sales)
cor(test$Item_MRP,test$Item_Outlet_Sales)
### random forest ###
test$predic<-predict(model_rf,test,type = 'response')
view(test)
write.csv(test,'Final.csv')
getwd()
