library(tm)
library(SnowballC)
library(slam)
require(stringr); require(data.table)

stanford_tokenizer <- "export CLASSPATH=stanford-parser.jar;java edu.stanford.nlp.process.PTBTokenizer -preserveLines -options untokenizable=noneDelete,normalizeParentheses=false,normalizeOtherBrackets=false "
token_cleaner <- "python token_cleaner.py"

tokenize <- function(txt) {
  tokens <- try(system(stanford_tokenizer, intern = TRUE,input=txt))
  tokens <- try(system(token_cleaner, intern = TRUE,input=tokens))
  if(identical(tokens,character(0))){
    return(character(0))
  }
  tokens <- wordStem(unlist(str_split(str_trim(tokens)," ")))
  tokens <- str_trim(paste(tokens,collapse = " "))
  return(tokens)
}


predict_4gram <- function(words){
  setkey(quagram,look.up)
  ngram <- quagram[look.up==words,]
  if(nrow(ngram)>0){
    setkey(ngram,"look.up")
    setkey(trigram,"word")
    ngram <- ngram[trigram,nomatch=0][,score:=cnt/i.cnt]
    return(head(ngram[,list(look.up,target,cnt,score)][,src:="4-gram"][order(-score)]))
  }
  return(data.table())
}

predict_3gram <- function(words){
  setkey(trigram,look.up)
  ngram <- trigram[look.up==words,]
  if(nrow(ngram)>0){
    setkey(ngram,"look.up")
    setkey(bigram,"word")
    ngram <- ngram[bigram,nomatch=0][,score:=0.4*cnt/i.cnt]
    return(head(ngram[,list(look.up,target,cnt,score)][,src:="3-gram"][order(-score)]))
  }
  return(data.table())
}

predict_2gram <- function(words){
  setkey(bigram,look.up)
  ngram <- bigram[look.up==words,]
  if(nrow(ngram)>0){
    setkey(ngram,"look.up")
    setkey(unigram,"word")
    ngram <- ngram[unigram,nomatch=0][,score:=0.4*0.4*cnt/i.cnt]
    return(head(ngram[,list(look.up,target,cnt,score)][,src:="2-gram"][order(-score)]))
  }
  return(data.table())
}


predict <- function(words){
  words <- tokenize(words)
  predict <- data.table()
  if (identical(words,character(0))){
    return(rbind(predict, head(unigram[,score:=0.4*0.4*freq][,list(look.up,target,cnt,score)][,src:="1-gram"][order(-score)])))
  }
  
  str <- unlist(str_split(words," "))
  len <- length(str)
  predict <- data.table()
  if (len>=3){
    ngram <- predict_4gram(paste(tail(str,3),collapse = " "))
    predict <- head(ngram)
    
    if(nrow(predict)<6){
      ##trigram
      ngram <- predict_3gram(paste(tail(str,2),collapse = " "))
      predict <- rbind(predict,head(ngram))    
    }
    
    if(nrow(predict)<6){
      ##bigram
      ngram <- predict_2gram(paste(tail(str,1),collapse = " "))
      predict <- rbind(predict,head(ngram))        
    }
    
  }else if(len==2){
    ngram <- predict_3gram(paste(tail(str,2),collapse = " "))
    predict <- head(ngram)
    if(nrow(predict)<6){
      ##bigram
      ngram <- predict_2gram(paste(tail(str,1),collapse = " "))
      predict <- rbind(predict,head(ngram))        
    }
  }else if (len==1){
    ngram <- predict_2gram(paste(tail(str,1),collapse = " "))
    predict <- head(ngram)
  }
  
  #predict <- predict[!is.na(predict)]
  if(nrow(predict)<5){
    predict <- rbind(predict, head(unigram[,score:=0.4*0.4*freq][,list(look.up,target,cnt,score)][,src:="1-gram"][order(-score)]))
  }
  print(predict)
  return(predict)
}