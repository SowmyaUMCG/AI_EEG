function [auc,Ypbin,accur]= fcn_performPrediction(Xtrain1,Ytrain1,Xtest1,Ytest1)
%%performs different ML classitication to differentiate between two classes
%b=weights assigned to each variable
%ind = indices of important variable
%Ypbin = predicted probability score for each epoch

%prepare data%%
[Xtrain1,Ytrain1]=fcn_balancedata(Xtrain1,Ytrain1);
paroptions = statset('UseParallel',true);
[Xtrainbin,m1,v1] = fcn_normalise_tr_mv(Xtrain1');
Ytrainbin=Ytrain1;

pp = randperm(length(Ytrainbin));
Ytrainbin = Ytrainbin(pp); Xtrainbin = Xtrainbin(pp,:);

Xtestbin=fcn_normalise_te_mv(Xtest1',m1,v1);
Ytestbin=Ytest1;

%%use GLMNET toolbox%%
% %% Create a cross-validated fit.
% opts=struct; opts.alpha=0.9;
% options=glmnetSet(opts);
% cvob1=cvglmnet(Xtrainbin,Ytrainbin,'gaussian',options);
% %% Examine plots to find appropriate regularization.
% indx=find(cvob1.glmnet_fit.lambda==cvob1.lambda_1se);
% B=cvob1.glmnet_fit.beta;
% B0 = B(:,indx); nonzeros = sum(B0 ~= 0); cnst = cvob1.glmnet_fit.a0(indx);
% % % %% extract nonzero coefficients
% ind=find(abs(B0)>0); 
% b=[cnst; B0(ind)]; 
% 
% %%perform LR prediction%%
% Ypbin= cvglmnetPredict(cvob1,Xtestbin(:,ind));

%%perform random forest prediction%%
%Bnew=TreeBagger(100,Xtrainbin(:,ind),Ytrainbin,'Options',paroptions);%you can tune these parameters based on the validation set
%[class,scores]=predict(Bnew,Xtestbin(:,ind));

Bnew=TreeBagger(100,Xtrainbin,Ytrainbin,'Options',paroptions);%you can tune these parameters based on the validation set
[class,scores]=predict(Bnew,Xtestbin);
Ypbin=scores(:,2);


%%perform SVM prediction
% % CVSVMModel = fitcsvm(Xtrainbin(:,ind),Ytrainbin,'Standardize',false);
% % CompactSVMModel = CVSVMModel; % Extract trained, compact classifier
% % [Ypbin,score] = predict(CompactSVMModel,Xtestbin(:,ind));
%auc = fcn_getAUC(Ytestbin(:),Ypbin(:));

%use nntool for neural networks prediction%
[~,~,~,auc]=perfcurve(Ytestbin(:),Ypbin(:),1);
class=Ypbin;
class(class>=0.5)=1;%equal probability score
class(class<1)=0;
C= confusionmat(Ytestbin(:),class(:));
accur = sum(diag(C))/sum(C(:));
end
