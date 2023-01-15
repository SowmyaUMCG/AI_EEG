function features1 = fcn_get_QEEGfeatures(signal,fs,dur2)
%this function extracts time, frequency and entropy features from a given
%input signal. Requires functions from the QEEG features folder.
%add/remove any additional features depending on the requirement%

% signal= input signal (time series vector)
% fs = sampling frequency of the signal (in Hz)
% dur2 = duration of the EEG epoch (in secs)
win1=fs*dur2;
sws=fcn_segment_epoch(signal,win1);
parfor pp=1:min(size(sws))
    datanew=sws(pp,:)';
    %%Extracts time and entropy features%%
    %%time domain features%%
    [N,L] = fcn_nonlinear_energy(datanew);
    [activity, mobility, complexity] = fcn_hjorth(datanew);
    RMS_amp = fcn_RMS_amplitude( datanew);
    kurt = kurtosis( datanew);
    skew = skewness( datanew);
    %%%get HT based features%%
    datanew(isnan(datanew))=[];
    z=hilbert(datanew);
    am=abs(z).^2;
    ife = fs/(2*pi)*diff(unwrap(angle(z)));
    fhtam1=nanmean(am);
    fhtam2=nanstd(am);
    fhtam3=abs(skewness(am));
    fhtam4=kurtosis(am);
    burst=length(find(am>=5));
    fhtam5= (burst/length(datanew))*100;
    fhtam=[fhtam1 fhtam2 fhtam3 fhtam4 fhtam5];
    feat1=[N activity  mobility  complexity RMS_amp kurt skew fhtam];%time features
    %%%frequency domain features%%
    %you can replace periodogram with additional methods such as multitaper
    %spectrogram, STFT etc
    [Pxx,F] = periodogram(datanew,hann(length(datanew)),length(datanew),fs);
    delta= bandpower(Pxx,F,[0.5 4],'psd');
    theta = bandpower(Pxx,F,[4 8],'psd');
    alpha = bandpower(Pxx,F,[8 12],'psd');
    spindle=bandpower(Pxx,F,[12 16],'psd');
    beta = bandpower(Pxx,F,[16 25],'psd');
    total = bandpower(Pxx,F,[0.5 25],'psd');
    delta_tot=delta/total;
    theta_tot=theta/total;
    alpha_tot=alpha/total;
    spindle_tot=spindle/total;
    beta_tot=beta/total;
    alpha_delta=alpha/delta;
    theta_delta=theta/delta;
    spindle_delta=spindle/delta;
    beta_delta=beta/delta;
    alpha_theta=alpha/theta;
    spindle_theta=spindle/theta;
    beta_theta=beta/theta;
    fhtife1=nanmean(ife);
    fhtife2=nanstd(ife);
    fhtife3=abs(skewness(ife));
    fhtife4=kurtosis(ife);
    fhtife=[fhtife1 fhtife2 fhtife3 fhtife4];
    [sef, df] = fcn_specstats(F,Pxx);%%spectral egde and peak frequency
    feat2=[delta theta alpha spindle beta total delta_tot theta_tot alpha_tot spindle_tot beta_tot alpha_delta theta_delta spindle_delta beta_delta alpha_theta spindle_theta beta_theta fhtife sef df];%frequency features
    %%feat22 = fcn_getAddSpecFeatures(Pxx,F)
    %%%entropy features%%%
    [svd_ent, fisher] = fcn_inf_theory(datanew);
    H_spec = fcn_spectral_entropy_g(Pxx,(length(Pxx)));%spectral entropy
    [SE,~] = fcn_state_response_entropy(Pxx,F,(length(Pxx)));%state response entropy
    saen = fcn_SampEn(2, 0.2*std(datanew), datanew);%sample entropy
    renyi=fcn_renyi_entro(datanew,0.5);%renyi entropy
    shan = wentropy(datanew./max(datanew),'shannon');
    %%%%apen=fcn_approx_entropy(fs*2,0.5,datanew');%approximate entropy
    perm_entr = fcn_pec(datanew',2,1);
    FD=fcn_fractaldimensionfeatures(datanew,fs);%%fractal dimension
    feat3 =[svd_ent H_spec SE saen abs(renyi) abs(shan) perm_entr FD];%entropy features  
    features1(pp,:)=[feat1 feat2 feat3];%all features
end

end

