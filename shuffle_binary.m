function [bin2]=shuffle_binary(binmat)
%isi preserving spike time shuffler
%rows are MU spike trains.
bin2=zeros(size(binmat));

for i=1:size(binmat,1)
    %find spikes
    times=find(binmat(i,:)==1);
    %calculate isi's
    isi=diff(times);
    %random vector from 1: # of spikes
    ind=randperm(length(isi));
    %start spikes at same time
        %remove this if random start times are needed
    bin2(i,times(1))=1;
    %then add random isi's
    bin2(i,(times(1)+cumsum(isi(ind))))=1;
end




end
