%% This function is to perform digital frequency mixing 
% of 2 time-series data. (y1 and y2, both column vectors)
% The 2 inputs should have same time stamp, and equally spaced (t, also column vector)
%
% t  : time base
% y1 : reference time trace
% y2 : data time trace
% ts : sampling time constant, corresponding to corner frequency of low pass 
%
% option: fRef is the reference frequency. If not provided, I will do FFT
% of y1
% z  : the output 
%
% Changyao Chen

function z = freqMixing(t, y1, y2, ts, fRef)
    
    if nargin == 4  % fRed is not provided
        fRef = myFFT(t,y1,'f0');  % to find fRef fro myFFT function
    end
    begin = find(t < 0.25/fRef,1,'last') + 1;  % quarter of 1/fRef
    
    M = floor((t(end) - t(begin))/ts); % how many data points in ONE time block
    N = floor((length(t) - begin)/M) - 1; % # of 'time blocks', minus 1 for the out-of-phase calculation
    
    t  = t(1:M*N);
    y1I = y1(1:M*N); % in phase
    y1O = y1(begin:M*N+begin-1);
    y2  = y2(1:M*N);
    
    tN   = reshape(t,N,M);
    y1IN = reshape(y1I,N,M);
    y1ON = reshape(y1O,N,M);
    y2N  = reshape(y2,N,M);
    
    zNITemp = y1IN.*y2N;  
    zNOTemp = y1ON.*y2N;
    zNIOut  = mean(zNITemp); % in phase component
    zNOOut  = mean(zNOTemp); % out of phase component
    

    
    T = mean(unique(diff(t)));  % sampled time interval
    
    tNOut = mean(tN);
    z     = [tNOut; zNIOut; zNOOut]';
    
end
