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
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 01';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';
%--------------------------------------------------------------------------
Fs = 100;


%%
[b,a] = butter(4,0.5/(Fs/2),'high');
[b_low,a_low] = butter(4,20/(Fs/2),'low');
%%
threshold = 0.5;
%%
time = [1:20*Fs]/Fs;
HR_1_all = zeros(10,length(time));
HR_2_all = zeros(10,length(time));
HR_3_all = zeros(10,length(time));

GSR_1_all = zeros(10,length(time));
GSR_2_all = zeros(10,length(time));
GSR_3_all = zeros(10,length(time));

for i = 1:10
    
    fileName1 = ['dc_' num2str(i)];
    fileName2 = ['hg_' num2str(i)];
    fileName3 = ['lg_' num2str(i)];
    %fileName4 = ['compensation_reverse_' num2str(i) '_' num2str(i) '.mat'];
    
    cd (dataFolder)
    load(fileName1);
    cd (codeFolder)   
    Data_HR_1 = data.values_GSR(3*Fs+1:23*Fs,2);
    Data_HR_filt_1 = filtfilt(b,a,Data_HR_1);
    [HR_1_vec] =  EKG2HR (Data_HR_filt_1,Fs,40);
    HR_1_all(i,:) = HR_1_vec;
    
    Data_GSR_1 = data.values_GSR(3*Fs+1:23*Fs,3);
    Data_GSR_filt_1 = filtfilt(b_low,a_low,Data_GSR_1);
    GSR_1_all(i,:) = Data_GSR_filt_1-Data_GSR_filt_1(1);
    
     cd (dataFolder)
    load(fileName2);
    cd (codeFolder)   
    Data_HR_2 = data.values_GSR(3*Fs+1:23*Fs,2);
    Data_HR_filt_2 = filtfilt(b,a,Data_HR_2);
    [HR_2_vec] =  EKG2HR (Data_HR_filt_2,Fs,40);
    HR_2_all(i,:) = HR_2_vec;
    
    Data_GSR_2 = data.values_GSR(3*Fs+1:23*Fs,3);
    Data_GSR_filt_2 = filtfilt(b_low,a_low,Data_GSR_2);
    GSR_2_all(i,:) = Data_GSR_filt_2-Data_GSR_filt_2(1);
    
     cd (dataFolder)
    load(fileName3);
    cd (codeFolder)   
    Data_HR_3 = data.values_GSR(3*Fs+1:23*Fs,2);
    Data_HR_filt_3 = filtfilt(b,a,Data_HR_3);
    [HR_3_vec] =  EKG2HR (Data_HR_filt_3,Fs,40);
    HR_3_all(i,:) = HR_3_vec;
    
    Data_GSR_3 = data.values_GSR(3*Fs+1:23*Fs,3);
    Data_GSR_filt_3 = filtfilt(b_low,a_low,Data_GSR_3);
    GSR_3_all(i,:) = Data_GSR_filt_3-Data_GSR_filt_3(1);
    
    HR_1(i)  = mean(HR_1_vec(10*Fs+1:end)); %-restHR;
    HRV_1(i)  = std(HR_1_vec(10*Fs+1:end)); %-restHRV ;
    HRV_rms_1(i) = mean(rms(diff(HR_1_vec(10*Fs+1:end)))); %-restHRV_rms;
    HR_2(i)  = mean(HR_2_vec(10*Fs+1:end)); %-restHR;
    HRV_2(i)  = std(HR_2_vec(10*Fs+1:end)); %-restHRV ;
    HRV_rms_2(i) = mean(rms(diff(HR_2_vec(10*Fs+1:end)))); %-restHRV_rms;
    HR_3(i)  = mean(HR_3_vec(10*Fs+1:end)); %-restHR;
    HRV_3(i)  = std(HR_3_vec(10*Fs+1:end)); %-restHRV ;
    HRV_rms_3(i) = mean(rms(diff(HR_3_vec(10*Fs+1:end)))); %-restHRV_rms ;
   
    HR_diff_1(i)  = mean(HR_1_vec(end-3*Fs:end))-mean(HR_1_vec(1:3*Fs));
    HR_diff_2(i)  = mean(HR_2_vec(end-3*Fs:end))-mean(HR_2_vec(1:3*Fs));
    HR_diff_3(i)  = mean(HR_3_vec(end-3*Fs:end))-mean(HR_3_vec(1:3*Fs));
    
    GSR_1(i) = mean(GSR_1_all(i,10*Fs+1:end));
    GSR_2(i) = mean(GSR_2_all(i,10*Fs+1:end));
    GSR_3(i) = mean(GSR_3_all(i,10*Fs+1:end));
    
    GSR_min_1(i) = min(GSR_1_all(i,1:5*Fs));
    GSR_min_2(i) = min(GSR_2_all(i,1:5*Fs));
    GSR_min_3(i) = min(GSR_3_all(i,1:5*Fs));
    
    figure(1) 
    ax_1_1 = plot(time,HR_1_all(i,:),'k');
    ax_1_1.Color(4) = 0.5;
    hold on
    ax_2_1 = plot(time,HR_2_all(i,:),'b');
    ax_2_1.Color(4) = 0.5;
    ax_3_1 = plot(time,HR_3_all(i,:),'r');
    ax_3_1.Color(4) = 0.5;
    
    figure(2)
    ax_1_1 = plot(time,GSR_1_all(i,:),'k');
    ax_1_1.Color(4) = 0.5;
    hold on
    ax_2_1 = plot(time,GSR_2_all(i,:),'b');
    ax_2_1.Color(4) = 0.5;
    ax_3_1 = plot(time,GSR_3_all(i,:),'r');
    ax_3_1.Color(4) = 0.5;
end

HR_max = max([max(max(HR_1_all)),max(max(HR_2_all)),max(max(HR_3_all))]);
if HR_max > 150
    HR_max = 150;
end
HR_min = min([min(min(HR_1_all)),min(min(HR_2_all)),min(min(HR_3_all))]);

figure(1)
xlabel('Time (sec)')
ylabel('HR (bpm)')
ylim([HR_min-5 HR_max+5])
hold on
ax_1_2 = plot(time,mean(HR_1_all),'k','LineWidth',2);
ax_2_2 = plot(time,mean(HR_2_all),'b','LineWidth',2);
ax_3_2 = plot(time,mean(HR_3_all),'r','LineWidth',2);
ax_4_2 = plot([5 5],[HR_min-5 HR_max+5],'--','color','m');
legend([ax_1_2(1) ax_2_2(1) ax_3_2(1), ax_4_2(1)], 'Discrete','High gain continuous','Low gain continuous','Go Signal')
hold off


GSR_max = max([max(max(GSR_1_all)),max(max(GSR_2_all)),max(max(GSR_3_all))]);
GSR_min = min([min(min(GSR_1_all)),min(min(GSR_2_all)),min(min(GSR_3_all))]);
figure(2)
xlabel('Time (sec)')
ylabel('GSR')
ylim([GSR_min-5 GSR_max+5])
hold on
ax_1_2 = plot(time,mean(GSR_1_all),'k','LineWidth',2);
ax_2_2 = plot(time,mean(GSR_2_all),'b','LineWidth',2);
ax_3_2 = plot(time,mean(GSR_3_all),'r','LineWidth',2);
ax_4_2 = plot([5 5],[GSR_min-5 GSR_max+5],'--','color','m');
legend([ax_1_2(1) ax_2_2(1) ax_3_2(1), ax_4_2(1)], 'Discrete','High gain continuous','Low gain continuous','Go Signal')
hold off

%%
HR_All = [HR_1',HR_2',HR_3'];
HRV_All = [HRV_1',HRV_2',HRV_3'];
HRV_rms_All = [HRV_rms_1',HRV_rms_2',HRV_rms_3'];

figure(3)
subplot(3,1,1)
boxplot(HR_All)
title('Mean Heart Rate')
set(gca,'xtick',1:3, 'xticklabel',{'Discrete','High gain continuous','Low gain continuous'})
subplot(3,1,2)
boxplot(HRV_All)
title('Heart Rate Variability (SD)')
set(gca,'xtick',1:3, 'xticklabel',{'Discrete','High gain continuous','Low gain continuous'})
subplot(3,1,3)
boxplot(HRV_rms_All)
title('Heart Rate Variability (RMS)')
set(gca,'xtick',1:3, 'xticklabel',{'Discrete','High gain continuous','Low gain continuous'})

%%
GSR_All = [GSR_1',GSR_2',GSR_3'];
GSR_min_All = [GSR_min_1',GSR_min_2',GSR_min_3'];

figure(4)
subplot(1,2,1)
boxplot(GSR_All)
title('Mean GSR')
set(gca,'xtick',1:3, 'xticklabel',{'Discrete','High gain continuous','Low gain continuous'})
subplot(1,2,2)
boxplot(GSR_min_All)
title('Minimum Skin Conductance')
set(gca,'xtick',1:3, 'xticklabel',{'Discrete','High gain continuous','Low gain continuous'})
