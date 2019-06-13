
close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

subjectN = 11;

Fs = 1000;

CoV = zeros(subjectN,4);
PT = zeros(subjectN,4);
p_12_20 = zeros(subjectN,4);
HR = zeros(subjectN,4);
HR_diff = zeros(subjectN,4);
GSR = zeros(subjectN,4);

CoV_stack = [];
PT_stack = [];
p_12_20_stack = [];
CoV_2_stack = [];
PT_2_stack = [];
p_12_20_2_stack = [];


CoV_mean_stack = [];
PT_mean_stack = [];

CoV_diff_stack = [];
PT_diff_stack = [];
for i = 1:subjectN 
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

        cd(codeFolder)
        
        PT_temp = [zscore(PT_All(:,1));zscore(PT_All(:,2))];
        CoV_stack = [CoV_stack;zscore(CoV_All(:,1))]; %;CoV_All(:,2)];
        %PT_stack = [PT_stack;PT_temp]; %PT_All(:,1);PT_All(:,2)];
        PT_stack = [PT_stack;zscore(PT_All(:,1))]; %;zscore(PT_All(:,2))];
        p_12_20_stack = [p_12_20_stack;p_12_20_All(:,1)];
        CoV_2_stack = [CoV_2_stack;zscore(CoV_All(:,2))]; %;CoV_All(:,2)];
        %PT_stack = [PT_stack;PT_temp]; %PT_All(:,1);PT_All(:,2)];
        PT_2_stack = [PT_2_stack;zscore(PT_All(:,2))]; %;zscore(PT_All(:,2))];
        p_12_20_2_stack = [p_12_20_2_stack;p_12_20_All(:,2)];
        
        mean_CoV = mean(CoV_All);
        CoV_mean_stack = [CoV_mean_stack; mean_CoV'];
        CoV_diff_stack = [CoV_diff_stack; mean_CoV(1)-mean_CoV(2)];
        
        mean_PT = mean(PT_All);
        PT_mean_stack = [PT_mean_stack; mean_PT'];
        PT_diff_stack = [PT_diff_stack; mean_PT(1)-mean_PT(2)];
    end
end

%%

PT_stack_log = [PT_stack;PT_2_stack];
[R,P] = corrcoef(PT_stack_log,[CoV_stack;CoV_2_stack])
X = [ones(length(PT_stack_log),1) PT_stack_log];
b1 = X\[CoV_stack;CoV_2_stack];
CoV_Calc = X*b1;
Rsq = 1 - sum(([CoV_stack;CoV_2_stack] - CoV_Calc).^2)/sum(([CoV_stack;CoV_2_stack] - mean([CoV_stack;CoV_2_stack])).^2)

close all
figure(1)
scatter(PT_stack,CoV_stack,[],[123 50 148]/255,'filled')
hold on
scatter(PT_2_stack,CoV_2_stack,[],[0 136 55]/255,'filled')
semilogx([PT_stack;PT_2_stack],CoV_Calc,'k','LineWidth',1)
%ylim([0.5 3])
legend('High Gain','Low Gain')
xlabel('Physiological Tremor (%MVC^2)','FontSize',14)
ylabel('CoV for Force (%)','FontSize',14)
%set(gca,'xscale','log')
set(gca,'TickDir','out');
set(gca,'box','off')
% text(1.1,2.9,'Wrist Flexors','FontSize',14,'Color',[37  65 178]/255)
% text(3.1,2.9,'Wrist Extensors','FontSize',14,'Color',[230 57 70]/255)
%legend('Participant 1','Participant 2','Participant 3','Participant 4','Participant 5','Participant 6','Participant 7','Participant 8','Participant 9','location','southeast')
%%
p_12_20_stack_log = [p_12_20_stack;p_12_20_2_stack];
[R,P] = corrcoef(p_12_20_stack_log,[CoV_stack;CoV_2_stack])
X = [ones(length(p_12_20_stack_log),1) p_12_20_stack_log];
b1 = X\[CoV_stack;CoV_2_stack];
CoV_Calc = X*b1;
Rsq = 1 - sum(([CoV_stack;CoV_2_stack] - CoV_Calc).^2)/sum(([CoV_stack;CoV_2_stack] - mean([CoV_stack;CoV_2_stack])).^2)

figure(2)
scatter(p_12_20_stack,CoV_stack,[],[37  65 178]/255,'filled')
hold on
scatter(p_12_20_2_stack,CoV_2_stack,[],[230 57 70]/255,'filled')
semilogx([p_12_20_stack;p_12_20_2_stack],CoV_Calc,'k','LineWidth',1)
%ylim([0.5 3])
legend('High Gain','Low Gain')
xlabel('Physiological Tremor (%MVC^2)','FontSize',14)
ylabel('CoV for Force (%)','FontSize',14)
%set(gca,'xscale','log')
set(gca,'TickDir','out');
set(gca,'box','off')

%%
scatter(PT_diff_stack,CoV_diff_stack,'filled')
xlabel('Difference in Physiological Tremor (%MVC^2)','FontSize',14)
ylabel('Difference CoV for Force (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')