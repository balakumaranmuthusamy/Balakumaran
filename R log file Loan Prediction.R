train<-read.csv("E:\\R Studio\\Loan Prediction III\\Train.csv", header = TRUE,sep = ',',na.strings = c(""))
View(train)
test<-read.csv("E:\\R Studio\\Loan Prediction III\\Test.csv", header = TRUE,sep = ',',na.strings = c(""))
View(test)
str(train)
summary(train)
library(Hmisc)
library(e1071)

#Convert to factor and numeric

train$Credit_History<-as.factor(train$Credit_History)
str(train)

#Missing value imputation
train$Gender <- as.character(train$Gender)
train$Gender <- ifelse(is.na(train$Gender),"Male",train$Gender)
describe(train$Gender)
dim(train$Gender)
train$Gender <- as.factor(train$Gender)

train$Married <- as.character(train$Married)
describe(train$Married)
train$Married <- ifelse(is.na(train$Married),"Yes",train$Married)
train$Married <- as.factor(train$Married)

describe(train$Dependents)
train$Dependents <- as.character(train$Dependents)
train$Dependents <- ifelse(is.na(train$Dependents),"0",train$Dependents)
train$Dependents <- as.factor(train$Dependents)

train$Self_Employed <- as.character(train$Self_Employed)
train$Self_Employed <- ifelse(is.na(train$Self_Employed),"No",train$Self_Employed)
train$Self_Employed <- as.factor(train$Self_Employed)
describe(train$Self_Employed)

summary (train)
str(train)
train$LoanAmount<-ifelse(is.na(train$LoanAmount),median(train$LoanAmount,na.rm = TRUE),train$LoanAmount)
describe (train$LoanAmount)

describe (train$Loan_Amount_Term)
train$Loan_Amount_Term <- as.character(train$Loan_Amount_Term)
train$Loan_Amount_Term <- ifelse(is.na(train$Loan_Amount_Term),"360",train$Loan_Amount_Term)
train$Loan_Amount_Term <- as.integer(train$Loan_Amount_Term)



describe (train$Credit_History)
train$Credit_History <- as.character(train$Credit_History)
train$Credit_History <- ifelse(is.na(train$Credit_History),"1",train$Credit_History)
train$Credit_History <- as.factor(train$Credit_History)
####taking log in Loan amount######
train$ln_loanAmt<- log(train$LoanAmount)
skewness(train$ln_loanAmt)
######Taking log in Applicent income####
train$ln_Appli_loanAmt<- log(train$ApplicantIncome)
skewness(train$ApplicantIncome)
#####Taking log in coapplicant income####
train$ln_coappincome <- log(train$CoapplicantIncome)
skewness(train$ln_coappincome)
train$ln_coappincome<-ifelse(train$ln_coappincome== -Inf, 0, train$ln_coappincome)      


#multivariate analysis
names(train)
model<-glm(Loan_Status~Gender+Married+Dependents+Education+Self_Employed+ApplicantIncome+CoapplicantIncome+LoanAmount+Loan_Amount_Term+Credit_History+Property_Area,family= 'binomial',data = train)
summary(model)



train$preds <- predict (model,train,type = 'response')
train$Outcome <- ifelse(train$preds>=0.5,1,0) 
View(train)

table(train$Loan_Status,train$Outcome)

(84+415)/614  #81.27% accurate


------------------#####----------#######--------

#test data

str(test)

View(test)
summary(test)


test$Gender <- as.character(test$Gender)
test$Gender <- ifelse(is.na(test$Gender),"Male",test$Gender)
describe(test$Gender)
dim(test$Gender)
test$Gender <- as.factor(test$Gender)


describe(test$Dependents)
test$Dependents <- as.character(test$Dependents)
test$Dependents <- ifelse(is.na(test$Dependents),"0",test$Dependents)
test$Dependents <- as.factor(test$Dependents)

test$Self_Employed <- as.character(test$Self_Employed)
test$Self_Employed <- ifelse(is.na(test$Self_Employed),"No",test$Self_Employed)
test$Self_Employed <- as.factor(test$Self_Employed)
describe(test$Self_Employed)

summary (test)
str(train)
test$LoanAmount<-ifelse(is.na(test$LoanAmount),median(test$LoanAmount,na.rm = TRUE),test$LoanAmount)
describe (test$LoanAmount)

describe (test$Loan_Amount_Term)
test$Loan_Amount_Term <- as.character(test$Loan_Amount_Term)
test$Loan_Amount_Term <- ifelse(is.na(test$Loan_Amount_Term),"136",test$Loan_Amount_Term)
test$Loan_Amount_Term <- as.integer(test$Loan_Amount_Term)



describe (test$Credit_History)
test$Credit_History <- as.character(test$Credit_History)
test$Credit_History <- ifelse(is.na(test$Credit_History),"1",test$Credit_History)
test$Credit_History <- as.factor(test$Credit_History)

summary(test)



test$preds <- predict (model,test,type = 'response')
test$Outcome <- ifelse(test$preds>=0.5,1,0) 
View(test)


write.csv(test,'Finalpreds.csv')
getwd()


#############----------Decision Trees---------################33

install.packages("party")
library('party')
png(file = 'decision_tree.png')
names(train)
model_tree<- ctree(Loan_Status~Gender+Married+Dependents+Education+Self_Employed+ln_Appli_loanAmt+ln_coappincome+ln_loanAmt+Loan_Amount_Term+Credit_History+Property_Area, data = train)
#Plot Tree
plot(model_tree)
dev.off()
summary(model_tree)
model_tree

#####---------------------Confusion Matrix - Dection Tree ####################

train$predic_Modeltree_1<-predict(model_tree,train)

table(train$Loan_Status, train$predic_Modeltree_1)

(82+415)/(82+110+7+415) #80.94 accurate

##########----------Random forest--------################
install.packages("randomForest")
library(randomForest)

model_rf<- randomForest(Loan_Status~Gender+Married+Dependents+Education+Self_Employed+ApplicantIncome+CoapplicantIncome+ln_loanAmt+Loan_Amount_Term+Credit_History+Property_Area, data = train)

model_rf

(86+403)/(86+106+19+403) #Accurate is 79.64% as OOB is 20.36% error
#### increasing the tree number #####
names(train)

model_rf<- randomForest(Loan_Status~Gender+Married+Dependents+Education+Self_Employed+ApplicantIncome+CoapplicantIncome+ln_loanAmt+Loan_Amount_Term+Credit_History+Property_Area,ntree=500, data = train)
model_rf

#######transforming data APplicant income#####

train$tran_appincome <- (train$ApplicantIncome - mean(train$ApplicantIncome)/sd(train$ApplicantIncome))

