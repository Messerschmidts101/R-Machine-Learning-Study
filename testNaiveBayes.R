install.packages("tm")
install.packages("snowballC")
install.packages("gmodels")
library(tm)
library(SnowballC)
library(gmodels)

#load data
wbcd<-read.csv('data/sms_spam.csv',stringsAsFactors = FALSE)

#preprocessing data
  #creating bag of words
wbcd$type<-factor(sms_raw$type)
sms_corpus <- VCorpus(VectorSource(sms_raw$text))
  #cleaning
sms_corpus_clean<-tm_map(sms_corpus,content_transformer(tolower))
sms_corpus_clean<-tm_map(sms_corpus,removeNumbers)
sms_corpus_clean<-tm_map(sms_corpus,removeWords,stopwords())
sms_corpus_clean<-tm_map(sms_corpus,removePunctuation)#stemming
sms_corpus_clean<-tm_map(sms_corpus,stemDocument)
sms_corpus_clean<-tm_map(sms_corpus,stripWhitespace)
  #tokenization
sms_dtm<-DocumentTermMatrix(sms_corpus_clean)

#train model
sms_dtm_train<-sms_dtm[1:4169, ]
sms_train_labels<-sms_raw[1:4168, ]$type

#evaluating
  #test model
sms_dtm_test<-sms_dtm[4170:5559, ]
sms_test_labels<-sms_raw[4170:5559, ]$type
str(findFreqTerms(sms_dtm_train,5))
CrossTable(sms_test_pred,sms_test_labels,prop.chisq=FALSE,prop.t=FALSE,dnn=c('prediced','actual'))
