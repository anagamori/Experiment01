close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

subject_vec = [1 2 3 4 5 6 9];

p2p_sta_stack = [];
CoV_stack = [];
p2p_sta_stack_2 = [];
CoV_stack_2 = [];

mean_p2p_sta_stack= [];
for j = 1:2
    for i = 1:length(subject_vec)
        n = subject_vec(i);
        if j == 1
            if n < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) '/Wrist flexion'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(n) '/Wrist flexion'];
            end
        else
            if n < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) '/Wrist extension'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(n) '/Wrist extension'];
            end
        end
        
        cd(dataFolder)
        load('CoV_All')
        load('p2p_sta_all')
        cd(codeFolder)
        
        figure(1)
        scatter(p2p_sta_all(:,1),CoV_All(:,1),'filled')
        hold on
        
        p2p_sta_stack = [p2p_sta_stack;p2p_sta_all(:,1)];
        CoV_stack = [CoV_stack;CoV_All(:,1)];
        
        mean_p2p_sta_stack = [mean_p2p_sta_stack mean(p2p_sta_all(:,1))];
        
        figure(2)
        scatter(p2p_sta_all(:,2),CoV_All(:,2),'filled')
        hold on
        
        p2p_sta_stack_2 = [p2p_sta_stack_2;p2p_sta_all(:,2)];
        CoV_stack_2 = [CoV_stack_2;CoV_All(:,2)];
        
        
    end
    
end
p2p_sta_stack([58 111]) = [];
CoV_stack([58 111]) = [];
p2p_sta_stack_2(111) = [];
CoV_stack_2(111) = [];
index_muscle = length(p2p_sta_stack)/2;
[R,P] = corrcoef(p2p_sta_stack,CoV_stack)
X = [ones(length(p2p_sta_stack),1) p2p_sta_stack];
b1 = X\CoV_stack;
CoV_Calc = X*b1;
Rsq = 1 - sum((CoV_stack - CoV_Calc).^2)/sum((CoV_stack - mean(CoV_stack)).^2)

figure(1)
scatter(p2p_sta_stack(1:index_muscle),CoV_stack(1:index_muscle),'filled')
hold on 
scatter(p2p_sta_stack(index_muscle+1:end),CoV_stack(index_muscle+1:end),'filled')
hold on
plot(p2p_sta_stack,CoV_Calc,'k','LineWidth',1)
legend('Flexors','Extensors')
text(0.02,1.4,['R^2 = ' num2str(Rsq)])
xlabel('Peak-to-peak amplitude (%MVC)','FontSize',14)
ylabel('CoV for Force (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

[R_2,P_2] = corrcoef(p2p_sta_stack_2,CoV_stack_2)
X = [ones(length(p2p_sta_stack_2),1) p2p_sta_stack_2];
b1_2 = X\CoV_stack_2;
CoV_Calc_2 = X*b1_2;
Rsq_2 = 1 - sum((CoV_stack_2 - CoV_Calc_2).^2)/sum((CoV_stack_2 - mean(CoV_stack_2)).^2)

%%
figure(2)
scatter(p2p_sta_stack_2(1:index_muscle),CoV_stack_2(1:index_muscle),'filled')
hold on 
scatter(p2p_sta_stack_2(index_muscle+1:end),CoV_stack_2(index_muscle+1:end),'filled')
hold on
plot(p2p_sta_stack_2,CoV_Calc_2,'k','LineWidth',1)
legend('Flexors','Extensors')
text(0.06,3,['R^2 = ' num2str(Rsq_2)])
xlabel('Peak-to-peak amplitude (%MVC)','FontSize',14)
ylabel('CoV for Force (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

