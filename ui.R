library(shiny)

templateList=list("T1 (Yu et al 2010, Dickson, IMP)" = "T1", 
       "IS2 (Cachero, Ostrovsky et al 2010, Jefferis, MRC LMB)" = "IS2", 
       "Cell07 (Jefferis, Potter 2007, Jefferis/Luo, Cambridge/Stanford)" = "Cell07",
       "FCWB (Ostrovsky/Costa in prep, Jefferis, MRC LMB)" = "FCWB",
       "JFRC2 (HHMI/VFB)" = "JFRC2")

# Define UI for miles per gallon application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Transform between template brain coordinates"),

  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(

    selectInput("from", "from:",templateList,selected="FCWB"),
    selectInput("to", "to:",templateList,selected="JFRC2"),
    submitButton("Transform")
    ),

  mainPanel(
      h4("Input points:"),
      HTML('<textarea id="input_points" rows="16" cols=60>1 2 3</textarea>'),
      # textInput('', '3D coords (columnwise)', value = "1 2 3"),
      h4("Transformation:"),
      textOutput('xform'),
      textOutput("regpath"),
      h4("Transformed points:"),
      tableOutput('view'),
      downloadButton('downloadResults', 'Download Transformed Points')
      )
))