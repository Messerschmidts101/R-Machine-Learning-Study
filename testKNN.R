install.packages("class")
library(class)
library(gmodels)
#load data
wbcd<-read.csv('data/wisc_bc_data.csv',stringsAsFactors = FALSE)
#preprocess data
wbcd<-wbcd[-1]#remove id of dataset
wbcd$diagnosis<-factor(wbcd$diagnosis,levels=c("B","M"),labels=c("Benign","Malignant"))#extract and change values
  #normalizing data to remove outliers
normalize<-function(x){
  return((x-min(x))/(max(x)-min(x)))
}
wbcd_n<-as.data.frame(lapply(wbcd[2:31],normalize))
summary(wbcd_n$area_mean)
#modeling
  #training 
wbcd_train<-wbcd_n[1:469,]
wbcd_train_labels<-wbcd[1:469,1]
#evaluating
  #testing
wbcd_test<-wbcd_n[470:569,]
wbcd_test_labels<-wbcd[470:569,1]
wbcd_test_pred<-knn(train=wbcd_train,test=wbcd_test,cl=wbcd_train_labels,k=21)
CrossTable(x=wbcd_test_labels,y=wbcd_test_pred,prop.chisq=FALSE)