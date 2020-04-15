
close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

subjectN = 11;

Fs = 1000;

CoV = zeros(subjectN,2);
CoV_dt = zeros(subjectN,2);
df_slope = zeros(subjectN,2);

for i = 1:subjectN 
    index = 1;
    for j = 1
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
        load('CoV_dt_All')
        load('df_slope_All')
        cd(codeFolder)
        
        CoV(i,index:index+1) = mean(CoV_All);
        CoV_dt(i,index:index+1) = mean(CoV_dt_All);
        df_slope(i,index:index+1) = mean(df_slope_All);
        index = index+2;
    end
end

%%
c = linspace(1,10,subjectN);

close all
figure(1)
boxplot([CoV CoV_dt],'Colors','k')
hold on
scatter(ones(1,subjectN), CoV(:,1),[],[37  65 178]/255,'filled')
scatter(2*ones(1,subjectN), CoV(:,2),[],[37  65 178]/255,'filled')
plot(1:2, CoV(:,1:2)','color',[0.5 0.5 0.5])
scatter(3*ones(1,subjectN), CoV_dt(:,1),[],[230 57 70]/255,'filled')
scatter(4*ones(1,subjectN), CoV_dt(:,2),[],[230 57 70]/255,'filled')
plot(3:4, CoV_dt','color',[0.5 0.5 0.5])
%ylim([0.5 3])
ylabel('CoV for Force (%)','FontSize',14)
set(gca,'xtick',1:6, 'xticklabel',{'High gain','Low gain','High gain','Low gain'})
set(gca,'TickDir','out');
set(gca,'box','off')

cd('/Users/akiranagamori/Documents/GitHub/MU-Population-Model/SLR Test/Stats')
save('CoV','CoV')
save('CoV_dt','CoV_dt')
cd(codeFolder)
%text(1.1,2.9,'Wrist Flexors','FontSize',14,'Color',[37  65 178]/255)
%text(3.1,2.9,'Wrist Extensors','FontSize',14,'Color',[230 57 70]/255)
%legend('Participant 1','Participant 2','Participant 3','Participant 4','Participant 5','Participant 6','Participant 7','Participant 8','Participant 9','location','southeast')
%%
figure(2)
boxplot(df_slope)