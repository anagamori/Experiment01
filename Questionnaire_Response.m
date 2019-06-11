close all
clear all
clc

codeFolder = '/Users/akiranagamori/Documents/GitHub/Experiment01/';

[~,~,data_temp] = xlsread('Questionnaire_Response.xlsx');
% Column info
% 1: 'record_id'
% 2: 'hg_attention'
% 3: 'attention_dir_hg'
% 4: 'hg_stress'
% 5: 'hg_difficulty'
% 6: 'lg_attention'
% 7: 'attention_dir_lg'
% 8: 'lg_stress'
% 9: 'lg_difficulty'
% 10 'lg_arousal';
% 11: 'tiredness'
data_temp(1,:) = [];
data = cell2mat(data_temp);

save('Data_response','data')