
close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';


Fs = 1000;

subject_vec = 1:11; %[1 2 3 4 5 6 7 9];
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
 
        cd(codeFolder)
        CoV(k,index:index+1) = mean(CoV_All);
        PT(k,index:index+1) = mean(PT_All);
        p_12_20(k,index:index+1) = mean(p_12_20_All);
        index = index+2;
    end
end
CoV_diff_1 = CoV(:,1)-CoV(:,2);
CoV_diff_2 = CoV(:,3)-CoV(:,4);
CoV_diff_vec = (CoV_diff_1+CoV_diff_2)/2;

PT_diff_1 = PT(:,1)-PT(:,2);
PT_diff_2 = PT(:,3)-PT(:,4);
PT_diff_vec = (PT_diff_1+PT_diff_2)/2;
%CoV_diff_vec = [CoV(:,1)-CoV(:,2);CoV(:,3)-CoV(:,4)];
Attention_vec = [Data_attention(subject_vec)]; %;Data_attention(subject_vec)];
Difficulty_vec = [Data_difficulty(subject_vec)]; %;Data_difficulty(subject_vec)];
Stress_vec = [Data_stress(subject_vec)]; %;Data_stress(subject_vec)];
%%
X = [ones(length(Attention_vec),1) Attention_vec];
b1 = X\CoV_diff_vec;
CoV_Calc = X*b1;
Rsq = 1 - sum((CoV_diff_vec - CoV_Calc).^2)/sum((CoV_diff_vec - mean(CoV_diff_vec)).^2)

close all
[R,P] = corrcoef(CoV_diff_vec,Attention_vec)
figure(1)
% scatter(CoV(:,1)-CoV(:,2),Data_attention(subject_vec),[],[37  65 178]/255,'filled')
% hold on
% scatter(CoV(:,3)-CoV(:,4),Data_attention(subject_vec),[],[230 57 70]/255,'filled')
scatter(Data_attention(subject_vec),CoV_diff_vec,[],[37  65 178]/255,'filled')
hold on
plot(Attention_vec,CoV_Calc,'k','LineWidth',2) 
xlabel('Difference in sujective rating of attention','FontSize',14)
ylabel('Difference in CoV for force','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')


%%
CoV_hg = mean([CoV(:,1),CoV(:,3)],2);
CoV_lg = mean([CoV(:,2),CoV(:,4)],2);
CoV_gain = [CoV_hg;CoV_lg];
attention_gain = [Data_questionnaire(:,2);Data_questionnaire(:,6)];
X_2 = [ones(length(attention_gain),1) attention_gain];
b_2 = X_2\CoV_gain;
CoV_2_Calc = X_2*b_2;
Rsq_2 = 1 - sum((CoV_gain - CoV_2_Calc).^2)/sum((CoV_gain - mean(CoV_gain)).^2)

close all
[R_2,P_2] = corrcoef(CoV_gain,attention_gain)
figure(2)
% scatter(CoV(:,1)-CoV(:,2),Data_attention(subject_vec),[],[37  65 178]/255,'filled')
% hold on
% scatter(CoV(:,3)-CoV(:,4),Data_attention(subject_vec),[],[230 57 70]/255,'filled')
scatter(attention_gain(1:subjectN),CoV_gain(1:subjectN),[],[37  65 178]/255,'filled')
hold on 
scatter(attention_gain(subjectN+1:end),CoV_gain(subjectN+1:end),[],[230 57 70]/255,'filled')
hold on
plot(attention_gain,CoV_2_Calc,'k','LineWidth',2) 
plot([attention_gain(1:subjectN) attention_gain(subjectN+1:end)]',[CoV_gain(1:subjectN) CoV_gain(subjectN+1:end)]','color',[0.5 0.5 0.5])
legend('High Gain','Low Gain')
xlabel('Subjective Rating of Attention','FontSize',14)
ylabel('CoV for Force (%)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')


%%
b_3 = X\PT_diff_vec;
PT_Calc = X*b_3;
Rsq = 1 - sum((PT_diff_vec - PT_Calc).^2)/sum((PT_diff_vec - mean(PT_diff_vec)).^2)

%close all
[R,P] = corrcoef(PT_diff_vec,Attention_vec)
figure(3)
% scatter(PT(:,1)-PT(:,2),Data_attention(subject_vec),[],[37  65 178]/255,'filled')
% hold on
% scatter(PT(:,3)-PT(:,4),Data_attention(subject_vec),[],[230 57 70]/255,'filled')
scatter(Data_attention(subject_vec),PT_diff_vec,[],[37  65 178]/255,'filled')
hold on
plot(Attention_vec,PT_Calc,'k','LineWidth',2) 
xlabel('Difference in sujective rating of attention','FontSize',14)
ylabel('Difference in Physiological Tremor (%MVC^2)','FontSize',14)
set(gca,'TickDir','out');
set(gca,'box','off')

