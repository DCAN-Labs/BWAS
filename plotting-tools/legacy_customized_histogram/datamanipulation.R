## set working directory##
setwd('/remote_home/Emitch/Desktop')

## read in csv that was created in matlab##
data<-read.csv("newdata.csv",header=T)

##Adding a column of summary stats to data table##
data$avg_income<-(sum(data$income)/5)

## T test ##
t.test(data$income,data$fconn_10_27)











