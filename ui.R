
shinyUI(fluidPage(
  titlePanel("Clustering Tool"),
  
  sidebarLayout(
    sidebarPanel(
           fileInput(inputId = "inputFile", 
                     label = "Import csv:"), 
           selectInput(inputId = "dataset",
                       label = "Set clustering method :",
                       choices = c("Average", "Ward", "K-means")),
           sliderInput(inputId = "bins",
                       label = "Set number of clusters:",
                       min = 2,
                       max = 10,
                       value = 2)
    ),
    
    mainPanel(tabsetPanel(
      tabPanel("Data",DT::dataTableOutput("contents")),
      tabPanel("Plot",plotOutput("plot")),
      tabPanel("Dendrogram",plotOutput("DENDplot"))
    ))
    

  )
))





