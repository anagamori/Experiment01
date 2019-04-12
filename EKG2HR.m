function [HR_vec] =  EKG2HR (data,Fs,threshold,figOpt)

HR_vec = zeros(1,length(data));

[~,loc] = findpeaks(data,'MinPeakDistance',0.5*Fs,'MinPeakHeight',threshold);

if figOpt == 1
    figure(21)
    findpeaks(data,'MinPeakDistance',0.5*Fs,'MinPeakHeight',threshold)
    
end
for i = 2:length(loc)
    ISI = (loc(i) - loc(i-1))/Fs;
    HR = 60/ISI;
    HR_vec(loc(i-1):loc(i)) = HR;
    if i == 2
        HR_vec(1:loc(i-1)) = HR;
    elseif i == length(loc)
        HR_vec(loc(i):end) = HR;
    end
end

end

