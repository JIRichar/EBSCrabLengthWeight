library(stats4)
library(readxl)
library(tidyverse)
Female_EBSCO_weights_and_temps <- read_csv("//akc0ks-n220/KOD_Research/RKC-BKC/Survey L-W paper- Jon/Opilio/Female_EBSCO_weights_temps_analysis.csv")

Female_EBSCO_weights_and_temps
FEBSCO=Female_EBSCO_weights_and_temps
names(Female_EBSCO_weights_and_temps)
FEBSCO%>% filter(CLUTCH_SIZE==4|CLUTCH_SIZE==5|CLUTCH_SIZE==6)->FEBSCO_mat

# Sample size
nrow(FEBSCO_mat)

#MODEL 1#
#Null

LW1=function(a,b,sd){
  ave=log(FEBSCO_mat$WIDTH)*b+a
	-sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
	}
param=list(a=-8,b=3,sd=0.1)
mLW1=mle(LW1,start=param)
summary(mLW1)

#MODEL 2: #
#a(SC)
LW2=function(a,aOS,b,sd){
  a=a+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,b=3,aOS=0,sd=0.1)
mLW2=mle(LW2,start=param)
summary(mLW2)

#MODEL 3: #
#b(SC)
LW3=function(a,bOS,b,sd){
  b=b+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,b=3,bOS=0,sd=0.1)
mLW3=mle(LW3,start=param)
summary(mLW3)

#MODEL 4: #
#a(SC)b(SC)
LW4=function(a,aOS,b,bOS,sd){
  a=a+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  b=b+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aOS=0,b=3,bOS=0,sd=0.1)
mLW4=mle(LW4,start=param)
summary(mLW4)

#MODEL 5: #
#a(T)
LW5=function(a,aT,b,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-5,aT=0,b=2.5,sd=0.05)
mLW5=mle(LW5,start=param)
summary(mLW5)

#MODEL 6: #
#b(T)
LW6=function(a,bT,b,sd){
  b=b+bT*FEBSCO_mat$Temperature_MATFEM
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,bT=0,b=3,sd=0.1)
mLW6=mle(LW6,start=param)
summary(mLW6)

#MODEL 7: #
#a(T)b(T)
LW7=function(a,aT,b,bT,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM
  b=b+bT*FEBSCO_mat$Temperature_MATFEM
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,b=3,bT=0,sd=0.1)
mLW7=mle(LW7,start=param)
summary(mLW7)

#MODEL 8: #
#a(Tr)b(Tr)
LW8=function(a,aTr,b,bTr,sd){
  a=a+aTr*(FEBSCO_mat$Temperature_MATFEM>1.0)
  b=b+bTr*(FEBSCO_mat$Temperature_MATFEM>1.0)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aTr=0,b=3,bTr=0,sd=0.1)
mLW8=mle(LW8,start=param)
summary(mLW8)

#MODEL 9: #
#a(T,T2)b(T,T2)
LW9=function(a,aT,aT2,b,bT,bT2,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM+aT2^2*FEBSCO_mat$Temperature_MATFEM
  b=b+bT*FEBSCO_mat$Temperature_MATFEM+bT2^2*FEBSCO_mat$Temperature_MATFEM
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,aT2=0,b=3,bT=0,bT2=0,sd=0.1)
mLW9=mle(LW9,start=param)
summary(mLW9)

#MODEL 10: #
#a(T,SC)b(T)
LW10=function(a,aT,aOS,b,bT,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  b=b+bT*FEBSCO_mat$Temperature_MATFEM
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,aOS=0,b=3,bT=0,sd=0.1)
mLW10=mle(LW10,start=param)
summary(mLW10)

#MODEL 11: #
#a(T)b(T,SC)
LW11=function(a,aT,b,bT,bOS,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM
  b=b+bT*FEBSCO_mat$Temperature_MATFEM+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,b=3,bOS=0,bT=0,sd=0.1)
mLW11=mle(LW11,start=param)
summary(mLW11)

#MODEL 12: #
#a(T,SC)b(T,SC)
LW12=function(a,aT,aOS,b,bT,bOS,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  b=b+bT*FEBSCO_mat$Temperature_MATFEM+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,aOS=0,b=3,bOS=0,bT=0,sd=0.1)
mLW12=mle(LW12,start=param)
summary(mLW12)


#MODEL 13: #
#a(SC,Tr)b(Tr)
LW13=function(a,aOS,aTr,b,bTr,sd){
  a=a+aTr*(FEBSCO_mat$Temperature_MATFEM>1.0)+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  b=b+bTr*(FEBSCO_mat$Temperature_MATFEM>1.0)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aOS=0,aTr=0,b=3,bTr=0,sd=0.1)
mLW13=mle(LW13,start=param)
summary(mLW13)

#MODEL 14: #
#a(Tr)b(SC,Tr)
LW14=function(a,aTr,b,bOS,bTr,sd){
  a=a+aTr*(FEBSCO_mat$Temperature_MATFEM>1.0)
  b=b+bTr*(FEBSCO_mat$Temperature_MATFEM>1.0)+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aTr=0,b=3,bOS=0,bTr=0,sd=0.1)
mLW14=mle(LW14,start=param)
summary(mLW14)


#MODEL 15: #
#a(SC,Tr)b(SC,Tr)
LW15=function(a,aOS,aTr,b,bOS,bTr,sd){
  a=a+aTr*(FEBSCO_mat$Temperature_MATFEM>1.0)+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  b=b+bTr*(FEBSCO_mat$Temperature_MATFEM>1.0)+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aOS=0,aTr=0,b=3,bOS=0,bTr=0,sd=0.1)
mLW15=mle(LW15,start=param)
summary(mLW15)

#MODEL 16: #
#a(SC,T)b
LW16=function(a,aT,aOS,b,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,aOS=0,b=3,sd=0.1)
mLW16=mle(LW16,start=param)
summary(mLW16)

#MODEL 17: #
#a,b(T,SC)
LW17=function(a,b,bT,bOS,sd){
  b=b+bT*FEBSCO_mat$Temperature_MATFEM+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,b=3,bOS=0,bT=0,sd=0.1)
mLW17=mle(LW17,start=param)
summary(mLW17)

#MODEL 18: #
#a(SC,T(SC))b
LW18=function(a,a2T,aOS,b,sd){
  a=a+a2T*FEBSCO_mat$Temperature_MATFEM*(FEBSCO_mat$SHELL_CONDITION==2)+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,a2T=0,aOS=0,b=3,sd=0.1)
mLW18=mle(LW18,start=param)
summary(mLW18)

#MODEL 19: #
#a(SC#T))b
LW19=function(a,aT,a2T,aOS,b,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM+a2T*FEBSCO_mat$Temperature_MATFEM*(FEBSCO_mat$SHELL_CONDITION==2)+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,a2T=0,aOS=0,b=3,sd=0.1)
mLW19=mle(LW19,start=param)
summary(mLW19)

#MODEL 20: #
#a,b(T(SC),SC)
LW20=function(a,b,b2T,bOS,sd){
  b=b+b2T*FEBSCO_mat$Temperature_MATFEM*(FEBSCO_mat$SHELL_CONDITION==2)+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,b=3,bOS=0,b2T=0,sd=0.1)
mLW20=mle(LW20,start=param)
summary(mLW20)

#MODEL 21: #
#a,b(T#SC)
LW21=function(a,b,bT,b2T,bOS,sd){
  b=b+bT*FEBSCO_mat$Temperature_MATFEM+b2T*FEBSCO_mat$Temperature_MATFEM*(FEBSCO_mat$SHELL_CONDITION==2)+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,b=3,bT=0,bOS=0,b2T=0,sd=0.1)
mLW21=mle(LW21,start=param)
summary(mLW21)

#MODEL 22: #
#a(T#SC),b(T#SC)
LW22=function(a,aT,a2T,aOS,b,bT,b2T,bOS,sd){
  a=a+aT*FEBSCO_mat$Temperature_MATFEM+a2T*FEBSCO_mat$Temperature_MATFEM*(FEBSCO_mat$SHELL_CONDITION==2)+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  b=b+bT*FEBSCO_mat$Temperature_MATFEM+b2T*FEBSCO_mat$Temperature_MATFEM*(FEBSCO_mat$SHELL_CONDITION==2)+bOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,a2T=0,aOS=0,b=3,bT=0,bOS=0,b2T=0,sd=0.1)
mLW22=mle(LW22,start=param)
summary(mLW22)

#MODEL 23: #
#a(SC#Tr))b
LW23=function(a,aTr,a2Tr,aOS,b,sd){
  a=a+aTr*(FEBSCO_mat$Temperature_MATFEM>1.0)+a2Tr*(FEBSCO_mat$Temperature_MATFEM>1.0)*(FEBSCO_mat$SHELL_CONDITION==2)+aOS*(FEBSCO_mat$SHELL_CONDITION!=2)
  ave=log(FEBSCO_mat$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_mat$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aTr=0,a2Tr=0,aOS=0,b=3,sd=0.1)
mLW23=mle(LW23,start=param)
summary(mLW23)

##############################CLUTCH_SIZE (4, 5 and 6)
#MODEL 24: #
#b(clutch)
names(FEBSCO_mat)
FEBSCO_mat%>% filter(CLUTCH_SIZE==4|CLUTCH_SIZE==5|CLUTCH_SIZE==6)->FEBSCO_clutch
nrow(FEBSCO_clutch)

LW24=function(a,bc4,bc5,bc6,b,sd){
  b=b+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,b=3,bc4=0,bc5=0,bc6=0,sd=0.1)
mLW24=mle(LW24,start=param)
summary(mLW24)

#MODEL 25: #
#a(bc)b(bc)
LW25=function(a,ac4,ac5,ac6,b,bc4,bc5,bc6,sd){
  a=a+
    ac4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    ac5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    ac6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  b=b+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,ac4=0,ac5=0,ac6=0,b=3,bc4=0,bc5=0,bc6=0,sd=0.1)
mLW25=mle(LW25,start=param)
summary(mLW25)

#MODEL 26: #
#a(SC)b(clutch)
LW26=function(a,aOS,b,bc4,bc5,bc6,sd){
  a=a+aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aOS=0,b=3,bc4=0,bc5=0,bc6=0,sd=0.1)
mLW26=mle(LW26,start=param)
summary(mLW26)

#MODEL 27: #
#a(SC#T)b(clutch#T)
LW27=function(a,aT,a2T,aOS,b,bc4,bc5,bc6,bT,b4T,b5T,b6T,sd){
  a=a+
    aT*FEBSCO_clutch$Temperature_MATFEM+
    a2T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+
    bT*FEBSCO_clutch$Temperature_MATFEM+
    b4T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    b5T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    b6T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,a2T=0,aOS=0,b=3,bT=0,bc4=0,bc5=0,bc6=0,b4T=0,b5T=0,b6T=0,sd=0.1)
mLW27=mle(LW27,start=param)
summary(mLW27)

#MODEL 28: #
#a(SC#T)b(Clutch#SC)
LW28=function(a,aT,a2T,aOS,b,bc4,bc5,bc6,bOS,b4OS,b5OS,b6OS,sd){
  a=a+
    aT*FEBSCO_clutch$Temperature_MATFEM+
    a2T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+
    bOS*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    b4OS*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    b5OS*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    b6OS*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,a2T=0,aOS=0,b=3,bOS=0,bc4=0,bc5=0,bc6=0,b4OS=0,b5OS=0,b6OS=0,sd=0.1)
mLW28=mle(LW28,start=param)
summary(mLW28)

#MODEL 29: #
#a(SC)b(Clutch#SC)
LW29=function(a,aOS,b,bc4,bc5,bc6,bOS,b4OS,b5OS,b6OS,sd){
  a=a+aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+
    bOS*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    b4OS*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    b5OS*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    b6OS*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aOS=0,b=3,bOS=0,bc4=0,bc5=0,bc6=0,b4OS=0,b5OS=0,b6OS=0,sd=0.1)
mLW29=mle(LW29,start=param)
summary(mLW29)

#MODEL 30: #
#a(SC#T)b(CS)
LW30=function(a,aT,a2T,aOS,b,bc4,bc5,bc6,sd){
  a=a+aT*FEBSCO_clutch$Temperature_MATFEM+
    a2T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,aT=0,a2T=0,aOS=0,b=3,bc4=0,bc5=0,bc6=0,sd=0.1)
mLW30=mle(LW30,start=param)
summary(mLW30)

#MODEL 31: #
#a(SC#CS)b(CS)
LW31=function(a,ac4,ac5,ac6,a4c,a5c,a6c,aOS,b,bc4,bc5,bc6,sd){
  a=a+
    ac4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    ac5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    ac6*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    a4c*(FEBSCO_clutch$CLUTCH_SIZE==4)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a5c*(FEBSCO_clutch$CLUTCH_SIZE==5)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a6c*(FEBSCO_clutch$CLUTCH_SIZE==6)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,ac4=0,ac5=0,ac6=0,a4c=0,a5c=0,a6c=0,aOS=0,b=3,bc4=0,bc5=0,bc6=0,sd=0.1)
mLW31=mle(LW31,start=param)
summary(mLW31)

#Model 32: #

#a(SC#CS)b(SC#CS)
LW32=function(a,ac4,ac5,ac6,a4c,a5c,a6c,aOS,b,bOS,bc4,bc5,bc6,b4c,b5c,b6c,sd){
  a=a+
    ac4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    ac5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    ac6*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    a4c*(FEBSCO_clutch$CLUTCH_SIZE==4)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a5c*(FEBSCO_clutch$CLUTCH_SIZE==5)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a6c*(FEBSCO_clutch$CLUTCH_SIZE==6)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+
    bOS*(FEBSCO_clutch$SHELL_CONDITION!=2)+ 
    b4c*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    b5c*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    b6c*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,ac4=0,ac5=0,ac6=0,a4c=0,a5c=0,a6c=0,aOS=0,b=3,bOS=0,bc4=0,bc5=0,bc6=0,b4c=0,b5c=0,b6c=0,sd=0.1)
mLW32=mle(LW32,start=param)
summary(mLW32)

#MODEL 33: #
#a(clutch)

LW33=function(a,ac4,ac5,ac6,b,sd){
  a=a+
    ac4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    ac5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    ac6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,ac4=0,ac5=0,ac6=0,b=3,sd=0.1)
mLW33=mle(LW33,start=param)
summary(mLW33)

#Model 34   #
#a(SC#CS#T)b(SC#CS)
LW34=function(a,ac4,ac5,ac6,a2c,a3c,a4c,aT,a2T,a3T,a4T,a5T,ac4T,ac5T,ac6T,aOS,b,bOS,bc4,bc5,bc6,b2c,sd){
  a=a+
    ac4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    ac5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    ac6*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    a2c*(FEBSCO_clutch$CLUTCH_SIZE==4)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a3c*(FEBSCO_clutch$CLUTCH_SIZE==5)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a4c*(FEBSCO_clutch$CLUTCH_SIZE==6)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aT*FEBSCO_clutch$Temperature_MATFEM +
    a2T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    ac4T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    ac5T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    ac6T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    a3T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==4)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a4T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==5)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a5T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==6)*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+bOS*(FEBSCO_clutch$SHELL_CONDITION!=2)+ 
    b2c*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE!=4)+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,ac4=0,ac5=0,ac6=0,a2c=0,a3c=0,a4c=0,aT=0,a2T=0,a3T=0,a4T=0,a5T=0,ac4T=0,ac5T=0,ac6T=0,aOS=0,b=3,bOS=0,bc4=0,bc5=0,bc6=0,b2c=0,sd=0.1)
mLW34=mle(LW34,start=param)
summary(mLW34)


#Model 35   #
#33 parameters(!)
#a(SC#CS#T)b(SC#CS#T)
LW35=function(a,ac4,ac5,ac6,a2c,a3c,a4c,aOS,aT,aSCT,ac4T,ac5T,ac6T,a4T,a5T,a6T,b,bOS,b2c,b3c,b4c,bc4,bc5,bc6,bT,bSCT,bc4T,bc5T,bc6T,b4T,b5T,b6T,sd){
  a=a+
    ac4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    ac5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    ac6*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    a2c*(FEBSCO_clutch$CLUTCH_SIZE==4)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a3c*(FEBSCO_clutch$CLUTCH_SIZE==5)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a4c*(FEBSCO_clutch$CLUTCH_SIZE==6)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aOS*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    aT*FEBSCO_clutch$Temperature_MATFEM +
    aSCT*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    ac4T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    ac5T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    ac6T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    a4T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==4)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a5T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==5)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    a6T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==6)*(FEBSCO_clutch$SHELL_CONDITION!=2)
  b=b+bOS*(FEBSCO_clutch$SHELL_CONDITION!=2)+ 
    b2c*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    b3c*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    b4c*(FEBSCO_clutch$SHELL_CONDITION!=2)*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    bc4*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    bT*FEBSCO_clutch$Temperature_MATFEM +
    bSCT*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    bc4T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==4)+
    bc5T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==5)+
    bc6T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==6)+
    b4T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==4)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    b5T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==5)*(FEBSCO_clutch$SHELL_CONDITION!=2)+
    b6T*FEBSCO_clutch$Temperature_MATFEM*(FEBSCO_clutch$CLUTCH_SIZE==6)*(FEBSCO_clutch$SHELL_CONDITION!=2)
  ave=log(FEBSCO_clutch$WIDTH)*b+a
  -sum(dnorm(log(FEBSCO_clutch$WEIGHT), mean=ave,sd=sd,log=TRUE))
}
param=list(a=-8,ac4=0,ac5=0,ac6=0,a2c=0,a3c=0,a4c=0,aT=0,aOS=0,aSCT=0,ac4T=0,ac5T=0,ac6T=0,a4T=0,a5T=0,a6T=0,b=3,bOS=0,
           b2c=0,b3c=0,b4c=0,bc4=0,bc5=0,bc6=0,bT=0,bSCT=0,bc4T=0,bc5T=0,bc6T=0,b4T=0,b5T=0,b6T=0,sd=0.1)
mLW35=mle(LW35,start=param)
summary(mLW35)


