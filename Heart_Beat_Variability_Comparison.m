close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

subject_vec = 1; %[1 2 3 4 5 6 9];

p2p_sta_stack = [];
CoV_stack = [];
p2p_sta_stack_2 = [];
CoV_stack_2 = [];

mean_p2p_sta_stack= [];
for j = 1:4
    for i = 1:length(subject_vec)
        n = subject_vec(i);
        if j == 1
            if n < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) '/Wrist flexion'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(n) '/Wrist flexion'];
            end
        elseif j == 2
            if n < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) '/Wrist extension'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(n) '/Wrist extension'];
            end
            elseif j == 3
            if n < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) ' 20_MVC/Wrist flexion'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(n) ' 20_MVC/Wrist flexion'];
            end
            elseif j == 4
            if n < 10
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID 0' num2str(n) ' 20_MVC/Wrist extension'];
            else
                dataFolder = ['/Users/akiranagamori/Documents/GitHub/Experiment01/Record ID ' num2str(n) ' 20_MVC/Wrist extension'];
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

%%
index_contraction = length(p2p_sta_stack)/2;

[R_5,P_5] = corrcoef(p2p_sta_stack(1:index_contraction),CoV_stack(1:index_contraction))
X_5 = [ones(length(p2p_sta_stack(1:index_contraction)),1) p2p_sta_stack(1:index_contraction)];
b_5 = X_5\CoV_stack(1:index_contraction);
CoV_5_Calc = X_5*b_5;
Rsq_5 = 1 - sum((CoV_stack(1:index_contraction) - CoV_5_Calc).^2)/sum((CoV_stack(1:index_contraction) - mean(CoV_stack(1:index_contraction))).^2)

[R_20,P_20] = corrcoef(p2p_sta_stack(index_contraction+1:end),CoV_stack(index_contraction+1:end))
X_20 = [ones(length(p2p_sta_stack(index_contraction+1:end)),1) p2p_sta_stack(index_contraction+1:end)];
b_20 = X_20\CoV_stack(index_contraction+1:end);
CoV_20_Calc = X_20*b_20;
Rsq_20 = 1 - sum((CoV_stack(index_contraction+1:end) - CoV_20_Calc).^2)/sum((CoV_stack(index_contraction+1:end) - mean(CoV_stack(index_contraction+1:end))).^2)

figure(1)
scatter(p2p_sta_stack(1:index_contraction),CoV_stack(1:index_contraction),[],[230,97,1]/255,'filled')
hold on 
scatter(p2p_sta_stack(index_contraction+1:end),CoV_stack(index_contraction+1:end),[],[94,60,153]/255,'filled')
hold on
plot(p2p_sta_stack(1:index_contraction),CoV_5_Calc,'k','LineWidth',1)
plot(p2p_sta_stack(index_contraction+1:end),CoV_20_Calc,'k','LineWidth',1)
legend('5% MVC','20% MVC')
text(0.02,1.4,['R^2 = ' num2str(Rsq_5)])
text(0.1,1.4,['R^2 = ' num2str(Rsq_20)])
xlabel('Peak-to-peak amplitude (%MVC)','FontSize',14)
ylabel('CoV for Force (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

%%
[R_5_2,P_5_2] = corrcoef(p2p_sta_stack_2(1:index_contraction),CoV_stack_2(1:index_contraction))
X_5_2 = [ones(length(p2p_sta_stack_2(1:index_contraction)),1) p2p_sta_stack_2(1:index_contraction)];
b_5_2 = X_5_2\CoV_stack_2(1:index_contraction);
CoV_5_Calc_2 = X_5_2*b_5_2;
Rsq_5_2 = 1 - sum((CoV_stack_2(1:index_contraction) - CoV_5_Calc_2).^2)/sum((CoV_stack_2(1:index_contraction) - mean(CoV_stack_2(1:index_contraction))).^2)

[R_20_2,P_20_2] = corrcoef(p2p_sta_stack_2(index_contraction+1:end),CoV_stack_2(index_contraction+1:end))
X_20_2 = [ones(length(p2p_sta_stack_2(index_contraction+1:end)),1) p2p_sta_stack_2(index_contraction+1:end)];
b_20_2 = X_20_2\CoV_stack_2(index_contraction+1:end);
CoV_20_Calc_2 = X_20_2*b_20_2;
Rsq_20_2 = 1 - sum((CoV_stack_2(index_contraction+1:end) - CoV_20_Calc_2).^2)/sum((CoV_stack_2(index_contraction+1:end) - mean(CoV_stack_2(index_contraction+1:end))).^2)

figure(2)
scatter(p2p_sta_stack_2(1:index_contraction),CoV_stack_2(1:index_contraction),[],[230,97,1]/255,'filled')
hold on 
scatter(p2p_sta_stack_2(index_contraction+1:end),CoV_stack_2(index_contraction+1:end),[],[94,60,153]/255,'filled')
hold on
plot(p2p_sta_stack_2(1:index_contraction),CoV_5_Calc_2,'k','LineWidth',1)
plot(p2p_sta_stack_2(index_contraction+1:end),CoV_20_Calc_2,'k','LineWidth',1)
legend('5% MVC','20% MVC')
text(0.05,1.8,['R^2 = ' num2str(Rsq_5_2)])
text(0.14,1.8,['R^2 = ' num2str(Rsq_20_2)])
xlabel('Peak-to-peak amplitude (%MVC)','FontSize',14)
ylabel('CoV for Force (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

