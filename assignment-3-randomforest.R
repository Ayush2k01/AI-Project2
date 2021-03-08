library(dplyr)
library(stringr)
library(FSelect)
library(rpart.plot)
library(caret)
library(rpart)
library(rpart.plot)
library(data.tree)
library(party)
library(partykit)
library(caTools)
library(ElemStatLearn)
library(randomForest)
setwd("/Curso-ML/Assignment-3/")
data2y <- read.csv("transactions-2.csv") ## Items
data2y <- select(data2y,fraud,income1,seller_sco,dispersao,type,V11) ##V12.1
str(data2y)
summary(data2y)
data2y$fraud <- as.factor(data2y$fraud)
data_sample = sample.split(data2y$fraud ,SplitRatio=0.95) ##here we separate the file to be the nodes
test  = subset(data2y,data_sample==FALSE) ##test data
data_sample = sample.split(data2y$fraud ,SplitRatio=0.30) ##here we separate the file to be the nodes
train = subset(data2y,data_sample==TRUE)  ##trainning data
rf <- randomForest(fraud~.,data=train, ntree=300, ntry=8)
print(rf)
attributes(rf)
p1 <- predict(rf, test)
head(p1)
head(train$fraud)
confusionMatrix(p1, test$fraud)
varImpPlot(rf)
partialPlot(rf, train, fraud, "2")
getTree(rf, 1, lableVar = TRUE)
MDSplot(rf, train$fraud)