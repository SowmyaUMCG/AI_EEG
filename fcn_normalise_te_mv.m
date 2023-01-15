function [data] = fcn_normalise_te_mv(data,u,std)
%function to normalize testing data w.r.t. mean(u) and standard dev of the
%training data
[N]=size(data,2);

data=(data-u*ones(1,N)) ./ (std*ones(1,N));
data=data';
