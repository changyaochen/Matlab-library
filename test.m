
meanFreqAll = 64.5e3;

volt2 = cos(2*pi*(meanFreqAll+0)*time);

inPhase    = freqMixingRef(time, volt2, meanFreqAll, 'sin');
quadrature = freqMixingRef(time, volt2, meanFreqAll, 'cos');
phase      = atan2(quadrature, inPhase);

SampleRate = 1/mean(diff(time));
lpFilt = designfilt('lowpassiir','FilterOrder',20, ...
         'PassbandFrequency',1e3,'PassbandRipple',0.1, ...
         'SampleRate',SampleRate);  % the sampling rate is found from the data
phase = filter(lpFilt, phase);
    
figure(99); [f, output, f0] = myFFT(time, phase, 'psd');
set(gca,'xscale','log');