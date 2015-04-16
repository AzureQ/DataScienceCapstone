library(tm)
library(SnowballC)
library(slam)
library(data.table)
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

top20_t1 <- topN(twitter1,20)
top20_t2 <- topN(twitter2,20)
top20_t3 <- topN(twitter3,20)
top20_t4 <- topN(twitter4,20)
