%% The purpose of this function is to remove the linear background of the
% given data set
% y = linear_bkg(x, y0, option1, option2)
% Both input and output should be column vector
% Additional abscissa (x) is required for input
%
% If option == 'NoOffset', then the constant offset will be removed too
% If option == 'start' or 'end', the background removal is only done on one
% end

% Changyao Chen

%%
function y = linear_bkg(x, y0, option1, option2)

if nargin == 2
    option1 = 'dummy';
    option2 = 'dummy';
elseif nargin == 3
    option2 = 'dummy';
end

size = length(y0); % find out the length of the input vector
data_all = [x,y0];
data_sub = data_all([1:floor(0.01*size),floor(0.99*size:end)],:);
% only keep the first and last 1% of the data set, default
if nargin > 2 && (strcmp(option1, 'start') || strcmp(option2, 'start'))
    % only take first 5%
    data_sub = data_all(1:floor(0.05*size),:);
elseif nargin > 2  && (strcmp(option1, 'end') || strcmp(option2, 'end'))
    % only take last 5%
    data_sub = data_all(floor(0.95*size):end,:);
end

p = polyfit(data_sub(:,1), data_sub(:,2),1);
y = y0 - (p(1)* x + p(2)) + y0(1);

if nargin > 2 && (strcmp(option1, 'NoOffset') || strcmp(option2, 'NoOffset'))
    y = y0 - (p(1)* x + p(2));
end

end


