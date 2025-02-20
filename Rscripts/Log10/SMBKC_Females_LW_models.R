# Jon Richar with tidyverse functions courtesy of Erin Fedewa
# 5/20/2020
# Calculate length/weight regression models for SMBKC females by shell condition
library(tidyverse)
library(stats)
library(nlme)
library(ggpubr)

#setwd("C:/Users/Jon.Richar/Work/Projects/Length_weight/DATA")
df<-read.csv("DATA/SMBKC_weightDB_analysis.csv")

df1<-subset(df, WEIGHT>0 & SEX==2)
colnames(df1)
dev.new()
plot(df1$WEIGHT~df1$LENGTH)
#identify(df1$WEIGHT~df1$LENGTH)
######################### Tidyverse approach ###################################
#df1 %>%
#  mutate(logwidth = log10(WIDTH),
#          logweight = log10(WEIGHT),
#          Year = substring(CRUISE, 1,4), 
#          YEAR = as.factor(Year)) %>%
 #  filter(SEX == 2) -> female #Only SC2 as to not bias for weight of epibionts 
#male
#ggplot(female, aes(x = LENGTH, y = WEIGHT, group = YEAR)) +
#     geom_point(aes(colour = factor(SHELL_CONDITION)))


################################################################################

sc1_immatfemales<-subset(df1,SEX==2 & SHELL_CONDITION==1 & CLUTCH_SIZE==0)
sc2_immatfemales<-subset(df1,SEX==2 & SHELL_CONDITION==2 & CLUTCH_SIZE==0)

sc1_matfemales<-subset(df1,SEX==2 & SHELL_CONDITION==1 & CLUTCH_SIZE>0)
sc2_matfemales<-subset(df1,SEX==2 & SHELL_CONDITION==2 & CLUTCH_SIZE>0)
sc3_matfemales<-subset(df1,SEX==2 & SHELL_CONDITION==3 & CLUTCH_SIZE>0)
sc4_matfemales<-subset(df1,SEX==2 & SHELL_CONDITION==4 & CLUTCH_SIZE>0)
sc5_matfemales<-subset(df1,SEX==2 & SHELL_CONDITION==5 & CLUTCH_SIZE>0)


hist(sc1_matfemales$WEIGHT)
hist(sc2_matfemales$WEIGHT)
hist(sc3_matfemales$WEIGHT)
hist(sc4_matfemales$WEIGHT)
hist(sc5_matfemales$WEIGHT)

hist(log10(sc2_matfemales$WEIGHT))
hist(sc3_matfemales$WEIGHT)
hist(sc4_matfemales$WEIGHT)

plot(sc2_matfemales$WEIGHT~sc2_matfemales$LENGTH)
plot(sc3_matfemales$WEIGHT~sc3_matfemales$LENGTH)
plot(sc4_matfemales$WEIGHT~sc4_matfemales$LENGTH)

########################## Aggregate by New shell/old shell #####################################
ns_immatfemales<-subset(df1,SEX==2 & CLUTCH_SIZE==0 & SHELL_CONDITION==2)
ns_matfemales<-subset(df1,SEX==2 & CLUTCH_SIZE>0 & SHELL_CONDITION==2)
os_matfemales<-subset(df1,SEX==2 & CLUTCH_SIZE>0 & SHELL_CONDITION==3|SHELL_CONDITION==4)
os_matfemales

all_matfemales<-subset(df1,SEX==2 & CLUTCH_SIZE>0)





#####################################################################################################################
############################ First model L-W relationship by shell condition #########################################
#####################################################################################################################


######################################################################################################
############################ Immature females ########################################################
######################################################################################################
plot(ns_immatfemales$WEIGHT~ns_immatfemales$LENGTH)
############################## Plot base data in GG plot ############################################################
dev.new()
p<-ggplot(ns_immatfemales, aes(x = LENGTH, y = WEIGHT)) +
  geom_point()
p+ labs(title="New shell (SC2) immature females")

############################# Add fields for analysis ########################################################
Year <- substring(ns_immatfemales$CRUISE, 1,4) 

YEAR <- as.factor(Year)
log.length<-log(ns_immatfemales$LENGTH)
log.weight <- log(ns_immatfemales$WEIGHT)

log10.length<-log10(ns_immatfemales$LENGTH)
log10.weight <- log10(ns_immatfemales$WEIGHT)
ns_imfemale<-as.data.frame(cbind(ns_immatfemales,YEAR,log10.length,log10.weight,log.length,log.weight))   		 # Bind new data objects and crab data in data frame  
ns_imfemale                    							  		 # inspect data
names(ns_imfemale)											 # Check column names


############################ Plot log transformeddata in GGplot #############################################
dev.new()
p<-ggplot(ns_imfemale, aes(x = log10.length, y = log10.weight)) +
  geom_point()
p+ labs(x="ln(length)",y="ln(weight)", title="New shell (SC2) immature females-log transformed")


############################## Fit initial model ########################################################

fit1<-lm(log10.weight~log10.length,data=ns_imfemale)
summary(fit1)
coef(fit1)
############################## check diagnostics #################################################
dev.new()
par(mfrow=c(2,2))

plot(fit1)
plot(cooks.distance(fit1), pch=16, cex=0.5, main="Cook's distance with critical distance cutoff") 
abline(h = 4/(nrow(ns_imfemale)), col=4,lwd=1.5)  # critical Cooks Distance cutline(> 4/nobs)

ns_imfemale

ns_imfemale$Cooks_D <- cooks.distance(fit1)
ns_immatfemales_analysis<-subset(ns_imfemale, Cooks_D < (4/(nrow(ns_imfemale))))

nrow(ns_imfemale)-nrow(ns_immatfemales_analysis)    #94 obs removed based on Cook's Distance
nrow(ns_immatfemales_analysis)

##################################################################################################
############################# Plot using editted dataset #########################################
dev.new()
p<-ggplot(ns_immatfemales_analysis, aes(x = LENGTH, y = WEIGHT)) +
  geom_point()
p+ labs(title="New shell (SC2) immature females- infuential points removed")


############################ log transformed ##################################################
dev.new()
p<-ggplot(ns_immatfemales_analysis, aes(x = log10.length, y = log10.weight)) +
  geom_point()
p+ labs(x="ln(length)",y="ln(weight)", title="New shell (SC2) immature females-log transformed, influential points removed")

############################ Fit followup model ##########################################
fit.im<-lm(log10.weight~log10.length,data=ns_immatfemales_analysis)
summary(fit.im)
coef(fit.im)

cf2<-as.matrix(coef(fit.im))

exp(-7.656292)
# log10(W) = -7.656292  + 3.094701  * log10(L) on transformed scale       #updated for females
# W = exp(-7.656292) * L^(3.094701)  on original scale                #updated for females
# a = 0.0004730583                                                 #updated for females
# b = 3.094701                                                     #updated for females
##############################################################################################
######################## Apply bias-correction procedure #####################################
cf2
names(fit.im)
names(summary(fit.im))
###############################################################################################
v2<-(summary(fit.im)$sigma)**2  #Variance 
v2
int<-cf2[1,1]
A<-(exp(int)*exp(v2/2))
A                         #0.000474389 

####################### Variance for parameter A/intercept ########################################
#vcov(fit2)
Av<-vcov(fit.im)[1,1]   #extract variance for intercept
sd<-sqrt(Av)          #take square root to create standard deviation
sd
sdA<-(exp(sd)*exp(v2/2))
sdA

sdA_base<-exp(sd)
sdA_base
##################### BIAS-CORRECTED PARAMETERS FOR NEW SHELLIMMATURE FEMALE MODEL ###############################
# a = 0.000474389    #updated for females
# b = 3.094701           #updated for females



######################################################################################################
############################ New shell ###############################################################
######################################################################################################

plot(ns_matfemales$WEIGHT~ns_matfemales$LENGTH)
############################## Plot base data in GG plot ############################################################
dev.new()
p<-ggplot(ns_matfemales, aes(x = LENGTH, y = WEIGHT)) +
      geom_point()
p+ labs(title="New shell (SC2) females")

############################# Add fields for analysis ########################################################
Year <- substring(ns_matfemales$CRUISE, 1,4) 

YEAR <- as.factor(Year)
log.length<-log(ns_matfemales$LENGTH)
log.weight <- log(ns_matfemales$WEIGHT)

log10.length<-log10(ns_matfemales$LENGTH)
log10.weight <- log10(ns_matfemales$WEIGHT)
ns_female<-as.data.frame(cbind(ns_matfemales,YEAR,log10.length,log10.weight,log.length,log.weight))   		 # Bind new data objects and crab data in data frame  
ns_female                    							  		 # inspect data
names(ns_female)											 # Check column names


############################ Plot log transformeddata in GGplot #############################################
dev.new()
p<-ggplot(ns_female, aes(x = log10.length, y = log10.weight)) +
      geom_point()
p+ labs(x="ln(length)",y="ln(weight)", title="New shell (SC2) females-log transformed")


############################## Fit initial model ########################################################

fit1<-lm(log10.weight~log10.length,data=ns_female)
summary(fit1)
coef(fit1)
############################## check diagnostics #################################################
dev.new()
par(mfrow=c(2,2))
plot(fit1)
plot(cooks.distance(fit1), pch=16, cex=0.5, main="Cook's distance with critical distance cutoff") 
     abline(h = 4/(nrow(ns_female)), col=4,lwd=1.5)  # critical Cooks Distance cutline(> 4/nobs)

ns_female$Cooks_D <- cooks.distance(fit1)
ns_matfemales_analysis<-subset(ns_female, Cooks_D < (4/(nrow(ns_female))))
 
nrow(ns_female)-nrow(ns_matfemales_analysis)    #60 obs removed based on Cook's Distance

nrow(ns_matfemales_analysis)
##################################################################################################
############################# Plot using editted dataset #########################################
dev.new()
p<-ggplot(ns_matfemales_analysis, aes(x = LENGTH, y = WEIGHT)) +
      geom_point()
p+ labs(title="New shell (SC2) females- infuential points removed")


############################ log transformed ##################################################
dev.new()
p<-ggplot(ns_matfemales_analysis, aes(x = log10.length, y = log10.weight)) +
      geom_point()
p+ labs(x="ln(length)",y="ln(weight)", title="New shell (SC2) females-log transformed, influential points removed")

############################ Fit followup model ##########################################
fit2<-lm(log10.weight~log10.length,data=ns_matfemales_analysis)
summary(fit2)
coef(fit2)

cf2<-as.matrix(coef(fit2))
exp(-5.38851)
# log10(W) = -5.38851  + 2.60755 * log10(L) on transformed scale           #Updated for females
# W = exp(-5.38851) * L^(2.60755)  on original scale                   #Updated for females
# a = 0.004568776                                                      #Updated for females
# b = 2.60755                                                          #Updated for females
##############################################################################################
######################## Apply bias-correction procedure #####################################
cf2
names(fit2)
names(summary(fit2))
###############################################################################################
v2<-(summary(fit2)$sigma)**2  #Variance 
v2
int<-cf2[1,1]
A<-(exp(int)*exp(v2/2))
A                         #0.004579617

####################### Variance for parameter A/intercept ########################################
#vcov(fit2)
Av<-vcov(fit2)[1,1]   #extract variance for intercept
sd<-sqrt(Av)          #take square root to create standard deviation
sd
sdA<-(exp(sd)*exp(v2/2))
sdA

sdA_base<-exp(sd)
sdA_base
##################### BIAS-CORRECTED PARAMETERS FOR NEW SHELL MODEL ###############################
# a = 0.004579617                                                  #Updated for females
# b = 2.60755                                                     #Updated for females


###################################################################################################
############################ Old shell ############################################################
###################################################################################################

dev.new()
plot(os_matfemales$WEIGHT~os_matfemales$LENGTH)
p<-ggplot(os_matfemales, aes(x = LENGTH, y = WEIGHT)) +
      geom_point()
p+ labs(title="Old shell (SC3+SC4) females")

############################# Add fields for analysis ########################################################
Year <- substring(os_matfemales$CRUISE, 1,4) 

YEAR <- as.factor(Year)
log.length<-log(os_matfemales$LENGTH)
log.weight <- log(os_matfemales$WEIGHT)

log10.length<-log10(os_matfemales$LENGTH)
log10.weight <- log10(os_matfemales$WEIGHT)
os_female<-as.data.frame(cbind(os_matfemales,YEAR,log10.length,log10.weight,log.length,log.weight))   		 # Bind new data objects and crab data in data frame  
os_female                    							  		 # inspect data
names(os_female)											 # Check column names


############################ Plot log transformeddata in GGplot #############################################
dev.new()
p<-ggplot(os_female, aes(x = log10.length, y = log10.weight)) +
      geom_point()
p+ labs(x="ln(length)",y="ln(weight)", title="Old shell (SC3+SC4) females-log transformed")

############################## Fit initial model ########################################################

fit3<-lm(log10.weight~log10.length,data=os_female)
summary(fit3)
coef(fit3)

############################## check diagnostics #################################################
dev.new()
par(mfrow=c(2,2))
plot(fit3)
plot(cooks.distance(fit3), pch=16, cex=0.5, main="Cook's distance with critical distance cutoff") 
     abline(h = 4/(nrow(os_female)), col=4,lwd=1.5)  # critical Cooks Distance cutline(> 4/nobs)

os_female$Cooks_D <- cooks.distance(fit3)
os_matfemales_analysis<-subset(os_female, Cooks_D < (4/(nrow(os_female))))
 
nrow(os_female)-nrow(os_matfemales_analysis)    #26 obs removed

nrow(os_matfemales_analysis)

##################################################################################################
############################# Plot using editted dataset #########################################
dev.new()
p<-ggplot(os_matfemales_analysis, aes(x = LENGTH, y = WEIGHT)) +
      geom_point()
p+ labs(title="Old shell (SC3+SC4) females- infuential points removed")


############################ log transformed ##################################################
dev.new()
p<-ggplot(os_matfemales_analysis, aes(x = log10.length, y = log10.weight)) +
      geom_point()
p+ labs(x="ln(length)",y="ln(weight)", title="Old shell (SC3+SC4) SMBKC females-log transformed, influential points removed")

############################ Fit followup model ##########################################
fit4<-lm(log10.weight~log10.length,data=os_matfemales_analysis)
summary(fit4)
coef(fit4)
cf4<-as.matrix(coef(fit4))

plot(log10.weight~log10.length,data=os_matfemales_analysis)
abline(a=cf2[1,1],b=cf2[2,1])
abline(a=cf4[1,1],b=cf4[2,1])

cf4
exp(-4.59768 )

# log10(W) = -4.59768  + 2.461781 * log10(L) on transformed scale                     #Updated for females
# W = exp(-4.59768 ) * L^(2.461781)  on original scale                            #Updated for females
# a = 0.01007518                                                               #Updated for females
# b = 2.461781                                                                   #Updated for females

################################################################################################
######################## Apply bias-correction procedure #####################################
###############################################################################################
v4<-(summary(fit4)$sigma)**2  #Variance 
v4
int<-cf4[1,1]
A<-(exp(int)*exp(v4/2))
A                         #0.01009829

####################### Variance for parameter A/intercept ########################################
#vcov(fit2)
Av<-vcov(fit4)[1,1]   #extract variance for intercept
sd<-sqrt(Av)          #take square root to create standard deviation
sd
sdA<-(exp(sd)*exp(v4/2))
sdA

sdA_base<-exp(sd)
sdA_base
##################### BIAS-CORRECTED PARAMETERS FOR OLD SHELL MODEL ###############################
# a = 0.01009829                                                                  #Updated for females
# b = 2.461781                                                                      #Updated for females




#############################################################################################################################################################
############################ combine data sets and plot, using shell condition as grouping factor############################################################
#############################################################################################################################################################
os_matfemales_analysis$SC <- "OS"
ns_matfemales_analysis$SC <- "NS"

analysis_females<-rbind(ns_matfemales_analysis,os_matfemales_analysis)

write.csv(analysis_females,"EBS_CO_Analysis_females.csv")

ggplot(analysis_females, aes(x = LENGTH, y = WEIGHT, group = SC)) +
     geom_point(aes(colour = factor(SC)))

q<-ggplot(analysis_females, aes(x = LENGTH, y = WEIGHT, group = SC)) +
     geom_point(aes(colour = factor(SC)))
q+ labs(x="Width(mm)",y="Weight(g)", title="Female SMBKC (New shell and old shell)")

######################Log transformed #################################################
dev.new()


ggplot(analysis_females, aes(x = log10.length, y = log10.weight, group = SC)) +
     geom_point(aes(colour = factor(SC)))+
	labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC (New shell and old shell, log-transformed)")

ebsco_sc_points<-ggplot(analysis_females, aes(x = log10.length, y = log10.weight, group = SC)) +
     geom_point(aes(colour = factor(SC)))+
	labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC (New shell and old shell, log-transformed)")

# lines ONLY
ggplot(analysis_females, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC (New shell and old shell, log-transformed)")

ebsco_sc_lines<-ggplot(analysis_females, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC(New shell and old shell, log-transformed)")

# with points and lines
ggplot(analysis_females, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
     geom_point()+
geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC (New shell and old shell log-transformed)")


################ Alternative approach with lines
ggscatter(analysis_females, x="log10.length",y="log10.weight",color="SC", add="reg.line"
)+
stat_regline_equation(
aes(label=paste(..eq.label.., ..rr.label.., sep="~~~~"), color = factor(SC))
)


########################################################################################################################
############################### Run ANCOVA analyses to determine if statistically different ############################

mod1<-aov(log10.weight~log10.length*SC,data = analysis_females)			# p = 1.94e-15--significant interaction -- slopes different
summary(mod1)

mod2<-aov(log10.weight~log10.length+SC,data = analysis_females)			# p< 2e-16: interceptes are significantly different
summary(mod2)

anova(mod1,mod2)										# p = 1.94e-15--interaction term is significant to model

reg_mod<-lm(log10.weight~SC/log10.length-1,data=analysis_females)
summary(reg_mod)







##########################################################################################################################################################
############################### Rerun shell condition models while limit data to same size ranges ##########################################################
###########################################################################################################################################################






x.lim=c(0,200)
?hist()
summary(os_matfemales_analysis$LENGTH)


summary(ns_matfemales_analysis$LENGTH)


dev.new()
par(mfrow=c(2,1))
hist(ns_matfemales_analysis$LENGTH,breaks=30,main="New shell size frequency",xaxt='n',xlim=x.lim)

abline(v=mean(ns_matfemales_analysis$LENGTH),col=4)

axis(side=1,at=seq(0,200,10),label=seq(0,200,10))

hist(os_matfemales_analysis$LENGTH,breaks=20,main="Old shell size frequency",xaxt='n',xlim=x.lim)
abline(v=mean(os_matfemales_analysis$LENGTH),col=4)
axis(side=1,at=seq(0,200,10),label=seq(0,200,10))

############################ Truncate new shells to match old shell size range ###################

ns_matfemales_analysis_sub<-subset(ns_matfemales_analysis,LENGTH>36.0)


############################ Fit followup model ##########################################
fit5<-lm(log10.weight~log10.length,data=ns_matfemales_analysis_sub)
summary(fit5)
coef(fit5)

cf5<-as.matrix(coef(fit5))
cf5
exp(-5.388513)
			# log10(W) = -8.414407 + 3.134860 * log10(L) on transformed scale
    			# W = exp(-8.36005)*L^(3.134860 )  on original scale
			# a = 0.0002340326
			# b = 3.134860

p<-ggplot(ns_matfemales_analysis_sub, aes(x = log10.length, y = log10.weight)) +
      geom_point()
p+ labs(x="ln(width)",y="ln(weight)", title="New shell (SC2) females-log transformed")
p+ geom_abline(intercept = cf5[1,1],slope = cf5[2,1],color = "red")



####################################################################################################################################
######################## Combine old shell and truncated new shell data and plot ##############################################################
analysis_females_sub<-as.data.frame(rbind(ns_matfemales_analysis_sub,os_matfemales_analysis))


########################### Non transformed ############################################################################
q<-ggplot(analysis_females_sub, aes(x = LENGTH, y = WEIGHT, group = SC)) +
     geom_point(aes(colour = SC))
	q+ labs(x="Ln(Length)",y="Ln(Weight)", title="Male SMBKC (New shell and old shell)")

########################### Log transformed ##########################################################################
dev.new()

############################# points only ############################################################################
ggplot(analysis_females_sub, aes(x = log10.length, y = log10.weight, group = SC)) +
     geom_point(aes(colour = factor(SC)))+
	labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC (New shell and old shell, log-transformed)")

ebsco_sc_points_sub <- ggplot(analysis_females_sub, aes(x = log10.length, y = log10.weight, group = SC)) +
     geom_point(aes(colour = SC))+
	labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC (New shell and old shell, log transformed and truncated)")

############################# lines ONLY ###############################################################################
ggplot(analysis_females_sub, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
	geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
	labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC(New shell and old shell, log-transformed)")


ebsco_sc_lines_sub <-ggplot(analysis_females_sub, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
	geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
	labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC(New shell and old shell,log transformed and truncated)")


############################# with points and lines#####################################################################
ggplot(analysis_females_sub, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
     geom_point()+
geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
labs(x="Ln(Length)",y="Ln(Weight)", title="Female SMBKC(New shell and old shell log-transformed)")

######################  Alternative approach #########################################################################
ggscatter(analysis_females_sub, x="log10.length",y="log10.weight",color="SC", add="reg.line"
)+
stat_regline_equation(
aes(label=paste(..eq.label.., ..rr.label.., sep="~~~~"), color = factor(SC))
)

########################################################################################################################
############################### 4 panel ################################################################################

ggarrange(ebsco_sc_points, ebsco_sc_lines, ebsco_sc_points_sub, ebsco_sc_lines_sub,
labels = c("a.)", "b.)", "c.)", "d.)"),
ncol = 2, nrow = 2)



########################################################################################################################
############################### Run ANCOVA analyses to determine if statistically different ############################

mod1<-aov(log10.weight~log10.length*SC,data = analysis_females_sub)
summary(mod1)									# p= 2e-16 on interaction term= significant interaction--suggests different slopes

mod2<-aov(log10.weight~log10.length+SC,data = analysis_females_sub)
summary(mod2)									# p = 2e-16 for SC, SC-based regression lines have differing intercepts

anova(mod1,mod2)									# p= 2.2e-16...removing interaction term sinificantly affects model

reg_mod<-lm(log10.weight~SC/log10.length-1,data=analysis_females_sub)		
summary(reg_mod)














########################################## FOLLOWING CODE NOT ADAPTED FOR FEMALES ##################################################################
















if(FALSE){
















########################################################################################################################
############################### Truncate further at width = 76 mm(based on old shell first quartile) ######################################################
ns_matfemales_analysis_sub2<-subset(ns_matfemales_analysis,WIDTH>76)
os_matfemales_analysis_sub<-subset(os_matfemales_analysis,WIDTH>76)

############################ Fit followup model - new shell ##########################################
fit6<-lm(log10.weight~log10.length,data=ns_matfemales_analysis_sub2)
summary(fit6)
coef(fit6)

cf6<-as.matrix(coef(fit6))
			# log10(W) = -8.588717  + 3.17365  * log10(L) on transformed scale
    			# W= exp(-8.588717*L^(3.17365)  on original scale
			# a =  0.0001861948
			# b = 3.17365

############################ Fit followup model - old shell ##########################################
fit7<-lm(log10.weight~log10.length,data=os_matfemales_analysis_sub)
summary(fit7)
coef(fit7)

cf7<-as.matrix(coef(fit7))
			# log10(W) = -7.99453 + 3.055352  * log10(L) on transformed scale
    			# W = exp(-7.99453*L^(3.055352)  on original scale
			# a =  0.0003373026
			# b = 3.055352 

p<-ggplot(ns_matfemales_analysis_sub2, aes(x = log10.length, y = log10.weight)) +
      geom_point()
p+ labs(x="ln(width)",y="ln(weight)", title="New shell (SC2) females-log transformed")
p+ geom_abline(intercept = cf6[1,1],slope = cf6[2,1],color = "red")

####################################################################################################################################
######################## Combine old shell and truncated new shell data and plot ##############################################################

analysis_females_sub2<-as.data.frame(rbind(ns_matfemales_analysis_sub2,os_matfemales_analysis_sub))


########################### Non transformed ############################################################################
q<-ggplot(analysis_females_sub2, aes(x = WIDTH, y = WEIGHT, group = SC)) +
     geom_point(aes(colour = SC))
	q+ labs(x="Ln(Width)",y="Ln(Weight)", title="Male SMBKC (New shell and old shell) females")

########################### Log transformed ##########################################################################
dev.new()

############################# po only ############################################################################
ggplot(analysis_females_sub2, aes(x = log10.length, y = log10.weight, group = SC)) +
     geom_point(aes(colour = factor(SC)))+
	labs(x="Ln(Width)",y="Ln(Weight)", title="Male SMBKC (New shell and old shell, log-transformed)")

ebsco_sc_points_sub2 <- ggplot(analysis_females_sub2, aes(x = log10.length, y = log10.weight, group = SC)) +
     geom_point(aes(colour = SC))+
	labs(x="Ln(Width)",y="Ln(Weight)", title="Male SMBKC (New shell and old shell, truncated at 76 mm)")

############################# lines ONLY ###############################################################################
ggplot(analysis_females_sub2, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
	geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
	labs(x="Ln(Width)",y="Ln(Weight)", title="Male SMBKC(New shell and old shell, log-transformed)")


ebsco_sc_lines_sub2 <-ggplot(analysis_females_sub2, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
	geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
	labs(x="Ln(Width)",y="Ln(Weight)", title="Male SMBKC(New shell and old shell, truncated at 76 mm)")


############################# with points and lines#####################################################################
ggplot(analysis_females_sub2, aes(x = log10.length, y = log10.weight, group = SC,color = SC,shape=SC)) +
     geom_point()+
	geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
	labs(x="Ln(Width)",y="Ln(Weight)", title="Male SMBKC (New shell and old shell log-transformed)")

######################  Alternative approach #########################################################################
ggscatter(analysis_females_sub2, x="log10.length",y="log10.weight",color="SC", add="reg.line"
)+
stat_regline_equation(
aes(label=paste(..eq.label.., ..rr.label.., sep="~~~~"), color = factor(SC))
)

########################################################################################################################
############################### 4 panel ################################################################################
ggarrange(ebsco_sc_points,ebsco_sc_lines,ebsco_sc_points_sub2, ebsco_sc_lines_sub2,
labels = c("a.)", "b.)", "c.)", "d.)"),
ncol = 2, nrow = 2)

dev.new()

ggarrange(ebsco_sc_points_sub,ebsco_sc_lines_sub,ebsco_sc_points_sub2, ebsco_sc_lines_sub2,
labels = c("a.)", "b.)", "c.)", "d.)"),
ncol = 2, nrow = 2)

########################################################################################################################
############################### Run ANCOVA analyses to determine if statistically different ############################

mod1<-aov(log10.weight~log10.length*SC,data = analysis_females_sub2)
summary(mod1)									# p = 7.18e-10 on interaction term= significant interaction--suggests different slopes

mod2<-aov(log10.weight~log10.length+SC,data = analysis_females_sub2)
summary(mod2)									# p <2e-16 for SC, SC-based regression lines have differing intercepts

anova(mod1,mod2)									# p = 7.177e-10...removing interaction term sinificantly affects model

reg_mod<-lm(log10.weight~SC/log10.length-1,data=analysis_females_sub2)		
summary(reg_mod)

########################################################################################################################
############################## USE ANCOVA TO COMPARE NEW SHELL AND NEW SHELL TRUNCATED SERIES ##########################
########################################################################################################################
ns_matfemales_analysis$Series<- "Base"
ns_matfemales_analysis_sub$Series<- "Sub1"
ns_matfemales_analysis_sub2$Series<- "Sub2"

analysis_females_sub<-rbind(ns_matfemales_analysis,ns_matfemales_analysis_sub)
analysis_females_sub2<-rbind(ns_matfemales_analysis_sub,ns_matfemales_analysis_sub2)
analysis_females_sub3<-rbind(ns_matfemales_analysis,ns_matfemales_analysis_sub2)

########################################################################################################################
############################### Run ANCOVA analyses to determine if base and series 1 are statistically different ############################

mod1<-aov(log10.weight~log10.length*Series,data = analysis_females_sub)
summary(mod1)									# p = 0.00701 on interaction term=significant interaction--suggests different slopes

mod2<-aov(log10.weight~log10.length+Series,data = analysis_females_sub)
summary(mod2)									# p = 0.298 for series, regression lines do not have differing intercepts

anova(mod1,mod2)									# p = 0.007013...removing interaction term does not sinificantly affect model

reg_mod<-lm(log10.weight~Series/log10.length-1,data=analysis_females_sub)		
summary(reg_mod)


########################################################################################################################
############################### Run ANCOVA analyses to determine if series 1 and 2 are statistically different ############################

mod1<-aov(log10.weight~log10.length*Series,data = analysis_females_sub2)
summary(mod1)									# p = 0.0111 on interaction term= significant interaction--suggests different slopes

mod2<-aov(log10.weight~log10.length+Series,data = analysis_females_sub2)
summary(mod2)									# p = 0.773 for series, regression lines do not have differing intercepts

anova(mod1,mod2)									# p = 0.7623...removing interaction term does not sinificantly affect model

reg_mod<-lm(log10.weight~Series/log10.length-1,data=analysis_females_sub2)		
summary(reg_mod)


########################################################################################################################
############################### Run ANCOVA analyses to determine if series 1 and 2 are statistically different ############################

mod1<-aov(log10.weight~log10.length*Series,data = analysis_females_sub3)
summary(mod1)									# p = 0.00352l on interaction term= significant interaction--suggests different slopes

mod2<-aov(log10.weight~log10.length+Series,data = analysis_females_sub3)
summary(mod2)									# p = 0.198  for series, regression lines do not have differing intercepts

anova(mod1,mod2)									# p = 0.003517...removing interaction term sinificantly affects model

reg_mod<-lm(log10.weight~Series/log10.length-1,data=analysis_females_sub2)		
summary(reg_mod)
}


