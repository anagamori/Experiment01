%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update 4/12/2018
% Descriptions:
%   Save data in an appropriate format for statistical analysis in R
%--------------------------------------------------------------------------


close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

%% number of subjects in the data set
subjectN =11;

%% Initialization
subID = [];
muscle = [];
condition = [];
CoV = [];
PT = [];
nHR = [];
dHR = [];
GSR = [];

%% Loop through each subject and each condition
for i = 1:subjectN
    index = 1;
    for j = 1:2
        if j == 1
            if i < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist flexion'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(i) '/Wrist flexion'];
            end
        elseif j == 2
            if i < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist extension'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(i) '/Wrist extension'];
            end
        end
        cd(dataFolder)
        load('CoV_All')
        load('PT_All')
%         load('HR_All')
%         load('HR_diff_All')
%         load('GSR_All')
        cd(codeFolder)
        
        muscle = [muscle; j*ones(20,1)];
        condition = [condition; [ones(10,1); 2*ones(10,1)]];
        CoV = [CoV;reshape(CoV_All,[],1)];
        PT = [PT;reshape(PT_All,[],1)];
%         nHR = [nHR;reshape(HR_All,[],1)];
%         dHR = [dHR;reshape(HR_diff_All,[],1)];
%         GSR = [GSR;reshape(GSR_All,[],1)];
        
    end
    subID = [subID; i*ones(40,1)];
end


%%
% column 1: subject ID
% column 2: muscle (1: flexors, 2: extensors)
% column 3: condition (1: high gain, 2: low gain)
% column 4: CoV for force
% column 5: physiological tremor (PT)
% column 6: normalized heart rate (nHR)
% column 7: heart rate deceleration (dHR)
% column 8: skin conductance (GSR)
Data_All = [subID muscle condition CoV PT]; % nHR dHR GSR];
save('Data_All','Data_All')