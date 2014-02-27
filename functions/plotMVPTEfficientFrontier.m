function [ h ] = plotMVPTEfficientFrontier( vdMu, mdSigma, varargin )
%plotMVPTEfficientFrontier plots MVPT efficient frontier
%                   
%   * plots MVPT efficient frontier
%   * optional parameters plot portfolios on efficient frontier with labels
%
%   Input:
%   vdMu:           vector of asset expected return
%   mdSigma:        covariance matrix
%   (vdStdDev):     vector portfolio std. dev.
%   (vdExpReturn):  vector portfolio expected return
%   (cLabels):      structure of portfolio labels
%
%   Output:
%   h:              figure handle

%% Settings
if (length(varargin)==3)
   vdStdDev = varargin{1};
   vdExpReturn = varargin{2};
   cLabels = varargin{3};
end

sFontName = 'Palatino';
iTitleFontSize = 16;
iLabelFontSize = 14;

close all;
h = figure();
set(h,'Visible', 'off');

%% Plot efficient frontier
vdER = 0:0.0001:0.3;
for i=1:length(vdER)
    vdWeights = calcMVWeights_Er(vdMu,mdSigma,vdER(i));
    cEFMVPT(i).ExpectedReturn = vdWeights' * vdMu;
    cEFMVPT(i).StdDev = sqrt(vdWeights' * mdSigma * vdWeights);
end
plot([cEFMVPT.StdDev],[cEFMVPT.ExpectedReturn])
%% Plot portfolios if provided
if (length(varargin)==3) 
    hold on;
    plot(vdStdDev , vdExpReturn, '.r','MarkerSize',15);
    for i=1:length(vdStdDev)
        text(vdStdDev(i)+0.025, vdExpReturn(i)  , cLabels{i}, 'Color', 'k','Fontname',sFontName);
    end
    hold off;
end

%% Titles and Labels
set(gca,'FontSize',9);
title('\textbf{MVPT Ef\/f\/icient Frontier}','Fontname',sFontName,'FontSize',iTitleFontSize,'Interpreter','latex');
xlabel('Standard Deviation $\sigma$','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
ylabel('Expected Return $E$','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');

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