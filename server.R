library(shiny)

shinyServer(function(input, output) {

    xformed_points <- reactive(function() {
        pts=read.table(text=input$input_points)
        if(ncol(pts)==3) {
            colnames(pts)=c('X','Y','Z')
        } else if(ncol(pts)==4) {
            colnames(pts)=c('X','Y','Z','W')
        } else {
            stop("Data must have 3 or 4 columns")
        }
        pts
      })

    output$view <- reactiveTable(function() {
        head(xformed_points(),5)
        })
    output$xform <- reactiveText(function() {
        paste(input$from,sep="->",input$to)
        })
    output$downloadResults <- downloadHandler(
        filename = function() {  paste('transformed-', Sys.Date(), '.txt', sep='') },
        content = function(file) {
          write.table(xformed_points(), file, col.names=TRUE,row.names=FALSE)
        }
      )
})