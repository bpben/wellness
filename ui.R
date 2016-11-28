#UI - things to add
# - Reformat so rows, not columns

library(shiny)
library(shinydashboard)
library(markdown)

chooser<-function(table, html){
  tabItem(table,
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

shinyUI(
dashboardPage(
  dashboardHeader(title = "Wellness Program Evaluation Tool",titleWidth = 400),
  dashboardSidebar(
    fileInput('file1', 'Choose file to upload',
              accept = '.xlsx'),
    checkboxInput('template', 'Using WPET template?'),
    conditionalPanel(
      condition = "input.template == true",
      'Click on "Dashboard" to see results'
    ),
    sidebarMenu(
      menuItem("Preview", tabName = "Preview"),
      menuItem("Leadership", tabName = "lead"),
      menuItem("Promotion", tabName = "promo"),
      menuItem("Incentives", tabName = "incent"),
      menuItem("Services", tabName = "serv"),
      menuItem("Employees", tabName = "emp"),
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Comprehensive Program", tabName = "Comprehensive"),
      menuItem("Similar Program", tabName = "Similar")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem("Preview",
              tableOutput('preview')
      ),
      chooser('lead','./leadership.md.html'),
      chooser('promo','./promo.md.html'),
      chooser('incent','./incent.md.html'),
      chooser('serv','./serv.md.html'),
      tabItem('emp',
              fluidRow(
                column(
                  width=4,tableOutput('age')
                ),
                column(
                  width=4,tableOutput('sal')
                ),
                column(
                  width=4,tableOutput('gen')
                ),
                column(
                  width=4,tableOutput('part')
                )
              )
      ),
      tabItem("dashboard",
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
                  width=12,plotOutput('serv.plot')
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
      tabItem("Comprehensive",
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
                  width=12,plotOutput('serv.plot.comp.one')
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
      tabItem("Similar",
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
                  width=12,plotOutput('serv.plot.sim')
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
)
