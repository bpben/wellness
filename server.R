#Server - things to add

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

#Change all NAs to zero
read.csv.tozero<-function(file,input){
  x <-read.csv(file, header = input$header,
               sep = input$sep, quote = input$quote,
               check.names=FALSE)
  x[is.na(x)]<-0
  return(x)
}

#Label wrapping for clean charts
wrap.it <- function(x, len)
{ 
  sapply(x, function(y) paste(strwrap(y, len), 
                              collapse = "\n"), 
         USE.NAMES = FALSE)
}
wrap.labels <- function(x, len)
{
  if (is.list(x))
  {
    lapply(x, wrap.it, len)
  } else {
    wrap.it(x, len)
  }
}

shinyServer(function(input, output) {
  if(debug==1){
    data <- reactive(read.csv.tozero('./data/combined_fortool.csv',input))
  } else data <- reactive(read.csv(input$file1    , header = input$header,
                                   sep = input$sep, quote = input$quote,
                                   check.names = FALSE))
  
  output$comp.raw <- renderTable({
    head(data.comp.one)
  })
  
  output$preview <- renderTable({
    t(head(data()))
  },include.rownames=TRUE,include.colnames=FALSE)
  
  output$lead <- renderUI({
    choices <-checkboxGroupInput('lead.choices','Which columns describe "leadership"?',names(data()),
                                 #Pre-selected
                                 c('Program champions',
                                   'Board level health discussions',
                                   'Worktime participation'))
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
  
  #Store original plot params
  op<-c(5, 4, 4, 2) + 0.1
  plotter<-function(company,choices,indata=data()){
    par(mar = (c(5, 4, 7, 2)))
    pltdata<-t(data.matrix(indata[company,choices]))
    y<-1:ncol(pltdata)
    x<-1:nrow(pltdata)
    #Gray for 0, green for 1
    collist <- c('gray','darkgreen')
    image(x,y,pltdata, col = collist, breaks=seq(-1,1),
          axes=F,xlab="",ylab="")
    #Draw labels on axis
    axis(3, at = x, labels=wrap.labels(choices,10),tick=FALSE)
    par(op)
  }
  
  output$lead.plot <- renderPlot({
    if(input$template){
      choices <- lcomp
    } else {
      validate(
      need(input$lead.choices!='','Select leadership variables to display')
    )
      choices <- input$lead.choices
    }
    print(choices)
    plotter(input$company,choices)
  })
  
  output$promo.plot <- renderPlot({
    if(input$template){
      choices <- pcomp
    } else {
      validate(
        need(input$promo.choices!='','Select promotion variables to display')
      )
      choices <- input$promo.choices
    }
    plotter(input$company,choices)
  })
  output$incent.plot <- renderPlot({
    if(input$template){
      choices <- icomp
    } else {
      validate(
        need(input$incent.choices!='','Select incentive variables to display')
      )
      choices <- input$incent.choices
    }
    plotter(input$company,choices)
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
    if(input$template){
      choices <- scomp
    } else {
      validate(
        need(input$serv.choices!='','Select service variables to display')
      )
      choices <- input$serv.choices
    }
    stars(input$company,choices)
    })
  
  output$serv.plot.comp.one <- renderPlot({
    stars(1,scomp,indata=data.comp.one)
  })
    
  
  bars<-function(company,choices,indata=data(),title){
    melted <- melt(indata[company,choices])
    d<-ggplot(melted,aes(x=sort(as.character(variable)),y=value))
    d+geom_bar(stat='identity')+theme_classic()+coord_flip()+
      labs(y='',title=title)
  }
  
  output$age.plot <- renderPlot({
    if(input$template){
      choices <- agecomp
    } else {
      validate(
        need(input$age.choices!='','Select employee age variables to display')
      )
      choices <- input$age.choices
    }
    bars(input$company,choices,title='Employee Age')
  })
  output$sal.plot <- renderPlot({
    if(input$template){
      choices <- salcomp
    } else {
      validate(
        need(input$sal.choices!='','Select employee salary variables to display')
      )
      choices <- input$sal.choices
    }
    bars(input$company,choices,title='Employee Salary')
  })
  output$age.plot.comp.one <- renderPlot({
    bars(1,agecomp,indata=data.comp.one,title='Employee Age')
  })
  output$sal.plot.comp.one <- renderPlot({
    bars(1,salcomp,indata=data.comp.one,title='Employee Salary')
  })
  
  makepct<-function(num){
    if(num<1){
      num <- round(num,2)*100
    } else{
      num <- round(num)
    }
    return(as.character(num))
  }

  output$gen.text <- renderText({
    if(input$template){
      choices <- 'Percent female'
    } else {
      validate(
        need(input$gen.choices!='','Select employee gender info to display')
      )
      choices <- input$gen.choices
    }
    fem <- data()[input$company,choices]
    paste0('Number/Percent female employees:', makepct(fem))
  })
  
  output$part.text <- renderText({
    if(input$template){
      choices <- 'Participation'
    } else {
      validate(
        need(input$part.choices!='','Select employee participation info to display')
      )
      choices <- input$part.choices
    }
    part = as.numeric(data()[input$company,choices])
    paste0('Participation: ', makepct(part))
  })
  output$gen.text.comp.one <- renderText({
    fem <- data.comp.one[1,'Percent female']
    paste0('Female employees:', makepct(fem))
  })
  output$part.text.comp.one <- renderText({
    part = data.comp.one[1,'Participation']
    paste0('Participation: ', makepct(part))
  })
  
  #Create similar, based on gender, if available
  data.sim <- reactive({
    if(input$template){
      part.num<-as.numeric(data()[input$company,'Participation'])
      gen.num<-as.numeric(data()[input$company,'Percent female'])
    } else{
      validate(
        need(input$part.choices!='','Select employee variables to find similar company')
      )
      part.num<-as.numeric(data()[input$company,input$part.choices])
      gen.num<-as.numeric(data()[input$company,input$gen.choices])
    }
    higher<-data.comp[as.numeric(data.comp$Participation) > part.num,]
    higher[which.min(abs(higher[,'Percent female'] - gen.num)),]
    })
  output$gen.text.sim <- renderText({
    fem <- data.sim()[,'Percent female']
    paste0('Female employees:', makepct(fem))
  })
  output$part.text.sim <- renderText({
    part = data.sim()[,'Participation']
    paste0('Participation: ', makepct(part))
  })
  output$age.plot.sim <- renderPlot({
    bars(1,agecomp,indata=data.sim(),title='Employee Age')
  })
  output$sal.plot.sim <- renderPlot({
    bars(1,salcomp,indata=data.sim(),title='Employee Salary')
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
