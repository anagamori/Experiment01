
close all
clear all
clc

codeFolder = '/Users/akira/Documents/GitHub/Experiment01/';

subjectN = 11;

Fs = 1000;

freq = 0:0.1:30;
pxx_fl_1_all = zeros(subjectN,length(freq));
pxx_fl_2_all = zeros(subjectN,length(freq));
pxx_norm_fl_1_all = zeros(subjectN,length(freq));
pxx_norm_fl_2_all = zeros(subjectN,length(freq));

for i = 1:subjectN
    index = 1;
    
    if i < 10
        dataFolder = ['/Users/akira/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist flexion'];
    else
        dataFolder = ['/Users/akira/Documents/GitHub/Experiment01/Record ID ' num2str(i) '/Wrist flexion'];
    end
    cd(dataFolder)
    load('pxx_1')
    load('pxx_2')
    load('pxx_norm_1')
    load('pxx_norm_2')
    cd(codeFolder)
    pxx_fl_1_all(i,:) = mean(pxx_1);
    pxx_fl_2_all(i,:) = mean(pxx_2);
    pxx_norm_fl_1_all(i,:) = mean(pxx_norm_1);
    pxx_norm_fl_2_all(i,:) = mean(pxx_norm_2);
    
    
end

cd('/Users/akira/Documents/GitHub/MU-Population-Model/SLR Test/Stats')
save('pxx_fl_1_all','pxx_fl_1_all')
save('pxx_fl_2_all','pxx_fl_2_all')
cd(codeFolder)
%%
eta_squared = zeros(1,length(freq));
cohens_d = zeros(1,length(freq));
p_val = zeros(1,length(freq));
for f = 1:length(freq)
    [~,p_val(f),ci,stats] = ttest(pxx_fl_1_all(:,f),pxx_fl_2_all(:,f));
    if p_val(f) > 0.1
        p_val(f) = 0.1;
    end
    eta_squared(f) = stats.tstat^2/(stats.tstat^2 + stats.df);
    diff_pxx = abs(pxx_fl_1_all(:,f)-pxx_fl_2_all(:,f));
    cohens_d(f) = mean(diff_pxx)/std(diff_pxx);
end

%%
close all
figure(1)
subplot(4,1,1:2)
plot(freq,mean(pxx_fl_1_all),'LineWidth',1,'Color',[37  65 178]/255)
hold on
plot(freq,mean(pxx_fl_2_all),'LineWidth',1,'Color',[230 57 70]/255)
xlim([0 15])
ylim([0 2e-3])
ylabel('Power (%MVC)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG')
subplot(4,1,3)
plot(freq,p_val,'LineWidth',1,'Color','k')
ylabel('p-value','FontSize',10)
xlim([0 15])
set(gca,'TickDir','out');
set(gca,'box','off')
subplot(4,1,4)
plot(freq,eta_squared,'LineWidth',1,'Color','k')
xlim([0 15])
xlabel('Frequency (Hz)','FontSize',14)
ylabel('\eta^2','FontSize',10)
set(gca,'TickDir','out');
set(gca,'box','off')

%%
figure(2)
plot(freq,mean(pxx_fl_1_all),'LineWidth',1,'Color',[37  65 178]/255)
hold on
plot(freq,mean(pxx_fl_2_all),'LineWidth',1,'Color',[230 57 70]/255)
xlim([0 15])
ylim([0 0.5e-4])
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Power (%MVC)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG')

%%
figure(3)
plot(freq,mean(pxx_norm_fl_1_all)*100,'LineWidth',1)
hold on
plot(freq,mean(pxx_norm_fl_2_all)*100,'LineWidth',1)
xlim([0 15])
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Proportional Power (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG')

figure(4)
plot(freq,mean(pxx_norm_fl_1_all)*100,'LineWidth',1)
hold on
plot(freq,mean(pxx_norm_fl_2_all)*100,'LineWidth',1)
xlim([0 15])
ylim([0 2])
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Proportional Power (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG')

%%
figure(5)
subplot(2,1,1)
plot(freq,mean(pxx_fl_1_all),'LineWidth',1)
hold on
plot(freq,mean(pxx_fl_2_all),'LineWidth',1)
subplot(2,1,2)
plot(freq,cohens_d,'LineWidth',1)

