#UI - things to add
# - Reformat so rows, not columns

library(shiny)
library(markdown)

shinyUI(fluidPage(
  # Application title
  titlePanel("Wellness Program Evaluation Tool (WPET)"),
  tabsetPanel(
    tabPanel("Input",
             sidebarLayout(
               sidebarPanel(
                 fileInput('file1', 'Choose file to upload',
                           accept = c(
                             'text/csv',
                             'text/comma-separated-values',
                             'text/tab-separated-values',
                             'text/plain',
                             '.csv',
                             '.tsv')),
                 checkboxInput('template', 'Using WPET template?'),
                 conditionalPanel(
                   condition = "input.template == true",
                   'Click on "Dashboard" tab to see results'
                 ),
                 conditionalPanel(
                   condition = "input.template == false",
                   checkboxInput('header', 'Header', TRUE),
                   radioButtons('sep', 'Separator',
                                c(Comma=',',
                                  Semicolon=';',
                                  Tab='\t'),
                                ','),
                   radioButtons('quote', 'Quote',
                                c(None='',
                                  'Double Quote'='"',
                                  'Single Quote'="'"),
                                '"')
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
    tabPanel('lead',
             fluidRow(
               column(
                 width=4,tableOutput('lead')
                 ),
               column(
                 width=8,
                 includeHTML("./leadership.md.html")
               )
             )
             ),
    tabPanel('promo',
             fluidRow(
               column(
                 width=4,tableOutput('promo')
               ),
               column(
                 width=8,
                 includeHTML("./promo.md.html")
               )
             )
    ),
    tabPanel('incent',
             fluidRow(
               column(
                 width=4,tableOutput('incent')
               ),
               column(
                 width=8,
                 includeHTML("./incent.md.html")
               )
             )
    ),
    tabPanel('serv',
             fluidRow(
               column(
                 width=4,tableOutput('serv')
               ),
               column(
                 width=8,
                 includeHTML("./serv.md.html")
               )
             )
    ),
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
                 width=6,flowLayout(
                   plotOutput('lead.plot.comp.one'),
                   plotOutput('promo.plot.comp.one'),
                   plotOutput('incent.plot.comp.one')  
                 )
               ),
               column(
                 width=6,offset=1,plotOutput('serv.plot.comp.one')
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
                 width=6,flowLayout(
                   plotOutput('lead.plot.sim'),
                   plotOutput('promo.plot.sim'),
                   plotOutput('incent.plot.sim')  
                 )
               ),
               column(
                 width=6,offset=1,plotOutput('serv.plot.sim')
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