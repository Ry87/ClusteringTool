
library(reshape2)
library(ggplot2)
library(DT)
library(cluster)


source("http://aoki2.si.gunma-u.ac.jp/R/src/radar.R", encoding="euc-jp") 

shinyServer(function(input, output) {


  data_set <- reactive({if(is.null(input$inputFile)) return(NULL)
    read.csv(input$inputFile$datapath,row.names=1, header = TRUE, sep=",")
  })
  

  
  output$plot = renderPlot(
    {
      df <- data_set()
      gp <- NULL
      sel <- input$contents_columns_selected
      if (!is.null(df)){
        if (length(sel)) {
          gp <- {
            plot(df[sel],pch=as.character(df[,1]), cex = 2,col =clus_color())
            
            }
        }
      }
      return(gp)
    })
  
  
  dendGroup <-  reactive({
    sel <- input$contents_columns_selected
    switch(input$dataset,
           "Average" = hclust(d=dist(data_set()[sel]),method="average"),
           "Ward" = hclust(d=dist(data_set()[sel]),method="ward.D2")
    )
  })
  output$DENDplot = renderPlot({
    df <- data_set()
    gp <- NULL
    if (!is.null(df)){
      sel <- input$contents_columns_selected
      if (length(sel)) {
        plot(dendGroup(),xlab = "")
        gp <- rect.hclust(dendGroup(), k=input$bins, border = rainbow(input$bins))
      }
    }
    return(gp)
  })
  
  output$RadarChart = renderPlot({
    df <- data_set()
    gp <- NULL
    if (!is.null(df)){
      sel <- input$contents_columns_selected
      if (length(sel)) {
        gp <- radar(data_set()[sel],col = clus_color())
      }
    }
    return(gp)
  })
  


  histdata <- reactive({
    col = PCAgroup()
    for (i in 1:length(col)){
      if (col[i] == 1) col[i]="A"
      if (col[i] == 2) col[i]="B"
      if (col[i] == 3) col[i]="C"
      if (col[i] == 4) col[i]="D"
      if (col[i] == 5) col[i]="E"
    }
    return(col)
  })
  
  clus_color <- reactive({
    col = PCAgroup()
    for (i in 1:length(col)){
      col[i] = rainbow(input$bins)[PCAgroup()[i]]
    }
    return(col)
  })
  
  PCAgroup <-  reactive({
    sel <- input$contents_columns_selected
    switch(input$dataset,
           "Average" = cutree(tree=dendGroup(),k= input$bins),
           "Ward" = cutree(tree=dendGroup(),k= input$bins),
           "K-means" = kmeans(dist(data_set()[sel]),input$bins)$cluster
    )
  })
  sotedData <- reactive({
    hoge <- data.frame(data_set(),group=PCAgroup())
    lis <- order(hoge$group)
    lis2 <- hoge[lis,]
    hoge <- lis2[,colnames(lis2)!="group"]
    return (hoge)
  })

  output$PCAplot = renderPlot({
      df <- data_set()
      gp <- NULL
      if (!is.null(df)){
        sel <- input$contents_columns_selected
        if (length(sel)) {
          df <-sotedData()
          gp <- clusplot(df[sel], pch=as.character(df[,1]),col.p =clus_color() ,col.clus =rainbow(input$bins),PCAgroup(), cex = 2,color=TRUE,shade=TRUE,labels=FALSE,plotchar=FALSE, lines=0)
        }
      }
      return(gp)
    })
  
  observeEvent(input$show, {
  })

  output$contents <- DT::renderDataTable(data_set(),selection = list(target='column'))
  

})
