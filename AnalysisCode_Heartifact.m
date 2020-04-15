%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 11/20/2018
% Descriptions:
%   Analysis test trials
%--------------------------------------------------------------------------

close all
clear all
clc


codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';
%--------------------------------------------------------------------------
Fs = 1000;
Fs_HR = 100;
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------


[b,a] = butter(2,[0.5 5]/(Fs/2),'bandpass');
[b_2,a_2] = butter(4,30/(Fs/2),'low');
[b_HR,a_HR] = butter(4,[0.5 5]/(Fs_HR/2),'bandpass');
threshold = 15;

kernel = gausswin(2*Fs)./sum(gausswin(1*Fs));

muscle = 'flexion';
subject_vec = 1; %[1 2 3 4 5 6 9];

for j = 1 %:length(subject_vec)
    %--------------------------------------------------------------------------
    n = subject_vec(j);
    if n < 10
        dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) '/Wrist ' muscle];
    else
        dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(n) '/Wrist ' muscle];
    end
    
    cd (dataFolder)
    load('MVC')
    cd (codeFolder)
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
        
        figure(11)
        ax_1_1 =  plot((lags_sta/Fs_HR)*1000,sta(i,:),'color',[1 0 0]);
        ax_1_1.Color(4) = 0.5;
        hold on
        
        
        %%
        cd (dataFolder)
        load (fileName2)
        cd (codeFolder)
        Force_RawVoltage_2 = data.values(8:13,:)'-data.offset';
        Force_Newton_2 = Force_RawVoltage_2*CalibrationMatrix;
        Force_Norm_2 = abs(Force_Newton_2(:,3))./MVC*100;
        
        Force_Norm_2_filt = filtfilt(b,a,Force_Norm_2);
        Force_2 = Force_Norm_2_filt(10*Fs+1:end);
        Force_2_DS = downsample(Force_2,10);
        
        Force_Norm_2_filt_2 = filtfilt(b_2,a_2,Force_Norm_2);
        mean_Force_2 = mean(Force_Norm_2_filt_2(10*Fs+1:end));
        SD_Force_2 = std(Force_Norm_2_filt_2(10*Fs+1:end));
        CoV_2(i) = SD_Force_2/mean_Force_2*100;
        
        Force_2_DS_2 = downsample(Force_Norm_2_filt_2(10*Fs+1:end),10);
        
        Data_HR_2_temp = data.values_GSR(3*Fs_HR+1:23*Fs_HR,2);
        Data_HR_filt_2 = filtfilt(b_HR,a_HR,Data_HR_2_temp);
        [~,loc] = findpeaks(Data_HR_filt_2,'MinPeakDistance',0.5*Fs_HR,'MinPeakHeight',threshold);
        Data_HR_2_long = zeros(1,length(Data_HR_filt_2));
        Data_HR_2_long(loc) = 1;
        Data_HR_2 = Data_HR_2_long(end-10*Fs_HR+1:end);
        nBeat_2 = length(find(Data_HR_2_long(end-10*Fs_HR+1:end)==1));
        
        time_HR = [1:length(Data_HR_2)]./Fs_HR;
        
        [sta_temp,lags_sta] = xcorr(Force_2_DS-mean(Force_2_DS),Data_HR_2-mean(Data_HR_2),200);
        sta_2(i,:) = sta_temp./nBeat_2;
        
        figure(21)
        ax_2_1 =  plot((lags_sta/Fs_HR)*1000,sta_2(i,:),'color',[0 25 255]/255);
        ax_2_1.Color(4) = 0.5;
        hold on
        
        
        
    end
    
    %%
    figure(11)
    ax_1_2 = plot((lags_sta/Fs_HR)*1000,mean(sta),'color',[1 0 0],'LineWidth',2);
    xlim([-1000 1000])
    xlabel('Lags (ms)')
    ylabel('Heart beat triggered avearge (%MVC)')
    set(gca,'TickDir','out');
    set(gca,'box','off')
    
    figure(21)
    ax_2_2 = plot((lags_sta/Fs_HR)*1000,mean(sta_2),'color',[0 25 255]/255,'LineWidth',2);
    xlim([-1000 1000])
    xlabel('Lags (ms)')
    ylabel('Heart beat triggered avearge (%MVC)')
    set(gca,'TickDir','out');
    set(gca,'box','off')
    
    %%
    p2p_sta = max(sta(:,201:301),[],2)-min(sta(:,201:301),[],2);
    p2p_sta_2 = max(sta_2(:,201:301),[],2)-min(sta_2(:,201:301),[],2);
    
    figure(2)
    scatter(p2p_sta,CoV_1,'filled','MarkerFaceColor',[1 0 0])
    hold on
    scatter(p2p_sta_2,CoV_2,'filled','MarkerFaceColor',[0 25 255]/255)
    xlabel('Peak-to-peak amplitude (%MVC)','FontSize',14)
    ylabel('CoV (%)','FontSize',14)
    set(gca,'TickDir','out');
    set(gca,'box','off')
    
    %%
    p2p_sta_all = [p2p_sta p2p_sta_2];
    
    cd (dataFolder)
    save ('p2p_sta_all','p2p_sta_all')
    cd (codeFolder)
    
end
% figure(22)
% ax_2_2 = plot((lags/Fs_HR)*1000,mean(r_2),'color',[0 25 255]/255,'LineWidth',2);
% xlabel('Lags (ms)')
% ylabel('Heart beat triggered avearge (%MVC)')
% set(gca,'TickDir','out');
% set(gca,'box','off')



% figure(41)
% ax_4_2 = plot((lags/Fs_HR)*1000,mean(r_2),'color',[1 0 0],'LineWidth',2);
% xlabel('Lags (ms)')
% ylabel('Heart beat triggered avearge (%MVC)')
% set(gca,'TickDir','out');
% set(gca,'box','off')

