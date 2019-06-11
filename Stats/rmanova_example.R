library(R.matlab)
library(lattice)
library(lme4)
library(lmerTest)

path_code = '/Users/akiranagamori/Documents/GitHub/Experiment01/Stats'
path_data = '/Users/akiranagamori/Documents/GitHub/Experiment01/'

data.temp <- readMat(paste(path_data,'CoV.mat',sep = ""))
data <- data.temp$CoV
subID <- seq(1,dim(data)[1])
data.all <- cbind(c(subID),data)
correl = cor(data.all,use="pairwise.complete.obs")
symnum(correl)
data.df <- as.data.frame(data.all) 
colnames(data.df) <- c("subID","Fl_HG","Fl_LG","Ex_HG","Ex_LG")

random = rchisq(nrow(data.df[,-1]),7)
fake = lm(random~.,data = data.df[,-1])
standardized = rstudent(fake)
fitted = scale(fake$fitted.values)

hist(standardized)
qqnorm(standardized)
abline(0,1)

plot(fitted,standardized)
abline(0,0)
abline(v=0)

library(reshape)
longdata = melt(data.df,id = "subID",measured = c("Fl_HG","Fl_LG","Ex_HG","Ex_LG"))
longdata$condition = c(rep("High",dim(data)[1]),
                       rep("Low",dim(data)[1]),
                       rep("High",dim(data)[1]),
                       rep("Low",dim(data)[1]))
longdata$muscle = c(rep("Fl",dim(data)[1]*2),
                       rep("Ex",dim(data)[1]*2))

longdata$condition = factor(longdata$condition,
                            levels = c("High","Low"),
                            labels = c("High","Low"))
longdata$muscle = factor(longdata$muscle,
                            levels = c("Fl","Ex"),
                            labels = c("Fl","Ex"))

longdata <- within(longdata,{
  subjectID <- factor(subID)
  condition <- factor(condition)
  muscle <- factor(muscle)
})
longdata <- longdata[order(longdata$subID),]
longdata.mean <- aggregate(longdata$value,
                           by = list(longdata$subID, longdata$condition,
                                     longdata$muscle),
                           FUN = 'mean')
colnames(longdata.mean) <- c("subID","condition","muscle","CoV")

CoV.aov <- with(longdata.mean,aov(CoV~condition*muscle + Error(subID/(condition*muscle))))
summary(CoV.aov)
