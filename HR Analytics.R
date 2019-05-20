train<-read.csv("E:\\Studys\\Data Science\\R Studio\\HR Analytics\\train.csv", sep = ',', na.strings = c(""))
test<-read.csv("E:\\Studys\\Data Science\\R Studio\\HR Analytics\\test.csv", sep = ',', na.strings = c(""))
str(train)
summary(train)
describe(train)
###----------treating missing value---------####
###--------education variable--------###
train$education<- as.character(train$education) 
str(train)
train$education<- ifelse(is.na(train$education),"Bachelor's", train$education)
train$education<- as.factor(train$education)
train$KPIs_met..80.<- as.factor(train$KPIs_met..80.)
train$awards_won.<-as.factor(train$awards_won.)
train$is_promoted<-as.factor(train$is_promoted)
str(train)
test$education<- as.character(test$education) 
str(test)
test$education<- ifelse(is.na(test$education),"Bachelor's", test$education)
test$education<- as.factor(test$education)
test$KPIs_met..80.<- as.factor(test$KPIs_met..80.)
test$awards_won.<-as.factor(test$awards_won.)
test$is_promoted<-as.factor(test$is_promoted)
str(test)
#######------------previous_year_rating variable---------####
train$previous_year_rating<-ifelse(is.na(train$previous_year_rating), median(train$previous_year_rating, na.rm = TRUE),train$previous_year_rating)
summary(train)
test$previous_year_rating<-ifelse(is.na(test$previous_year_rating), median(test$previous_year_rating, na.rm = TRUE),test$previous_year_rating)
summary(test)
#####---------corr & skewness-------######
cor(train$previous_year_rating,train$length_of_service)
skewness(train$length_of_service)
skewness(train$no_of_trainings)
skewness(train$awards_won.)
########--------------Exploratory data analysis---------######
table(train$department)
table(train$region)
####------------Conditional Mean----------####
mean(train$age[train$department=="Analytics"])
mean(train$age[train$department=="Finance"])
mean(train$age[train$department=="HR"])
#####-----------Department with highest awards----------########
table(train$department,train$awards_won.)

#####-----------------Log reg -------------####
names(train)
model_log<- glm(is_promoted~department+region+education+gender+recruitment_channel+no_of_trainings+
              age+previous_year_rating+length_of_service+KPIs_met..80.+awards_won.+avg_training_score,
            family = 'binomial',data = train)
model_log
View(model_log)
summary(model_log)
train$predict_glm<-predict(model_log,train,type = 'response')
train$outcome<-ifelse(train$predict>=0.5,1,0)
table(train$is_promoted,train$outcome)
(49830+1261)/54808#accurate is 93.21

#############----------Decision Trees---------################
install.packages("mvtnorm")
library('party')
png(file = 'decision_tree.png')
names(train)
model_tree<- ctree(is_promoted~department+region+education+gender+recruitment_channel+no_of_trainings+
                     age+previous_year_rating+length_of_service+KPIs_met..80.+awards_won.+avg_training_score,
                   data = train)
#Plot Tree
plot(model_tree)
dev.off()
summary(model_tree)
model_tree

#####---------------------Confusion Matrix - Dection Tree---------------####################
train$predic_Modeltree<-predict(model_tree,train)

table(train$is_promoted, train$predic_Modeltree)

(50067+1465)/54808 #94.02 accurate

##########----------Random forest--------################3
install.packages("randomForest")
library(randomForest)

model_rf<- randomForest(is_promoted~department+region+education+gender+recruitment_channel+no_of_trainings+
                          age+previous_year_rating+length_of_service+KPIs_met..80.+awards_won.+avg_training_score,
                        data = train)

model_rf#(49977+1436)/54808 #Accurate is 93.80%

train$predic_rf<-predict(model_rf,train)

table(train$is_promoted, train$predic_rf)
(50140+3268)/54808#97.44563(check only the this confusion matrix)
####----F1 score---#####
precision_rf<-(1445)/(150+1445)#.9059561
recall_rf<- (1445)/(1445+3223)#0.3095544
F1_score_rf<- 2*((precision_rf *recall_rf)/(precision_rf+recall_rf ))#f1score
F1_score_rf#0.4614402
####------------increasing the tree number--------------#####
model_rf_1000<- randomForest(is_promoted~Pclass+Sex+Age+SibSp+Parch+Fare+Embarked,ntree=1000, data = train)
model_rf_1000

########---------------SVM---------------######
model_svm<- svm(is_promoted~department+region+education+gender+recruitment_channel+no_of_trainings+
                  age+previous_year_rating+length_of_service+KPIs_met..80.+awards_won.+avg_training_score,
                data = train)
model_svm

#####---------------------Confusion Matrix - SVM------------###############
train$predic_svm<-predict(model_svm,train)

table(train$is_promoted, train$predic_svm)

(50140+644)/54808######accurate is 92.65

#######------------F1 score----------------#########
precision<-(644)/(644+0)#Precision
recall<-(644)/(644+4024)#recall
F1_score_SVM<- 2*((precision*recall)/(precision+recall))#f1score
F1_score_SVM#0.2424699

####------------Modeling process------------########
#X<- c("department"+"region"+"education"+"gender"+"recruitment_channel"+"no_of_trainings"+
       #"age"+"previous_year_rating"+"length_of_service"+"KPIs_met..80."+"awards_won."+"avg_training_score")
#Y<- c("is_promoted")
#levels(train$is_promoted)<- make.names(levels(factor(train$is_promoted)))

#library(caret)
#fitcontrol<- trainControl(
  #method = "CV",
  #number = 1,
  #savePredictions = 'final',
  #classProbs = T )
  
#model_rf_caret<-train(train[,X],train[,Y],method = 'rf')


#####--------Bayes theorem--------######
model_nb<-naiveBayes(is_promoted~department+region+education+gender+recruitment_channel+no_of_trainings+
                       age+previous_year_rating+length_of_service+KPIs_met..80.+awards_won.+avg_training_score,
                     data = train)
model_nb
train$predic_nb<-predict(model_nb,train)
table(train$is_promoted,train$predic_nb)
(48800+836)/54808####accurate is 90.5634

write.csv(train,'train_HR.csv')
getwd()
train_HR<-read.csv("E:\\R Studio\\HR Analytics\\train_HR.csv", sep = ',', na.strings = c(""))
names(train_HR)
train_HR<-subset(train_HR,select = -c(predict_glm))
train_HR$final_vote<-train_HR$predic_svm+train_HR$predic_rf+train_HR$predic_Modeltree+train_HR$predic_nb+
                     train_HR$outcome
View(train_HR)
train_HR$final_predic<-ifelse(train_HR$final_vote>=3,1,0)
write.csv(train_HR,'train_HR.csv')
getwd()


###########--------------test data----------############

str(test_HR)
test_HR$final_vote<-test_HR$predic_svm+test_HR$predic_rf+test_HR$predic_Modeltree+test_HR$predic_nb+
  test_HR$outcome
View(test_HR)
test_HR$final_predic<-ifelse(test_HR$final_vote>=3,1,0)
write.csv(test_HR,'test_HR.csv')
getwd()
