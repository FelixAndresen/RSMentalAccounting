function [ h, mdViterbi ] = plotViterbiSequence( dates, mdData, cLegend, mdMu, vdViterbiPath )
%plotViterbiSequence plots Viterbi sequence
%   
%   * plots Viterbi sequence
%   * changes first color depending on sign of first state
%
%   Input:
%   dates:          vector of dates
%   mdData:         matrix of equity curves (requires same length as dates)
%   cLegend:        structure legend (not plotted -> comment in)
%   mdMu:           vector of distribution means
%   vdViterbiPath:  vector indicating the state sequence (requires same length as dates)
%
%   Output:
%   h:              figure handle

%% Settings
sTitle = '\textbf{Viterbi Sequence}';
sFontName = 'Palatino';
iTitleFontSize = 16;
iLabelFontSize = 14;

if (size(dates,1) ~= size(mdData,1))
        error('plotViterbiSequence: ', 'data and dates are not of the same length'); 
end

if (size(dates,2)==1)
    miDates = repmat(dates,1,size(mdData,2));
end

% rearrange colores depending on sign of first distribution mean
if (sign(mdMu(1,1))==-1)
    csColors = {'r','g','y','m','b','c'};
else
    csColors = {'g','r','y','m','b','c'};
end

close all;
h = figure();
set(h,'Visible', 'off'); 

%% Plot Equity Curves
plot(miDates,mdData);
if (yearfrac(dates(1),dates(end))<5)
    datetick('x','mmmyy','keeplimits'); %mm
else
    datetick('x','yy','keeplimits');
end
xlim([min(dates),max(dates)])
hold on;

%% Calculate length of each state
mdViterbi =  [dates [vdViterbiPath(1) , vdViterbiPath]'];

viIndex = [1,find([0,mdViterbi(1:end-1,2)'-mdViterbi(2:end,2)'])];
if (viIndex(end)~= length(mdViterbi))
    viIndex = [viIndex, length(mdViterbi)+1];
end

cState{mdViterbi(viIndex(1),2),1} = mdViterbi([viIndex(1),viIndex(2)-1],1);
iCounter = 2;
iLastDate = mdViterbi(viIndex(2)-1,1);
for i = 2:numel(viIndex)
    iState = mdViterbi(viIndex(i-1),2);
    viDates = mdViterbi([viIndex(i-1),viIndex(i)-1],1);
    cState{iState,iCounter} = [iLastDate, viDates(2)];
    iCounter = iCounter + 1;
    iLastDate = viDates(2);
    if (i==numel(viIndex)) && (viIndex(i)==length(mdViterbi))
        cState{mdViterbi(viIndex(i),2),iCounter} = [iLastDate, mdViterbi(end,1)];
    end
end

%% Shade Plot depending on State
for iIndexState = 1:size(cState,1)
    ShadePlotForEmpahsis(cState(iIndexState,~cellfun('isempty',cState(iIndexState,:))), csColors{iIndexState},0.5);
end

% legend_h = legend(cLegend);
% set(legend_h, 'Color', 'None', 'Box', 'off');

%% Titles and Labels
title(sTitle,'Fontname',sFontName,'FontSize',iTitleFontSize,'Interpreter','latex');
xlabel('Year','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
ylabel('Equity','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
set(gcf, 'Color', 'w');
hold off;

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