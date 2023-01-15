function [Xtrain,Ytrain]=fcn_balancedata(Xtrain,Ytrain)
% % % scramble the training data
%%This function takes in X,Y and randomy balances data based on minimum class in
%%binary Y.

pp = randperm(size(Ytrain,1));
Yt = Ytrain(pp); Xt = Xtrain(pp,:);
%%%balance the training data
n0 = sum(Yt==0); n1 = sum(Yt==1);
n = min(n0,n1);
ind = find(Yt==0); ind = ind(1:n); X0 = Xt(ind,:); Y0 = Yt(ind);
ind = find(Yt==1); ind = ind(1:n); X1 = Xt(ind,:); Y1 = Yt(ind);
Xtrain = [X0; X1];
Ytrain= [Y0; Y1];
end