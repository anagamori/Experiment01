
close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';


Fs = 1000;

subject_vec = [1 2 3 4 5 6 7 9];
subjectN = length(subject_vec);
CoV = zeros(length(subject_vec) ,4);
PT = zeros(length(subject_vec) ,4);
p_12_20 = zeros(length(subject_vec) ,4);
HR = zeros(length(subject_vec) ,4);
HRV = zeros(length(subject_vec) ,4);
GSR = zeros(length(subject_vec) ,4);

for k = 1:length(subject_vec) 
    i = subject_vec(k);
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
        load('p_12_20_All')
        load('HR_All')
        load('HRV_All')
        load('GSR_All')
        cd(codeFolder)
        CoV(k,index:index+1) = mean(CoV_All);
        PT(k,index:index+1) = mean(PT_All);
        p_12_20(k,index:index+1) = mean(p_12_20_All);
        HR(k,index:index+1) = nanmean(HR_All);
        HRV(k,index:index+1) = nanmean(HRV_All);
        GSR(k,index:index+1) = nanmean(GSR_All);
        index = index+2;
    end
end

%%
close all
figure(1)
boxplot(HR,'Colors','k')
hold on
scatter(ones(1,subjectN), HR(:,1),[],[37  65 178]/255,'filled')
scatter(2*ones(1,subjectN), HR(:,2),[],[37  65 178]/255,'filled')
plot(1:2, HR(:,1:2)','color',[0.5 0.5 0.5])
scatter(3*ones(1,subjectN), HR(:,3),[],[230 57 70]/255,'filled')
scatter(4*ones(1,subjectN), HR(:,4),[],[230 57 70]/255,'filled')
plot(3:4, HR(:,3:4)','color',[0.5 0.5 0.5])
ylabel('Normalized Heart Rate (bpm)','FontSize',14)
set(gca,'xtick',1:6, 'xticklabel',{'High gain','Low gain','High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')
% text(1.1,2.9,'Wrist Flexors','FontSize',14,'Color',[37  65 178]/255)
% text(3.1,2.9,'Wrist Extensors','FontSize',14,'Color',[230 57 70]/255)
%legend('Participant 1','Participant 2','Participant 3','Participant 4','Participant 5','Participant 6','Participant 7','Participant 8','Participant 9','location','southeast')

%%
figure(2)
boxplot(HRV,'Colors','k')
hold on
scatter(ones(1,subjectN), HRV(:,1),[],[37  65 178]/255,'filled')
scatter(2*ones(1,subjectN), HRV(:,2),[],[37  65 178]/255,'filled')
plot(1:2, HRV(:,1:2)','color',[0.5 0.5 0.5])
scatter(3*ones(1,subjectN), HRV(:,3),[],[230 57 70]/255,'filled')
scatter(4*ones(1,subjectN), HRV(:,4),[],[230 57 70]/255,'filled')
plot(3:4, HRV(:,3:4)','color',[0.5 0.5 0.5])
%ylim([0 7e-6])
ylabel('Heart Rate Variability (bpm)','FontSize',14)
set(gca,'xtick',1:6, 'xticklabel',{'High gain','Low gain','High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')
% text(1.1,1.5e-5,'Wrist Flexors','FontSize',14,'Color',[37  65 178]/255)
% text(3.1,1.5e-5,'Wrist Extensors','FontSize',14,'Color',[230 57 70]/255)
%legend('Participant 1','Participant 2','Participant 3','Participant 4','Participant 5','Participant 6','Participant 7','Participant 8','Participant 9','location','southeast')
%%
figure(3)
boxplot(GSR,'Colors','k')
hold on
scatter(ones(1,subjectN), GSR(:,1),[],[37  65 178]/255,'filled')
scatter(2*ones(1,subjectN), GSR(:,2),[],[37  65 178]/255,'filled')
plot(1:2, GSR(:,1:2)','color',[0.5 0.5 0.5])
scatter(3*ones(1,subjectN), GSR(:,3),[],[230 57 70]/255,'filled')
scatter(4*ones(1,subjectN), GSR(:,4),[],[230 57 70]/255,'filled')
plot(3:4, GSR(:,3:4)','color',[0.5 0.5 0.5])
%ylim([0 7e-6])
ylabel('Average Electrodermal Activity','FontSize',14)
set(gca,'xtick',1:6, 'xticklabel',{'High gain','Low gain','High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')
% text(1.1,1.5e-5,'Wrist Flexors','FontSize',14,'Color',[37  65 178]/255)
% text(3.1,1.5e-5,'Wrist Extensors','FontSize',14,'Color',[230 57 70]/255)

save('HR','HR')
save('HRV','HRV')
save('GSR','GSR')