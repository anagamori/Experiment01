
close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

subjectN = 1;

Fs = 1000;

CoV = zeros(subjectN,4);
PT = zeros(subjectN,4);
p_12_20 = zeros(subjectN,4);
HR = zeros(subjectN,4);
HR_diff = zeros(subjectN,4);
GSR = zeros(subjectN,4);

for i = 1:subjectN 
    index = 1;
    for j = 1:2
        if j == 1
            if i < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) ' 20_MVC/Wrist flexion'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(i) ' 20_MVC/Wrist flexion'];
            end
        elseif j == 2
            if i < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) ' 20_MVC/Wrist extension'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(i) ' 20_MVC/Wrist extension'];
            end
        end
        cd(dataFolder)
        load('CoV_All')
        load('PT_All')
%        load('p_12_20_All')
%         load('HR_All')
%         load('HR_diff_All')
%         load('GSR_All')
        cd(codeFolder)
        CoV(i,index:index+1) = mean(CoV_All);
        PT(i,index:index+1) = mean(PT_All);
%        p_12_20(i,index:index+1) = mean(p_12_20_All);
%         HR(i,index:index+1) = nanmean(HR_All);
%         HR_diff(i,index:index+1) = nanmean(HR_diff_All);
%         GSR(i,index:index+1) = nanmean(GSR_All);
        index = index+2;
    end
end

%%
c = linspace(1,10,subjectN);

close all
figure(1)
boxplot(CoV,'Colors','k')
hold on
scatter(ones(1,subjectN), CoV(:,1),[],[37  65 178]/255,'filled')
scatter(2*ones(1,subjectN), CoV(:,2),[],[37  65 178]/255,'filled')
plot(1:2, CoV(:,1:2)','color',[0.5 0.5 0.5])
scatter(3*ones(1,subjectN), CoV(:,3),[],[230 57 70]/255,'filled')
scatter(4*ones(1,subjectN), CoV(:,4),[],[230 57 70]/255,'filled')
plot(3:4, CoV(:,3:4)','color',[0.5 0.5 0.5])
ylim([0.5 3])
ylabel('CoV for Force (%)','FontSize',14)
set(gca,'xtick',1:6, 'xticklabel',{'High gain','Low gain','High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')
text(1.1,2.9,'Wrist Flexors','FontSize',14,'Color',[37  65 178]/255)
text(3.1,2.9,'Wrist Extensors','FontSize',14,'Color',[230 57 70]/255)
%legend('Participant 1','Participant 2','Participant 3','Participant 4','Participant 5','Participant 6','Participant 7','Participant 8','Participant 9','location','southeast')

%%
figure(2)
boxplot(PT,'Colors','k')
hold on
scatter(ones(1,subjectN), PT(:,1),[],[37  65 178]/255,'filled')
scatter(2*ones(1,subjectN), PT(:,2),[],[37  65 178]/255,'filled')
plot(1:2, PT(:,1:2)','color',[0.5 0.5 0.5])
scatter(3*ones(1,subjectN), PT(:,3),[],[230 57 70]/255,'filled')
scatter(4*ones(1,subjectN), PT(:,4),[],[230 57 70]/255,'filled')
plot(3:4, PT(:,3:4)','color',[0.5 0.5 0.5])
%ylim([0 7e-6])
ylabel('Physiological Tremor (%MVC^2)','FontSize',14)
set(gca,'xtick',1:6, 'xticklabel',{'High gain','Low gain','High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')
text(1.1,1.5e-5,'Wrist Flexors','FontSize',14,'Color',[37  65 178]/255)
text(3.1,1.5e-5,'Wrist Extensors','FontSize',14,'Color',[230 57 70]/255)
%legend('Participant 1','Participant 2','Participant 3','Participant 4','Participant 5','Participant 6','Participant 7','Participant 8','Participant 9','location','southeast')
%%
% figure(3)
% boxplot(p_12_20,'Colors','k')
% hold on
% scatter(ones(1,subjectN), p_12_20(:,1),[],[37  65 178]/255,'filled')
% scatter(2*ones(1,subjectN), p_12_20(:,2),[],[37  65 178]/255,'filled')
% plot(1:2, p_12_20(:,1:2)','color',[0.5 0.5 0.5])
% scatter(3*ones(1,subjectN), p_12_20(:,3),[],[230 57 70]/255,'filled')
% scatter(4*ones(1,subjectN), p_12_20(:,4),[],[230 57 70]/255,'filled')
% plot(3:4, p_12_20(:,3:4)','color',[0.5 0.5 0.5])
% %ylim([0 7e-6])
% ylabel('Power in the 12-20 Hz range (%MVC^2)','FontSize',14)
% set(gca,'xtick',1:6, 'xticklabel',{'High gain','Low gain','High gain','Low gain'})
% set(gca,'TickDir','out');
% set(gca,'box','off')
% text(1.1,1.5e-5,'Wrist Flexors','FontSize',14,'Color',[37  65 178]/255)
% text(3.1,1.5e-5,'Wrist Extensors','FontSize',14,'Color',[230 57 70]/255)


