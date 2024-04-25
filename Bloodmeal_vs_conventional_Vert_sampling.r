
###################################################
#### Import mosquito bloodmeal data #####################
##################################################

mosquito_dry<-read.csv("./Data/Mosquito_DRY2022.csv")
unique(mosquito_dry$Host)


mosquito_wet<-read.csv("./Data/Mosquitoes_WET2022.csv")
table(mosquito_wet$Host)
mosquito_wet$Site<-"DEL9"
mosquito_wet<-mosquito_wet[- which(mosquito_wet$Host %in% c("No amplification",
                                                            "no match - poor quality seq")),]
#### Wait to see if MISSING and PENDING need to be removed


### Merge all mosquito data
mosquito_all<-rbind(mosquito_dry[, -5],mosquito_wet[,-5])



key<-read.csv("./Data/DeLuca_Species_Class.csv") ### Assign the class to each host

unique(mosquito_all[which(! mosquito_all$Host%in% key$Host),"Host"])

# Remove samples without spatial information
mosquito_all<-mosquito_all[-which(mosquito_all$Site %in% c("Missing","DELB", "DELA")),]

# Add habitat and date data

mosquito_all<-merge(mosquito_all,key)
mosquito_all$Site<-as.numeric(gsub("DEL","",mosquito_all$Site))
mosquito_all$habitat<-"Scrub"
mosquito_all$habitat[mosquito_all$Site %in% c(1,2)]<-"Forest"
mosquito_all$habitat[mosquito_all$Site %in% c(3,4)]<-"Orchard"
mosquito_all$habitat[mosquito_all$Site %in% c(7,8)]<-"Wetland"
mosquito_all$habitat[mosquito_all$Site %in% c(9)]<-"Rangeland"


mosquito_all$ColDate<-as.Date(mosquito_all$ColDate,format='%m/%d/%Y')
mosquito_all[is.na(mosquito_all$ColDate),]

### Fill date for DELU274 - 2/3/2022 from checking other records
mosquito_all[mosquito_all$ID=="DELU274","ColDate"]<-as.Date("2/3/2022",format='%m/%d/%Y')

head(mosquito_all)
###################################################
#### Import conventional surveys data #####################
##################################################

###############  Birds


birds1<-read.csv("C:/Users/seboc/Box/DeLuca/Final_Databases/All_Bird_Data_SciNames.csv")

birds2<-read.csv("C:/Users/seboc/Box/DeLuca/Final_Databases/RAP/RAP_Birds_PointCounts.csv")
key<-birds1[!duplicated(birds1$Species),c(2,12)]
unique(birds2[which(! birds2$Species%in% key$Species),"Species"])
birds2<-merge(birds2,key, all.x = T)
birds2[birds2$Species=="CRCA","SCINAME"]<-"Caracara plancus"
birds2[birds2$Species=="LBH","SCINAME"]<-"Egretta caerulea"
birds2[birds2$Species=="YBCU","SCINAME"]<-"Coccyzus americanus"


names(birds1)
names(birds2)

birds1<-birds1[,c(4,5,6,7,12)]
birds2<-birds2[,c(3,4,5,7)]
birds2$Site<-9

birds1<-rbind(birds1,birds2)

birds1$Date<-paste(birds1$Date,"2022", sep="_")
birds1$Date<-as.Date(birds1$Date,format='%b_%d_%Y')





birds<-read.csv("C://Users//seboc//Box//DeLuca//All_Bird_Data_SciNames.csv")
head(birds)
birds$Date<-paste(birds$Date,"2022", sep="_")
birds$Date<-as.Date(birds$Date,format='%b_%d_%Y')
birds<-birds[birds$Estimate_Method=="Abundance",] # only use abundance method
names(birds)[9]<-"N_individuals"
birds<-birds[birds$Detection_Loc=="IN-50",]

