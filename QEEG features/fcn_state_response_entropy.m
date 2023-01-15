% EEG Spectral entropy per epoch
function [SE,RE] = fcn_state_response_entropy(Pxx,F,w)
ind1=find(F>=0.8 &F<=32);
ind2=find(F>32 &F<=47);
Rlow=Pxx(ind1);
Rhigh=Pxx(ind2);
N1=length(Rlow);
N2=length(Rhigh);
SRlow=fcn_spectral_entropy_g(Rlow,w);
SRhigh=fcn_spectral_entropy_g(Rhigh,w);

SE=SRlow./log2(N1+eps);
RE=SRhigh./log2(N2+eps);
end