load("uni_gram.RData")
load("bi_gram.RData")
load("tri_gram.RData")
load("qua_gram.RData")

library(shiny)
library(wordcloud)
library(rCharts)
source(file = "utility.R",local = TRUE)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {
  
  dataInput <- reactive(predict(input$input))
  
  output$top1 <- renderText({
    paste("Top 1:", input$input, dataInput()$target[1])
  })
  output$top2 <- renderText({
    paste("Top 2:", input$input, dataInput()$target[2])
  })
  output$top3 <- renderText({
    paste("Top 3:", input$input, dataInput()$target[3])
  })
  output$top4 <- renderText({
    paste("Top 4:", input$input, dataInput()$target[4])
  })
  output$top5 <- renderText({
    paste("Top 5:", input$input, dataInput()$target[5])
  })
  
  output$sent <- renderText({
    input$input
  })
  
  wordcloud_rep <- repeatable(wordcloud)
  output$wordCloud <- renderPlot({
    wordcloud(unique(dataInput()$target),dataInput()$score,colors=brewer.pal(8, 'Dark2'),rot.per=0.25,random.order = TRUE)
  })
  
  output$myChart <- renderChart2({
    p <- nPlot(score~target,data=dataInput(),group="src",type="multiBarHorizontalChart")
    p$yAxis(tickFormat = "#! function(d) {return (d*100).toFixed(2) } !#")
    p$yAxis(axisLabel = 'Count')
    p$set(width=500)
    return(p)})
  
  output$tokenizer<-renderText({"http://nlp.stanford.edu/software/tokenizer.shtml

- It was initially designed to largely mimic Penn Treebank 3 (PTB) tokenization                               
- Over time the tokenizer has added quite a few options and a fair amount of Unicode compatibility                                
- Tokenize text at a rate of about 200,000 tokens per second                                
- PTBTokenizer mainly targets formal English writing rather than SMS-speak
                                
export CLASSPATH=stanford-parser.jar
$ cat >sample.txt
\"Oh, no,\" she's saying, \"our $400 blender can't handle something this hard!\"
$ java edu.stanford.nlp.process.PTBTokenizer sample.txt
``
Oh
,
no
,
''
she
's
saying
,
``
our
$
400
blender
ca
n't
handle
something
this
hard
!
''
PTBTokenizer tokenized 23 tokens at 370.97 tokens per second."})
  
  
  output$tokencleaner<-renderText({"- Converting to lower case
- Removing numbers
- Removing Punctuations
- Removing Foreign words
- Removing extra white spaces 

_digits = re.compile('\\d')
_nonenglish = re.compile('[\\x80-\\xFF]')
...
"})
  
  output$ngram<-renderText({"R packages: tm,RWeka,slam,SnowballC

corpus <- VCorpus(VectorSource(data))
corpus <- tm_map(corpus, stemDocument,language = (\"english\"))
  
# define tokenization functions for 1-, 2-, 3-, 4- grams
uni_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 1, max = 1))
bi_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 2, max = 2))
tri_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 3, max = 3))
qua_tokenizer <- function(t) NGramTokenizer(t, Weka_control(min = 4, max = 4))
                            
# create 1-,2-,3-,4- gram
unigram <- TermDocumentMatrix(corpus, control=list(tokenize = uni_tokenizer,stopwords=FALSE,wordLengths=c(1,Inf)))
bigram <- TermDocumentMatrix(corpus,control=list(tokenize = bi_tokenizer,stopwords=FALSE,wordLengths=c(1,Inf)))
trigram <- TermDocumentMatrix(corpus, control=list(tokenize = tri_tokenizer,stopwords=FALSE,wordLengths=c(1,Inf)))
quagram <- TermDocumentMatrix(corpus, control=list(tokenize = qua_tokenizer,stopwords=FALSE,wordLengths=c(1,Inf)))
"})
  
  output$filesize <- renderChart2({
    data <- data.table(File=c("Blogs","News","Twitter"),Size=c(210.2,205.8,167.1),LineCount=c(899288,1010242,2360148),WordCount=c(37334690,34372720,30374206))
    p <- nPlot(Size~File,data=data,type="discreteBarChart")
    p$yAxis(tickFormat = "#! function(d) {return d+'MB' } !#")
    p$set(width=400,height=400)
    return(p)})
  
  output$linecount <- renderChart2({
    data <- data.table(File=c("Blogs","News","Twitter"),Size=c(210.2,205.8,167.1),LineCount=c(899288,1010242,2360148),WordCount=c(37334690,34372720,30374206))
    p <- nPlot(LineCount~File,data=data[order(LineCount),],type="discreteBarChart")
    p$yAxis(tickFormat = "#! function(d) {return (d/1000000).toFixed(2)+'m' } !#")
    p$set(width=400,height=400)
    return(p)})
  
  output$wordcount <- renderChart2({
    data <- data.table(File=c("Blogs","News","Twitter"),Size=c(210.2,205.8,167.1),LineCount=c(899288,1010242,2360148),WordCount=c(37334690,34372720,30374206))
    p <- nPlot(WordCount~File,data=data,type="discreteBarChart")
    p$yAxis(tickFormat = "#! function(d) {return (d/1000000).toFixed(2)+'m' } !#")
    p$set(width=400,height=400)
    return(p)})
  
  output$topunigram <- renderChart2({
    top15_word_unigram <- head(unigram[order(-cnt),],15)
    bar_unigram <- nPlot(cnt~word,data=top15_word_unigram,type="discreteBarChart")
    bar_unigram$yAxis(tickFormat = "#! function(d) {return (d/1000000).toFixed(2) + 'm' } !#")
    bar_unigram$yAxis(axisLabel = 'Count',width=60)
    bar_unigram$set(title = "Top 15 words in unigram")
    return(bar_unigram)})
  
  output$topbigram <- renderChart2({
    top15_word_bigram <- head(bigram[order(-cnt),],15)
    bar_bigram<- nPlot(cnt~word,data=top15_word_bigram,type="discreteBarChart")
    bar_bigram$yAxis(tickFormat = "#! function(d) {return (d/1000).toFixed(2) + 'k' } !#")
    bar_bigram$yAxis(axisLabel = 'Count',width=60)
    bar_bigram$set(title = "Top 15 words in unigram")
    return(bar_bigram)})
  
  output$toptrigram <- renderChart2({
    top15_word_trigram <- head(trigram[order(-cnt),],15)
    bar_trigram <- nPlot(cnt~word,data=top15_word_trigram,type="discreteBarChart")
    bar_trigram$xAxis(rotateLabels=-20)
    bar_trigram$yAxis(tickFormat = "#! function(d) {return (d/1000).toFixed(2) + 'k' } !#")
    bar_trigram$yAxis(axisLabel = 'Count',width=60)
    bar_trigram$set(title = "Top 15 words in unigram")
    return(bar_trigram)})
  
  output$topquagram <- renderChart2({
    top15_word_quagram <- head(quagram[order(-cnt),],15)
    bar_quagram <- nPlot(cnt~word,data=top15_word_quagram,type="discreteBarChart")
    bar_quagram$xAxis(rotateLabels=-20)
    bar_quagram$yAxis(tickFormat = "#! function(d) {return (d/1000).toFixed(2) + 'k' } !#")
    bar_quagram$yAxis(axisLabel = 'Count',width=60)
    return(bar_quagram)})
  
})
