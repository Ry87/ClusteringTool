
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
    
    
    #mainPanel(
    #        fluidPage(
    #          column(6,plotOutput('plot')),
    #          column(6,plotOutput("PCAplot"))
    #        ),
    #        fluidPage(
    #          column(6,plotOutput("DENDplot")),
    #          column(6,plotOutput("RadarChart"))
    #        )
    #   inputId = "main",
    #   plotOutput('plot'),
    #   bsModal("pcamodal", "Principal Component Analysis", "pca", size = "large",plotOutput("PCAplot")),
    #   bsModal("dendmodal", "Dendrogram", "dend", size = "large",plotOutput("DENDplot")),
    #   bsModal("radarmodal", "RadarChart", "radar", size = "large",plotOutput("RadarChart")),
    #   bsModal("histmodal", "Histgram", "hist", size = "large",plotOutput("Histgram"))
    # ),
    # column(2,
    # inputId = "aaaa",
    # actionButton(inputId="pca", "PCA"),
    # actionButton(inputId = "dend", "Dendrogram"),
    # actionButton(inputId = "radar", "Radial Chart"),
    # actionButton(inputId = "hist", "Histgram"))
  #)
  )
))





