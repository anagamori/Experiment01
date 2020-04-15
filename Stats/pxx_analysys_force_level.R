library(R.matlab)
library(stats)
library(ggplot2)
library(gridExtra)
library(WRS2)

nTrial = 20

path_code = '/Users/akiranagamori/Documents/GitHub/MU-Population-Model/SLR Test/Stats'
path_data = '/Users/akiranagamori/Documents/GitHub/MU-Population-Model/Data/SLR_test_v9_IN_08_CN_007_007_8_045_RC_16_50_25_013_Ia_16_014_Ib_PIC_6_K/'
setwd(path_code)


data.temp <- readMat(paste(path_data,'pxx_Force.mat',sep = ""))
pxx.Force.1 <- data.temp$pxx.Force[1:nTrial,]

path_data = '/Users/akiranagamori/Documents/GitHub/MU-Population-Model/Data/SLR_test_v9_IN_08_CN_007_007_5_045_RC_7_50_25_013_Ia_13_014_Ib_PIC_6_K/'

data.temp <- readMat(paste(path_data,'pxx_Force.mat',sep = ""))
pxx.Force.2 <- data.temp$pxx.Force[1:nTrial,]

# path_data = '/Users/akiranagamori/Documents/GitHub/MU-Population-Model/Data/SLR_test_v9_IN_08_CN_007_007_0_0_RC_16_50_25_013_Ia_0_0_Ib_PIC_6_K/'
# 
# data.temp <- readMat(paste(path_data,'pxx_Force.mat',sep = ""))
# pxx.Force.3 <- data.temp$pxx.Force[1:nTrial,]

f = seq(0,30,by = 0.1)
p.val = vector(mode="numeric", length=length(f))
eff.size = vector(mode="numeric", length=length(f))
for (i in seq(1,length(f),1)){
  idx = rep(1:2, each=nTrial)
  val = c(pxx.Force.1[,i],pxx.Force.2[,i])
  # fit = lm(val~idx)
  df.data = data.frame(idx,val)
  test = yuen(val~idx,data = df.data,tr = 0)
  #F_test = oneway.test(val~idx,data = df.data,var.equal = F)
  p.val[i] =  test[3]$p.value
  if (p.val[i] > 0.1){
    p.val[i] = 0.1
  }
  eff.size[i] = test[6]$effsize
}

df = data.frame(x = c(f,f), y = c(colMeans(pxx.Force.1),colMeans(pxx.Force.2)),variable=rep(paste0("category", 1:2), each=length(f)))
p1 = ggplot(data = df, aes(x=x, y=y)) + geom_line(aes(colour=variable)) + xlim(0, 10)

df.p = data.frame(x = f,y = p.val)
p2 = ggplot(data = df.p, aes(x=x, y=y)) + geom_line(aes(colour='k')) + xlim(0, 10)

df.eff = data.frame(x = f,y = eff.size)
p3 = ggplot(data = df.eff, aes(x=x, y=y)) + geom_line(aes(colour='k')) + xlim(0, 10)
grid.arrange(p1,p2,p3,nrow = 3,ncol = 1)

p1.2 = ggplot(data = df, aes(x=x, y=y)) + geom_line(aes(colour=variable)) + xlim(0, 15) + ylim(0,0.0003)
p2.2 = ggplot(data = df.p, aes(x=x, y=y)) + geom_line(aes(colour='k')) + xlim(0, 15)
grid.arrange(p1.2,p2.2,nrow = 2)

pxx.1Hz.1 = rowMeans(pxx.Force.1[,6:21])
pxx.1Hz.2 = rowMeans(pxx.Force.2[,6:21])
val = c(pxx.1Hz.1,pxx.1Hz.2)
df.data = data.frame(idx,val)
yuen(val~idx,data = df.data,tr = 0.2)

pxx.4Hz.1 = rowMeans(pxx.Force.1[,41:51])
pxx.4Hz.2 = rowMeans(pxx.Force.2[,41:51])
val = c(pxx.4Hz.1,pxx.4Hz.2)
df.data = data.frame(idx,val)
yuen(val~idx,data = df.data,tr = 0.2)

pxx.6Hz.1 = rowMeans(pxx.Force.1[,51:71])
pxx.6Hz.2 = rowMeans(pxx.Force.2[,51:71])
val = c(pxx.6Hz.1,pxx.6Hz.2)
df.data = data.frame(idx,val)
yuen(val~idx,data = df.data,tr = 0.2)

setwd(path_data)
filename <- paste("p", ".mat", sep = "")
writeMat(filename,p = p.val)
filename <- paste("eff", ".mat", sep = "")
writeMat(filename,eff = eff.size)
setwd(path_code)

