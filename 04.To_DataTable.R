library(tm)
library(SnowballC)
library(slam)
library(data.table)

to_datatable_unigram <- function(){
  load("RDATA/tokenized_data_unigram.RData")
  unigram <- to_frequency_table(unigram)
  save(unigram,file=paste0("RDATA/","uni_table.RData"))
}

to_datatable_bigram <- function(){
  load("RDATA/tokenized_data_bigram.RData")
  bigram <- to_frequency_table(bigram)
  save(bigram,file=paste0("RDATA/","bi_table.RData"))
}

to_datatable_trigram <- function(){
  load("RDATA/tokenized_data_trigram.RData")
  trigram <- to_frequency_table(trigram)
  save(trigram,file=paste0("RDATA/","tri_table.RData"))
}

to_datatable_quagram <- function(){
  load("RDATA/tokenized_data_quagram.RData")
  quagram <- to_frequency_table(quagram)
  save(quagram,file=paste0("RDATA/","qua_table.RData"))
}

to_frequency_table <- function(table){
  term_frequency <- sort(row_sums(table),decreasing=TRUE)
  dt <- data.table(word=names(term_frequency),cnt=term_frequency)
  dt[,freq:=100*(cnt/sum(cnt))][,cum_freq:=cumsum(freq)][,idx:=.I]
}

to_datatable_unigram()
to_datatable_bigram()
to_datatable_trigram()
to_datatable_quagram()