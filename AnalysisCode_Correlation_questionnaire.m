
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

load('Data_response')
Data_questionnaire = data;
Data_attention = Data_questionnaire(:,2)-Data_questionnaire(:,6);
Data_difficulty = Data_questionnaire(:,5)-Data_questionnaire(:,9);
Data_stress = Data_questionnaire(:,4)-Data_questionnaire(:,8);
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
HR_diff_1 = HR(:,1)-HR(:,2);
HR_diff_2 = HR(:,3)-HR(:,4);
HR_diff_vec = (HR_diff_1+HR_diff_2)/2;
%HR_diff_vec = [HR(:,1)-HR(:,2);HR(:,3)-HR(:,4)];
Attention_vec = [Data_attention(subject_vec)]; %;Data_attention(subject_vec)];
Difficulty_vec = [Data_difficulty(subject_vec)]; %;Data_difficulty(subject_vec)];
Stress_vec = [Data_stress(subject_vec)]; %;Data_stress(subject_vec)];
%%
X = [ones(length(HR_diff_vec),1) HR_diff_vec];
b1 = X\Attention_vec;
Attention_Calc = X*b1;
Rsq = 1 - sum((Attention_vec - Attention_Calc).^2)/sum((Attention_vec - mean(Attention_vec)).^2)

close all
[R,P] = corrcoef(HR_diff_vec,Attention_vec)
figure(1)
% scatter(HR(:,1)-HR(:,2),Data_attention(subject_vec),[],[37  65 178]/255,'filled')
% hold on
% scatter(HR(:,3)-HR(:,4),Data_attention(subject_vec),[],[230 57 70]/255,'filled')
scatter(HR_diff_vec,Data_attention(subject_vec),[],[37  65 178]/255,'filled')
hold on
plot(HR_diff_vec,Attention_Calc,'k','LineWidth',2) 
xlabel('Difference in normalized heart rate (bpm)','FontSize',14)
ylabel('Difference in sujective rating of attention','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')


%%
[R,P] = corrcoef(HR_diff_vec,Difficulty_vec)
figure(2)
scatter(HR(:,1)-HR(:,2),Data_difficulty(subject_vec),[],[37  65 178]/255,'filled')
hold on
scatter(HR(:,3)-HR(:,4),Data_difficulty(subject_vec),[],[230 57 70]/255,'filled')
xlabel('Difference in normalized heart rate (bpm)','FontSize',14)
ylabel('Difference in sujective rating of difficulty','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

[R,P] = corrcoef(HR_diff_vec,Stress_vec)
figure(3)
scatter(HR(:,1)-HR(:,2),Data_stress(subject_vec),[],[37  65 178]/255,'filled')
hold on
scatter(HR(:,3)-HR(:,4),Data_stress(subject_vec),[],[230 57 70]/255,'filled')
xlabel('Difference in normalized heart rate (bpm)','FontSize',14)
ylabel('Difference in sujective rating of difficulty','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')
