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
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 09/Wrist flexion/';
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

[b,a] = butter(4,[0.5 20]/(Fs/2),'bandpass');

[b_HR,a_HR] = butter(4,[0.5 5]/(Fs_HR/2),'bandpass');
threshold = 15;

kernel = gausswin(3*Fs_HR)./sum(gausswin(3*Fs_HR));
%
for i = 1:10
    
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
    Force_Norm_1 = filtfilt(b,a,Force_Norm_1);
    Force_1 = Force_Norm_1(10*Fs+1:end);
    Force_1_DS = downsample(Force_1,10);
    mean_Force_1 = mean(Force_1);
    SD_Force_1 = std(Force_1);
    CoV_1(i) = SD_Force_1/mean_Force_1*100;
    
    Data_HR_1_temp = data.values_GSR(3*Fs_HR+1:23*Fs_HR,2);
    Data_HR_filt_1 = filtfilt(b_HR,a_HR,Data_HR_1_temp);
    [~,loc] = findpeaks(Data_HR_filt_1,'MinPeakDistance',0.5*Fs_HR,'MinPeakHeight',threshold);
    Data_HR_1_long = zeros(1,length(Data_HR_filt_1));
    Data_HR_1_long(loc) = 1;
    Data_HR_1 = Data_HR_1_long(end-10*Fs_HR+1:end);
    time = [1:length(Force_1)]./Fs;
    time_HR = [1:length(Data_HR_1)]./Fs_HR;
    figure(11)
    yyaxis left
    plot(time_HR,Force_1_DS)
    yyaxis right
    plot(time_HR,Data_HR_1)
    
    [r(i,:),lags] = xcorr(Force_1_DS-mean(Force_1_DS),Data_HR_1-mean(Data_HR_1),100);
    rng shuffle
    for n = 1:1000
        fake_Data_HR_1_long = shuffle_binary(Data_HR_1_long);
        fake_Data_HR_1 = fake_Data_HR_1_long(end-10*Fs_HR+1:end);
        [r_fake(n,:),lags] = xcorr(Force_1_DS-mean(Force_1_DS),fake_Data_HR_1-mean(fake_Data_HR_1),100);
    end
    mean_r_fake = mean(atanh(r_fake));
    std_r_fake = std(atanh(r_fake));
    r_z(i,:) = (atanh(r(i,:))-mean_r_fake)./std_r_fake;
    
    [pks_r_z(i) loc_r_z] = max(r_z(i,51:101));
    delay_r_z(i) = (lags(loc_r_z+50)/Fs_HR)*1000;
    figure(1)
    ax_1_1 =  plot((lags/Fs_HR)*1000,r_z(i,:),'color',[1 0 0]);
    ax_1_1.Color(4) = 0.5;
    hold on 
    
    figure(2)
    ax_1_1 =  plot((lags/Fs_HR)*1000,r(i,:),'color',[1 0 0]);
    ax_1_1.Color(4) = 0.5;
    hold on 
    
    cd (dataFolder)
    load (fileName2)
    cd (codeFolder)   
    Force_RawVoltage_2 = data.values(8:13,:)'-data.offset';
    Force_Newton_2 = Force_RawVoltage_2*CalibrationMatrix;
    Force_Norm_2 = abs(Force_Newton_2(:,3))./MVC*100;
    Force_Norm_2 = filtfilt(b,a,Force_Norm_2);
    Force_2 = Force_Norm_2(10*Fs+1:end);
    Force_2_DS = downsample(Force_2,10);
     mean_Force_2 = mean(Force_2);
    SD_Force_2 = std(Force_2);
    CoV_2(i) = SD_Force_2/mean_Force_2*100;
    
    Data_HR_2_temp = data.values_GSR(3*Fs_HR+1:23*Fs_HR,2);
    Data_HR_filt_2 = filtfilt(b_HR,a_HR,Data_HR_2_temp);
    [~,loc] = findpeaks(Data_HR_filt_2,'MinPeakDistance',0.5*Fs_HR,'MinPeakHeight',threshold);
    Data_HR_2_long = zeros(1,length(Data_HR_filt_2));
    Data_HR_2_long(loc) = 1;
    Data_HR_2 = Data_HR_2_long(end-10*Fs_HR+1:end);
    time = [1:length(Force_2)]./Fs;
    time_HR = [1:length(Data_HR_2)]./Fs_HR;
    figure(11)
    yyaxis left
    plot(time_HR,Force_2_DS)
    yyaxis right
    plot(time_HR,Data_HR_2)
    
    [r_2(i,:),lags] = xcorr(Force_2_DS-mean(Force_2_DS),Data_HR_2-mean(Data_HR_2),100);
    
    for n = 1:1000
        fake_Data_HR_2_long = shuffle_binary(Data_HR_2_long);
        fake_Data_HR_2 = fake_Data_HR_2_long(end-10*Fs_HR+1:end);
        [r_2_fake(n,:),lags] = xcorr(Force_2_DS-mean(Force_2_DS),fake_Data_HR_2-mean(fake_Data_HR_2),100);
    end
    mean_r_2_fake = mean(atanh(r_2_fake));
    std_r_2_fake = std(atanh(r_2_fake));
    r_2_z(i,:) = (atanh(r_2(i,:))-mean_r_2_fake)./std_r_2_fake;
    
    [pks_r_2_z(i) loc_r_2_z] = max(r_2_z(i,51:101));
    delay_r_2_z(i) = (lags(loc_r_2_z+50)/Fs_HR)*1000;
    figure(3)
    ax_3_1 =  plot((lags/Fs_HR)*1000,r_2_z(i,:),'color',[0 25 255]/255);
    ax_3_1.Color(4) = 0.5;
    hold on 
    
    figure(4)
    ax_4_1 =  plot((lags/Fs_HR)*1000,r_2(i,:),'color',[0 25 255]/255);
    ax_4_1.Color(4) = 0.5;
    hold on 
end


figure(1)
ax_1_2 = plot((lags/Fs_HR)*1000,mean(r_z),'color',[1 0 0],'LineWidth',2);
xlabel('Lags (ms)')
ylabel('Average cross-correlation')
set(gca,'TickDir','out');
set(gca,'box','off')

figure(2)
ax_2_2 = plot((lags/Fs_HR)*1000,mean(r),'color',[1 0 0],'LineWidth',2);
xlabel('Lags (ms)')
ylabel('Average cross-correlation')
set(gca,'TickDir','out');
set(gca,'box','off')

figure(3)
ax_3_2 = plot((lags/Fs_HR)*1000,mean(r_2_z),'color',[0 25 255]/255,'LineWidth',2);
xlabel('Lags (ms)')
ylabel('Average cross-correlation')
set(gca,'TickDir','out');
set(gca,'box','off')

figure(4)
ax_4_2 = plot((lags/Fs_HR)*1000,mean(r_2),'color',[0 25 255]/255,'LineWidth',2);
xlabel('Lags (ms)')
ylabel('Average cross-correlation')
set(gca,'TickDir','out');
set(gca,'box','off')

% figure(1)
% boxplot(CoV_All)
% title('Force variability amplitude')
% set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})

figure(21)
scatter(pks_r_z,CoV_1,'o')
