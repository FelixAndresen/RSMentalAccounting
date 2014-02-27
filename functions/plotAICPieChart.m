function [ h ] = plotAICPieChart( vdAicWeights, cLabels )
%plotAICPieChart plots a pie chart of all AIC weights
%                   
%   * plots a pie chart of all AIC weights
%   * labels are augmented for percentages
%
%   Input:
%   vdAicWeights:   vector of AIC weights
%   cLabels:        labels for plot
%
%   Output:
%   h:              figure handle

%% Settings
if (size(vdAicWeights,1) ~= size(cLabels,1))
        error('plotAICPieChart: ', 'data and labels are not of the same length'); 
end
close all;
h = figure();
set(h,'Visible', 'off'); 

%% calculate Labels
vdPerc = vdAicWeights ./ sum(vdAicWeights) * 100;
idx = vdPerc>0.01;
cNewLabels = cellstr(strcat(cLabels(idx),cell({' : '}),num2str(vdPerc(idx),'%g'),'%'));

%% Create Plot
viExplode = zeros(size(vdAicWeights(idx)));
[~,iOffset] = max(vdAicWeights(idx));
viExplode(iOffset) = 1;
pie(vdAicWeights(idx), viExplode, cNewLabels);
colormap jet;
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