%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 11/20/2018
% Descriptions:
%   Analysis test trials
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 01/Wrist flexion/';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';

%--------------------------------------------------------------------------
Fs = 1000;
Fs_HR = 100;
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------
cd (dataFolder)
load('MVC')
cd (codeFolder)

[b,a] = butter(2,[0.5 5]/(Fs/2),'bandpass');
[b_2,a_2] = butter(4,30/(Fs/2),'low');
[b_HR,a_HR] = butter(4,[0.5 5]/(Fs_HR/2),'bandpass');
threshold = 15;

kernel = gausswin(2*Fs)./sum(gausswin(1*Fs));
%
for i = 1:10
    %i = n +1;
    fileName1 = ['hg_' num2str(i) '.mat'];
    fileName2 = ['lg_' num2str(i) '.mat'];
    %fileName3 = ['lg_' num2str(i) '.mat'];
    %fileName4 = ['compensation_reverse_' num2str(i) '_' num2str(i) '.mat'];
    
    cd (dataFolder)
    load (fileName1)
    cd (codeFolder)
    Force_RawVoltage_1 = data.values(8:13,:)'-data.offset';
    Force_Newton_1 = Force_RawVoltage_1*CalibrationMatrix;
    Force_Norm_1 = abs(Force_Newton_1(:,3))./MVC*100;
    
    Force_Norm_1_filt = filtfilt(b,a,Force_Norm_1);
    Force_1 = Force_Norm_1_filt(10*Fs+1:end);
    Force_1_DS = downsample(Force_1,10);
    
    Force_Norm_1_filt_2 = filtfilt(b_2,a_2,Force_Norm_1);
    mean_Force_1 = mean(Force_Norm_1_filt_2(10*Fs+1:end));
    SD_Force_1 = std(Force_Norm_1_filt_2(10*Fs+1:end));
    CoV_1(i) = SD_Force_1/mean_Force_1*100;
    
    Force_1_DS_2 = downsample(Force_Norm_1_filt_2(10*Fs+1:end),10);
    
    Data_HR_1_temp = data.values_GSR(3*Fs_HR+1:23*Fs_HR,2);
    Data_HR_filt_1 = filtfilt(b_HR,a_HR,Data_HR_1_temp);
    [~,loc] = findpeaks(Data_HR_filt_1,'MinPeakDistance',0.5*Fs_HR,'MinPeakHeight',threshold);
    Data_HR_1_long = zeros(1,length(Data_HR_filt_1));
    Data_HR_1_long(loc) = 1;
    Data_HR_1 = Data_HR_1_long(end-10*Fs_HR+1:end);
    nBeat_1 = length(find(Data_HR_1_long(end-10*Fs_HR+1:end)==1));
    
    time_HR = [1:length(Data_HR_1)]./Fs_HR;
    
    [sta_temp,lags_sta] = xcorr(Force_1_DS-mean(Force_1_DS),Data_HR_1-mean(Data_HR_1),200);
    sta(i,:) = sta_temp./nBeat_1;
    
    cutoff_time = 1*Fs_HR;
    Force_1_temp = Force_1_DS-mean(Force_1_DS);
    loc_sta_temp = find(Data_HR_1==1);
    loc_sta = loc_sta_temp(loc_sta_temp>cutoff_time&loc_sta_temp<10*Fs_HR-cutoff_time);
    time_sta = [-cutoff_time:cutoff_time]./Fs_HR;
    
    for j = 1:length(loc_sta)
        Force_sta(j,:) = Force_1_temp(loc_sta(j)-cutoff_time:loc_sta(j)+cutoff_time);
        figure(1)
        ax_2_1 = plot(time_sta,Force_sta(j,:),'color',[0 25 255]/255);
         ax_2_1.Color(4) = 0.4;
         hold on 
    end
    
    figure(1)
    ax_2_2 = plot(time_sta,mean(Force_sta),'color',[0 25 255]/255,'LineWidth',2);
    
    figure(11)
    ax_1_1 =  plot((lags_sta/Fs_HR)*1000,sta(i,:),'color',[0 25 255]/255);
    ax_1_1.Color(4) = 0.4;
    hold on
    
end

%%
figure(11)
ax_1_2 = plot((lags_sta/Fs_HR)*1000,mean(sta),'color',[0 25 255]/255,'LineWidth',3);
xlim([-1000 1000])
xlabel('Lags (ms)')
ylabel('Heart beat triggered avearge (%MVC)')
set(gca,'TickDir','out');
set(gca,'box','off')
