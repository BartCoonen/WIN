function [si, sq, ts] = transmitSimul(p, t, filter1, filter2, fc, SNR, stransmit, RTLAmp) 
dt = t(2)-t(1);

%Send a zeropadded value of stransmit so that stransmit2 can expand
tInitNull = [t t(end)+dt:dt:t(end)+dt*(length(p)-1)];
sTransmitLong = [zeros(1,floor(length(p)/2)) stransmit zeros(1,floor(length(p)/2))];
[srec1Nul, t1] = channel(sTransmitLong, filter1, SNR, tInitNull);

%Compute stransmit 2 and send
stransmit2 = conv(stransmit, p);
[srec2Nul, t2] = channel(stransmit2, filter2, SNR, tInitNull);

%Sum the two received signals
if length(srec1Nul) >= length(srec2Nul)
    srec2Nul(end+1:length(srec1Nul)) = 0;
    trec = t1;
else
    srec1Nul(end+1:length(srec2Nul)) = 0;
    trec = t2;
end
srecNul = srec1Nul + srec2Nul;

%SDR simultation
[si, sq, ts] = rtlSim(trec, srecNul, fc, RTLAmp);
si = double(si);
sq = double(sq);
end

