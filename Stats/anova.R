library(R.matlab)
library(lattice)
library(lme4)
library(lmerTest)

path_code = '/Users/akiranagamori/Documents/GitHub/Experiment01/Stats'
path_data = '/Users/akiranagamori/Documents/GitHub/Experiment01/'

data <- readMat(paste(path_data,'Data_All.mat',sep = ""))
data.df <- as.data.frame(data$Data.All)
colnames(data.df) <- c("subID","muscle","condition","CoV","PT") #,"nHR","dHR","GSR")

boxplot(CoV ~ subID,data=data.df)

## CoV for force
#mod <- lmer(CoV ~ muscle + condition + (1|subID),data=data.df) #without interaction
#anova(mod,mod.int)
mod.int.CoV <- lmer(CoV ~ muscle * condition + (1|subID),data=data.df) #with interaction
anova(mod.int.CoV)
summary(mod.int.CoV)

## Heart rate
mod.int.nHR<- lmer(nHR ~ muscle * condition + (1|subID),data=data.df) #with interaction
anova(mod.int.nHR)
summary(mod.int.nHR)

## Physiological tremor
mod.int.PT<- lmer(PT ~ muscle * condition + (1|subID),data=data.df) #with interaction
anova(mod.int.PT)
summary(mod.int.PT)
