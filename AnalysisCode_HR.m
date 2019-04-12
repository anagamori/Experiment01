%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 1/11/2019
% Descriptions: 
%   Analysis test trials
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
subjectFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 04/';
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 04/Wrist flexion';
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

for i = 2
    
    %fileName1 = ['dc_' num2str(i)];
    fileName1 = ['hg_' num2str(i)];
    fileName2 = ['lg_' num2str(i)];
    %fileName4 = ['compensation_reverse_' num2str(i) '_' num2str(i) '.mat'];
    
    cd (dataFolder)
    load(fileName1);
    cd (codeFolder)   
    Data_HR_1 = data.values_GSR(3*Fs+1:23*Fs,2);
    Data_HR_filt_1 = filtfilt(b,a,Data_HR_1);
    [HR_1_vec] =  EKG2HR (Data_HR_filt_1,Fs,threshold,1);
    HR_1_all(i,:) = HR_1_vec-rest_HR;
    
    Data_GSR_1 = data.values_GSR(3*Fs+1:23*Fs,3);
    Data_GSR_filt_1 = filtfilt(b_low,a_low,Data_GSR_1);
    GSR_1_all(i,:) = Data_GSR_filt_1-Data_GSR_filt_1(1);
    
     cd (dataFolder)
    load(fileName2);
    cd (codeFolder)   
    Data_HR_2 = data.values_GSR(3*Fs+1:23*Fs,2);
    Data_HR_filt_2 = filtfilt(b,a,Data_HR_2);
    [HR_2_vec] =  EKG2HR (Data_HR_filt_2,Fs,threshold,1);
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
    
    figure(1) 
    ax_1_1 = plot(time,HR_1_all(i,:),'color',[1 0 0]);
    ax_1_1.Color(4) = 0.5;
    hold on
    ax_2_1 = plot(time,HR_2_all(i,:),'color',[0 25 255]/255);
    ax_2_1.Color(4) = 0.5;
%     ax_3_1 = plot(time,HR_3_all(i,:),'r');
%     ax_3_1.Color(4) = 0.5;
    
    figure(2)
    ax_1_1 = plot(time,GSR_1_all(i,:),'color',[1 0 0]);
    ax_1_1.Color(4) = 0.5;
    hold on
    ax_2_1 = plot(time,GSR_2_all(i,:),'color',[0 25 255]/255);
    ax_2_1.Color(4) = 0.5;
%     ax_3_1 = plot(time,GSR_3_all(i,:),'r');
%     ax_3_1.Color(4) = 0.5;
end

%%
HR_max = max([max(max(HR_1_all)),max(max(HR_2_all))]);
if HR_max > 150
    HR_max = 150;
end
HR_min = min([min(min(HR_1_all)),min(min(HR_2_all))]);

figure(1)
xlabel('Time (sec)','FontSize',14)
ylabel('Normalized HR (bpm)','FontSize',14)
ylim([HR_min-5 HR_max+5])
hold on
ax_1_2 = plot(time,mean(HR_1_all),'color',[1 0 0],'LineWidth',2);
ax_2_2 = plot(time,mean(HR_2_all),'color',[0 25 255]/255,'LineWidth',2);
%ax_3_2 = plot(time,mean(HR_3_all),'r','LineWidth',2);
ax_4_2 = plot([5 5],[HR_min-5 HR_max+5],'--','color','m');
legend([ax_1_2(1) ax_2_2(1) ax_4_2(1)], 'High Sensitivity','Low Sensitivity','Go Signal')
set(gca,'TickDir','out');
set(gca,'box','off')
hold off


GSR_max = max([max(max(GSR_1_all)),max(max(GSR_2_all))]);
GSR_min = min([min(min(GSR_1_all)),min(min(GSR_2_all))]);
figure(2)
xlabel('Time (sec)','FontSize',14)
ylabel('GSR','FontSize',14)
ylim([GSR_min-5 GSR_max+5])
hold on
ax_1_2 = plot(time,mean(GSR_1_all),'color',[1 0 0],'LineWidth',2);
ax_2_2 = plot(time,mean(GSR_2_all),'color',[0 25 255]/255,'LineWidth',2);
%ax_3_2 = plot(time,mean(GSR_3_all),'r','LineWidth',2);
ax_4_2 = plot([5 5],[GSR_min-5 GSR_max+5],'--','color','m');
legend([ax_1_2(1) ax_2_2(1)  ax_4_2(1)], 'High Sensitivity','Low Sensitivity','Go Signal')
hold off

%%
HR_All = [HR_1',HR_2'];
HRV_All = [HRV_1',HRV_2'];
HRV_rms_All = [HRV_rms_1',HRV_rms_2'];
HR_diff_All = [HR_diff_1',HR_diff_2'];
GSR_All = [GSR_1',GSR_2'];
GSR_min_All = [GSR_min_1',GSR_min_2'];

% cd (dataFolder)
% save('HR_All','HR_All')
% save('HRV_All','HRV_All')
% save('HR_diff_All','HR_diff_All')
% save('GSR_All','GSR_All')
% save('GSR_min_All','GSR_min_All')
% cd (codeFolder)
% 

figure(3)
boxplot(HR_All)
title('Mean Heart Rate')
set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})

figure(4)
boxplot(HR_diff_All)
title('Mean Heart Rate')
set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})

figure(5)
boxplot(HRV_All)
title('Heart Rate Variability (SD)')
set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})

figure(6)
boxplot(HRV_rms_All)
title('Heart Rate Variability (RMS)')
set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})

%%
GSR_All = [GSR_1',GSR_2'];
GSR_min_All = [GSR_min_1',GSR_min_2'];

figure(7)
boxplot(GSR_All)
title('Mean GSR')
set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})
figure(8)
boxplot(GSR_min_All)
title('Minimum Skin Conductance')
set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})
