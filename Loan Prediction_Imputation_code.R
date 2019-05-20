###########Automatic imputation on the Loan perdiction data##########
install.packages("Amelia")
library(Amelia)
newimpute <- amelia(train, m=5, idvars = c("Loan_ID","Education","ApplicantIncome","CoapplicantIncome","Property_Area","Loan_Status"),noms = c("Gender","Married","Self_Employed","Credit_History"), ords = c("Dependents"))
write.amelia(newimpute,file.stem = "Imputed_data_Loan_prediction")
