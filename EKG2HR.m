function [HR_vec] =  EKG2HR (data,Fs,threshold)

HR_vec = zeros(1,length(data));

[pks,loc] = findpeaks(data,'MinPeakDistance',0.5*Fs,'MinPeakHeight',threshold);

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

