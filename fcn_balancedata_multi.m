function [XX,YY]=fcn_balancedata_multi(Xtrain,Ytrain)

%%This function takes in X,Y and randomy balances data based on minimum class in
%%multiclass Y.

% % % scramble the training data
pp = randperm(length(Ytrain));
Yt = Ytrain(pp); Xt = Xtrain(pp,:);
%%%balance the training data
aa=unique(Ytrain);
for pp=1:length(aa)
nn(pp) = sum(Yt==aa(pp));
end
n = min(nn);

XX=[];YY=[];
for pp=1:length(aa)
ind = find(Yt==aa(pp)); ind = ind(1:n); X0 = Xt(ind,:); Y0 = Yt(ind);
XX=[XX;X0];
YY=[YY;Y0];
end
% % % scramble the training data
pp = randperm(length(YY));
YY = YY(pp); XX = XX(pp,:);
end