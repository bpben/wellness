library(stats)
library(psych)
library(plyr)


#Employee
y1yee<-readRDS(file="//pocono/Drops/B/Batorsky_Benjamin/Inbox/y1yee_pcas.Rda")
names(y1yee)
#Age cats, every 10 years
age.min<-as.numeric(describe(as.numeric(y1yee$age))['min'])
age.max<-as.numeric(describe(as.numeric(y1yee$age))['max'])
y1yee$agebin<-cut(y1yee$age,seq(age.min,age.max,10))
for(lv in unique(y1yee$agebin)){
  y1yee[,paste0(lv)]<-ifelse(y1yee$agebin==lv,1,0)
}
#salary cats
sal.cats <- list('salary <10k-19k','salary 20k-29k', 'salary 30-39k', 'salary 40-59k','salary 60k+')
i = 1
for(cat in sal.cats){
  y1yee[,paste0(cat)]<-ifelse(y1yee$income_cat==i,1,0)
  i=i+1
}
#select specific cols
yee.agg<-y1yee[,c(1,3,32:43)]
#aggregate
yee.agg<-ddply(yee.agg,'company_name',function(x) {
  aggregate(x[,2:14],by=list(x$company_name), function(y) sum(as.numeric(y),na.rm=TRUE)/nrow(x))
})
names(yee.agg)
yee.agg['NA']<-NULL
yee.agg['company_name']<-yee.agg['Group.1']
yee.agg['Group.1']<-NULL


#Employer
y1yer<-readRDS(file="//pocono/Drops/B/Batorsky_Benjamin/Inbox/combinedyer.Rda")
y1yer<-y1yer[y1yer$year1==1,]

#Merge
yeryee<-merge(y1yer,yee.agg,by='company_name')

#Output
write.csv(yeryee,file='C:/Users/batorsky/Documents/OJT/Dissertation/wellnesstool/data/combined_fortool.csv',row.names=FALSE)

#Compare to earlier output
a<-read.csv('C:/Users/batorsky/Documents/OJT/Dissertation/wellnesstool/data/y1yer_fortool.csv')
b<-merge(yeryee,a,by=intersect(names(a),names(yeryee)))
write.csv(b,file='C:/Users/batorsky/Documents/OJT/Dissertation/wellnesstool/data/combined_fortool.csv',row.names=FALSE)

#Testing viz
library(ggplot2)
library(reshape2)
cols.age <- names(yeryee)[26:31]
cols.sal <- names(yeryee)[32:36]

bars<-function(id,vars){
  melted <- melt(yeryee[id,c(vars,'company_name')],id_vars='company_name')
  d<-ggplot(melted,aes(x=sort(as.character(variable)),y=value))
  d+geom_bar(stat='identity')+theme_classic()+coord_flip()
}
bars(1,cols.age)
age.m

#Age bar
age.m <- melt(yeryee[1,c(cols.age,'company_name')],id.vars='company_name')
d<-ggplot(age.m,aes(x=sort(as.character(variable)),y=value))
d+geom_bar(stat='identity')+theme_classic()+coord_flip()

#Salary bar
sal.m <- melt(yeryee[1,c(cols.sal,'company_name')],id.vars='company_name')
d<-ggplot(sal.m,aes(x=sort(as.character(variable)),y=value))
d+geom_bar(stat='identity',aes(fill=variable))+theme_classic()+coord_flip()#+scale_fill_brewer(palette='Greens')

#Gender pie
gender<-yeryee
gender['male_perc']<-100-yeryee$female_perc
gender<-melt(gender[1,c('company_name','female_perc','male_perc')],id.vars='company_name')
d<-ggplot(gender,aes(variable,value))
d+geom_bar(stat='identity',aes(fill=variable))+theme_classic()+coord_flip()

d+coord_polar(theta="y")
gender<-yeryee
gender['male_perc']<-100-yeryee$female_perc
yeryee$female_perc

names(yeryee)
