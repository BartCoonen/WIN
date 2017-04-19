function [ p, hres ] = IterativeNulling(hres, h1, h2, t, filter1, filter2, fc, SNR, stransmit, RTLAmp )
%close all
k(1) = sum(abs(hres))/length(hres);
figure
for i = 1:300
    lhres = length(hres);
    plot(hres)
    hold on
    h2(end+1:lhres) = 0;
    h1(end+1:lhres) = 0;
    if(rem(i,2) == 0)
        h1 = hres + h1;
    else 
        rh1 = xcorr(h1);
        r1res = xcorr(hres, h1);
        %r1res = fliplr(r1res);
        hresoverh1 = deconvwnr(r1res, rh1);
        h2 = conv(([zeros(1,lhres-1) 1 zeros(1,lhres-1)] + hresoverh1), h2); %+ instead of - ??
        h2 = h2(lhres:2*lhres-1);
    end
    r22 = xcorr(h2);
    r12 = xcorr(-h1,h2);
    p = deconvwnr(r12,r22);
    
    [si, sq, ts] = transmitSimul(p, t, filter1, filter2, fc, SNR, stransmit, RTLAmp);
    hres = estimate_h(si, sq,stransmit,fc,ts);
    hres = hres(lhres:2*lhres-1); %As the h estimation should be done with sTransmitLong the response we get now will be shifted with lhres
    k(i+1) = sum(abs(hres))/length(hres);
    if k(end) < 1e-10
        break;
    end
end 

y = si.*cos(2*pi*fc*ts)+sq.*sin(2*pi*fc*ts);
figure
plot(0:i,k)
title('Iterative Nulling Convergence')
ylabel('Channel Residue Error');
xlabel('Iteration')

figure
plot(t(1:length(hres))*10e9, hres)
title('Performance After Iterative Nulling')
ylabel('Channel Residue');
xlabel('Time (ns)')
drawnow;

end


