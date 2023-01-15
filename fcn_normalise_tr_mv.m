function [data,m,v] = normalise(data)
%function to normalize training data  and returns mean(u) and standard dev of the
%training data
[N]=size(data,2);
m = nanmean(data(:,:),2);
v = std(data(:,:),[],2);
data=(data-m*ones(1,N)) ./ (v*ones(1,N));
data=data';
