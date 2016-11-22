#Load/install required packages
testin <- function(package){
  if (!package %in% installed.packages())
    install.packages(package) }
testin("markdown")
testin("shiny")
testin("shinydashboard")
testin('shiny')
testin('reshape2')
testin('ggplot2')
testin('RColorBrewer')
testin('xlsx')
testin('rJava')