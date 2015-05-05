load('RDATA/uni_table.RData')
load('RDATA/bi_table.RData')
load('RDATA/tri_table.RData')
load('RDATA/qua_table.RData')
library(data.table)


wordcloud_unigram <- head(unigram,100)
wordcloud_bigram <- head(bigram,100)
wordcloud_trigram <- head(trigram,100)
wordcloud_quagram <- head(quagram,100)
library(wordcloud)
png("WordCloud_new.png",width = 800, height = 600)
par(mfrow=c(2,2))
wordcloud(wordcloud_unigram$word, wordcloud_unigram$cnt, max.words = 100, colors=brewer.pal(6, 'Dark2'),scale=c(4,2),rot.per=0.25,random.order = TRUE)
wordcloud(wordcloud_bigram$word, wordcloud_bigram$cnt, max.words = 100, colors=brewer.pal(6, 'Dark2'),scale=c(3,0.8),rot.per=0.25,random.order = TRUE)
wordcloud(wordcloud_trigram$word, wordcloud_trigram$cnt, max.words = 100, colors=brewer.pal(6, 'Dark2'),scale=c(3,0.8),rot.per=0.25,random.order = TRUE)
wordcloud(wordcloud_quagram$word, wordcloud_quagram$cnt, max.words = 100, colors=brewer.pal(6, 'Dark2'),scale=c(2,0.5),rot.per=0.35,random.order = TRUE)
dev.off()

top15_word_unigram <- head(wordcloud_unigram,15)
top15_word_bigram <- head(wordcloud_bigram,15)
top15_word_trigram <- head(wordcloud_trigram,15)
top15_word_quagram <- head(wordcloud_quagram,15)
library(rCharts)
bar_unigram <- nPlot(cnt~word,data=top15_word_unigram,type="discreteBarChart")
bar_unigram$yAxis(tickFormat = "#! function(d) {return (d/1000000).toFixed(2) + 'm' } !#")
bar_unigram$yAxis(axisLabel = 'Count',width=60)
bar_unigram$set(title = "Top 15 words in unigram")
bar_unigram

bar_bigram<- nPlot(cnt~word,data=top15_word_bigram,type="discreteBarChart")
bar_bigram$yAxis(tickFormat = "#! function(d) {return (d/1000).toFixed(2) + 'k' } !#")
bar_bigram$yAxis(axisLabel = 'Count',width=60)
bar_bigram$set(title = "Top 15 words in unigram")
bar_bigram

bar_trigram <- nPlot(cnt~word,data=top15_word_trigram,type="discreteBarChart")
bar_trigram$xAxis(rotateLabels=-20)
bar_trigram$yAxis(tickFormat = "#! function(d) {return (d/1000).toFixed(2) + 'k' } !#")
bar_trigram$yAxis(axisLabel = 'Count',width=60)
bar_trigram$set(title = "Top 15 words in unigram")
bar_trigram

bar_quagram <- nPlot(cnt~word,data=top15_word_quagram,type="discreteBarChart")
bar_quagram$xAxis(rotateLabels=-20)
bar_quagram$yAxis(tickFormat = "#! function(d) {return (d/1000).toFixed(2) + 'k' } !#")
bar_quagram$yAxis(axisLabel = 'Count',width=60)
bar_quagram

library(reshape2)
library(ggplot2)
unigram_row_num <- nrow(unigram)
unigram_data_point_90 <- unigram[which.min(abs(unigram$cum_freq-90)),]
unigram_data_point_50 <- unigram[which.min(abs(unigram$cum_freq-50)),]
data_point_last <- unigram[unigram_row_num,]
word_coverage_unigram <- ggplot(unigram[, .SD[.N], by=cnt],aes(x=(idx/unigram_row_num*100),y=cum_freq))
word_coverage_unigram <- word_coverage_unigram + geom_line()+
  xlab("% of unique words") +
  ylab("% of word instances") +
  geom_point(data=unigram_data_point_50,colour = I("red"), size = I(3))+
  geom_point(data=unigram_data_point_90,colour = I("red"), size = I(3))+
  geom_point(data=data_point_last,colour = I("red"), size = I(3))+
  geom_text(data=unigram_data_point_50,aes(label=paste(idx,"words",round(unigram_data_point_50$idx/unigram_row_num*100,2),"%",sep=" ")),hjust=-0.1,vjust=1)+
  geom_text(data=unigram_data_point_90,aes(label=paste(idx,"words",round(unigram_data_point_90$idx/unigram_row_num*100,2),"%",sep=" ")),hjust=-0.1,vjust=1) +
  geom_text(data=data_point_last,aes_string(label='idx'),hjust=1,vjust=1.5) +
  scale_x_continuous(breaks = c(seq(0,100, by = 10))) +
  scale_y_continuous(breaks = c(seq(0,100, by = 10)))+
  theme(text = element_text(size=16)) +
  ggtitle("Word Coverage - Unigram")




bigram_row_num <- nrow(bigram)
bigram_data_point_90 <- bigram[which.min(abs(bigram$cum_freq-90)),]
bigram_data_point_50 <- bigram[which.min(abs(bigram$cum_freq-50)),]
data_point_last <- bigram[bigram_row_num,]
word_coverage_bigram <- ggplot(bigram[, .SD[.N], by=cnt],aes(x=(idx/bigram_row_num*100),y=cum_freq))
word_coverage_bigram <- word_coverage_bigram + geom_line()+
  xlab("% of unique grams") +
  ylab("% of gram instances") +
  geom_point(data=bigram_data_point_50,colour = I("red"), size = I(3))+
  geom_point(data=bigram_data_point_90,colour = I("red"), size = I(3))+
  geom_point(data=data_point_last,colour = I("red"), size = I(3))+
  geom_text(data=bigram_data_point_50,aes(label=paste(idx,"grams",round(bigram_data_point_50$idx/bigram_row_num*100,2),"%",sep=" ")),hjust=-0.1,vjust=1)+
  geom_text(data=bigram_data_point_90,aes(label=paste(idx,"grams",round(bigram_data_point_90$idx/bigram_row_num*100,2),"%",sep=" ")),hjust=-0.1,vjust=1) +
  geom_text(data=data_point_last,aes_string(label='idx'),hjust=1,vjust=1.5) +
  scale_x_continuous(breaks = c(seq(0,100, by = 10))) +
  scale_y_continuous(breaks = c(seq(0,100, by = 10)))+
  theme(text = element_text(size=16)) +
  ggtitle("Word Coverage - 2-gram")




trigram_row_num <- nrow(trigram)
trigram_data_point_90 <- trigram[which.min(abs(trigram$cum_freq-90)),]
trigram_data_point_50 <- trigram[which.min(abs(trigram$cum_freq-50)),]
data_point_last <- trigram[trigram_row_num,]
word_coverage_trigram <- ggplot(trigram[, .SD[.N], by=cnt],aes(x=(idx/trigram_row_num*100),y=cum_freq))
word_coverage_trigram <- word_coverage_trigram + geom_line()+
  xlab("% of unique grams") +
  ylab("% of gram instances") +
  geom_point(data=trigram_data_point_50,colour = I("red"), size = I(3))+
  geom_point(data=trigram_data_point_90,colour = I("red"), size = I(3))+
  geom_point(data=data_point_last,colour = I("red"), size = I(3))+
  geom_text(data=trigram_data_point_50,aes(label=paste(idx,"grams",round(trigram_data_point_50$idx/trigram_row_num*100,2),"%",sep=" ")),hjust=-0.1,vjust=1)+
  geom_text(data=trigram_data_point_90,aes(label=paste(idx,"grams",round(trigram_data_point_90$idx/trigram_row_num*100,2),"%",sep=" ")),hjust=1.2) +
  geom_text(data=data_point_last,aes_string(label='idx'),hjust=1,vjust=2.5) +
  scale_x_continuous(breaks = c(seq(0,100, by = 10))) +
  scale_y_continuous(breaks = c(seq(0,100, by = 10)))+
  theme(text = element_text(size=16)) +
  ggtitle("Word Coverage - 3-gram")


quagram_row_num <- nrow(quagram)
quagram_data_point_90 <- quagram[which.min(abs(quagram$cum_freq-90)),]
quagram_data_point_50 <- quagram[which.min(abs(quagram$cum_freq-50)),]
data_point_last <- quagram[quagram_row_num,]
word_coverage_quagram <- ggplot(quagram[, .SD[.N], by=cnt],aes(x=(idx/quagram_row_num*100),y=cum_freq))
word_coverage_quagram <- word_coverage_quagram + geom_line()+
  xlab("% of unique grams") +
  ylab("% of gram instances") +
  geom_point(data=quagram_data_point_50,colour = I("red"), size = I(3))+
  geom_point(data=quagram_data_point_90,colour = I("red"), size = I(3))+
  geom_point(data=data_point_last,colour = I("red"), size = I(3))+
  geom_text(data=quagram_data_point_50,aes(label=paste(idx,"grams",round(quagram_data_point_50$idx/quagram_row_num*100,2),"%",sep=" ")),hjust=-0.1,vjust=1)+
  geom_text(data=quagram_data_point_90,aes(label=paste(idx,"grams",round(quagram_data_point_90$idx/quagram_row_num*100,2),"%",sep=" ")),hjust=1.2) +
  geom_text(data=data_point_last,aes_string(label='idx'),hjust=1.5) +
  scale_x_continuous(breaks = c(seq(0,100, by = 10))) +
  scale_y_continuous(breaks = c(seq(0,100, by = 10)))+
  theme(text = element_text(size=16)) +
  ggtitle("Word Coverage - 4-gram")

require(gridExtra)
grid.arrange(word_coverage_unigram,word_coverage_bigram,word_coverage_trigram,word_coverage_quagram,ncol=2)
