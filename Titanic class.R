Test<- read.csv("E:\\R Studio\\Titanic\\test.csv", header = TRUE,sep = ",",na.strings = c(""))
Train<-read.csv("E:\\R Studio\\Titanic\\train.csv", header = TRUE,sep = ",",na.strings = c(""))
summary(Train)
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
model<- glm(Survived~Pclass+Sex+Age+SibSp+Parch+Fare+Embarked,family = 'binomial',data = Train)
model
View(model)
summary(model)
Train$predictglm<-predict.glm(model,Train)
Train$predict<-predict(model,Train,type = 'response')
Train$outcome<-ifelse(Train$predict>=0.5,1,0)
table(Train$Survived,Train$outcome)
table(Train$outcome,Train$Survived)
###-------------------------------------------------------####
Train$ln_fare<-log(Train$Fare)
Train$ln_fare<-ifelse(Train$ln_fare==-Inf,0,Train$ln_fare)
model_1<- glm(Survived~Pclass+Sex+Age+SibSp+Parch+ln_fare+Embarked,family = 'binomial',data = Train)
summary(model_1)
###-------------------------------------------------------####

summary(Test)
describe(Test)
Test$Survived<- as.factor(Test$Survived)
Test$Pclass<-as.factor(Test$Pclass)
str(Test)
#imputting the missing value
describe(Test$Age) 
Test$Age<-ifelse(is.na(Test$Age),median(Test$Age,na.rm = TRUE),Test$Age)
describe(Test$Age) 
is.na(Test$Age)
#Missing value Imputation for the Embarked
sum(is.na(Test$Embarked))
table(Test$Embarked)
Test$Embarked<-as.character(Test$Embarked)
Test$Embarked<- ifelse(is.na(Test$Embarked),'S',Test$Embarked)
sum(is.na(Test$Embarked))
table(Test$Embarked)
Test$Embarked<-as.factor(Test$Embarked)
#Missing value for fare
Test$Fare<-ifelse(is.na(Test$Fare),median(Test$Fare,na.rm = TRUE),Test$Fare)
Test$predic<-predict(model,Test,type = 'response')
Test$outcome<-ifelse(Test$predic>=0.5,1,0)

write.csv(Test,'Final.csv')
getwd()
#############----------Decision Trees---------################33

install.packages("party")
library('party')
png(file = 'decision_tree.png')
names(Train)
model_tree<- ctree(Survived~Pclass+Sex+Age+SibSp+Parch+Fare+Embarked, data = Train)
#Plot Tree
plot(model_tree)
dev.off()
summary(model_tree)
model_tree

#####---------------------Confusion Matrix - Dection Tree ####################
Train$predic_Modeltree<-predict(model_tree,Train)

table(Train$Survived, Train$predic_Modeltree)

(492+246)/(492+57+96+246) #82.82 accurate

##########----------Random forest--------################3
install.packages("randomForest")
library(randomForest)

model_rf<- randomForest(Survived~Pclass+Sex+Age+SibSp+Parch+Fare+Embarked, data = Train)

model_rf

(507+240)/(507+42+102+240) #Accurate is 83.83% as OOB is 16.27% error
#### increasing the tree number #####
model_rf<- randomForest(Survived~Pclass+Sex+Age+SibSp+Parch+Fare+Embarked,ntree=500, data = Train)
model_rf

########SVM######
model_svm<- svm(Survived~Pclass+Sex+Age+SibSp+Parch+Fare+Embarked, data = Train)
model_svm
#######Droping the variable not using#####
names(Train)
Train_1<- subset(Train,select = -c(PassengerId,Name,Ticket,Cabin))

#####---------------------Confusion Matrix - SVM ####################
Train_1$svm<- predict(model_svm,Train_1)
Train_1$predic_svm<-predict(model_svm,Train_1)

table(Train_1$Survived, Train_1$predic_svm)

(492+250)/(492+57+92+250)######accurate is 83.27




