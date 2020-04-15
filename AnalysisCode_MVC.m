%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 1/11/2019
% Descriptions: 
%   Analysis code for MVC trials    
%--------------------------------------------------------------------------

close all
clear all
clc

dataFolder = '/Users/akira/Documents/GitHub/Experiment01/Record ID 11/wrist flexion';
codeFolder = '/Users/akira/Documents/GitHub/Experiment01';

Fs = 1000; % sampling frequency

CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0]; % calibration matrix for JR3

[b,a] = butter(4,10/(Fs/2),'low');
 
%--------------------------------------------------------------------------
% Go through all MVC trials
for j = 1:2
   fileName_MVC = ['mvc_' num2str(j) '.mat'];
   cd (dataFolder)
   load (fileName_MVC)
   Force_RawVoltage = data.values(8:13,:)'-data.offset';
   Force_Newton = Force_RawVoltage*CalibrationMatrix;
   Force = abs(Force_Newton(:,3));
   EMG = data.values(4:7,:)';
   cd(codeFolder)
  
   time = [1:length(Force)]/Fs;
   figure(1)
   plot(time,Force)
   hold on
   
   [MVC_temp(j),loc] = max(Force); 
   
   [EMG_processed] = PreProcessing(EMG,100);
   EMG_env = zeros(size(EMG_processed));
   for i = 1:4
       EMG_env(:,i) = filtfilt(b,a,EMG_processed(:,i));
   end
   
   figure(2)
   plot(time,EMG_env(:,1))
   hold on
   
   [MVC_EMG_temp(j,:),~] = max(EMG_env(loc-0.5*Fs:loc,:)); 
end

%--------------------------------------------------------------------------
% Pick the highest MVC value 
[MVC,trial] = max(MVC_temp)
MVC_emg = MVC_EMG_temp(trial,:)

%--------------------------------------------------------------------------
% Store the value
cd (dataFolder)
save('MVC','MVC')
save('MVC_emg','MVC_emg')
cd (codeFolder)