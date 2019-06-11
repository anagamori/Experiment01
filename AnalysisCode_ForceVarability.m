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
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 01 20_MVC/Wrist extension/';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';

%--------------------------------------------------------------------------
Fs = 1000;
CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];

%--------------------------------------------------------------------------
cd (dataFolder)
load('MVC')
cd (codeFolder)

[b,a] = butter(4,30/(Fs/2),'low');
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
    [pxx_1_temp,freq] = pwelch(Force_1-mean(Force_1),gausswin(5*Fs),0.9*5*Fs,0:0.2:30,Fs,'power');
    PT_1(i) = mean(mean(pxx_1_temp(:,31:51),2));
    time = [1:length(Force_Norm_1)]./Fs;
    figure(11)
    plot(time,Force_Norm_1)
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
    [pxx_2_temp,~] = pwelch(Force_2-mean(Force_2),gausswin(5*Fs),0.9*5*Fs,0:0.2:30,Fs,'power');
    PT_2(i) = mean(mean(pxx_2_temp(:,31:51),2));
    figure(12)
    plot(time,Force_Norm_2)
    hold on 
    
%     load (fileName3)
%     Force_RawVoltage_3 = data.values(8:13,:)'-data.offset';
%     Force_Newton_3 = Force_RawVoltage_3*CalibrationMatrix;
%     Force_Norm_3 = abs(Force_Newton_3(:,3))./MVC*100;
%     Force_Norm_3 = filtfilt(b,a,Force_Norm_3);
%     Force_3 = Force_Norm_3(10*Fs+1:end);
%     mean_Force_3 = mean(Force_3);
%     SD_Force_3 = std(Force_3);
%     CoV_3(i) = SD_Force_3/mean_Force_3*100;
%     [pxx_3_temp,~] = pwelch(Force_3-mean(Force_3),gausswin(5*Fs),0.9*5*Fs,0:0.2:30,Fs,'power');
%     PT_3(i) = mean(mean(pxx_3_temp(:,31:51),2));  
%     cd (codeFolder)
%     figure(13)
%     plot(time,Force_Norm_3)
%     hold on    
    
    cd (codeFolder)
    pxx_1(i,:) = pxx_1_temp;
    pxx_2(i,:) = pxx_2_temp;
    %pxx_3(i,:) = pxx_3_temp;
    
    pxx_norm_1(i,:) = pxx_1_temp./sum(pxx_1_temp);
    pxx_norm_2(i,:) = pxx_2_temp./sum(pxx_2_temp);
    %pxx_norm_3(i,:) = pxx_3_temp./sum(pxx_3_temp);
   
    
end

for f = 1:length(freq)
    [~,p_1_2(f)] = ttest2(pxx_1(:,f),pxx_2(:,f));
    if p_1_2(f) > 0.2
        p_1_2(f) = 0.2;
    end
    
     [~,p_1_2_norm(f)] = ttest2(pxx_norm_1(:,f),pxx_norm_2(:,f));
    if p_1_2_norm(f) > 0.2
        p_1_2_norm(f) = 0.2;
    end
    
%     [~,p_1_3(f)] = ttest2(pxx_1(:,f),pxx_3(:,f));
%     if p_1_3(f) > 0.2
%         p_1_3(f) = 0.2;
%     end
%     
%     [~,p_2_3(f)] = ttest2(pxx_2(:,f),pxx_3(:,f));
%     if p_2_3(f) > 0.2
%         p_2_3(f) = 0.2;
%     end
end

CoV_All = [CoV_1',CoV_2']; %,CoV_3'];
PT_All = [PT_1',PT_2']; %,PT_3'];

cd (dataFolder)
save('CoV_All','CoV_All')
save('PT_All','PT_All')
save('pxx_1','pxx_1')
save('pxx_2','pxx_2')
save('pxx_norm_1','pxx_norm_1')
save('pxx_norm_2','pxx_norm_2')
cd (codeFolder)

figure(1)
boxplot(CoV_All)
title('Force variability amplitude')
set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})

figure(2)
boxplot(PT_All)
title('Physiological Tremor')
set(gca,'xtick',1:2, 'xticklabel',{'High gain continuous','Low gain continuous'})

figure(3)
plot(freq,mean(pxx_1),'LineWidth',2)
hold on 
plot(freq,mean(pxx_2),'LineWidth',2)
% hold on 
% plot(freq,mean(pxx_3),'LineWidth',2)
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Power (N^2)','FontSize',14)
legend('High gain continuous','Low gain continuous')

figure(4)
plot(freq,mean(pxx_norm_1),'LineWidth',2)
hold on 
plot(freq,mean(pxx_norm_2),'LineWidth',2)
% hold on 
% plot(freq,mean(pxx_norm_3),'LineWidth',2)
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Proportion to total power (%)','FontSize',14)
legend('High gain continuous','Low gain continuous')

figure(5)
subplot(2,2,1)
plot(freq,mean(pxx_1),'LineWidth',2)
hold on 
plot(freq,mean(pxx_2),'LineWidth',2)
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Power (N^2)','FontSize',14)
legend('High gain continuous','Low gain continuous')
subplot(2,2,3)
plot(freq,p_1_2,'LineWidth',2)
subplot(2,2,2)
plot(freq,mean(pxx_norm_1),'LineWidth',2)
hold on 
plot(freq,mean(pxx_norm_2),'LineWidth',2)
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Power (N^2)','FontSize',14)
legend('High gain continuous','Low gain continuous')
subplot(2,2,4)
plot(freq,p_1_2_norm,'LineWidth',2)

% figure(6)
% subplot(2,1,1)
% plot(freq,mean(pxx_1),'LineWidth',2)
% hold on 
% plot(freq,mean(pxx_3),'LineWidth',2)
% xlabel('Frequency (Hz)','FontSize',14)
% ylabel('Power (N^2)','FontSize',14)
% legend('Discrete','Low gain continuous')
% subplot(2,1,2)
% plot(freq,p_1_3,'LineWidth',2)
% 
% figure(7)
% subplot(2,1,1)
% plot(freq,mean(pxx_2),'LineWidth',2)
% hold on 
% plot(freq,mean(pxx_3),'LineWidth',2)
% xlabel('Frequency (Hz)','FontSize',14)
% ylabel('Power (N^2)','FontSize',14)
% legend('High gain continuous','Low gain continuous')
% subplot(2,1,2)
% plot(freq,p_2_3,'LineWidth',2)


