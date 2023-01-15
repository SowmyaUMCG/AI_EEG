function [X,Y]=fcn_getFeatures(eeg,annot,Fs,dur)
% eeg = raw EEG
%annot = annotations 
for pp=1:size(eeg,2)
    pp
    signal=eeg(:,pp);
    %signal = filter1('bp',y,'fc',[0.1 25],'fs',Fs);%filter data between two frequency range
    %resample signal to desired sampling frequency if required%
    X{pp}= fcn_get_QEEGfeatures(signal,Fs,dur);%get QEEG features for each patient
    sws=fcn_segment_epoch(annot,Fs*dur);
    Y{pp}=sws(:,1);%get ground truth
end