library(shiny)
require(markdown)
require(rCharts)
shinyUI(
  navbarPage("SwiftKey Word Prediction", inverse = FALSE, collapsible = FALSE, 
             tabPanel("Overview",
                      fluidRow(
                        mainPanel(
                          h1("Overview"),
                          br(),
                          p("The goal of this project is to allow a user to input a phrase into the application, and it would predict the next word that they “most likely” want to type."),
                          br(),
                          p("The primary use case for this application is text messaging on mobile phones."),
                          br(),
                          h1("Tasks"),
                          img(src = "flow.png",height="40%",width="150%",align="center")
                          ))),
             tabPanel("Data Processing",
                      fluidRow(
                        sidebarPanel(width=3,
                                     h3("Tokenization Flow"),
                                     img(src="tokenization.png",height="180%",width="100%",align="center")
                        ),
                        mainPanel(
                          tabsetPanel(
                            id="dpr",
                            tabPanel("Stanford Tokenizer",verbatimTextOutput("tokenizer")), 
                            tabPanel("Token Cleaner",verbatimTextOutput("tokencleaner")), 
                            tabPanel("N-gram Generator", verbatimTextOutput("ngram"))
                          )))),
             tabPanel("Exploratory Analysis",
                      fluidRow(
                        mainPanel(
                          column(4,
                                 h3("Data File Size"),hr(),
                                 showOutput("filesize", "nvd3")
                                 ),
                          column(4,
                                 h3("Line Counts"),hr(),
                                 showOutput("linecount", "nvd3")
                          ),
                          column(4,
                                 h3("Word Counts"),hr(),
                                 showOutput("wordcount", "nvd3")
                          ),
                          column(10,
                                 h3("Word Cloud - Top 100"),hr(),
                                 img(src="wordcloud.png",height="100%",width="100%",align="center")
                          ),
                          column(10,
                                 h3("Word Coverage"),hr(),
                                 img(src="wordcoverage.png",height="150%",width="100%",align="center")
                          ),
                          column(12,
                                 h3("Top 15 1-Gram"),hr(),
                                 showOutput("topunigram", "nvd3")
                          ),
                          column(12,
                                 h3("Top 15 2-Gram"),hr(),
                                 showOutput("topbigram", "nvd3")
                          ),
                          column(12,
                                 h3("Top 15 3-Gram"),hr(),
                                 showOutput("toptrigram", "nvd3")
                          ),
                          column(12,
                                 h3("Top 15 4-Gram"),hr(),
                                 showOutput("topquagram", "nvd3")
                          )
                          ))),
             tabPanel("Application", 
                      fluidRow(
                        sidebarPanel(width=3,
                                     h5("Input:"),
                                     textInput("input", 
                                               "Please type your words here:",
                                               "Nice to meet you")
                                     ),
                        
                        mainPanel(
                          column(5,
                                 h3("Word Prediction"),hr(),
                                 h5('The sentence you just typed:'),                             
                                 wellPanel(span(h4(textOutput('sent')),style = "color:#428ee8")),
                                 hr(),
                                 h5('Top 5 Possible Single Word Predictions:'),
                                 wellPanel(span(h4(textOutput('top1')),style = "color:#e86042"),
                                           span(h5(textOutput('top2')),style = "color:#2b8c1b"),
                                           span(h5(textOutput('top3')),style = "color:#2b8c1b"),
                                           span(h5(textOutput('top4')),style = "color:#2b8c1b"),
                                           span(h5(textOutput('top5')),style = "color:#2b8c1b"))
                          ),
                          column(5,
                                 h3("Stupid Backoff Scores"),hr(),
                                 showOutput("myChart", "nvd3")
                          ),
                          column(5,
                                 h3("Word Cloud"),hr(),
                                 h5("A", code("word cloud"), "or data cloud is a data display which uses font size and/
                                              or color to indicate numerical values like frequency of words."),
                                 plotOutput("wordCloud")
                          )
                          )
                        )
             )
  )
)
