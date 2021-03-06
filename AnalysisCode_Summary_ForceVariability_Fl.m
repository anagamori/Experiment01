
close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

subjectN = 4;

Fs = 1000;

CoV = zeros(subjectN,2);
PT = zeros(subjectN,2);
HR = zeros(subjectN,2);
HR_diff = zeros(subjectN,2);
GSR = zeros(subjectN,2);

for i = 1:subjectN 
    index = 1;
    for j = 1
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
        CoV(i,index:index+1) = mean(CoV_All);
        PT(i,index:index+1) = mean(PT_All);
        HR(i,index:index+1) = mean(HR_All);
        HR_diff(i,index:index+1) = mean(HR_diff_All);
        GSR(i,index:index+1) = mean(GSR_All);
        index = index+2;
    end
end

%%
close all
figure(1)
boxplot(CoV,'Colors','k')
hold on
plot(CoV','o','LineWidth',2)
plot(CoV')
ylim([0.5 2.0])
ylabel('CoV for Force (%)','FontSize',14)
set(gca,'xtick',1:2, 'xticklabel',{'High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Participant 1','Participant 2','Participant 3','Participant 4','location','northwest')

%%
figure(2)
boxplot(PT,'Colors','k')
hold on
plot(PT','o','LineWidth',2)
plot(PT')
ylim([0 4e-6])
ylabel('Physiological Tremor (N^2)','FontSize',14)
set(gca,'xtick',1:2, 'xticklabel',{'High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')

%%
figure(3)
boxplot(HR,'Colors','k')
hold on
plot(HR','o','LineWidth',2)
plot(HR')
ylim([-8 5])
ylabel('Normlized Heart Rate (bpm)','FontSize',14)
set(gca,'xtick',1:2, 'xticklabel',{'High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')

%%
figure(4)
boxplot(GSR,'Colors','k')
ylabel('Normlized Skin Conductance','FontSize',14)
hold on
plot(GSR','o','LineWidth',2)
set(gca,'xtick',1:2, 'xticklabel',{'High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')

%%
figure(5)
boxplot(HR_diff,'Colors','k')
ylabel('Heart Rate Deceleration (bpm)','FontSize',14)
hold on
plot(HR_diff','o','LineWidth',2)
plot(HR_diff')
set(gca,'xtick',1:2, 'xticklabel',{'High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')



