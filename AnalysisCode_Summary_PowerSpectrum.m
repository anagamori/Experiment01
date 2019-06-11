
close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

subjectN = 11;

Fs = 1000;

freq = 0:0.2:30;
pxx_fl_1_all = zeros(subjectN,length(freq));
pxx_fl_2_all = zeros(subjectN,length(freq));
pxx_ex_1_all = zeros(subjectN,length(freq));
pxx_ex_2_all = zeros(subjectN,length(freq));
pxx_norm_fl_1_all = zeros(subjectN,length(freq));
pxx_norm_fl_2_all = zeros(subjectN,length(freq));
pxx_norm_ex_1_all = zeros(subjectN,length(freq));
pxx_norm_ex_2_all = zeros(subjectN,length(freq));

for i = 1:subjectN
    index = 1;
    for j = 1:2
        if j == 1
            if i < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist flexion'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(i) '/Wrist flexion'];
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
        elseif j == 2
            if i < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist extension'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(i) '/Wrist extension'];
            end
            cd(dataFolder)
            load('pxx_1')
            load('pxx_2')
            load('pxx_norm_1')
            load('pxx_norm_2')
            cd(codeFolder)
            pxx_ex_1_all(i,:) = mean(pxx_1);
            pxx_ex_2_all(i,:) = mean(pxx_2);
            pxx_norm_ex_1_all(i,:) = mean(pxx_norm_1);
            pxx_norm_ex_2_all(i,:) = mean(pxx_norm_2);
        end
        
    end
end

for f = 1:length(freq)
    [~,p_1_2(f)] = ttest(pxx_norm_fl_1_all(:,f),pxx_norm_ex_1_all(:,f));
    if p_1_2(f) > 0.2
        p_1_2(f) = 0.2;
    end
    
     [~,p_1_2_norm(f)] = ttest(pxx_norm_fl_2_all(:,f),pxx_norm_ex_2_all(:,f));
    if p_1_2_norm(f) > 0.2
        p_1_2_norm(f) = 0.2;
    end
    
%     [~,p_1_3(f)] = ttest2(pxx_1(:,f),pxx_3(:,f));
%     if p_1_3(f) > 0.2
%         p_1_3(f) = 0.2;
%     end
%     
%     [~,p_2_3(f)] = ttest2(pxx_2(:,f),pxx_3(:,f));
%     if p_2_3(f) > 0.2
%         p_2_3(f) = 0.2;
%     end
end

%%
close all
figure(1)
plot(freq,mean(pxx_fl_1_all),'LineWidth',1)
hold on 
plot(freq,mean(pxx_fl_2_all),'LineWidth',1)
plot(freq,mean(pxx_ex_1_all),'LineWidth',1)
plot(freq,mean(pxx_ex_2_all),'LineWidth',1)
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Power (%MVC)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG','Ex HG','Ex LG')
figure(2)
plot(freq,mean(pxx_fl_1_all),'LineWidth',1)
hold on 
plot(freq,mean(pxx_fl_2_all),'LineWidth',1)
plot(freq,mean(pxx_ex_1_all),'LineWidth',1)
plot(freq,mean(pxx_ex_2_all),'LineWidth',1)
ylim([0 1.5e-5])
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Power (%MVC)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG','Ex HG','Ex LG')

%%
figure(3)
plot(freq,mean(pxx_norm_fl_1_all),'LineWidth',1)
hold on 
plot(freq,mean(pxx_norm_fl_2_all),'LineWidth',1)
plot(freq,mean(pxx_norm_ex_1_all),'LineWidth',1)
plot(freq,mean(pxx_norm_ex_2_all),'LineWidth',1)
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Power (%MVC)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG','Ex HG','Ex LG')

figure(4)
plot(freq,mean(pxx_norm_fl_1_all),'LineWidth',1)
hold on 
plot(freq,mean(pxx_norm_fl_2_all),'LineWidth',1)
plot(freq,mean(pxx_norm_ex_1_all),'LineWidth',1)
plot(freq,mean(pxx_norm_ex_2_all),'LineWidth',1)
ylim([0 0.01])
xlabel('Frequency (Hz)','FontSize',14)
ylabel('Power (%MVC)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Fl HG','Fl LG','Ex HG','Ex LG')

%%
figure(5)
subplot(2,1,1)
plot(freq,mean(pxx_norm_fl_1_all),'LineWidth',1)
hold on 
plot(freq,mean(pxx_norm_ex_1_all),'LineWidth',1)
subplot(2,1,2)
plot(freq,p_1_2,'LineWidth',1)

figure(6)
subplot(2,1,1)
plot(freq,mean(pxx_norm_fl_2_all),'LineWidth',1)
hold on 
plot(freq,mean(pxx_norm_ex_2_all),'LineWidth',1)
subplot(2,1,2)
plot(freq,p_1_2_norm,'LineWidth',1)