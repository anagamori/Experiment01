%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 11/20/2018
% Descriptions:
%   Analysis test trials
%--------------------------------------------------------------------------

close all
clear all
clc
Fs = 1000;
[b_high,a_high] = butter(4,0.5/(Fs/2),'high');
f = 0:0.1:30;
muscle = 'flexion';
for n = 1:11
    n
    %--------------------------------------------------------------------------
    if n < 10
        dataFolder = ['/Users/akira/Documents/GitHub/Experiment01/Record ID 0' num2str(n) '/Wrist ' muscle];
    else
        dataFolder = ['/Users/akira/Documents/GitHub/Experiment01/Record ID ' num2str(n) '/Wrist ' muscle];
    end
    codeFolder = '/Users/akira/Documents/GitHub/Experiment01';
    
    %--------------------------------------------------------------------------
    
    CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
        0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
    
    %--------------------------------------------------------------------------
    cd (dataFolder)
    load('MVC')
    load('MVC_emg')
    cd (codeFolder)
    
    [b_Force,a_Force] = butter(4,10/(Fs/2),'low');
    [b,a] = butter(4,10/(Fs/2),'low');
    
    kernel = gausswin(2*Fs)./sum(gausswin(1*Fs));
    
    mean_EMG_1 = zeros(10,4);
    mean_EMG_2 = zeros(10,4);
    %
    for i = 1:10
        
        fileName1 = ['hg_' num2str(i) '.mat'];
        fileName2 = ['lg_' num2str(i) '.mat'];
        
        cd (dataFolder)
        load (fileName1)
        cd (codeFolder)
        
        Force_RawVoltage_1 = data.values(8:13,:)'-data.offset';
        Force_Newton_1 = Force_RawVoltage_1*CalibrationMatrix;
        Force_Norm_1 = abs(Force_Newton_1(:,3))./MVC*100;
        Force_Norm_1 = filtfilt(b_Force,a_Force,Force_Norm_1);
        Force_1 = Force_Norm_1(10*Fs+1:end);
        
        EMG = data.values(4:7,:)';
        
        [EMG_processed] = PreProcessing(EMG,100);
        EMG_env = zeros(size(EMG_processed));
        for j = 1:4
            EMG_env(:,j) = filtfilt(b,a,EMG_processed(:,j));
            EMG_norm = EMG_env./MVC_emg;
        end
        mean_EMG_1(i,:) = mean(EMG_norm(10*Fs+1:end,:));     
        
        [C_1_1_temp,~] = mscohere(Force_1-mean(Force_1),EMG_norm(10*Fs+1:end,1)-mean(EMG_norm(10*Fs+1:end,1)),hann(2.5*Fs),0.9*2.5*Fs,f,Fs);
        [C_2_1_temp,~] = mscohere(Force_1-mean(Force_1),EMG_norm(10*Fs+1:end,2)-mean(EMG_norm(10*Fs+1:end,2)),hann(2.5*Fs),0.9*2.5*Fs,f,Fs);
        
        C_1_1(i,:) = C_1_1_temp;
        C_2_1(i,:) = C_2_1_temp;
        
        cd (dataFolder)
        load (fileName2)
        cd (codeFolder)
        Force_RawVoltage_2 = data.values(8:13,:)'-data.offset';
        Force_Newton_2 = Force_RawVoltage_2*CalibrationMatrix;
        Force_Norm_2 = abs(Force_Newton_2(:,3))./MVC*100;
        Force_Norm_2 = filtfilt(b,a,Force_Norm_2);
        Force_2 = Force_Norm_2(10*Fs+1:end);
        
        EMG = data.values(4:7,:)';
        
        [EMG_processed] = PreProcessing(EMG,100);
        EMG_env = zeros(size(EMG_processed));
        for j = 1:4
            EMG_env(:,j) = filtfilt(b,a,EMG_processed(:,j));
            EMG_norm = EMG_env./MVC_emg;
        end
        mean_EMG_2(i,:) = mean(EMG_norm(10*Fs+1:end,:));    
                
        [C_1_2_temp,~] = mscohere(Force_2-mean(Force_2),EMG_norm(10*Fs+1:end,1)-mean(EMG_norm(10*Fs+1:end,1)),hann(2.5*Fs),0.9*2.5*Fs,f,Fs);
        [C_2_2_temp,~] = mscohere(Force_2-mean(Force_2),EMG_norm(10*Fs+1:end,2)-mean(EMG_norm(10*Fs+1:end,2)),hann(2.5*Fs),0.9*2.5*Fs,f,Fs);
        
        C_1_2(i,:) = C_1_2_temp;
        C_2_2(i,:) = C_2_2_temp;
    end
    
    
    cd (dataFolder)
    save('mean_EMG_1','mean_EMG_1')
    save('mean_EMG_2','mean_EMG_2')
    save('C_1_1','C_1_1')
    save('C_2_1','C_2_1')
    save('C_1_2','C_1_2')
    save('C_2_2','C_2_2')
    cd (codeFolder)
%     
end
