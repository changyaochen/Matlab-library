%% This is my attempt to realize k-means clustering
% The inputs are:
%   Y:    N x 1 array (or vector)
%   k:    number of clusters
%   iter: number of iterations
%
% The outputs are:
%   c: k x 1 array (or vector), the centroids of the clusters
%   A: N x 1 array (or vector), assignments of the cluster
%   
%   Changyao Chen, Apr. 2017

function [c, A] = k_means(Y, k, iter)
    % initialize A
    A = -1*ones(size(Y));
    % first assign the centrorids randomly
    c = randn(k, 1); 
    
    % start the iterations:
    for i = 1:iter
        disp(['k-means iteration ', num2str(i), ' of ', num2str(iter)])
        % assign the cluster number to each element in Y
        for ii = 1:size(Y, 1)
            dist = Inf;
            % check each cluster
            for iii = 1:k
                if (Y(ii) - c(iii))^2 < dist
                    dist = (Y(ii) - c(iii))^2;
                    A(ii) = iii;
                end
            end
        end
        % update the centroids
        for iii = 1:k
           c(iii) = mean(Y(A == iii));
        end
    end
    
