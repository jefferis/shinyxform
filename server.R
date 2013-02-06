library(shiny)

# registrations<-dir("")
source(getOption('gjanalysissuite.startup'))
 
shinyServer(function(input, output) {
    
    select_transform<-reactive(function(){
        RegDir=file.path(dirname(attr(body(function() {}),'srcfile')$filename),'BridgingRegistrations')
        reg=file.path(RegDir,paste(input$to,sep="","_",input$from,".list"))
        if(file.exists(reg)) return(reg)
        else {
            return(paste("Reg not found:",reg))
        }
    })
    output$regpath<-reactiveText(function(){
        select_transform()
    })
    
    xformed_points <- reactive(function() {
        pts=read.table(text=input$input_points)
        if(ncol(pts)==3) {
            colnames(pts)=c('X','Y','Z')
        } else if(ncol(pts)==4) {
            colnames(pts)=c('X','Y','Z','W')
        } else {
            stop("Data must have 3 or 4 columns")
        }
        reg=select_transform()
        if(!is.na(reg) || input$to==input$from){
            xpts=transformedPoints(xyzs=pts[,1:3],warpfile=reg,transforms='warp',gregxoptions='')$warp
            if(ncol(pts)==4)
            xpts=cbind(xpts,pts[,4])
        } else xpts=pts
        xpts
      })
      
    # output$scriptloc <-reactiveText(function() {
    #     dirname(attr(body(function() {}),'srcfile')$filename)})
    # 

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