
shinyUI(fluidPage(
  titlePanel("Clustering Tool"),
  
  sidebarLayout(
    sidebarPanel(
           fileInput(inputId = "inputFile", 
                     label = "Import csv:"), 
           selectInput(inputId = "method",
                       label = "Set clustering method :",
                       choices = c("Average", "Ward","Single","Complete","Centroid","Median","Mcquitty", "K-means")),
           sliderInput(inputId = "clusterNum",
                       label = "Set number of clusters:",
                       min = 2,
                       max = 10,
                       value = 2)
    ),
    
    mainPanel(tabsetPanel(
      tabPanel("Data",DT::dataTableOutput("table")),
      tabPanel("Plot",plotOutput("plot")),
      tabPanel("Dendrogram",plotOutput("DENDplot"))
    ))
    

  )
))





