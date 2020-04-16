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
    cd (codeFolder)
    
    [b,a] = butter(4,30/(Fs/2),'low');
    kernel = gausswin(2*Fs)./sum(gausswin(1*Fs));
    
    %
    for i = 1:10
        
        fileName1 = ['hg_' num2str(i) '.mat'];
        fileName2 = ['lg_' num2str(i) '.mat'];
        
        cd (dataFolder)
        load (fileName1)
        
        Force_RawVoltage_1 = data.values(8:13,:)'-data.offset';
        Force_Newton_1 = Force_RawVoltage_1*CalibrationMatrix;
        Force_Norm_1 = abs(Force_Newton_1(:,3))./MVC*100;
        Force_Norm_1 = filtfilt(b,a,Force_Norm_1);
        Force_1 = Force_Norm_1(10*Fs+1:end);
        
        window = 1*Fs;
        bp = [window:window:length(Force_1)];
        %Force_1_dt = filtfilt(b_high,a_high,Force_1);
        Force_1_dt = detrend(Force_1,1,bp);
        
        mean_Force_1 = mean(Force_1);
        SD_Force_1 = std(Force_1);
        CoV_1(i) = SD_Force_1/mean_Force_1*100;
        CoV_1_dt(i) = std(Force_1_dt)/mean_Force_1*100;
        [pxx_1_temp,freq] = pwelch(Force_1-mean(Force_1),hann(2.5*Fs),0.9*2.5*Fs,0:0.1:30,Fs);
        %pxx_1_temp = pxx_1_temp./sum(pxx_1_temp);
        PT_1(i) = mean(mean(pxx_1_temp(:,31:61),2));
        p_12_20_1(i) = mean(mean(pxx_1_temp(:,61:101),2));
        time = [1:length(Force_Norm_1)]./Fs;
 
        
        load (fileName2)
        
        Force_RawVoltage_2 = data.values(8:13,:)'-data.offset';
        Force_Newton_2 = Force_RawVoltage_2*CalibrationMatrix;
        Force_Norm_2 = abs(Force_Newton_2(:,3))./MVC*100;
        Force_Norm_2 = filtfilt(b,a,Force_Norm_2);
        Force_2 = Force_Norm_2(10*Fs+1:end);
        
        bp = [window:window:length(Force_2)];
        %Force_2_dt = detrend(Force_2,1,bp);
        Force_2_dt = filtfilt(b_high,a_high,Force_2);
        mean_Force_2 = mean(Force_2);
        
        SD_Force_2 = std(Force_2);
        CoV_2(i) = SD_Force_2/mean_Force_2*100;
        CoV_2_dt(i) = std(Force_2_dt)/mean_Force_2*100;
        [pxx_2_temp,~] = pwelch(Force_2-mean(Force_2),hann(2.5*Fs),0.9*2.5*Fs,0:0.1:30,Fs);
        %pxx_2_temp = pxx_2_temp./sum(pxx_2_temp);
        PT_2(i) = mean(mean(pxx_2_temp(:,31:61),2));
        p_12_20_2(i) = mean(mean(pxx_2_temp(:,61:101),2));
        
        cd (codeFolder)
        pxx_1(i,:) = pxx_1_temp;
        pxx_2(i,:) = pxx_2_temp;
        
        pxx_norm_1(i,:) = pxx_1_temp./sum(pxx_1_temp);
        pxx_norm_2(i,:) = pxx_2_temp./sum(pxx_2_temp);
        
    end
    
    
    CoV_All = [CoV_1',CoV_2']; %,CoV_3'];
    CoV_dt_All = [CoV_1_dt',CoV_2_dt']; %,CoV_3'];
    PT_All = [PT_1',PT_2']; %,PT_3'];
    p_12_20_All = [p_12_20_1',p_12_20_2'];
    
    cd (dataFolder)
    save('CoV_All','CoV_All')
    save('CoV_dt_All','CoV_dt_All')
    save('PT_All','PT_All')
    save('p_12_20_All','p_12_20_All')
    save('pxx_1','pxx_1')
    save('pxx_2','pxx_2')
    save('pxx_norm_1','pxx_norm_1')
    save('pxx_norm_2','pxx_norm_2')
    cd (codeFolder)
    
end
