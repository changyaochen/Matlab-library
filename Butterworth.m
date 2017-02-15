% This function is to calculate the output magnitude and phase of the
% Butterworth filter. 
% Requires signal processing toolbox
% [Mag Phase] = Butterworth(type, order, f_corner, f_carrier)
% input: type = 'low' or 'high'
%        order = order of the filter
% Changyao Chen, July 2015

function [Mag, Phase] = Butterworth(type, order, f_corner, f_carrier)

if (~strcmp(type, 'low') && ~strcmp(type, 'high'))
    error('Please chose either low pass or high pass filter!');
    return;
end

if max(f_corner, f_carrier) > 501e3
    error('This function only works for frequencies less than 500 kHz!');
    return;
end

f_max = 500e3;  % base frequency for normalization is 500 kHz

% construct the filter! 
[b, a] = butter(order, f_corner / f_max, type);
% freqz(b, a);
[h, w] = freqz(b, a, [f_carrier / f_max, 1] * pi);

Mag = abs(h(1));
Phase = angle(h(1)) * 180 / pi; % phase in degree
