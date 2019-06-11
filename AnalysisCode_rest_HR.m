

close all
clear all
clc

%--------------------------------------------------------------------------
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 01 20_MVC/';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';
%--------------------------------------------------------------------------
Fs = 100;


%%
[b,a] = butter(4,[0.5 10]/(Fs/2),'bandpass');
[b_low,a_low] = butter(4,20/(Fs/2),'low');

threshold = 15;
cd (dataFolder)
load('rest');
cd (codeFolder)

Data_HR = data.values_GSR(8*Fs+1:end,2);
Data_HR_filt = filtfilt(b,a,Data_HR);
[HR_vec] =  EKG2HR (Data_HR_filt,Fs,threshold,1);
mean_HR = mean(HR_vec)

Data_GSR = data.values_GSR(8*Fs+1:end,3);
Data_GSR_filt = filtfilt(b_low,a_low,Data_GSR);
mean_GSR = mean(Data_GSR_filt)

time = [1:length(HR_vec)]/Fs;

figure(1)
plot(time,HR_vec)

figure(2)
plot(time,Data_GSR_filt)

cd(dataFolder)
save('rest_HR','mean_HR')
save('rest_GSR','mean_GSR')
cd(codeFolder)