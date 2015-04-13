library(tm)
library(SnowballC)
library(slam)
library(RWeka)
library(tools)
options(mc.cores=1)

build <- function(file){
  
  filename <- basename(file_path_sans_ext(file))
  # Read file
  data <- readLines(file)
  
  corpus <- VCorpus(VectorSource(data))
  corpus <- tm_map(corpus, stemDocument,language = ("english"))
  corpus <- tm_map(corpus, stripWhitespace)
  
  # define tokenization functions for 1-, 2-, 3-, 4- grams
  uni_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 1, max = 1))
  bi_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 2, max = 2))
  tri_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 3, max = 3))
  qua_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 4, max = 4))
  
  # create 1-,2-,3-,4- gram
  unigram <- TermDocumentMatrix(corpus, control=list(tokenize = uni_tokenizer))
  bigram <- TermDocumentMatrix(corpus,control=list(tokenize = bi_tokenizer))
  trigram <- TermDocumentMatrix(corpus, control=list(tokenize = tri_tokenizer))
  quagram <- TermDocumentMatrix(corpus, control=list(tokenize = qua_tokenizer))
  
  unigram <- removeSparseTerms(unigram, 0.8)
  bigram <- removeSparseTerms(bigram, 0.8)
  trigram <- removeSparseTerms(trigram, 0.8)
  quagram <- removeSparseTerms(quagram, 0.8)
  
  #Save RDATA
  save(unigram,file=paste("RDATA/",filename,"_1gram.RData"))
  save(bigram,file=paste("RDATA/",filename,"_2gram.RData"))
  save(trigram,file=paste("RDATA/",filename,"_3gram.RData"))
  save(quagram,file=paste("RDATA/",filename,"_4gram.RData"))
  
  #Save RDS
  saveRDS(unigram,file=paste("RDS/",filename,"_1gram.rds"))
  saveRDS(bigram,file=paste("RDS/",filename,"_2gram.rds"))
  saveRDS(trigram,file=paste("RDS/",filename,"_3gram.rds"))
  saveRDS(quagram,file=paste("RDS/",filename,"_4gram.rds"))
}

build('dataset//en_US//tokenized_en_US.blogs.txt')
build('dataset//en_US//tokenized_en_US.news.txt')
build('dataset//en_US//tokenized_en_US.twitter.txt')
build('dataset//en_US//tokenized_data.txt')
