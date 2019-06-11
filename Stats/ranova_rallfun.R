library(R.matlab)
library(lattice)

setwd("/Users/akiranagamori/Desktop/Research/Papers/Tendon Stiffness/R-Code")
source('Rallfun-v33')
setwd("/Users/akiranagamori/Documents/GitHub/Experiment01/")

path_code = '/Users/akiranagamori/Documents/GitHub/Experiment01/Stats'
path_data = '/Users/akiranagamori/Documents/GitHub/Experiment01/'

#============================================================
data.temp <- readMat(paste(path_data,'CoV.mat',sep = ""))
data <- data.temp$CoV
subID <- seq(1,dim(data)[1])
data.all <- cbind(c(subID),data)
correl = cor(data.all,use="pairwise.complete.obs")
symnum(correl)
data.df <- as.data.frame(data.all) 
colnames(data.df) <- c("subID","Fl_HG","Fl_LG","Ex_HG","Ex_LG")

condition1 = rep(1,each = dim(data)[1])
condition2 = rep(2,each = dim(data)[1])
condition <- c(condition1,condition2,condition1,condition2)
data.long<- cbind(c(data.df$Fl_HG,data.df$Fl_LG),c(data.df$Ex_HG,data.df$Ex_LG),condition)
data.list <- list(data.df$Fl_HG,data.df$Fl_LG,data.df$Ex_HG,data.df$Ex_LG)

wwtrim(2,2,data.list,tr = 0)
wwmcp(2,2,data.list,tr = 0)

wwtrimbt(2,2,data.list,tr = 0)
wwmcppb(2,2,data.list,tr = 0)

yuend(data.df$Fl_HG,data.df$Ex_HG,tr=0,alpha=0.05)
ydbt(data.df$Fl_HG,data.df$Ex_HG,tr=0,alpha=0.05)
bootdpci(data.df$Fl_HG,data.df$Ex_HG,est=onestep)

yuend(data.df$Fl_LG,data.df$Ex_LG,tr=0,alpha=0.05)


#============================================================
data.temp <- readMat(paste(path_data,'p_12_20.mat',sep = ""))
data <- data.temp$p.12.20
subID <- seq(1,dim(data)[1])
data.all <- cbind(c(subID),data)
correl = cor(data.all,use="pairwise.complete.obs")
symnum(correl)
data.df <- as.data.frame(data.all) 
colnames(data.df) <- c("subID","Fl_HG","Fl_LG","Ex_HG","Ex_LG")

condition1 = rep(1,each = dim(data)[1])
condition2 = rep(2,each = dim(data)[1])
condition <- c(condition1,condition2,condition1,condition2)
data.long<- cbind(c(data.df$Fl_HG,data.df$Fl_LG),c(data.df$Ex_HG,data.df$Ex_LG),condition)
data.list <- list(data.df$Fl_HG,data.df$Fl_LG,data.df$Ex_HG,data.df$Ex_LG)

wwtrim(2,2,data.list,tr = 0)
wwmcp(2,2,data.list,tr = 0)

wwtrimbt(2,2,data.list,tr = 0)
wwmcppb(2,2,data.list,tr = 0)

yuend(data.df$Fl_HG,data.df$Ex_HG,tr=0,alpha=0.05)
ydbt(data.df$Fl_HG,data.df$Ex_HG,tr=0,alpha=0.05)
bootdpci(data.df$Fl_HG,data.df$Ex_HG,est=onestep)

#============================================================
data.temp <- readMat(paste(path_data,'PT.mat',sep = ""))
data <- data.temp$PT
subID <- seq(1,dim(data)[1])
data.all <- cbind(c(subID),data)
correl = cor(data.all,use="pairwise.complete.obs")
symnum(correl)
data.df <- as.data.frame(data.all) 
colnames(data.df) <- c("subID","Fl_HG","Fl_LG","Ex_HG","Ex_LG")

condition1 = rep(1,each = dim(data)[1])
condition2 = rep(2,each = dim(data)[1])
condition <- c(condition1,condition2,condition1,condition2)
data.long<- cbind(c(data.df$Fl_HG,data.df$Fl_LG),c(data.df$Ex_HG,data.df$Ex_LG),condition)
data.list <- list(data.df$Fl_HG,data.df$Fl_LG,data.df$Ex_HG,data.df$Ex_LG)

wwtrim(2,2,data.list,tr = 0)
wwmcp(2,2,data.list,tr = 0)

wwtrimbt(2,2,data.list,tr = 0)
wwmcppb(2,2,data.list,tr = 0)

yuend(data.df$Fl_HG,data.df$Ex_HG,tr=0,alpha=0.05)
ydbt(data.df$Fl_HG,data.df$Ex_HG,tr=0,alpha=0.05)
bootdpci(data.df$Fl_HG,data.df$Ex_HG,est=onestep)

#============================================================
data.temp <- readMat(paste(path_data,'HR.mat',sep = ""))
data <- data.temp$HR
subID <- seq(1,dim(data)[1])
data.all <- cbind(c(subID),data)
correl = cor(data.all,use="pairwise.complete.obs")
symnum(correl)
data.df <- as.data.frame(data.all) 
colnames(data.df) <- c("subID","Fl_HG","Fl_LG","Ex_HG","Ex_LG")

condition1 = rep(1,each = dim(data)[1])
condition2 = rep(2,each = dim(data)[1])
condition <- c(condition1,condition2,condition1,condition2)
data.long<- cbind(c(data.df$Fl_HG,data.df$Fl_LG),c(data.df$Ex_HG,data.df$Ex_LG),condition)
data.list <- list(data.df$Fl_HG,data.df$Fl_LG,data.df$Ex_HG,data.df$Ex_LG)

wwtrim(2,2,data.list,tr = 0)
wwmcp(2,2,data.list,tr = 0)

wwtrimbt(2,2,data.list,tr = 0)
wwmcppb(2,2,data.list,tr = 0)

yuend(data.df$Fl_HG,data.df$Fl_LG,tr=0,alpha=0.05)
yuend(data.df$Ex_HG,data.df$Ex_LG,tr=0,alpha=0.05)
ydbt(data.df$Fl_HG,data.df$Ex_HG,tr=0,alpha=0.05)
bootdpci(data.df$Fl_HG,data.df$Ex_HG,est=onestep)