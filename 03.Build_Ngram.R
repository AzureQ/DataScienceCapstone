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
  #corpus <- tm_map(corpus, stemDocument,language = ("english"))
  
  # define tokenization functions for 1-, 2-, 3-, 4- grams
  uni_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 1, max = 1))
  bi_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 2, max = 2))
  tri_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 3, max = 3))
  qua_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 4, max = 4))
  
  # create 1-,2-,3-,4- gram
  unigram <- TermDocumentMatrix(corpus, control=list(tokenize = uni_tokenizer,stopwords=FALSE,wordLengths=c(1,Inf)))
  save(unigram,file=paste0("RDATA/",filename,"_unigram.RData"))
  #saveRDS(unigram,file=paste0("RDS/",filename,"_1gram.rds"))
  
  bigram <- TermDocumentMatrix(corpus,control=list(tokenize = bi_tokenizer,stopwords=FALSE,wordLengths=c(1,Inf)))
  save(bigram,file=paste0("RDATA/",filename,"_bigram.RData"))
  #saveRDS(bigram,file=paste0("RDS/",filename,"_2gram.rds"))
  
  trigram <- TermDocumentMatrix(corpus, control=list(tokenize = tri_tokenizer,stopwords=FALSE,wordLengths=c(1,Inf)))
  save(trigram,file=paste0("RDATA/",filename,"_trigram.RData"))
  #saveRDS(trigram,file=paste0("RDS/",filename,"_3gram.rds"))
  
  quagram <- TermDocumentMatrix(corpus, control=list(tokenize = qua_tokenizer,stopwords=FALSE,wordLengths=c(1,Inf)))
  save(quagram,file=paste0("RDATA/",filename,"_quagram.RData"))
  #saveRDS(quagram,file=paste0("RDS/",filename,"_4gram.rds"))
}

#build('dataset//en_US//tokenized_en_US.blogs.txt')
#build('dataset//en_US//tokenized_en_US.news.txt')
#build('dataset//en_US//tokenized_en_US.twitter.txt')
build('dataset//en_US//tokenized_data.txt')