#setwd("~/Prudential/GitHubRepo")
set.seed(1725)
#library(caret)
library(xgboost)
train1<-read.csv("train.csv")
test1<-read.csv("test.csv")

#convert any factors into numeric values
train2<-data.frame(data.matrix(train1))
test2<-data.frame(data.matrix(test1))

#replace any NA with median values
f<-function(x){
  replace(x, is.na(x), median(x, na.rm=TRUE))
}
train2=data.frame(apply(train2,2,f))
test2=data.frame(apply(test2,2,f))

#drop the ID variable
train2$Id<-NULL
test2$Id<-NULL


#build the first prediction model
modx <- xgboost(data        = data.matrix(train2[1:126]),
                label       = as.numeric(train2$Response),
                eta         = 0.02,
                depth       = 10,
                nrounds     = 2500,
                objective   = "reg:linear",
                eval_metric = "rmse")

#calculate predcitions (note data partitioning was not used)
train2$rawResponse<-predict(modx,newdata=data.matrix(train2))
#calculate the error and add it to the training database
train2$error<-train2$Response - train2$rawResponse

#create database for the error model and eliminate the Response output
train3<-train2
train3$Response<-NULL

#create the error model
moderror <- xgboost(data        = data.matrix(train3[1:127]),
                label       = as.numeric(train3$error),
                booster     = "gblinear",
                nrounds     = 1000,
                lambda      =10,
                lambda_bias =0,
                alpha       =0,
                eta         =.02,
                max_depth   =20,
                objective   = "reg:linear",
                eval_metric = "rmse")


#start predictions

test2$rawResponse<-predict(modx,newdata=data.matrix(test2))
test2$error<-predict(moderror,newdata=data.matrix(test2))
test2[test2$error<.5 & test2$error>-.5,"error"]<-0
test2$Response<-test2$error + test2$rawResponse

#create an output file for Kaggle submission
submission <- data.frame(Id=test1$Id)
submission$Response<-round(test2$Response)
submission[submission$Response<1, "Response"] <- 1
submission[submission$Response>8, "Response"] <- 8
write.csv(submission, file="submit2205.csv",row.names=FALSE)
