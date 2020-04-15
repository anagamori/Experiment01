
close all
clear all
clc

codeFolder = '/Users/akira/Documents/GitHub/Experiment01/';

subjectN = 11;

Fs = 1000;

freq = 0:0.1:30;
C_fl_1_1_all = zeros(subjectN,length(freq));
C_fl_2_1_all = zeros(subjectN,length(freq));
C_fl_1_2_all = zeros(subjectN,length(freq));
C_fl_2_2_all = zeros(subjectN,length(freq));

mean_EMG_1_all = zeros(subjectN,4);
mean_EMG_2_all = zeros(subjectN,4);

for i = 1:subjectN
    index = 1;
    
    if i < 10
        dataFolder = ['/Users/akira/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist flexion'];
    else
        dataFolder = ['/Users/akira/Documents/GitHub/Experiment01/Record ID ' num2str(i) '/Wrist flexion'];
    end
    cd(dataFolder)
    load('C_1_1')
    load('C_2_1')
    load('C_1_2')
    load('C_2_2')
    load('mean_EMG_1')
    load('mean_EMG_2')
    cd(codeFolder)
    
    C_fl_1_1_all(i,:) = mean(atanh(sqrt(C_1_1)));
    C_fl_2_1_all(i,:) = mean(atanh(sqrt(C_2_1)));
    C_fl_1_2_all(i,:) = mean(atanh(sqrt(C_1_2)));
    C_fl_2_2_all(i,:) = mean(atanh(sqrt(C_2_2)));

    mean_EMG_1_all(i,:) = mean(mean_EMG_1);
    mean_EMG_2_all(i,:) = mean(mean_EMG_2);
end

%%
cd('/Users/akira/Documents/GitHub/MU-Population-Model/SLR Test/Stats')
save('C_fl_1_1_all','C_fl_1_1_all')
save('C_fl_2_1_all','C_fl_2_1_all')
save('C_fl_1_2_all','C_fl_1_2_all')
save('C_fl_2_2_all','C_fl_2_2_all')
load('p_C_1')
p_C_1 = p;
load('p_C_2')
p_C_2 = p;
load('eff_C_1')
eff_C_1 = eff;
load('eff_C_2')
eff_C_2 = eff;
cd(codeFolder)

%%
close all
figure(1)
subplot(4,1,1:2)
plot(freq,mean(C_fl_1_1_all),'LineWidth',1,'Color',[37  65 178]/255)
hold on
plot(freq,mean(C_fl_1_2_all),'LineWidth',1,'Color',[230 57 70]/255)
xlim([0 15])
%ylim([0 2e-3])
ylabel('Power (%MVC)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG')
subplot(4,1,3)
plot(freq,p_C_1,'LineWidth',1,'Color','k')
ylabel('p-value','FontSize',10)
xlim([0 15])
set(gca,'TickDir','out');
set(gca,'box','off')
subplot(4,1,4)
plot(freq,eff_C_1,'LineWidth',1,'Color','k')
xlim([0 15])
xlabel('Frequency (Hz)','FontSize',14)
ylabel('\eta^2','FontSize',10)
set(gca,'TickDir','out');
set(gca,'box','off')

%%
figure(2)
subplot(4,1,1:2)
plot(freq,mean(C_fl_2_1_all),'LineWidth',1,'Color',[37  65 178]/255)
hold on
plot(freq,mean(C_fl_2_2_all),'LineWidth',1,'Color',[230 57 70]/255)
xlim([0 15])
%ylim([0 2e-3])
ylabel('Power (%MVC)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG')
subplot(4,1,3)
plot(freq,p_C_2,'LineWidth',1,'Color','k')
ylabel('p-value','FontSize',10)
xlim([0 15])
set(gca,'TickDir','out');
set(gca,'box','off')
subplot(4,1,4)
plot(freq,eff_C_2,'LineWidth',1,'Color','k')
xlim([0 15])
xlabel('Frequency (Hz)','FontSize',14)
ylabel('\eta^2','FontSize',10)
set(gca,'TickDir','out');
set(gca,'box','off')

%%

mean_EMG = [mean_EMG_1_all(:,1) mean_EMG_2_all(:,1) mean_EMG_1_all(:,2) mean_EMG_2_all(:,2)]*100;
figure(3)
boxplot(mean_EMG,'Colors','k')
hold on
scatter(ones(1,subjectN), mean_EMG(:,1),[],[37  65 178]/255,'filled')
scatter(2*ones(1,subjectN), mean_EMG(:,2),[],[37  65 178]/255,'filled')
plot(1:2, mean_EMG(:,1:2)','color',[0.5 0.5 0.5])
scatter(3*ones(1,subjectN), mean_EMG(:,3),[],[230 57 70]/255,'filled')
scatter(4*ones(1,subjectN), mean_EMG(:,4),[],[230 57 70]/255,'filled')
plot(3:4, mean_EMG(:,3:4)','color',[0.5 0.5 0.5])
set(gca,'TickDir','out');
set(gca,'box','off')

cd('/Users/akira/Documents/GitHub/MU-Population-Model/SLR Test/Stats')
save('mean_EMG','mean_EMG')
cd(codeFolder)