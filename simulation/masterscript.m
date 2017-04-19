close all
clearvars
%% Variables
dt = 50e-12; %50 ps
tmax = 0.00001; %10 us
fc = 0.01*10^9; %0.01 GHz
fb = 10000; %10 kHz
Rb = 300; %300 Hz
SNR = 100; %dB awgn added at the receiver (not completly correct)

%Fixed
RTLAmp = 1;
[C1_initial,C2_initial,C1_man,C2_man] = initialChannel( dt*10 );
filter1 = [zeros(1,100) abs(C1_initial)];
filter2 = [zeros(1,100) abs(C2_initial)];
t = dt:dt:tmax;


%% Transmitter
bits = Createbitstream(Rb,t);               %Create bitstream (000000...)
sBase = createBPSK(t,bits,fb,Rb);           %Create (BPSK) signal
stransmit = transmit(t,fc,sBase);           %Transmit signal over carrier

%% Simulation
[srec1, t1] = channel(stransmit, filter1, SNR, t);
[srec2, t2] = channel(stransmit, filter2, SNR, t);

[si1, sq1, ts1] = rtlSim(t1, srec1, fc, RTLAmp);
[si2, sq2, ts2] = rtlSim(t2, srec2, fc, RTLAmp); %Not downsampled

%% initial nulling

%Upsampling skipped as been taken out of the SDR simulation only change fi
%values to doubles:
si1 = double(si1);
sq1 = double(sq1);
si2 = double(si2);
sq2 = double(sq2);

%Estimate the channels
h1 = estimate_h(si1,sq1,stransmit,fc,ts1);
h2 = estimate_h(si2,sq2,stransmit,fc,ts2); %ts = tup

%% Draw figure
figure
plot(t(1:length(h1))*10e9,h1)
hold on
plot(t(1:length(h1))*10e9,filter1)
title('Estimation of h1')
ylabel('Magnitude');
xlabel('Time (ns)')
legend('h estimate', 'h real')
axis([50 100 -0.5e-3 5.5e-3])
drawnow;

%% Continue inital nulling
%Call the inital nulling script
[p, siInNull, sqInNull, tsInNull] = initialNulling(h1,h2,t,filter1,filter2,fc,SNR,stransmit, RTLAmp);

%Compute the residue channel
hres = estimate_h(siInNull, sqInNull,stransmit,fc,tsInNull);
hres = hres(length(p)/2:length(p)); %Length correction as not stranmit was send but a zeropadded version

figure
plot(t(1:length(h1))*10e9,hres)
title('Performance After Initial Nulling')
ylabel('Signal Residue');
xlabel('Time (ns)')
drawnow;
hresInit = hres;
%% iterative nulling

%stransmit = stransmit * 10;
[p, hres] = IterativeNulling(hres, h1, h2, t, filter1, filter2, fc, SNR, stransmit, RTLAmp );

%% Detection
figure
%plot(hres)
hold on
leg = {'hres'};

lhres = length(hres);
for i= 1:length(C1_man(:,1))
    filter1New(i,:) = [zeros(1,100) abs(C1_man(i,:))];
    filter2New(i,:) = [zeros(1,100) abs(C2_man(i,:))];
    [si, sq, ts] = transmitSimul(p, t, filter1New(i,:), filter2New(i,:), fc, SNR, stransmit, RTLAmp);
    hTemp = estimate_h(si, sq,stransmit,fc,ts);
    h(i,:) = hTemp(lhres:2*lhres-1);
    
    %Plot
    plot(t(1:length(h(i,:))),h(i,:))
    leg{i+1} = ['channel' num2str(i)];
end
leg(1) = [];
legend(leg);

%% Make different plots
figure
n = 1;
filter2New(n,end+1:length(filter1New)) = 0;
plot(t(1:length(filter1New(n,:)))*10^9,filter1New(n,:)-filter2New(n,:))
hold on
plot(t(1:length(h(n,:)))*10^9,h(n,:))
n = 30;
filter2New(n,end+1:length(filter1New)) = 0;
plot(t(1:length(filter1New(n,:)))*10^9,filter1New(n,:)-filter2New(n,:))
hold on
plot(t(1:length(h(n,:)))*10^9,h(n,:))
title('"Activity channel"')
ylabel('Magnitude');
xlabel('Time (ns)')
legend('Expected channel (left)','Estimated channel (left)','Expected channel (center)','Estimated channel (center)');
drawnow;