
% Changyao Chen Dec. 2015
% The simpliest Lornetzian function, in amplitude
% y = LorentzAmp(p, x)
% The inputs are: p = [A, f0, Q, bkg], x = frequency
% The output  is: y

function y = LorentzAmp_zero_bkg(p, x)

A = p(1);  % overall amplitude
f0 = p(2);  % resonance
Q = p(3);  % quality factor


y = A./sqrt((x.^2 - f0^2).^2 + (x * f0./Q).^2);
