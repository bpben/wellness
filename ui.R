#UI - things to add
# - Reformat so rows, not columns

library(shiny)
library(markdown)
chooser<-function(table, html){
  tabPanel(table,
           fluidRow(
             column(
               width=4,tableOutput(table)
             ),
             column(
               width=8,
               includeHTML(html)
             )
           )
  )
}


shinyUI(fluidPage(
  # Application title
  titlePanel("Wellness Program Evaluation Tool (WPET)"),
  tabsetPanel(
    tabPanel("Input",
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose file to upload',
                           accept = '.xlsx'),
                 checkboxInput('template', 'Using WPET template?'),
                 conditionalPanel(
                   condition = "input.template == true",
                   'Click on "Dashboard" tab to see results'
                 )
               ),
               mainPanel(
                 h3('Preview of data'),
                 tabPanel('preview', 
                          tableOutput('preview')
                          )
                 )
             )
    ),
    chooser('lead','./leadership.md.html'),
    chooser('promo','./promo.md.html'),
    chooser('incent','./incent.md.html'),
    chooser('serv','./serv.md.html'),
    tabPanel('employees',
             flowLayout(
               tableOutput('age'),
               tableOutput('sal'),
               tableOutput('gen'),
               tableOutput('part')
             )
    ),
    tabPanel('Dashboard',
             fluidRow(
               column(
                 width=3,verbatimTextOutput('choices')
                      ),
               column(
                 width=4,numericInput('company','Company # (for debug)',1)
               )
             ),
             #Employer data
             fluidRow(
               column(
                 width=12,plotOutput('lead.plot')
                 ),
               column(
                 width=12,plotOutput('promo.plot')
               ),
               column(
                 width=12,plotOutput('incent.plot')
               ),
               column(
                 width=12,offset=1,plotOutput('serv.plot')
               )
             ),
             #Employee data
             fluidRow(
               column(
                 width=4,plotOutput('age.plot')
                 ),
               column(
                 width=4,plotOutput('sal.plot')
                 ),
               column(
                 width=4,
                 verticalLayout(
                   h3(textOutput('gen.text')),
                   h3(textOutput('part.text'))
                   )
                 )
               )
             ),
    tabPanel('Comprehensive',
             fluidRow(
               column(
                 width=12,plotOutput('lead.plot.comp.one')
               ),
               column(
                 width=12,plotOutput('promo.plot.comp.one')
               ),
               column(
                 width=12,plotOutput('incent.plot.comp.one')
               ),
               column(
                 width=12,offset=1,plotOutput('serv.plot.comp.one')
               )
             ),
             fluidRow(
               column(
                 width=4,plotOutput('age.plot.comp.one')
               ),
               column(
                 width=4,plotOutput('sal.plot.comp.one')
               ),
               column(
                 width=4,
                 verticalLayout(
                   h3(textOutput('gen.text.comp.one')),
                   h3(textOutput('part.text.comp.one'))
                 )
               )
             )
    ),
    tabPanel('Similar',
             fluidRow(
               column(
                 width=12,plotOutput('lead.plot.sim')
               ),
               column(
                 width=12,plotOutput('promo.plot.sim')
               ),
               column(
                 width=12,plotOutput('incent.plot.sim')
               ),
               column(
                 width=12,offset=1,plotOutput('serv.plot.sim')
               )
             ),
             fluidRow(
               column(
                 width=4,plotOutput('age.plot.sim')
               ),
               column(
                 width=4,plotOutput('sal.plot.sim')
               ),
               column(
                 width=4,
                 verticalLayout(
                   h3(textOutput('gen.text.sim')),
                   h3(textOutput('part.text.sim'))
                 )
               )
             )
    )
    )
  )
)