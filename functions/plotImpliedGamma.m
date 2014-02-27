function [ h ] = plotImpliedGamma( dates, vdImpliedGamma )
%plotImpliedGamma plot Implied Gamma
%   
%   * plot Implied Gamma
%
%   Input:
%   dates:              vector of dates
%   vdImpliedGamma:     vector of implied gamma (requires same length as dates)
%
%   Output:
%   h:                  figure handle

%% Settings
sFontName = 'Palatino';
iTitleFontSize = 16;
iLabelFontSize = 14;

if (size(dates,1) ~= size(vdImpliedGamma,1))
        error('plotImpliedGamma: ', 'data and dates are not of the same length'); 
end

close all;
h = figure();
set(h,'Visible', 'off'); 

%% Plot Implied Gamma
plot(dates, vdImpliedGamma);
title('Implied Risk Aversion','Fontname',sFontName,'FontSize',iTitleFontSize,'Interpreter','latex');
xlabel('Year','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
ylabel('Implied $\gamma$','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
datetick('x','yy');
xlim([min(dates)-500,max(dates)+500]);
%legend_h = legend({'Implied $\gamma$'},'Fontname',sFontName,'Interpreter','latex');
%set(legend_h, 'Color', 'None', 'Box', 'off');
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