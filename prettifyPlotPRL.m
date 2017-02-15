%% The purpose of this function is to make the plot look nicer, for PRL format
% inputs (in sequence):
% y_label, x_label, figure_title, figure_legend

% Changyao Chen

%%
function prettifyPlotPRL(y_label, x_label, figure_title, figure_legend)

    fontsize = 24;
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
    set(gcf, 'Position',[100 100 500 500])
    
    set(gca,'tickdir','out');
    box on;
end