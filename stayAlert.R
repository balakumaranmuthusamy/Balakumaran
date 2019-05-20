train<- read.csv("E:\\R Studio\\Stay Alert\\fordTrain.csv", na.string= c(""))
test<- read.csv("E:\\R Studio\\Stay Alert\\fordTest.csv", na.strings = c(""))
library(Hmisc)
library(e1071)
summary(train)
sum(is.na(train))
str(train)
#convecting as factor in train and test data 
train$IsAlert<-as.factor(train$IsAlert)
train$E9<-as.factor(train$E9)
train$V5<-as.factor(train$V5)

test$E9<-as.factor(test$E9)
test$V5<-as.factor(test$V5)

#removing the variable P8 V7 V9 in both test and train data

train<- subset(train,select=-c(P8,V7,V9))
test<- subset(test,select=-c(IsAlert,P8,V7,V9))
test<- subset(test,select=-c(IsAlert))
names(test)

#Bi variate
describe(train)
summary(train)

correlation<- rcorr(as.matrix(train))
correlation_train<-as.data.frame(correlation$r)
write.csv(correlation_train,'correlation.csv')
#Logistic_regresion#####
names(train)
Logistic_reg<- glm(IsAlert~P1+P2+P3+P4+P5+P6+P7+E1+E2+E3+E4+E5+E6+E7+E8+E9+E10+E11+V1+V2+V3+V4+V5+V6+V8+V10+V11, family = 'binomial'
, data = train)
summary(Logistic_reg)
train$predictglm<-predict.glm(Logistic_reg,train)
train$predict<-predict(Logistic_reg,train,type = 'response')
train$outcome<-ifelse(train$predict>=0.5,1,0)
table(train$IsAlert,train$outcome)
180691+297056
477747/604329
#########decision tree#####
library('party')
png(file = 'decision_tree.png')
names(train)
model_tree<- ctree(IsAlert~P1+P2+P3+P4+P5+P6+P7+E1+E2+E3+E4+E5+E6+E7+E8+E9+E10+E11+V1+V2+V3+V4+V5+V6+V8+V10+V11,
                data = train)
#Plot Tree
plot(model_tree)
dev.off()
summary(model_tree)
model_tree
#####---------------------Confusion Matrix - Dection Tree ####################
rain$predic_Modeltree<-predict(model_tree,Train)

table(Train$IsAlert, Train$predic_Modeltree)

(492+246)/(492+57+96+246) #82.82 accurate
########random forest#########