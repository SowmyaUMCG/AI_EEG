function [SEF, TP] = fcn_spectral_edge(PSD,freq,f1,f2,percent)
i11 = find(abs(freq-f1)<=0.1);    % f1 hertz index
i22 = find(abs(freq-f2)<=0.1);    % f2 Hz index
i1=i11(1);i2=i22(1);

P = PSD(i1:i2,:);       % Power in range f1-f2

edgeTP = zeros(1,size(P,2));
SEF = zeros(1,size(P,2));
TP = sum(P,1);
for j=1:size(P,2)
    i=1;
    edgeTP(j) = percent*sum(P(:,j));      % 90% of total spectral power between f1-f2Hz
    
    while((sum(P([1:i],j)) < edgeTP(j)) & (i <= (i2-i1)))
        i=i+1;
    end
    
    SEF(j) = freq(i1+i);       %spectral edge freq
end