%% This function is to perform digital frequency mixing 
% [x, y, r, phase] = freqMixingRef(t, y1, fRef, lpBW)
% phase is in unit of rad, and taken Four-quadrant inverse tangent
%
% Changyao Chen

function [x, y, r, phase] = freqMixingRef(t, y1, fRef, lpBW)
    
    SampleRate = 1/mean(diff(t));
    lpFilt = designfilt('lowpassiir','FilterOrder',8, ...
         'PassbandFrequency',lpBW,'PassbandRipple',0.2, ...
         'SampleRate',SampleRate);  % the sampling rate is found from the data

    
    x = y1 .* cos(2*pi*fRef*t);
    x = filter(lpFilt, x);
    
    y = y1 .* sin(2*pi*fRef*t);
    y = filter(lpFilt, y);
    
    r = sqrt(x.^2 + y.^2);
    phase = atan2(y, x);
    
end
