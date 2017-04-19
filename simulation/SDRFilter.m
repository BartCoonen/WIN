function [ out ] = SDRFilter(sIn, t, fs, SDR)
%SDR = 1 mean this is the simulation of the SDR and checks for to small dt
%SDR = 0 doesnt check for to small dt
%   Detailed explanation goes here
       
fsampleSim = 1/(t(2) - t(1));

[filterCoefb, filterCoefa] = fir1(500, 2*fs/fsampleSim);
Filter = freqz(filterCoefb, filterCoefa, floor(length(t)/2));
if rem(length(t),2)
    Filter = [fliplr(Filter') 1 Filter'];
else
    Filter = [fliplr(Filter') Filter'];
end
Sr = fft(sIn);

Srshift = fftshift(Sr);
[~, i] = max(abs(Srshift(1:floor(end/2)-100)));
if Filter(i) > 0.01 && SDR && i
    error('dt to big for the SDRFilter or not enough filter coefficients')
end

Sr = Sr.*fftshift(Filter);
out = ifft(Sr);

end

