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
% Changyao Chen, ANL, March 2015

function [M, Result] = RTSA_perfect(data, N, option)

[row, col] = size(data);
Points_Segment = floor(row/N);
temp    = [];  % initialize the temp outputs, it will be the same fashion as megasweep data
Result  = [];

for i = 0:N-1
    % carve out the data
    time = data((i*Points_Segment+1):(i*Points_Segment+1)+Points_Segment,1);
    Amp  = data((i*Points_Segment+1):(i*Points_Segment+1)+Points_Segment,2);
    Amp_Hilbert = hilbert(Amp);
    Amp0 = mean(abs(Amp_Hilbert));
    [f, A, f0] = myFFT(time, Amp,'NoFigure');
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

[M, Md] = mega2matrix_perfect(temp);
if nargin > 2 && strcmp(option, 'NoFigure')
    return;
else
    megaPlot(M,'Amp of FFT (a.u)', 'log');
end
end
    
    
