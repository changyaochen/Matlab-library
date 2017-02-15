% The purpose of this function is to plot the megasweep data
% The input should be a M by N matrix, where the element (1,1) in not used
% and the first row (not including the first element) should be stepped parameter
% and the first column (not including the first element) to be the swept
% parameter
%
% Options are: 'log': plotting data in logarithm scale
%              'diff': plotting numerical derivative of data along column
%              'smooth': smooth the data in z-direction

% Changyao Chen

%%
function megaPlot(M, ZLabel,option)
    data    = M(2:end,2:end);  % real data
    X       = M(1, 2:end);
    Y       = M(2:end,1);
    scrsz = get(0,'ScreenSize');
%     figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
    
    if nargin == 3 && strcmp(option, 'log') % plot the data in log format
        data = log10(abs(data));
    elseif nargin == 3 && strcmp(option, 'diff') % take numercial derivative along column direction
        data = abs(diff(data));
        Y    = Y(1:end-1);
    end
    
    if nargin == 3 && strcmp(option, 'smooth') % plot the data in log format
        surf(X, Y, data,'EdgeColor','none','FaceColor','interp'); % smooth the surface
    else
        surf(X, Y, data,'EdgeColor','none');
    end
  
    xlim([min(X), max(X)]);
    view(0,90); % set view angle
    
    if nargin == 3 && strcmp(option,'smooth')
        imagesc(data);
        % now going to put the right axis in
        SP      = M(1, 2:end); % stepped parameter
        XTick   = get(gca,'XTick');
        xRange  = xlim;
        XTickLabel = (SP(1) + XTick * (SP(end) - SP(1)) / (xRange(2) - xRange(1)));
        
        
        Y = M(2:end, 1); % swept parameter
        if nargin == 3 && strcmp(option, 'diff') % take numercial derivative along column direction
            Y = Y(1:end-1) + 0.5*diff(Y);
        end
        YTick   = get(gca,'YTick');
        yRange  = ylim;
        YTickLabel = Y(1) + YTick * (Y(end) - Y(1))/ (yRange(2) - yRange(1));
        
        format bank;
        set(gca,'XTickLabel',XTickLabel,'YTickLabel',YTickLabel);
        format longEng
    end
    
    hcb=colorbar;
    colorTitleHandle = get(hcb,'Title');
    titleString = ZLabel;
    set(colorTitleHandle ,'String',titleString);
    

end