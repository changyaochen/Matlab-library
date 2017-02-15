% This function is to unwrap phase data between [-2pi, 2pi] to unbounded
% values
% Changyao Chen, 1/21/2016

function phaseUnBouned = unwrap2pi(phaseBounded)
for i = 2:length(phaseBounded)
   if phaseBounded(i) - phaseBounded(i-1) > 0.98 * 2 * pi
       phase(i:end) = phase(i:end) - 2 * pi;
   end
   if phaseBounded(i) - phaseBounded(i-1) < -0.98 * 2 * pi
       phaseBounded(i:end) = phaseBounded(i:end) + 2 * pi;
   end
end

phaseUnBouned = phaseBounded;