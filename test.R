library(tm)
library(SnowballC)
library(slam)
library(wordcloud)
library(rCharts)
library(data.table)
library(stringr)
twitter1 <- readRDS("RDS/ tokenized_en_US.twitter _1gram.rds")
twitter2 <- readRDS("RDS/ tokenized_en_US.twitter _2gram.rds")
twitter3 <- readRDS("RDS/ tokenized_en_US.twitter _3gram.rds")
twitter4 <- readRDS("RDS/ tokenized_en_US.twitter _4gram.rds")

#news1 <- readRDS("RDS/ tokenized_en_US.news _1gram.rds")
#news2 <- readRDS("RDS/ tokenized_en_US.news _2gram.rds")
#news3 <- readRDS("RDS/ tokenized_en_US.news _3gram.rds")
#news4 <- readRDS("RDS/ tokenized_en_US.news _4gram.rds")

#blog1 <- readRDS("RDS/ tokenized_en_US.blogs _1gram.rds")
#blog2 <- readRDS("RDS/ tokenized_en_US.blogs _2gram.rds")
#blog3 <- readRDS("RDS/ tokenized_en_US.blogs _3gram.rds")
#blog4 <- readRDS("RDS/ tokenized_en_US.blogs _4gram.rds")




topN <- function(table,n=10){
  sorted_term_frequency <- sort(row_sums(table),decreasing = TRUE)
  topN = head(sorted_term_frequency,n)
  dt <- data.table(word=names(topN),cnt=topN)
  dt[,freq:=100*(cnt/sum(cnt))][,cum_freq:=cumsum(freq)]
}


prepare_look_up_words <- function(table){
  table[,look.up:=word(table$word,1,-2)][,target:=word(table$word,-1)]
  setkey(table,look.up)
}



top20_t1 <- topN(twitter1,20)
top20_t2 <- topN(twitter2,20)
top20_t3 <- topN(twitter3,20)
top20_t4 <- topN(twitter4,20)

#wordcloud(top20_t2$word,freq=top20_t2$cnt,scale=c(5,1),random.order=FALSE,colors=brewer.pal(8, "Dark2"),max.words=20)
#n1 <- nPlot(cnt~cum_freq,top20_t1,type="scatterChart")


#top20_t1 <- prepare_look_up_words(top20_t1)
top20_t2 <- prepare_look_up_words(top20_t2)
top20_t3 <- prepare_look_up_words(top20_t3)
top20_t4 <- prepare_look_up_words(top20_t4)


get_recommendation <- function(word){
  result4 <- top20_t4[word][,list(freq,target)]
  if()
  result3 <- top20_t3[word][,list(freq,target)]
  result2 <- top20_t2[word][,list(freq,target)]
  
}
