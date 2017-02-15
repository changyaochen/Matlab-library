% This function to calculate Single side band Phase Noise (PN) from
% time series data
% I also intend to perform "average" by slicing the time series data into N
% segement, and assuming the noise is un-correlated, that the average of
% the N calculation should result lower overall noise level, which will
% reveal the intrinsic PN
%
% The input is (t,y,N), where t is time vection, y is amplitude, and N is
% averaging number
%
% The output is [fOffset, PN, f0], where f is offset frequency, PN is SSB PN, in
% unit of dBc/Hz, and f0 is oscillator frequency
%
% The functions called are: myFFT
%
% Changyao Chen, April, 2015

function [fOffset, PN, f0] = PhaseNoise(t, y, N)
tic;
T = mean(unique(diff(t)));  % sampled time interval
if min(unique(diff(t))) < 0.9*T || max(unique(diff(t))) > 1.1*T
    error('Time series data is not equally spaced!'); return;
end

if size(t,2) > 1
    t = t';
end

if size(y,2) > 1
    y = y';
end

[row, col] = size([t,y]);
Points_Segment = floor(row/N);
PN_all = [];  % all the PN, total of N
f0_all = [];

for i = 0:N-1
    time = t((i*Points_Segment+1):(i*Points_Segment+1)+Points_Segment-1,1);
    Amp  = y((i*Points_Segment+1):(i*Points_Segment+1)+Points_Segment-1,1);
    [f, psd, f0] = myFFT(time, Amp,'psd');
%     f_1Hz  = 0:1:max(f);   % 1Hz abscissa for PN calculation
%     P_1Hz  = interp1(f,A.^2,f_1Hz);  % interpolate power into 1Hz grid
%     P_perHz = diff(cumtrapz(f_1Hz, P_1Hz));  % calculate the power per Hz
    f0_all = [f0_all, f0];
    PN_all = [PN_all, psd/max(psd)];  % i-th PN, in dBc/Hz
end

disp(num2str(f0_all));
fOffset = f - mean(f0_all);
% PN = mean((PN_all.^2)')';  % take the rms of all PNs, in power ratio
% PN = 10*log10(PN);  % convert unit to dBc/Hz, make sure the pre-factor is correct!
PN = mean(PN_all, 2);
plot(fOffset, 10*log10(PN));
% xlim([1e1,1e6]);
set(gca,'xscale','log');
prettifyPlot('Phase Noise (dBc)','Offset Frequency (Hz)','');
toc;
end
