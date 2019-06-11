
path_code = '/Users/akiranagamori/Documents/GitHub/Experiment01/Stats'
data_file = '/Users/akiranagamori/Documents/GitHub/Experiment01/Stats/HFEIFbytree.csv'
tree<- read.csv(data_file, header=T,sep=",")
tree$ID<- factor(tree$ID)
tree$plotnr <- factor(tree$plotnr)

library(lattice)
bwplot(height ~ Date|treat,data=tree)

tree$Date<- as.Date(tree$Date)
tree$time<- as.numeric(tree$Date - min(tree$Date))

boxplot(height ~ plotnr,data=tree)

library(lme4)
library(lmerTest)

#mod <- lmer(height ~ time + treat + (1|plotnr),data=tree) #without interaction
mod.int <- lmer(height ~ time * treat + (1|plotnr),data=tree) #with interaction
#anova(mod,mod.int)

anova(mod.int)

