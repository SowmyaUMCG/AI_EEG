 function [sef, df] = specstats(freq, pyy)
 % your frequency axis is freq (a vector)
 % your power spectrum is pyy (a vector)


 % normalize spectrum to get a density
 pyy_norm = pyy./sum(pyy);


 % compute cumulative density
 pyy_cum = cumsum(pyy_norm);


 % median frequency corresponds to the frequency at (nearest to)
 % the point on the freq axis where pyy_cum = 0.5
 [val, idx] = min(abs(pyy_cum-0.5));
 mf = freq(idx);


 % spectral edge frequency corresponds to the frequency at (nearest to)
 % the point on the freq axis where pyy_cum = 0.05
 [val, idx] = min(abs(pyy_cum-0.05));
 sef = freq(idx);


 % you can extend this code for dominant frequency accordingly ... if
 %%%all you mean
 % is the peak frequency then you have
 [val, idx] = max(pyy);
 df = freq(idx);
 end