yeryee<-read.csv('./data/combined_fortool.csv')

names(yeryee)
names(yeryee)
names(yeryee)[2]<-'Board level health discussions'
names(yeryee)[3]<-'Program branding'
names(yeryee)[4]<-'Program champions'
names(yeryee)[5]<-'Percent female'
names(yeryee)[7]<-'Health feedback'
names(yeryee)[8]<-'Health importance education'
names(yeryee)[9]<-'Health messenging'
names(yeryee)[10]<-'Publish health info'
names(yeryee)[11]<-'Incentives'
names(yeryee)[12]<-'Worktime participation'
names(yeryee)[13]<-'Performance objectives linked to health'
names(yeryee)[14]<-'Promotion materials'
names(yeryee)[15]<-'Corporate responsibility strategy'
names(yeryee)[16]<-'Outcomes-based incentives'
names(yeryee)[20]<-'Training in health'
names(yeryee)[21]<-'Wellbeing linked to org success'
names(yeryee)[22]<-'Wellness fairs'
names(yeryee)[25]<-'Participation'

names(yeryee)[grep('X.15.25.',names(yeryee))]<-'<25'
names(yeryee)[grep('X.25.35.',names(yeryee))]<-'25-35'
names(yeryee)[grep('X.35.45.',names(yeryee))]<-'35-45'
names(yeryee)[grep('X.45.55.',names(yeryee))]<-'45-55'
names(yeryee)[grep('X.55.65.',names(yeryee))]<-'55-65'
names(yeryee)[grep('X.65.75.',names(yeryee))]<-'65+'
names(yeryee)[grep('salary..10k.19k',names(yeryee))]<-'<20k'
names(yeryee)[grep('salary.20k.29k',names(yeryee))]<-'20-29k'
names(yeryee)[grep('salary.30.39k',names(yeryee))]<-'30-39k'
names(yeryee)[grep('salary.40.59k',names(yeryee))]<-'40-59k'
names(yeryee)[grep('salary.60k.',names(yeryee))]<-'60k+'

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

exlow <- yeryee[yeryee$group3==1,]
#Mark which one is adidas, Winner of 2013, Adidas
yeryee$compex <- ifelse(yeryee$company_name=='adidas UK Ltd.',1,0)
head(yeryee)
#just high-services, for examples
yeryee<-yeryee[yeryee$group3==3,]
yeryee<-yeryee[,c(lcomp,pcomp,icomp,scomp,'Participation','Percent female',
              agecomp,salcomp,'compex')]

#All comprehensive program data (group==3)
write.csv(yeryee,file='C:/Users/batorsky/Documents/OJT/Dissertation/wellnesstool/data/comprehensive.csv',row.names=FALSE)

#
comprehensive<-high[high$company_name=='adidas UK Ltd.',]
write.csv(comprehensive,file='C:/Users/batorsky/Documents/OJT/Dissertation/wellnesstool/data/comprehensive.csv',row.names=FALSE)

head(high)


#Similar (but high-services) data
#Choose random low-service company
exone<-exlow[1,]
col <-'Percent female'
high[which.min(abs(exone[,col] - high[,col])),]
exone$`Percent female`

