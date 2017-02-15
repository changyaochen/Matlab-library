%% The purpose of this function is to make the plot look nicer
%  modified from prettifyPlot(), but with different spec

% Changyao Chen

%%
function prettifyPlotSpec(y_label, x_label, figure_title, figure_legend)

    fontsize = 18;
    fontname = 'Arial';
    ylabel(y_label,'FontSize',fontsize,'FontName',fontname);
    xlabel(x_label,'FontSize',fontsize,'FontName',fontname);
    title(figure_title,'FontSize',fontsize,'FontName',fontname);
    if nargin == 4
        legend(figure_legend);
    end
    
    set(gca,'FontSize',fontsize,'FontName',fontname);
    set(gcf, 'Color', [1,1,1]);
    scrsz = get(0,'ScreenSize');
    set(gcf, 'Position',[1 scrsz(4)/2 scrsz(4)/1.7 scrsz(4)/2]);
    xlim([-.2, 3.2]);
    set(gca ,'TickDir','out');
    
end