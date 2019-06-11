
close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

subjectN = 6;

Fs = 1000;
CoV_mat = [];
PT_mat = [];
HR_mat = [];
HR_diff_mat = [];
GSR_mat = [];

for i = 1:subjectN
    index = 1;
    CoV = [];
    PT = [];
    HR = [];
    HR_diff = [];
    GSR = [];
    for j = 1:2
        if j == 1
            dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist flexion'];
        elseif j == 2
            dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist extension'];
        end
        cd(dataFolder)
        load('CoV_All')
        load('PT_All')
        load('HR_All')
        load('HR_diff_All')
        load('GSR_All')
        cd(codeFolder)
        CoV = [CoV;zscore(reshape(CoV_All,[],1))];
        PT = [PT;zscore(reshape(PT_All,[],1))];
        HR = [HR;zscore(reshape(HR_All,[],1))];
        HR_diff = [HR_diff;zscore(reshape(HR_diff_All,[],1))];
        GSR = [GSR;zscore(reshape(GSR_All,[],1))];
%         CoV = [CoV;reshape(CoV_All,[],1)];
%         PT = [PT;reshape(PT_All,[],1)];
%         HR = [HR;reshape(HR_All,[],1)];
%         HR_diff = [HR_diff;reshape(HR_diff_All,[],1)];
%         GSR = [GSR;reshape(GSR_All,[],1)];
    end
    CoV_mat = [CoV_mat CoV];
    PT_mat = [PT_mat PT];
    HR_mat = [HR_mat HR];
    HR_diff_mat = [HR_diff_mat HR_diff];
    GSR_mat = [GSR_mat GSR];
    
end

CoV_vec = reshape(CoV_mat,[],1);
PT_vec = reshape(PT_mat,[],1);
HR_vec = reshape(HR_mat,[],1);
HR_diff_vec = reshape(HR_diff_mat,[],1);
GSR_vec = reshape(GSR_mat,[],1);

%%
close all
X = [ones(length(HR_vec),1) HR_vec];
b1 = X\CoV_vec;
CoV_Calc = X*b1;
Rsq = 1 - sum((CoV_vec - CoV_Calc).^2)/sum((CoV_vec - mean(CoV_vec)).^2)
figure(1)
plot(HR_mat,CoV_mat,'o','LineWidth',2)
hold on
plot(HR_vec,CoV_Calc,'k','LineWidth',2) 
xlabel('Normalized Hear Rate (Z-Score)','FontSize',14)
ylabel('CoV for Force (Z-Score)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

%%
b2 = X\PT_vec;
PT_Calc = X*b2;
Rsq_2 = 1 - sum((PT_vec - PT_Calc).^2)/sum((PT_vec - mean(PT_vec)).^2)
figure(2)
plot(HR_mat,PT_mat,'o','LineWidth',2)
hold on
plot(HR_vec,PT_Calc,'k','LineWidth',2) 
xlabel('Normlized Hear Rate (Z-Score)','FontSize',14)
ylabel('Physiological Tremor (Z-Score)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

%%
X_2 = [ones(length(HR_diff_vec),1) HR_diff_vec];
b3 = X_2\CoV_vec;
CoV_2_Calc = X_2*b3;
Rsq_3 = 1 - sum((CoV_vec - CoV_2_Calc).^2)/sum((CoV_vec - mean(CoV_vec)).^2)
figure(3)
plot(HR_diff_mat,CoV_mat,'o','LineWidth',2)
hold on
plot(HR_diff_vec,CoV_2_Calc,'k','LineWidth',2) 
xlabel('Normalized Hear Rate (Z-Score)','FontSize',14)
ylabel('CoV for Force (Z-Score)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

%%
b4 = X_2\PT_vec;
PT_2_Calc = X_2*b4;
Rsq_4 = 1 - sum((PT_vec - PT_2_Calc).^2)/sum((PT_vec - mean(PT_vec)).^2)
figure(4)
plot(HR_diff_mat,PT_mat,'o','LineWidth',2)
hold on
plot(HR_diff_vec,PT_2_Calc,'k','LineWidth',2) 
xlabel('Normalized Hear Rate (Z-Score)','FontSize',14)
ylabel('PT for Force (Z-Score)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')