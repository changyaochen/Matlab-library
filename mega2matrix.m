% The purpose of this function is to convert the acquired megasweep (by iMeazure)
% to matrix format that can be better processed in Matlab
% Input are the raw data, in M x 3 format, where the 3 columns are: 
% x, y, stepped parameter (sp)
% Output are total of 1 matrix, where each of them have the format
%        stepped parameter 1, stepped parameter 2, stepped parameter 3, ...
%  x(1), y(1) at sp1        , y(1) at sp2        , y(1) at sp3        , ...
%  x(2), y(2) at sp1        , y(2) at sp2        , y(2) at sp3        , ...
%  x(3), y(3) at sp1        , y(3) at sp2        , y(3) at sp3        , ...
%  ... , ...                , ...                , ...                , ...

% MAscending  is that x is in ascending direction 
% MDescending is that x is in descending direction
% Changyao Chen

%%
function [MAscending, MDescending] = mega2matrix(rawData)

[m,n] = size(rawData);
SP = unique(rawData(:,3));
MAscending = [];
MDescending = [];

% There might be loss of data points, so abscissa might not line up
% Will take the longest abscissa, and apply it to M
% For the data with different abscissa, I will do linear interpolation

absLength = -1*ones(1,length(SP));
absLengthDescending = -1*ones(1,length(SP));
for k = 1:length(SP)
    MCol = rawData(rawData(:,3) == SP(k),:); % extract the data at k-th SP
    [temp, idx_switch] = max(MCol(:,1)); % find the line where the sweep direction changes
 %   idx_switch = idx_switch + 1; % just in case there are two identical maximum values
    MColAscending = MCol(1:idx_switch,:);
    idx = [];
    [MTemp, idx] = unique(MColAscending(:,1));
    cmd = strcat('MColAscending', num2str(k),' = MColAscending(idx,:);');% remove repeated abscissa
    eval(cmd);
    cmd = strcat('absLength(',num2str(k), ') = max(size(MColAscending', num2str(k), '));'); % find the length of abscissa
    eval(cmd);
    
    if idx_switch < size(MCol,1)
        MColDescending = MCol(idx_switch:end, :);
        idx = [];
        [MTemp, idx] = unique(MColDescending(:,1));
        cmd = strcat('MColDescending', num2str(k),' = MColDescending(idx,:);');% remove repeated abscissa
        eval(cmd);
        cmd = strcat('absLengthDescending(',num2str(k), ') = max(size(MColDescending', num2str(k), '));'); % find the length of abscissa
        eval(cmd);
    end
    
end

[C, I] = max(absLength);  % I is the index of where the longest abscissa is
cmd = strcat('MXAscending = MColAscending', num2str(I), '(:,1);'); % first column in M, which is considered as x
eval(cmd);

if idx_switch < size(MCol,1)
    [C, IDescending] = max(absLengthDescending);  % I is the index of where the longest abscissa is
    cmd = strcat('MXDescending = MColDescending', num2str(IDescending), '(:,1);'); % first column in M, which is considered as x
    eval(cmd);
end

% I am going to interpolate and then construct M
MAscending = MXAscending;
for k = 1:length(SP)
    cmd = strcat('MColInter', num2str(k), ' = interp1(MColAscending', num2str(k), '(:,1),MColAscending', num2str(k), '(:,2),MXAscending,''linear'',''extrap'');');
    % don't use spline, that will cause problems at both ends....
    eval(cmd);
    cmd = strcat('MAscending = [MAscending,MColInter', num2str(k), '];');
    eval(cmd);
end

if idx_switch < size(MCol,1)
    MDescending = MXDescending;
    for k = 1:length(SP)
        cmd = strcat('MColInter', num2str(k), ' = spline(MColDescending', num2str(k), '(:,1),MColDescending', num2str(k), '(:,2),MXDescending);');
        eval(cmd);
        cmd = strcat('MDescending = [MDescending,MColInter', num2str(k), '];');
        eval(cmd);
    end
end

MAscending = sortrows(MAscending, -1); % sort the frequency, with desending order
if idx_switch < size(MCol,1)
    MDescending = sortrows(MDescending, -1); % sort the frequency, with desending order
end


% add the header
MAscending = [[NaN,SP']; MAscending];
MDescending = [[NaN,SP']; MDescending];




