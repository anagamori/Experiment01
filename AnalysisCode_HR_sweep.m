%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 1/11/2019
% Descriptions:
%   Analysis test trials
%--------------------------------------------------------------------------

close all
clear all
clc


for n = 1:4
    n
    %--------------------------------------------------------------------------
    subjectFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n)];
    dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) '/Wrist extension'];
    codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';
    %--------------------------------------------------------------------------
    Fs = 100;
    
    cd(subjectFolder)
    load('rest_HR')
    load('rest_GSR')
    cd(codeFolder)
    rest_HR = mean_HR;
    rest_GSR = mean_GSR;
    %%
    [b,a] = butter(4,[0.5 5]/(Fs/2),'bandpass');
    [b_low,a_low] = butter(4,20/(Fs/2),'low');
    %%
    threshold = 15;
    %%
    time = [1:20*Fs]/Fs;
    HR_1_all = zeros(10,length(time));
    HR_2_all = zeros(10,length(time));
    HR_3_all = zeros(10,length(time));
    
    GSR_1_all = zeros(10,length(time));
    GSR_2_all = zeros(10,length(time));
    GSR_3_all = zeros(10,length(time));
    
    for i = 1:10
        
        %fileName1 = ['dc_' num2str(i)];
        fileName1 = ['hg_' num2str(i)];
        fileName2 = ['lg_' num2str(i)];
        %fileName4 = ['compensation_reverse_' num2str(i) '_' num2str(i) '.mat'];
        
        cd (dataFolder)
        load(fileName1);
        cd (codeFolder)
        Data_HR_1 = data.values_GSR(3*Fs+1:23*Fs,2);
        Data_HR_filt_1 = filtfilt(b,a,Data_HR_1);
        [HR_1_vec] =  EKG2HR (Data_HR_filt_1,Fs,threshold,0);
        HR_1_all(i,:) = HR_1_vec-rest_HR;
        
        Data_GSR_1 = data.values_GSR(3*Fs+1:23*Fs,3);
        Data_GSR_filt_1 = filtfilt(b_low,a_low,Data_GSR_1);
        GSR_1_all(i,:) = Data_GSR_filt_1-Data_GSR_filt_1(1);
        
        cd (dataFolder)
        load(fileName2);
        cd (codeFolder)
        Data_HR_2 = data.values_GSR(3*Fs+1:23*Fs,2);
        Data_HR_filt_2 = filtfilt(b,a,Data_HR_2);
        [HR_2_vec] =  EKG2HR (Data_HR_filt_2,Fs,threshold,0);
        HR_2_all(i,:) = HR_2_vec-rest_HR;
        
        Data_GSR_2 = data.values_GSR(3*Fs+1:23*Fs,3);
        Data_GSR_filt_2 = filtfilt(b_low,a_low,Data_GSR_2);
        GSR_2_all(i,:) = Data_GSR_filt_2-Data_GSR_filt_2(1);
        
        HR_1(i)  = mean(HR_1_vec(end-10*Fs+1:end))-rest_HR;
        HRV_1(i)  = std(HR_1_vec(end-10*Fs+1:end)); %-restHRV ;
        HRV_rms_1(i) = mean(rms(diff(HR_1_vec(end-10*Fs+1:end)))); %-restHRV_rms;
        HR_2(i)  = mean(HR_2_vec(end-10*Fs+1:end))-rest_HR;
        HRV_2(i)  = std(HR_2_vec(end-10*Fs+1:end)); %-restHRV ;
        HRV_rms_2(i) = mean(rms(diff(HR_2_vec(end-10*Fs+1:end)))); %-restHRV_rms;
        
        HR_diff_1(i)  = mean(HR_1_vec(end-10*Fs+1:end))-mean(HR_1_vec(2*Fs:5*Fs));
        HR_diff_2(i)  = mean(HR_2_vec(end-10*Fs+1:end))-mean(HR_2_vec(2*Fs:5*Fs));
        GSR_1(i) = mean(GSR_1_all(i,10*Fs+1:end));
        GSR_2(i) = mean(GSR_2_all(i,10*Fs+1:end));
        %    GSR_3(i) = mean(GSR_3_all(i,10*Fs+1:end));
        
        GSR_min_1(i) = min(GSR_1_all(i,1:5*Fs));
        GSR_min_2(i) = min(GSR_2_all(i,1:5*Fs));
        %    GSR_min_3(i) = min(GSR_3_all(i,1:5*Fs));
        
    end
    
    HR_All = [HR_1',HR_2'];
    HRV_All = [HRV_1',HRV_2'];
    HRV_rms_All = [HRV_rms_1',HRV_rms_2'];
    HR_diff_All = [HR_diff_1',HR_diff_2'];
    GSR_All = [GSR_1',GSR_2'];
    GSR_min_All = [GSR_min_1',GSR_min_2'];
    
    cd (dataFolder)
    save('HR_All','HR_All')
    save('HRV_All','HRV_All')
    save('HR_diff_All','HR_diff_All')
    save('GSR_All','GSR_All')
    save('GSR_min_All','GSR_min_All')
    cd (codeFolder)
    
end
