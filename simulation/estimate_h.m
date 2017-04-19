function [h] = estimate_h(yr,yc,x,fc,t)
%ESTIMATE_H2 Summary of this function goes here

%Recreate the received signal
y = yr.*cos(2*pi*fc*t)+yc.*sin(2*pi*fc*t);

%Determine expected filter length
lh = length(y)-length(x);

%Compute h (H=Y/X) as described in the paper
rxx = xcorr(x);
ryx = xcorr(y,x);
h = deconvwnr(ryx,rxx);
h = h(end/2 +0.5:end/2-0.5+lh); %h is causal and can't be longer than lh
h = h-(sum(h(1:100)/100)); %Average over the first hunderd 'noise' values to reduce the offset
h = h.*-x(1:length(h)); %Phase correction
end