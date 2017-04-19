function [p,si,sq, ts] = initialNulling(h1, h2, t, filter1, filter2, fc, SNR, stransmit, RTLAmp)
dt = t(2)-t(1);

%Compute p (P=-H1/H2)
r22 = xcorr(h2);
r12 = xcorr(-h1,h2);
p = deconvwnr(r12,r22);

%Transmit x over antenna 1 and px2 over antenna 2 siumtaniously
[si, sq, ts] = transmitSimul(p, t, filter1, filter2, fc, SNR, stransmit, RTLAmp) ;

%recreate the received signal
y = si.*cos(2*pi*fc*ts)+sq.*sin(2*pi*fc*ts);
end