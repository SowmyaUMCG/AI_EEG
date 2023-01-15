clear all; clc; format compact; 

load CCEMRCDATA
f = data.LPDfreqmaxfactor; 
s = data.hasseizures; 

ind = find(isnan(f)); f(ind) = 0.5; 

x = f; 
c = 1-s; 

[parm,parmci] = wblfit(x,0.04,c)