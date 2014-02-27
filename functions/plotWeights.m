function [ h ] = plotWeights( dates, vdWeights, cLegend, sTitle )
%plotWeights plots portfolio asset allocation
%   
%   * plots portfolio asset allocation
%
%   Input:
%   dates:      vector of dates
%   vdWeights:  vector of weights (require same length as dates)
%   cLegend:    structure legend
%   sTitle:     string title
%
%   Output:
%   h:          figure handle

%% Settings
sFontName = 'Palatino';
iTitleFontSize = 16;
iLabelFontSize = 14;

if (size(dates,1) ~= size(vdWeights,1))
        error('plotWeights: ', 'data and dates are not of the same length'); 
end

close all;
h = figure();
set(h,'Visible', 'off'); 

%% Plot Weights
bar(dates,vdWeights,1,'BaseValue',0);
title(sTitle,'Fontname',sFontName, 'FontSize',iTitleFontSize,'Interpreter','latex');
xlabel('Year','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
ylabel('Weight','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
datetick('x','yy');
legend_h = legend(cLegend);
set(legend_h, 'Color', 'None', 'Box', 'off');
xlim([min(dates)-250,max(dates)+250]);
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