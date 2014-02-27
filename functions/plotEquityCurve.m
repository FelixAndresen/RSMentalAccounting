function [ h ] = plotEquityCurve( dates, mdData, cLegend, sTitle )
%plotEquityCurve plots equity curve
%   
%   * plots (multiple) equity curves
%
%   Input:
%   dates:      vector of dates
%   mdData:     matrix of equity curves (require same length as dates)
%   cLegend:    structure legend
%   sTitle:     string title
%
%   Output:
%   h:          figure handle

%% Settings
sFontName = 'Palatino';
iTitleFontSize = 16;
iLabelFontSize = 14;

if (size(dates,1) ~= size(mdData,1))
        error('plotEquityCurve: ', 'data and dates are not of the same length'); 
end

if (size(dates,2)==1)
    miDates = repmat(dates,1,size(mdData,2));
end
close all;
h = figure();
set(h,'Visible', 'off'); 

%% Plot Equtiy curve
plot(miDates,mdData);
title(sTitle,'Fontname',sFontName,'FontSize',iTitleFontSize,'Interpreter','latex');
xlabel('Year','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
ylabel('Equity','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
if (yearfrac(dates(1),dates(end))<5)
    datetick('x','mmmyy','keeplimits'); %mm
else
    datetick('x','yy');
end
xlim([min(dates),max(dates)])
legend_h = legend(cLegend,'Fontname',sFontName,'Interpreter','latex','Location','NorthWest');
set(legend_h, 'Color', 'None', 'Box', 'off');
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