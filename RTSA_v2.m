% This function is to perform the equivalent of Real Time Spectrum Analyzer
% The inputs are raw data (data), and division in time (N) 
% should be a N by 2 matrix, 1st is time column, 2nd is Amplitude
% The data should be acquired from an oscilloscope
% The output M is the megasweep-type matrix, 
% They can be directly used by megaPlot function
% The output Result is the f0 vs. time 
%
% July 2015: add one more column the output Result, that is the amplitude
% of the time-domain data (requires Hilbert transformation)
% 
% Sept. 2016: upgraded to v2. In this new version, I am going to 'extend'
% each segment of time-series data, by simpling copying the orginal data
% and attaching it to the end k times. The purpose is to improve the
% 'quality' of the resuling FFT. At the very least, I should be able to
% increase the frequency resolution of the resulting FFT, which scales as
% fs/N, where fs is the sampling frequency (no way to change it), and N is
% the total length (that is being extended k times!)
% 
% Changyao Chen, ANL, March 2015

function [M, Result] = RTSA_v2(data, N, k, noise_level)

[row, col] = size(data);
Points_Segment = floor(row/N);
temp    = [];  % initialize the temp outputs, it will be the same fashion as megasweep data
Result  = [];

for i = 0:N-1
    % carve out the data
    time = data((i*Points_Segment+1):(i*Points_Segment+1)+Points_Segment,1);
    Amp  = data((i*Points_Segment+1):(i*Points_Segment+1)+Points_Segment,2);
    
    % ===== to stitch the data? ======
    [pks,locs] = findpeaks(Amp);   % requires singal processing toolbox
    time = time(locs(1):locs(end)-1);
    Amp = Amp(locs(1):locs(end)-1);
    
    % ===== to extend the time-series data! =====
    Amp_ext = repmat(Amp, k, 1);
    
    % ===== add some noise? =====
    Amp_ext = Amp_ext + noise_level * (max(Amp_ext) - min(Amp_ext)) * randn(size(Amp_ext));
    
    time_interval = mode(diff(time));
    for jj = 1:k
        if jj == 1
            time_ext = time;
        else
            time_ext = [time_ext; time_ext(end) + (time - time(1)) + time_interval]; 
        end
    end
    Amp_Hilbert = hilbert(Amp);
    Amp0 = mean(abs(Amp_Hilbert));
%     [f, A, f0] = myFFT(time, Amp,'NoFigure');
    
%     Amp_ext_Hilbert = hilbert(Amp_ext);
%     Amp0_ext = mean(abs(Amp_ext_Hilbert));
    [f, A, f0] = myFFT(time_ext, Amp_ext,'NoFigure');
    %     data_temp = data_temp(data_temp(:,1) < 2*f0, :);
    if i == 0
        temp = zeros(N*length(f), 3); % initialize the large matrix
        freq_length = length(f);
    end
    freq_length = length(f);
    data_temp = [f, A, mean(time)*ones(length(f),1)];
    temp((i*freq_length+1):(i*freq_length+1)+freq_length-1,:) = data_temp;
    
    Result = [Result; mean(time), f0, Amp0];
    clc; disp(['Percentage: ', num2str(100*i/N),'%']);
end

temp(temp(:,3) == 0, :) = [];    % remove any DC frequency component. It's gonna cause problem in mega2matrix script!
[M, Md] = mega2matrix(temp);

megaPlot(M,'Amp of FFT (a.u)', 'log');
end
    
    
