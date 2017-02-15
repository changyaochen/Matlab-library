%  This function to do FFT in an easy way that can be understood
%  [f, output, f0] = myFFT(t, y, option, sampling_time)
%  The input are (t,y, option)
%  t is time vector
%  y is input time series data
%  option = 'linear', 'log', 'normalized', 'f0', 'T'
%  What is also require is the sampling interval, T
%  If normalized equals to 1, then the spetrum is normalized to its max

function [f, output, f0] = myFFT(t, y, option, sampling_time)
tic;
if (nargin == 4)
    T = sampling_time;
else
T = mean(unique(diff(t)));  % sampled time interval
%     if min(unique(diff(t))) < 0.9*T || max(unique(diff(t))) > 1.1*T
%         error('Time series data is not equally spaced!'); return;
%     end
T = abs(mode(diff(t)));
end
Fs = 1/T;
L = length(t); % total number of points
L = abs(max(t) - min(t)) * Fs;
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y); % perform the fft
f = Fs/L:Fs/L:Fs/2;
f = f';
output = abs(Y(1:max(size(f))));
[temp, idx] = max(2*abs(Y(1:NFFT/2+1)));
f0 = f(idx);

if (nargin > 2) && strcmp(option, 'psd')
%     Y = fft(y); % perform the fft
%     Y = Y(1:floor(L/2)+1);
    psdY = (1/(L*L)) * abs(output).^2;
%     L*Fs
    psdY(2:end-1) = 2*psdY(2:end-1);
    output = psdY; 
%     f = 0:Fs/L:Fs/2';
    output = 10*log10(output);
    plot(f, output, 'r'); 
    prettifyPlot('Power Spectrum density, dB (unit)^2 /Hz','Frequency (Hz)','');
    return;
end
if (nargin > 2) && strcmp(option, 'NoFigure')
    return;
end
toc;

% Plot single-sided amplitude spectrum.
%figure();
if (nargin == 2) || (nargin == 4) 
    plot(f, output, 'r'); set(gca,'yscale','log');
elseif strcmp(option, 'normal') % normalized
    plot(f, output/max(output), 'r');
elseif strcmp(option,'linear') % set y to log scale
    plot(f, output, 'r'); set(gca,'yscale','linear');
elseif strcmp(option,'log') % set y to log scale
    plot(f, output, 'r'); set(gca,'yscale','log');
elseif strcmp(option,'f0') % output egien frequency
    [temp, idx] = max(2*abs(Y(1:NFFT/2+1)));
    f0 = f(idx); return;
end

grid on;
grid minor;

end
