%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 1/11/2019
% Descriptions: 
%   Analysis code for MVC trials    
%--------------------------------------------------------------------------

close all
clear all
clc

dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 05/Wrist extension';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';

Fs = 1000; % sampling frequency

CalibrationMatrix = [12.6690 0.2290 0.1050 0 0 0; 0.1600 13.2370 -0.3870  0 0 0; 1.084 0.6050 27.0920  0 0 0; ...
    0 0 0 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0]; % calibration matrix for JR3

%--------------------------------------------------------------------------
% Go through all MVC trials
for j = 1:2:3
   fileName_MVC = ['mvc_' num2str(j) '.mat'];
   cd (dataFolder)
   load (fileName_MVC)
   Force_RawVoltage = data.values(8:13,:)'-data.offset';
   Force_Newton = Force_RawVoltage*CalibrationMatrix;
   Force = abs(Force_Newton(:,3));
   cd(codeFolder)
   
   time = [1:length(Force)]/Fs;
   figure(1)
   plot(time,Force)
   hold on
     
   MVC_temp(j) = max(Force); 
end

%--------------------------------------------------------------------------
% Pick the highest MVC value 
MVC = max(MVC_temp);

%--------------------------------------------------------------------------
% Store the value
cd (dataFolder)
save('MVC','MVC')
cd (codeFolder)