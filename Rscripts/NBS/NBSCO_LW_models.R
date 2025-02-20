# Jon Richar with tidyverse functions courtesy of Erin Fedewa
# 5/20/2020
# Calculate length/weight regression models for BBRKC by shell condition
library(tidyverse)
library(stats)
library(nlme)
library(ggpubr)

#setwd("C:/Users/jon.richar/Work/GitRepos/EBSCrabLengthWeight/DATA/")


setwd("C:/Users/jon.richar/Work/GitRepos/EBSCrabLengthWeight/DATA/NBS_Data")

df<-read.csv("NBS_CO_DATA_FOR_SIZEWEIGHT_MALE.csv")
df1<-subset(df, WEIGHT>0 & SEX==1)
colnames(df1)
dev.new()
plot(df1$WEIGHT~df1$WIDTH)
#identify(df1$WEIGHT~df1$LENGTH)
######################### Tidyverse approach ###################################
df1 %>%
  mutate(logwidth = log(WIDTH),
          logweight = log(WEIGHT),
          Year = substring(CRUISE, 1,4), 
          YEAR = as.factor(Year)) %>%
 filter(SEX == 1) -> male #Only SC2 as to not bias for weight of epibionts 
#male
ggplot(male, aes(x = WIDTH, y = WEIGHT, group = YEAR)) +
     geom_point(aes(colour = factor(SHELL_CONDITION)))


################################################################################

sc1_males<-subset(df1,SEX==1 & SHELL_CONDITION==1)
sc2_males<-subset(df1,SEX==1 & SHELL_CONDITION==2)
sc3_males<-subset(df1,SEX==1 & SHELL_CONDITION==3)
sc4_males<-subset(df1,SEX==1 & SHELL_CONDITION==4)
sc5_males<-subset(df1,SEX==1 & SHELL_CONDITION==5)

hist(sc1_males$WEIGHT)
hist(sc2_males$WEIGHT)
hist(sc3_males$WEIGHT)
hist(sc4_males$WEIGHT)
hist(sc5_males$WEIGHT)

hist(log(sc2_males$WEIGHT))
hist(sc3_males$WEIGHT)
hist(sc4_males$WEIGHT)

plot(sc2_males$WEIGHT~sc2_males$WIDTH)
plot(sc3_males$WEIGHT~sc3_males$WIDTH)
plot(sc4_males$WEIGHT~sc4_males$WIDTH)

########################## Aggregate by New shell/old shell #####################################
ns_males<-subset(df1,SEX==1 & SHELL_CONDITION==2)
os_males<-subset(df1,SEX==1 & SHELL_CONDITION==3|SHELL_CONDITION==4)
os_males

all_males<-subset(df1,SEX==1)



#####################################################################################################################
############################ First model L-W relationship by shell condition #########################################
#####################################################################################################################


######################################################################################################
############################ New shell ###############################################################
######################################################################################################

plot(ns_males$WEIGHT~ns_males$WIDTH)
############################## Plot base data in GG plot ############################################################
dev.new()
p<-ggplot(ns_males, aes(x = WIDTH, y = WEIGHT)) +
      geom_point()
p+ labs(title="New shell (SC2) males")

############################# Add fields for analysis ########################################################
Year <- substring(ns_males$CRUISE, 1,4) 

YEAR <- as.factor(Year)
log.width<-log(ns_males$WIDTH)
log.weight <- log(ns_males$WEIGHT)
ns_male<-as.data.frame(cbind(ns_males,YEAR,log.width,log.weight))   		 # Bind new data objects and crab data in data frame  
ns_male                    							  		 # inspect data
names(ns_male)											 # Check column names


############################ Plot log transformeddata in GGplot #############################################
dev.new()
p<-ggplot(ns_male, aes(x = log.width, y = log.weight)) +
      geom_point()
p+ labs(x="ln(width)",y="ln(weight)", title="New shell (SC2) NBS males-log transformed")


############################## Fit initial model ########################################################

fit1<-lm(log.weight~log.width,data=ns_male)
summary(fit1)
coef(fit1)
############################## check diagnostics #################################################
dev.new()
par(mfrow=c(2,2))
plot(fit1)
plot(cooks.distance(fit1), pch=16, cex=0.5, main="Cook's distance with critical distance cutoff") 
     abline(h = 4/(nrow(ns_male)), col=4,lwd=1.5)  # critical Cooks Distance cutline(> 4/nobs)

ns_male$Cooks_D <- cooks.distance(fit1)
ns_males_analysis<-subset(ns_male, Cooks_D < (4/(nrow(ns_male))))
 
nrow(ns_male)-nrow(ns_males_analysis)    #75 obs removed based on Cook's Distance

nrow(ns_males_analysis)
##################################################################################################
############################# Plot using editted dataset #########################################
dev.new()
p<-ggplot(ns_males_analysis, aes(x = WIDTH, y = WEIGHT)) +
      geom_point()
p+ labs(title="New shell (SC2) NBS males- infuential points removed")


############################ log transformed ##################################################
dev.new()
p<-ggplot(ns_males_analysis, aes(x = log.width, y = log.weight)) +
      geom_point()
p+ labs(x="ln(width)",y="ln(weight)", title="New shell (SC2) NBS males-log transformed, influential points removed")

############################ Fit followup model ##########################################
fit2<-lm(log.weight~log.width,data=ns_males_analysis)
summary(fit2)
coef(fit2)

cf2<-as.matrix(coef(fit2))


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
A                         #0.000353156

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
# Corrcted for NBS CO
# a = 0.000353156 
# b = 3.023787
###################################################################################################
############################ Old shell ############################################################
###################################################################################################

dev.new()
plot(os_males$WEIGHT~os_males$WIDTH)
p<-ggplot(os_males, aes(x = WIDTH, y = WEIGHT)) +
      geom_point()
p+ labs(title="Old shell (SC3+SC4) males")

############################# Add fields for analysis ########################################################
Year <- substring(os_males$CRUISE, 1,4) 

YEAR <- as.factor(Year)
log.width<-log(os_males$WIDTH)
log.weight <- log(os_males$WEIGHT)
os_male<-as.data.frame(cbind(os_males,YEAR,log.width,log.weight))   		 # Bind new data objects and crab data in data frame  
os_male                    							  		 # inspect data
names(os_male)											 # Check column names


############################ Plot log transformeddata in GGplot #############################################
dev.new()
p<-ggplot(os_male, aes(x = log.width, y = log.weight)) +
      geom_point()
p+ labs(x="ln(width)",y="ln(weight)", title="Old shell (SC3+SC4) NBS males-log transformed")

############################## Fit initial model ########################################################

fit3<-lm(log.weight~log.width,data=os_male)
summary(fit3)
coef(fit3)

############################## check diagnostics #################################################
dev.new()
par(mfrow=c(2,2))
plot(fit3)
plot(cooks.distance(fit3), pch=16, cex=0.5, main="Cook's distance with critical distance cutoff") 
     abline(h = 4/(nrow(os_male)), col=4,lwd=1.5)  # critical Cooks Distance cutline(> 4/nobs)

os_male$Cooks_D <- cooks.distance(fit3)
os_males_analysis<-subset(os_male, Cooks_D < (4/(nrow(os_male))))
 
nrow(os_male)-nrow(os_males_analysis)    #2 obs removed

nrow(os_males_analysis)

##################################################################################################
############################# Plot using editted dataset #########################################
dev.new()
p<-ggplot(os_males_analysis, aes(x = WIDTH, y = WEIGHT)) +
      geom_point()
p+ labs(title="Old shell (SC3+SC4) males- infuential points removed")


############################ log transformed ##################################################
dev.new()
p<-ggplot(os_males_analysis, aes(x = log.width, y = log.weight)) +
      geom_point()
p+ labs(x="ln(width)",y="ln(weight)", title="Old shell (SC3+SC4) NBS opilio males-log transformed, influential points removed")

############################ Fit followup model ##########################################
fit4<-lm(log.weight~log.width,data=os_males_analysis)
summary(fit4)
coef(fit4)
cf4<-as.matrix(coef(fit4))

plot(log.weight~log.width,data=os_males_analysis)
abline(a=cf2[1,1],b=cf2[2,1])
abline(a=cf4[1,1],b=cf4[2,1])


################################################################################################
######################### plot baseline for comparison #########################################
setwd("C:/Users/jon.richar/Work/GitRepos/EBSCrabLengthWeight/DATA/")

base_dat<-read.csv("Baseline_Parameters.csv")

plot(log.weight~log.width,data=ns_males_analysis)
abline(a=cf2[1,1],b=cf2[2,1])
abline(a=cf4[1,1],b=cf4[2,1])
abline(a=base_dat[1,4],b=base_dat[2,4],col=3) #plot baseline for comparison

cf2
base_dat[1,4]
base_dat[2,4]

plot(log.weight~log.width,data=ns_males_analysis, ylim=c(4,10),xlim=c(4.0,5.0))
abline(a=cf2[1,1],b=cf2[2,1])
abline(a=cf4[1,1],b=cf4[2,1])
abline(a=base_dat[1,4],b=base_dat[2,4],col=3) #plot baseline for comparison

setwd("C:/Users/jon.richar/Work/GitRepos/EBSCrabLengthWeight/DATA/NBS_Data")
################################################################################################
######################## Apply bias-correction procedure #####################################
###############################################################################################
v4<-(summary(fit4)$sigma)**2  #Variance 
v4
int<-cf4[1,1]
A<-(exp(int)*exp(v4/2))
A                         #0.0004438862

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
# a = 0.0004438862
# b = 3.00448

############################ combine data sets and plot, using shell condition as grouping factor############################################################
os_males_analysis$SC <- "OS"
ns_males_analysis$SC <- "NS"

analysis_males<-rbind(ns_males_analysis,os_males_analysis)
#####Write csv as record ##################################

write.csv(analysis_males,"NBS_CO_Analysis_males.csv")

##### Plot ################################################
ggplot(analysis_males, aes(x = WIDTH, y = WEIGHT, group = SC)) +
     geom_point(aes(colour = factor(SC)))

q<-ggplot(analysis_males, aes(x = WIDTH, y = WEIGHT, group = SC)) +
     geom_point(aes(colour = factor(SC)))
q+ labs(x="Width(mm)",y="Weight(g)", title="Male NBS opilio (New shell and old shell)")

######################Log transformed #################################################
dev.new()


ggplot(analysis_males, aes(x = log.width, y = log.weight, group = SC)) +
     geom_point(aes(colour = factor(SC)))+
	labs(x="Ln(Width)",y="Ln(Weight)", title="Male NBS opilio (New shell and old shell, log-transformed)")

ebsco_sc_points<-ggplot(analysis_males, aes(x = log.width, y = log.weight, group = SC)) +
     geom_point(aes(colour = factor(SC)))+
	labs(x="Ln(Width)",y="Ln(Weight)", title="Male NBS CO (New shell and old shell, log-transformed)")

# lines ONLY
ggplot(analysis_males, aes(x = log.width, y = log.weight, group = SC,color = SC,shape=SC)) +
geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
labs(x="Ln(Width)",y="Ln(Weight)", title="Male NBS opilio (New shell and old shell, log-transformed)")

ebsco_sc_lines<-ggplot(analysis_males, aes(x = log.width, y = log.weight, group = SC,color = SC,shape=SC)) +
geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
labs(x="Ln(Width)",y="Ln(Weight)", title="Male NBS CO(New shell and old shell, log-transformed)")

# with points and lines
ggplot(analysis_males, aes(x = log.width, y = log.weight, group = SC,color = SC,shape=SC)) +
     geom_point()+
geom_smooth(method=lm, se=FALSE, fullrange=TRUE)+
labs(x="Ln(Width)",y="Ln(Weight)", title="Male NBS opilio (New shell and old shell log-transformed)")


################ Alternative approach with lines
ggscatter(analysis_males, x="log.width",y="log.weight",color="SC", add="reg.line"
)+
stat_regline_equation(
aes(label=paste(..eq.label.., ..rr.label.., sep="~~~~"), color = factor(SC))
)


########################################################################################################################
############################### Run ANCOVA analyses to determine if statistically different ############################

mod1<-aov(log.weight~log.width*SC,data = analysis_males)			# p = 0.889--insignificant interaction -- slopes not different
summary(mod1)

mod2<-aov(log.weight~log.width+SC,data = analysis_males)			# p< 4.31e-09: intercepts are significantly different
summary(mod2)

anova(mod1,mod2)										# p = 0.8895--interaction term is not significant to model

reg_mod<-lm(log.weight~SC/log.width-1,data=analysis_males)
summary(reg_mod)

######################################################################################################
############################ ALL MALES ###############################################################
######################################################################################################

plot(all_males$WEIGHT~all_males$WIDTH)
############################## Plot base data in GG plot ############################################################
dev.new()
p<-ggplot(all_males, aes(x = WIDTH, y = WEIGHT)) +
  geom_point()
p+ labs(title="New shell (SC2) males")

############################# Add fields for analysis ########################################################
Year <- substring(all_males$CRUISE, 1,4) 

YEAR <- as.factor(Year)
log.width<-log(all_males$WIDTH)
log.weight <- log(all_males$WEIGHT)
all_male<-as.data.frame(cbind(all_males,YEAR,log.width,log.weight))   		 # Bind new data objects and crab data in data frame  
all_male                    							  		 # inspect data
names(all_male)											 # Check column names


############################ Plot log transformeddata in GGplot #############################################
dev.new()
p<-ggplot(all_male, aes(x = log.width, y = log.weight)) +
  geom_point()
p+ labs(x="ln(width)",y="ln(weight)", title="New shell (SC2) NBS males-log transformed")


############################## Fit initial model ########################################################

fit1<-lm(log.weight~log.width,data=all_male)
summary(fit1)
coef(fit1)
############################## check diagnostics #################################################
dev.new()
par(mfrow=c(2,2))
plot(fit1)
plot(cooks.distance(fit1), pch=16, cex=0.5, main="Cook's distance with critical distance cutoff") 
abline(h = 4/(nrow(all_male)), col=4,lwd=1.5)  # critical Cooks Distance cutline(> 4/nobs)

all_male$Cooks_D <- cooks.distance(fit1)
all_males_analysis<-subset(all_male, Cooks_D < (4/(nrow(all_male))))

nrow(all_male)-nrow(all_males_analysis)    #75 obs removed based on Cook's Distance

nrow(all_males_analysis)
##################################################################################################
############################# Plot using editted dataset #########################################
dev.new()
p<-ggplot(all_males_analysis, aes(x = WIDTH, y = WEIGHT)) +
  geom_point()
p+ labs(title="New shell (SC2) NBS males- infuential points removed")


############################ log transformed ##################################################
dev.new()
p<-ggplot(all_males_analysis, aes(x = log.width, y = log.weight)) +
  geom_point()
p+ labs(x="ln(width)",y="ln(weight)", title="New shell (SC2) NBS males-log transformed, influential points removed")

############################ Fit followup model ##########################################
fit2<-lm(log.weight~log.width,data=all_males_analysis)
summary(fit2)
coef(fit2)

cf2<-as.matrix(coef(fit2))


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
A                         #0.000353156

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
# Corrcted for NBS CO
# a = 0.0003437372 
# b = 3.031287