%% The purpose of this plot is to create 2 x-axis for the same plot
%  Inputs are (y, yLabel, x1, x1Label, x2, x2Label), 
%  y, x1, and x2  are vectors with same size
%  Changyao Chen

%%
function TwoXaxisPlot(y, yLabel, x1, x1Label, x2, x2Label)
 
    if nargin > 4
        line(x1, y); hold on;
        ylabel(yLabel);
        xlabel(x1Label);
        
        ax1 = gca; % current axes
        ax1_pos = get(ax1, 'Position'); % position of first axes
        ax2 = axes('Position',ax1_pos,...
            'XAxisLocation','top',...
            'YAxisLocation','right',...
            'Color','none');
        hold on;
        line(x2,y,'Parent',ax2);
        ylabel(yLabel);
        xlabel(x2Label);
    else 
        plot(x1, y);
        ylabel(yLabel);
        xlabel(x1Label);
    end
    
end