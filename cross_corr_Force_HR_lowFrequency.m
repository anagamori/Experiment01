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

[b,a] = butter(4,5/(Fs/2),'low');
[b_2,a_2] = butter(4,30/(Fs/2),'low');
[b_3,a_3] = butter(4,5/(Fs/2),'low');
[b_HR,a_HR] = butter(4,[0.5 5]/(Fs_HR/2),'bandpass');
threshold = 15;

kernel = hann(1*Fs_HR);
kernel = kernel./sum(kernel);
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
    
    Force_Norm_1_filt = filtfilt(b,a,Force_Norm_1);
    Force_1 = Force_Norm_1_filt(10*Fs+1:end);
    Force_1_DS = downsample(Force_1,10);
    
    Data_HR_1_temp = data.values_GSR(3*Fs_HR+1:23*Fs_HR,2);
    temp_1 = Data_HR_1_temp-mean(Data_HR_1_temp);
    temp_1_2 =  filtfilt(b_3,a_3,temp_1);
    temp_1_3 = temp_1_2(end-10*Fs_HR+1:end);
    
    time_HR = [1:length(Force_1_DS)]./Fs_HR;
    
    figure(1)
    yyaxis left
    plot(time_HR,Force_1_DS)
    yyaxis right
    plot(time_HR,temp_1_3)
    
    [sta_temp,lags_sta] = xcorr(Force_1_DS-mean(Force_1_DS),temp_1_3-mean(temp_1_3),200,'coeff');
    sta(i,:) = sta_temp;
   
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
    
    Data_HR_2_temp = data.values_GSR(3*Fs_HR+1:23*Fs_HR,2);
    temp_2 = Data_HR_2_temp-mean(Data_HR_2_temp);
    temp_2_2 =  filtfilt(b_3,a_3,temp_2);
    temp_2_3 = temp_2_2(end-10*Fs_HR+1:end);
    
    figure(2)
    yyaxis left
    plot(time_HR,Force_2_DS)
    yyaxis right
    plot(time_HR,temp_2_3)
    
    
    [sta_temp,lags_sta] = xcorr(Force_2_DS-mean(Force_2_DS),temp_2_3-mean(temp_2_3),200,'coeff');
    sta_2(i,:) = sta_temp;
     
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

