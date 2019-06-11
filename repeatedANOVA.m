
%data structure needs to be subject(rows) by condition(columns)
% k = number of measurements taked to get the mean
%output: p = p-value for repeated measures ANOVA, ICC = intraclass
%correlation, SEM = standard error of measurements, MD = minmal detectable
%difference 

function [p,ICC,SEM,MD,eta_squared] = repeatedANOVA(data,k)
    [n_subject,n_condition] = size(data);

    df_subject = n_subject - 1; %degree of freedon for subject 
    df_condition = n_condition - 1; %degree of freedon for condition 
    df_error = df_subject*df_condition;
    df_within = n_subject*df_condition;

    mean_condition = mean(data,1);  %mean of each condition across subject
    mean_subject = mean(data,2);   %mean of each subject across condition 

    data_long = [];
    
    for i = 1:n_condition 
        data_long = [data(:,i);data_long];  
    end
    mean_total = mean(data_long);   %grand mean

    SS_total = 0;
    SS_within = 0;
    SS_condition = 0;

    for i = 1:n_condition 
       SS_total = sum((data(:,i)-mean_total).^2)+SS_total;  %total sum of squares (SS) 
       SS_within = sum((data(:,i)-mean_subject).^2)+SS_within; %SS for within subjects 
       SS_condition = n_subject*(mean_condition(i)-mean_total).^2+SS_condition; %SS for conditions 
    end

    SS_between = n_condition*sum((mean_subject-mean_total).^2); %SS for between subjects
    SS_error = SS_within - SS_condition;    %SS for error 

    MS_between = SS_between/df_subject;
    MS_within = SS_within/df_within;
    MS_condition = SS_condition/df_condition;
    MS_error = SS_error/df_error;

    F = MS_condition/MS_error;
    p = 1-fcdf(F,df_condition,df_error);
    
    ICC = (MS_between-MS_error)/(MS_between+k*(MS_condition-MS_error)/n_subject); %2-way fixed
    SD = sqrt(SS_total/(n_subject-1));
    SEM = SD*sqrt(1-ICC);
    SEM_TS = SD*sqrt(ICC*(1-ICC));
    MD = SEM*1.96*sqrt(2);
    
    eta_squared = MS_condition/(MS_condition+MS_error);
    
end
%sprintf('%.1f',SS_total)
