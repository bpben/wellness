#Server - things to add
#- Graphs of employee data
  # - Gender - Issue here, what if it's % or #, can just show that information?
  # - Participation rate - display
#- Format so row 1 = employer,2 = employee
#- Add static "comprehensive"
#- Add "similar" (i.e. same/close number of each component) (v2.0)

library(shiny)
library(reshape2)
library(ggplot2)
library(RColorBrewer)

debug <- 1

#Comprehensive program data for comparison
data.comp <- read.csv('./data/comprehensive.csv',check.names = FALSE)
#Just the static "overall comprehensive" data
data.comp.one <- data.comp[data.comp$compex==1,]
lcomp<-c('Board level health discussions',
         'Program champions',
         'Performance objectives linked to health',
         'Corporate responsibility strategy',
         'Training in health',
         'Wellbeing linked to org success')
pcomp<-c('Program branding',
         'Health feedback',
         'Health importance education',
         'Publish health info',
         'Worktime participation',
         'Promotion materials',
         'Wellness fairs')
icomp<-c('Incentives',
         'Outcomes-based incentives')
scomp<-c('Training','Screening','Disease.management',
         'EAP','Advice.line','Occ.health','Onsite.clinic','Smoking.info',
         'Smoking.Program','Other.smoking','Alch.info','Counsel','Other.Alch',
         'Onsite.gym','Unpaid.fitness','Paid.fitness','Showers',
         'Other.exercise','Eat.info','Eat.options.canteen','Eat.options.machines','Fruit.and.veg',
         'Dietician','Stress.prog','Stress.info','Work.life.prog','Stress.training')
agecomp<-c('<25','25-35','35-45','45-55','55-65','65+')
salcomp<-c('<20k','20-29k','30-39k','40-59k','60k+')


shinyServer(function(input, output) {
  if(debug==1){
    #//pocono/Drops/B/Batorsky_Benjamin/Inbox/
    data <- reactive(read.csv('./data/combined_fortool.csv', header = input$header,
                              sep = input$sep, quote = input$quote))
  } else data <- reactive(read.csv(input$file1    , header = input$header,
                                   sep = input$sep, quote = input$quote))
  
  output$comp.raw <- renderTable({
    head(data.comp.one)
  })
  
  output$contents <- renderTable({
    head(data())
  })
  
  output$lead <- renderUI({
    choices <-checkboxGroupInput('lead.choices','Which columns describe "leadership"?',names(data()),
                                 #Pre-selected
                                 c('champions','board_level','part_worktime'))
    choices
  })
  output$promo <- renderUI({
    choices <-checkboxGroupInput('promo.choices','Which columns describe "Promotion"?',names(data()),
                                 #Pre-selected
                                 c('promo','brand'))
    choices
  })
  output$incent <- renderUI({
    choices <-checkboxGroupInput('incent.choices','Which columns describe "Incentives"?',names(data()),
                                 #Pre-selected
                                 c('incentives','rewards'))
    choices
  })
  output$serv <- renderUI({
    choices <-checkboxGroupInput('serv.choices','Which columns describe "Services"?',names(data()),
                                 #Pre-selected
                                 c('Eat.info','Eat.options.machines','Showers'))
    choices
  })
  output$age <- renderUI({
    choices <-checkboxGroupInput('age.choices','Which columns have Employee age groups?',names(data()),
                                 #Pre-selected
                                 c("X.45.55.", "X.25.35.", "X.15.25.", "X.35.45.", "X.55.65.", "X.65.75."))
    choices
  })
  output$sal <- renderUI({
    choices <-checkboxGroupInput('sal.choices','Which columns have Employee salary ranges?',names(data()),
                                 #Pre-selected
                                 c("salary..10k.19k", "salary.20k.29k", "salary.30.39k", "salary.40.59k","salary.60k."))
    choices
  })
  output$gen <- renderUI({
    choices <-radioButtons('gen.choices','Which column has number/percent of female employees?',names(data()),
                                 ##Pre-selected
                                 "female_perc")
    choices
  })
  output$part <- renderUI({
    choices <-radioButtons('part.choices','Which column has number/percent of participants in the program?',names(data()),
                           ##Pre-selected
                           "part")
    choices
  })
  output$choices <- renderPrint({
    head(data()[,c(input$lead.choices,input$promo.choices,input$incent.choices,input$serv.choices)])
  })
  
  #plotter<-function(company,indata){
  plotter<-function(company,choices,indata=data()){
    #pltdata<-(data.matrix(data()[company,indata]))
    pltdata<-(data.matrix(indata[company,choices]))
    y<-1:ncol(pltdata)
    x<-1:nrow(pltdata)
    collist <- c('gray','darkgreen')
    image(x,y,pltdata, col = collist, breaks=seq(-1,1),
          axes=F,xlab="",ylab="")
    axis(2, at = y, labels=choices,tick=FALSE)
  }
  
  output$lead.plot <- renderPlot({
    validate(
      need(input$lead.choices!='','Select leadership variables to display')
    )
    plotter(input$company,input$lead.choices)
  })
  output$promo.plot <- renderPlot({
    validate(
      need(input$promo.choices!='','Select promotion variables to display')
    )
    plotter(input$company,input$promo.choices)
  })
  output$incent.plot <- renderPlot({
    validate(
      need(input$incent.choices!='','Select incentive variables to display')
    )
    plotter(input$company,input$incent.choices)
  })
  output$lead.plot.comp.one <- renderPlot({
    plotter(1,lcomp,indata=data.comp.one)
  })
  output$promo.plot.comp.one <- renderPlot({
    plotter(1,pcomp,indata=data.comp.one)
  })
  output$incent.plot.comp.one <- renderPlot({
    plotter(1,icomp,indata=data.comp.one)
  })
  
  stars2<-dget(paste0("./stars2.R"))
  
  stars<-function(company,choices,indata=data()){
    indata = indata[company,choices]
    if(ncol(indata)<=8){
      colvec <-brewer.pal(ncol(indata),'Accent')
    } else{
      cols <-brewer.pal(12,'Paired')
      pal <-colorRampPalette(cols)
      colvec<-pal(ncol(indata))
    }
    a<-stars2(indata,draw.segments=TRUE,labels=NA,flip.labels=F,
              scale=F,lty=0,col.segments=colvec)
    stars2(matrix(1,ncol(indata),nrow=1),key.loc=c(a$Var1,a$Var2),
           xpd = TRUE,key.labels = names(indata),flip.labels=F,add=T,scale=F,lty=0,cex=1)
  }
  
  output$serv.plot <- renderPlot({
    validate(
      need(input$serv.choices!='','Select service variables to display')
    )
    stars(input$company,input$serv.choices)
    })
  output$serv.plot.comp.one <- renderPlot({
    stars(1,scomp,indata=data.comp.one)
  })
    
  
  bars<-function(company,choices,indata=data()){
    #melted <- melt(data()[company,indata])
    melted <- melt(indata[company,choices])
    d<-ggplot(melted,aes(x=sort(as.character(variable)),y=value))
    d+geom_bar(stat='identity')+theme_classic()+coord_flip()
  }
  
  output$age.plot <- renderPlot({
    validate(
      need(input$age.choices!='','Select employee age variables to display')
    )
    bars(input$company,input$age.choices)
  })
  output$sal.plot <- renderPlot({
    validate(
      need(input$sal.choices!='','Select employee salary variables to display')
    )
    bars(input$company,input$sal.choices)
  })
  output$age.plot.comp.one <- renderPlot({
    bars(1,agecomp,indata=data.comp.one)
  })
  output$sal.plot.comp.one <- renderPlot({
    bars(1,salcomp,indata=data.comp.one)
  })

  output$gen.text <- renderText({
    paste0('Number/Percent female employees:', as.character(data()[input$company,input$gen.choices]))
  })
  output$part.text <- renderText({
    paste0('Participation:', as.character(data()[input$company,input$part.choices]))
  })
  output$gen.text.comp.one <- renderText({
    paste0('Number/Percent female employees:', as.character(data.comp.one[1,'Percent female']))
  })
  output$part.text.comp.one <- renderText({
    paste0('Participation:', as.character(data.comp.one[1,'Participation']))
  })
  
  #Create similar, based on gender, if available
  data.sim <- reactive({
    part.num<-as.numeric(data()[input$company,input$part.choices])
    higher<-data.comp[as.numeric(data.comp$Participation) > part.num,]
    higher[which.min(abs(higher[,'Percent female'] - data()[input$company,input$gen.choices])),]
    })
  output$gen.text.sim <- renderText({
    paste0('Number/Percent female employees:', as.character(data.sim()[,'Percent female']))
  })
  output$part.text.sim <- renderText({
    paste0('Participation:', as.character(data.sim()[,'Participation']))
  })
  output$age.plot.sim <- renderPlot({
    bars(1,agecomp,indata=data.sim())
  })
  output$sal.plot.sim <- renderPlot({
    bars(1,salcomp,indata=data.sim())
  })
  output$serv.plot.sim <- renderPlot({
    stars(1,scomp,indata=data.sim())
  })
  output$lead.plot.sim <- renderPlot({
    plotter(1,lcomp,indata=data.sim())
  })
  output$promo.plot.sim <- renderPlot({
    plotter(1,pcomp,indata=data.sim())
  })
  output$incent.plot.sim <- renderPlot({
    plotter(1,icomp,indata=data.sim())
  })
})
