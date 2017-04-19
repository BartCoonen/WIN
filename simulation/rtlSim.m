function [outr, outq, outt] = rtlSim(t, sIn, fcar, amp )
%RTLSIM according to figure 5 of lab 6.pdf

fs = 2.4e6;                %Sample frequency
sIn = amp * sIn;              %Low noise amp
fsampleSim = 1/(t(2) - t(1));

%sr = exp(-1i*2*pi*fcar*t).*sIn;  %Shift the frequency to the left so that f0 =fc


%% Low pass filter
%sFilt = SDRFilter(sr,t,fs,1);
%sIn = sFilt;
%% Quantizer %To do: Change to a integer quantizer
%Downsample to fs 
D = round(fsampleSim/fs);
%sDown = downsample(sFilt,D);
sDown = sIn; %sFilt; %Skip downsampling!
%outt = downsample(t,D);
outt = t; %Skip downsampling
outr = (real(sDown));%fi,1,8);
outq = (imag(sDown));%fi,1,8); %8 bit signed float
