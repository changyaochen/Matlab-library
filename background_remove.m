%% linear fitting to remove background 
% The goal of this script is to remove the influcence of y1(x) in y2(x)
% such that sum([y1(x) - (k0 + k1 * x) * y2(x)]^2) over all x can be
% minimized
%
% inputs:
% x : i x 1 matrix
% y1: i x j matrix
% y2: i x j matrix
% k1: intercept of the linear background 
% k2: slope of the linear background
% goal: min[ sum over j (sum over i [y1_(i,j) - (k1 + k2*x_i) * y2_(i,j)]^2 ) ]
%
% output:
% function, that can be used in fminsearch() call
% Changyao Chen, Feb, 2017


%%
function result = background_remove(x, y1, y2, k)
    if size(y1) ~= size(y2)
        disp('Sizes of y1 and y2 are not equal!');
        return;
    end
    
    if size(x,1) ~= size(y1,1)
       disp('Sizes of x and y1 (y2) are not equal!');
       return;
    end
    
    result = 0;
    for j = 1:size(y1, 2)
        for i = 1:size(y1, 1)
         result = result + (y2(i, j) - (k(1) + k(2)*x(i,1)) * y1(i, j))^2;
        end
    end