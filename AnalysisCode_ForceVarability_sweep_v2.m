%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 11/20/2018
% Descriptions:
%   Analysis test trials
%--------------------------------------------------------------------------

close all
clear all
clc

for k = 1:2
    if k == 1
        muscle = 'flexion';
    else
        muscle = 'extension';
    end
    for n = 1:11
        n
        %--------------------------------------------------------------------------
        if n < 10
            dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) '/Wrist ' muscle];
        else
            dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(n) '/Wrist ' muscle];
        end
        codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';
        
        %--------------------------------------------------------------------------
        Fs = 1000;
        CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
            0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
        
        %--------------------------------------------------------------------------
        cd (dataFolder)
        load('MVC')
        cd (codeFolder)
        
        %[b,a] = butter(2,[0.5 30]/(Fs/2),'bandpass');
        [b,a] = butter(2,[0.2 30]/(Fs/2),'bandpass');
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
            mean_Force_1 = mean(Force_1);
            SD_Force_1 = std(Force_1);
            CoV_1(i) = SD_Force_1; %/mean_Force_1*100;
            %[pxx_1_temp,freq] = pwelch(Force_1-mean(Force_1),[],[],0:0.1:30,Fs);
            [pxx_1_temp,freq] = pwelch(Force_1-mean(Force_1),hann(5*Fs),0.9*5*Fs,0:0.1:30,Fs);
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
            mean_Force_2 = mean(Force_2);
            SD_Force_2 = std(Force_2);
            CoV_2(i) = SD_Force_2; %/mean_Force_2*100;
            [pxx_2_temp,~] = pwelch(Force_2-mean(Force_2),hann(5*Fs),0.9*5*Fs,0:0.1:30,Fs);
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
        PT_All = [PT_1',PT_2']; %,PT_3'];
        p_12_20_All = [p_12_20_1',p_12_20_2'];
        
        cd (dataFolder)
        save('CoV_All','CoV_All')
        save('PT_All','PT_All')
        save('p_12_20_All','p_12_20_All')
        save('pxx_1','pxx_1')
        save('pxx_2','pxx_2')
        save('pxx_norm_1','pxx_norm_1')
        save('pxx_norm_2','pxx_norm_2')
        cd (codeFolder)
        
    end
end