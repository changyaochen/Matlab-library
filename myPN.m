% This function to calculate PN from phase vs. time data
% [PN, f] = myPN(t, phase)
% phase (input) is in unit of rad
% t (input) is in unit of second
% f (output) is in unit of Hz
% PN (output) is in unit of dBc/Hz
% it will call myFFT() function 

function [PN, f] = myPN(t, phase)

    phase_no_bkg = detrend(phase);
    figure();
    [f, output, f0] = myFFT(t, phase_no_bkg, 'psd');
    set(gca,'xscale','log');
    close;
    PN = output - 3;
    
return;