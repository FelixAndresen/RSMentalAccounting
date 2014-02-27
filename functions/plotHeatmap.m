function [ h ] = plotHeatmap( mdData, cColLabels, cRowLabels, colormap, iNoBins, sTitle, sXLabel, sYLabel )
%plotHeatmap plots a heatmap of data
%   
%   * plots a heatmap of data
%
%   Input:
%   mdData:         matrix of data
%   cColLabels:     structure column labels
%   cRowLabels:     structure row labels    
%   iNoBins:        number of bins used for coloring
%   sTitle:         string Title
%   sXLabel:        string X-axis label
%   sYLabe:         string Y-axis label
%
%   Output:
%   h:              figure handle

%% Settings
sFontName = 'Palatino';
iTickFontSize = 12;
iHeatMapFontSize= 12;
iTitleFontSize = 16;
iLabelFontSize = 14;

close all;
h = figure();
set(h,'Visible', 'off'); 
% set(0,'DefaultTextInterpreter', 'latex');

%% Plot Heatmap
heatmap(mdData,cColLabels,cRowLabels,'%0.2f','Textcolor','black','Colormap',colormap,'ColorLevels',iNoBins,'ColorBar',true,'GridLines', ':','ShowAllTicks',true,'TickFontSize',iTickFontSize,'FontSize',iHeatMapFontSize,'TickTexInterpreter',1);
title(sTitle,'Fontname',sFontName,'FontSize',iTitleFontSize,'Interpreter','latex','HorizontalAlignment','center');
xlabel(sXLabel,'Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
ylabel(sYLabel,'Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
set(gcf, 'Color', 'w');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% This source code is part of RSMentalAccounting.
%
% Copyright(c) 2014 Felix Andresen
% All Rights Reserved.
%
% This program shall not be used, rewritten, or adapted as the basis of a commercial software
% or hardware product without first obtaining written permission of the author. The author make
% no representations about the suitability of this software for any purpose. It is provided
% "as is" without express or implied warranty.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Written by
%   Felix Andresen  
%   Master Thesis:  Regime Switching Models and the Mental Accounting Framework
%   Advisors:       Prof. Jan Vecer, Prof. Sebastien Lleo
%   Master of Science in Quantitative Finance, Frankfurt School of Finance and Management
%   Frankfurt am Main, Germany
%   02/2014
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Contact
%   E-mail: Felix.Andresen@gmail.com
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%