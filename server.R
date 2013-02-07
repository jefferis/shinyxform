library(shiny)

# registrations<-dir("")
source(getOption('gjanalysissuite.startup'))
 
shinyServer(function(input, output) {
    
    select_transform<-reactive(function(){
        rval=list(reg=NA,inverse=TRUE)
        RegDir=file.path(dirname(attr(body(function() {}),'srcfile')$filename),'BridgingRegistrations')
        rval$reg=file.path(RegDir,paste(input$to,sep="","_",input$from,".list"))
        
        if(!file.exists(rval$reg)) {
            # try and look for inverse
            ireg=file.path(RegDir,paste(input$from,sep="","_",input$to,".list"))
            if(file.exists(ireg)) {
                rval$reg=ireg
                rval$inverse=FALSE
            } else {
                rval$reg=paste("Reg not found:",rval$reg)
            }
        }
        rval
    })
    output$regpath<-reactiveText(function(){
        select_transform()$reg
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
        reglist=select_transform()
        if(!is.na(reg) || input$to==input$from){
            xpts=transformedPoints(xyzs=pts[,1:3],warpfile=reglist$reg,
                transforms='warp',gregxoptions='',
                direction=ifelse(reglist$inverse,'inverse','forward'))$warp
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