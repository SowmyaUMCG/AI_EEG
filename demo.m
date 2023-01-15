clc
clear
addpath(genpath(pwd))%add all files in the current folder
%load data (change it to your data)
%load sampledata_2.mat
sampledata=rand(10000,21);
eeg=sampledata(:,1:20);%raw single channel EEG (simulated) from 20 patients
annot = round(sampledata(:,end));%annotations

%get QEEG features%%
Fs=125;%sampling frequency
dur=30;%duration of EEG small epochs for analysis (in seconds)
[X,Y]=fcn_getFeatures(eeg,annot,Fs,dur);%get QEEG features

%use fcn_performPrediction to perform binary/multiclass prediction%
%Xtrain = training data
%Ytrain = training data annotation
%Xtest = testing data
%Ytest = testing data annotation

%Here i have used first 15 patients data for training and remaining for
%testing. You can also dividie training data into training and validation
%to optimize hyperparameters and then use the parameters to test on test
%data. You can change this to predict for each patient separately.

Xtrain=cell2mat(X(:,1:15)');
Ytrain=cell2mat(Y(:,1:15)');
Xtest=cell2mat(X(:,16:end)');
Ytest=cell2mat(Y(1,16:end)');

[auc,Ypbin,accur]= fcn_performPrediction(Xtrain,Ytrain,Xtest,Ytest);