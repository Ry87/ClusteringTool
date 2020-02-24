library(ggplot2)
library(DT)
library(cluster)
library(ggdendro)


shinyServer(function(input, output) {

  
  ############################
  # Output
  ############################

  output$table <- DT::renderDataTable(ImportedData(),selection = list(target='column'))
  
  output$plot = renderPlot({
    return(GetPlotData())
    })
  
  output$DENDplot = renderPlot({
    return(GetDendrogramData())
  })
  
  
  ############################
  # Get Data
  ############################
  ImportedData <- reactive({if(is.null(input$inputFile)) return(NULL)
    read.csv(input$inputFile$datapath,row.names=1, header = TRUE, sep=",")
  })

  GetGroupInfo <-  function(data){
    if(input$method == "K-means"){info <- kmeans(dist(data),input$clusterNum)$cluster}
    else{info <- cutree(tree=GetTreeInfo(),k= input$clusterNum)}
    info <- paste0("Gr",info)
    return(info)
  }
  
  GetTreeInfo <-  reactive({
    sel <- input$table_columns_selected
    return(hclust(d=dist(ImportedData()[sel]),method=MethodConverter(input$method)))
  })
  
  MethodConverter <- function(method)
  {
    switch(method,
           "Average" = "average", 
           "Ward" = "ward.D2",
           "Single" = "single",
           "Complete" = "complete",
           "Centroid" = "centroid",
           "Median" = "median",
           "Mcquitty" = "mcquitty"
           )
  }

  GetPlotData <-function()
  {
    plot <- NULL
    if(length(input$table_columns_selected > 1))
    {
      data <- ImportedData()[input$table_columns_selected[1:2]]
      group <- GetGroupInfo(data)
      plotData <- data.frame(data,group=group)
      plot <- DrawPlot(plotData)
    }
    return(plot)
  }
  
  GetDendrogramData <-function()
  {
    plot <- NULL
    if(length(input$table_columns_selected > 1))
    {
      if(input$method != "K-means"){
        data <- ImportedData()[input$table_columns_selected[1:2]]
        tree <- GetTreeInfo()
        group <- GetGroupInfo(data)
        plot <- DrawDendrogram(data,tree,group)
      }
    }
    return(plot)
  }
  

  
  ############################
  # Draw Graph
  ############################
  
  DrawPlot <- function(data){
    xColName <-colnames(data[1])
    yColName <- colnames(data[2])
    plot <- ggplot(data, aes(x=data[,1], y=data[,2])) +
      xlab(xColName)+
      ylab(yColName)+
      theme(plot.caption = element_text(size=16),plot.title = element_text(size=16))+
      geom_point(aes(colour=data[["group"]]),cex=3) +
      labs( title=paste0(xColName," vs ",yColName), colour="Group")
    return(plot)
  }
  
  DrawDendrogram <- function(data,clusterHandle,gr){
    names(gr) <- rownames(data)
    dendroData <- dendro_data(clusterHandle,type="rectangle")
    dendroDf <- data.frame(label=names(gr), cluster=factor(gr))
    dendroData[["labels"]] <- merge(dendroData[["labels"]],dendroDf,by="label")
    dendPlot <- ggplot() + 
      geom_segment(data=segment(dendroData), aes(x=x, y=y, xend=xend, yend=yend)) + 
      geom_text(data=label(dendroData), aes(x, y, label=label, hjust=0, color=cluster),size=4) +
      labs(title = "Dendrogram") +
      theme(plot.title = element_text(size=16))
    return(dendPlot)
  }
  
  

})