
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

CoV_stack = [];
PT_stack = [];
p_12_20_stack = [];
HR_stack = [];
CoV_2_stack = [];
PT_2_stack = [];
p_12_20_2_stack = [];
HR_2_stack = [];

CoV_mean_stack = [];
PT_mean_stack = [];
HR_mean_stack = [];

CoV_diff_stack = [];
HR_diff_stack = [];
PT_diff_stack = [];

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
            color_muscle = [37  65 178]/255;
        elseif j == 2
            if i < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(i) '/Wrist extension'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(i) '/Wrist extension'];
            end
            color_muscle = [230 57 70]/255;
        end
        cd(dataFolder)
        load('CoV_All')
        load('PT_All')
        load('p_12_20_All')
        load('HR_All')
        load('HRV_All')
        load('GSR_All')
        cd(codeFolder)
        
        CoV_stack = [CoV_stack;CoV_All(:,1)];
        PT_stack = [PT_stack;PT_All(:,1)];
        p_12_20_stack = [p_12_20_stack;p_12_20_All(:,1)];
        HR_stack = [HR_stack;HR_All(:,1)];
        
        CoV_2_stack = [CoV_2_stack;CoV_All(:,2)];
        PT_2_stack = [PT_2_stack;PT_All(:,2)];
        p_12_20_2_stack = [p_12_20_2_stack;p_12_20_All(:,2)];
        HR_2_stack = [HR_2_stack;HR_All(:,2)];
        
        mean_CoV = mean(CoV_All);
        CoV_mean_stack = [CoV_mean_stack; mean_CoV'];
        CoV_diff_stack = [CoV_diff_stack; mean_CoV(1)-mean_CoV(2)];
        
        mean_HR = nanmean(HR_All);
        HR_mean_stack = [HR_mean_stack; mean_HR'];
        HR_diff_stack = [HR_diff_stack; mean_HR(1)-mean_HR(2)];
        
        mean_PT = mean(PT_All);
        PT_mean_stack = [PT_mean_stack; mean_PT'];
        PT_diff_stack = [PT_diff_stack; mean_PT(1)-mean_PT(2)];
        
        figure(4)
        scatter(mean_HR(1),mean_CoV(1),[],[37  65 178]/255,'filled')
        hold on
        scatter(mean_HR(2),mean_CoV(2),[],[230 57 70]/255,'filled')
        
        figure(6)
        scatter(mean_HR(1),mean_PT(1),[],[37  65 178]/255,'filled')
        hold on
        scatter(mean_HR(2),mean_PT(2),[],[230 57 70]/255,'filled')
        
        figure(3)
        scatter(mean_HR(1)-mean_HR(2),mean_CoV(1)-mean_CoV(2),[],color_muscle,'filled')
        hold on 
        
         figure(5)
         scatter(mean_HR(1)-mean_HR(2),mean_PT(1)-mean_PT(2),[],color_muscle,'filled')
         hold on 
    end
end

%%
% HR_stack_long = [HR_stack;HR_2_stack];
% [R,P] = corrcoef(HR_stack_long,[CoV_stack;CoV_2_stack])
% X = [ones(length(HR_stack_long),1) HR_stack_long];
% b1 = X\[CoV_stack;CoV_2_stack];
% CoV_Calc = X*b1;
% Rsq = 1 - sum(([CoV_stack;CoV_2_stack] - CoV_Calc).^2)/sum(([CoV_stack;CoV_2_stack] - mean([CoV_stack;CoV_2_stack])).^2)
% 
% figure(1)
% scatter(HR_stack,CoV_stack,[],[123 50 148]/255,'filled')
% hold on
% scatter(HR_2_stack,CoV_2_stack,[],[0 136 55]/255,'filled')
% plot([HR_stack;HR_2_stack],CoV_Calc,'k','LineWidth',1)
% legend('High Gain','Low Gain')
% xlabel('Normalized Heart Rate (bpm)','FontSize',14)
% ylabel('CoV for Force (%)','FontSize',14)
% set(gca,'TickDir','out');
% set(gca,'box','off')

%%
% figure(2)
% [R,P] = corrcoef(HR_stack_long,[PT_stack;PT_2_stack])
% b1 = X\[PT_stack;PT_2_stack];
% PT_Calc = X*b1;
% Rsq = 1 - sum(([PT_stack;PT_2_stack] - PT_Calc).^2)/sum(([PT_stack;PT_2_stack] - mean([PT_stack;PT_2_stack])).^2)
% 
% scatter(HR_stack,PT_stack,[],[123 50 148]/255,'filled')
% hold on
% scatter(HR_2_stack,PT_2_stack,[],[0 136 55]/255,'filled')
% plot([HR_stack;HR_2_stack],PT_Calc,'k','LineWidth',1)
% %ylim([0.5 3])
% legend('High Gain','Low Gain')
% xlabel('Normalized Heart Rate (bpm)','FontSize',14)
% ylabel('Physiological Tremor (%MVC^2)','FontSize',14)
% set(gca,'TickDir','out');
% set(gca,'box','off')

%%
[R,P] = corrcoef(HR_diff_stack,CoV_diff_stack)
X_2 = [ones(length(HR_diff_stack),1) HR_diff_stack];
b_2 = X_2\CoV_diff_stack;
CoV_diff_Calc = X_2*b_2;
Rsq_2 = 1 - sum((CoV_diff_stack - CoV_diff_Calc).^2)/sum((CoV_diff_stack - mean(CoV_diff_stack)).^2)

figure(3)
plot(HR_diff_stack,CoV_diff_Calc,'k','LineWidth',1)
%scatter(HR_diff_stack,CoV_diff_stack,[],[37  65 178]/255,'filled')
xlabel('Difference in Normalized Heart Rate (bpm)','FontSize',14)
ylabel('Difference in CoV for Force (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Flexors','Extensors')
%%
[R,P] = corrcoef(HR_mean_stack,CoV_mean_stack)
X_2 = [ones(length(HR_mean_stack),1) HR_mean_stack];
b_2 = X_2\CoV_mean_stack;
CoV_mean_Calc = X_2*b_2;
Rsq_2 = 1 - sum((CoV_mean_stack - CoV_mean_Calc).^2)/sum((CoV_mean_stack - mean(CoV_mean_stack)).^2)

figure(4)
plot(HR_mean_stack,CoV_mean_Calc,'k','LineWidth',1)
xlabel('Normalized Heart Rate (bpm)','FontSize',14)
ylabel('CoV for Force (%)','FontSize',14)
legend('High Gain','Low Gain')
set(gca,'TickDir','out');
set(gca,'box','off')

%%
HR_diff_avg = mean([HR_diff_stack(1:2:2*length(subject_vec)-1) HR_diff_stack(2:2:2*length(subject_vec))],2);
PT_diff_avg = mean([PT_diff_stack(1:2:2*length(subject_vec)-1) PT_diff_stack(2:2:2*length(subject_vec))],2);

[R,P] = corrcoef(HR_diff_stack,PT_diff_stack)
X_2 = [ones(length(HR_diff_stack),1) HR_diff_stack];
b_2 = X_2\PT_diff_stack;
PT_diff_Calc = X_2*b_2;
Rsq_2 = 1 - sum((PT_diff_stack - PT_diff_Calc).^2)/sum((PT_diff_stack - mean(PT_diff_stack)).^2)

figure(5)
plot(HR_diff_stack,PT_diff_Calc,'k','LineWidth',1)
%scatter(HR_diff_stack,PT_diff_stack,[],[37  65 178]/255,'filled')
xlabel('Difference in Normalized Heart Rate (bpm)','FontSize',14)
ylabel('Difference in Physiological Tremor (%MVC^2)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
legend('Flexors','Extensors')
%%
[R,P] = corrcoef(HR_mean_stack,PT_mean_stack)
X_2 = [ones(length(HR_mean_stack),1) HR_mean_stack];
b_2 = X_2\PT_mean_stack;
PT_mean_Calc = X_2*b_2;
Rsq_2 = 1 - sum((PT_mean_stack - PT_mean_Calc).^2)/sum((PT_mean_stack - mean(PT_mean_stack)).^2)

figure(6)
plot(HR_mean_stack,PT_mean_Calc,'k','LineWidth',1)
xlabel('Normalized Heart Rate (bpm)','FontSize',14)
ylabel('Physiological Tremor (%MVC^2)','FontSize',14)
legend('High Gain','Low Gain')
set(gca,'TickDir','out');
set(gca,'box','off')

