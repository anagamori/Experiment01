library(R.matlab)
library(nlme)
library(car)
path_code = '/Users/akiranagamori/Documents/GitHub/Experiment01/Stats'
path_data = '/Users/akiranagamori/Documents/GitHub/Experiment01/'

data <- readMat(paste(path_data,'Data_CoV.mat',sep = ""))
data.df <- as.data.frame(data$Data.CoV)
colnames(data.df) <- c("subjectID","condition","muscle","CoV")

model = aov(CoV~condition*muscle + Error(subjectID/(condition*muscle)),data = data.df)
summary(model)
