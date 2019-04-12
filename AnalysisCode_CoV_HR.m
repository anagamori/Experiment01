%--------------------------------------------------------------------------
% Author: Akira Nagamori
% Last update: 1/11/2019
% Descriptions: 
%   Analysis test trials
%--------------------------------------------------------------------------

close all
clear all
clc

%--------------------------------------------------------------------------
dataFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 02/Wrist flexion';
codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01';

cd (dataFolder)
load('CoV_All')
load('PT_All')
load('HR_All')
load('HRV_All')
load('GSR_All')
load('GSR_min_All')
cd (codeFolder)

CoV = reshape(CoV_All,[],1);
PT = reshape(PT_All,[],1);
HR = reshape(HR_All,[],1);
GSR = reshape(GSR_All,[],1);
GSR_min = reshape(GSR_min_All,[],1);

[R,P] = corrcoef(HR,CoV)

figure(1)
plot(HR_All,CoV_All,'o')
xlabel('Heart Rate','FontSize',14)
ylabel('CoV (%)','FontSize',14)
legend('Discrete','High gain continuous','Low gain continuous')

[R_PT,P_PT] = corrcoef(HR,PT)

figure(2)
plot(HR_All,PT_All,'o')
xlabel('Heart Rate','FontSize',14)
ylabel('Physiological Tremor','FontSize',14)
legend('Discrete','High gain continuous','Low gain continuous')

[R_GSR,P_GSR] = corrcoef(GSR,CoV)

figure(3)
plot(GSR_All,CoV_All,'o')
xlabel('Mean GSR','FontSize',14)
ylabel('CoV (%)','FontSize',14)
legend('Discrete','High gain continuous','Low gain continuous')

[R_GSR_min,P_GSR_min] = corrcoef(GSR_min,CoV)

figure(4)
plot(GSR_min_All,CoV_All,'o')
xlabel('Lowest GSR','FontSize',14)
ylabel('CoV (%)','FontSize',14)
legend('Discrete','High gain continuous','Low gain continuous')
