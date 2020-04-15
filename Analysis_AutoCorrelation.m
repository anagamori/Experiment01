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
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------
cd (dataFolder)
load('MVC')
cd (codeFolder)

 Force_1_all = [];
  Force_2_all = [];
  
[b,a] = butter(2,[0.5 30]/(Fs/2),'bandpass');
kernel = gausswin(2*Fs)./sum(gausswin(1*Fs));
%
trial_vec = 1:10; %[1:6 8:10];
for n = 1:length(trial_vec)
    i  = trial_vec(n);
    fileName1 = ['hg_' num2str(i) '.mat'];
    fileName2 = ['lg_' num2str(i) '.mat'];
    %fileName3 = ['lg_' num2str(i) '.mat'];
    %fileName4 = ['compensation_reverse_' num2str(i) '_' num2str(i) '.mat'];
    
    cd (dataFolder)
    load (fileName1)
       
    Force_RawVoltage_1 = data.values(8:13,:)'-data.offset';
    Force_Newton_1 = Force_RawVoltage_1*CalibrationMatrix;
    Force_Norm_1 = abs(Force_Newton_1(:,3))./MVC*100;
    Force_Norm_1 = filtfilt(b,a,Force_Norm_1);
    Force_1 = Force_Norm_1(10*Fs+1:end);
    mean_Force_1 = mean(Force_1);
    SD_Force_1 = std(Force_1);
    CoV_1(i) = SD_Force_1/mean_Force_1*100;
    [pxx_1_temp,freq] = pwelch(Force_1-mean(Force_1),[],[],0:0.2:30,Fs,'power');
    PT_1(i) = mean(mean(pxx_1_temp(:,31:51),2));
    
     Force_1_all = [Force_1_all;Force_1];
     
    lag_length = 3*Fs;
    [c_1,lags] = xcorr(Force_1-mean(Force_1),lag_length,'coeff');
    
    
    
    figure(21)
    ax_1_1 = plot(lags(lag_length+1:end),c_1(lag_length+1:end),'color',[1 0 0]);
    ax_1_1.Color(4) = 0.5;
    hold on 
    
    load (fileName2)
    Force_RawVoltage_2 = data.values(8:13,:)'-data.offset';
    Force_Newton_2 = Force_RawVoltage_2*CalibrationMatrix;
    Force_Norm_2 = abs(Force_Newton_2(:,3))./MVC*100;
    Force_Norm_2 = filtfilt(b,a,Force_Norm_2);
    Force_2 = Force_Norm_2(10*Fs+1:end);
    mean_Force_2 = mean(Force_2);
    SD_Force_2 = std(Force_2);
    CoV_2(i) = SD_Force_2/mean_Force_2*100;
    [pxx_2_temp,~] = pwelch(Force_2-mean(Force_2),[],[],0:0.2:30,Fs,'power');
    PT_2(i) = mean(mean(pxx_2_temp(:,31:51),2));
        
    Force_2_all = [Force_2_all;Force_2];
    
     [c_2,lags] = xcorr(Force_2-mean(Force_2),lag_length,'coeff');
   
    figure(21)
    ax_2_1 = plot(lags(lag_length+1:end),c_2(lag_length+1:end),'color',[0 25 255]/255);
    ax_2_1.Color(4) = 0.5;
    hold on 
    
    c_1_all(i,:) = c_1;
    c_2_all(i,:) = c_2;
    cd (codeFolder)
    pxx_1(i,:) = pxx_1_temp;
    pxx_2(i,:) = pxx_2_temp;
    %pxx_3(i,:) = pxx_3_temp;
    
    pxx_norm_1(i,:) = pxx_1_temp./sum(pxx_1_temp);
    pxx_norm_2(i,:) = pxx_2_temp./sum(pxx_2_temp);
    %pxx_norm_3(i,:) = pxx_3_temp./sum(pxx_3_temp);
   
    
end

figure(1)
histogram(Force_1_all,-0.2:0.01:0.2)
hold on
histogram(Force_2_all,-0.2:0.01:0.2)

    

figure(21)
ax_1_2 = plot(lags(lag_length+1:end),mean(c_1_all(:,lag_length+1:end)),'color',[1 0 0],'LineWidth',2);
hold on
plot([0 lag_length],[0 0],'k--')
xlabel('lags (ms)','FontSize',14)
ylabel('Correlation Coefficient','FontSize',14)

figure(21)
ax_2_2 = plot(lags(lag_length+1:end),mean(c_2_all(:,lag_length+1:end)),'color',[0 25 255]/255,'LineWidth',2);
hold on
plot([0 lag_length],[0 0],'k--')
xlabel('lags (ms)','FontSize',14)
ylabel('Correlation Coefficient','FontSize',14)