load('RDATA/uni_table.RData')
load('RDATA/bi_table.RData')
load('RDATA/tri_table.RData')
load('RDATA/qua_table.RData')
library(data.table)
library(stringr)
prepare_look_up_words <- function(table){
  table[,look.up:=word(table$word,1,-2)][,target:=word(table$word,-1)]
}


unigram<-unigram[cum_freq<=90,][,list(word,cnt,freq)]
unigram[,look.up:=unigram$word][,target:=unigram$word]
save(unigram,file="application/uni_gram.RData")

bigram<-bigram[cnt>3,][,list(word,cnt)]
bigram <- prepare_look_up_words(bigram)
save(bigram,file="application/bi_gram.RData")

trigram <- trigram[cnt>2,][,list(word,cnt)]
trigram <- prepare_look_up_words(trigram)
save(trigram,file="application/tri_gram.RData")

quagram <- quagram[cnt>2,][,list(word,cnt)]
quagram <- prepare_look_up_words(quagram)
save(quagram,file="application/qua_gram.RData")
