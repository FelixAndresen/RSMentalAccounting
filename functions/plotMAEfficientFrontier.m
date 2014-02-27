function [ h ] = plotMAEfficientFrontier(vdMu, mdSigma, vdHs, vdAlphas  )
%plotMAEfficientFrontier plots efficient MA frontier
%                   
%   * plots MA efficient frontier
%
%   Input:
%   vdMu:       vector of asset expected return
%   mdSigma:    covariance matrix
%   vdHs:       vector of investor required threshold return
%   vdAlphas:   vector of investor acceptable probability of failing to reach threshold return
%
%   Output:
%   h:          figure handle

%% Settings
sFontName = 'Palatino';
iTitleFontSize = 16;
iLabelFontSize = 12;

close all;
h = figure();
set(h,'Visible', 'off');

%% Plot MA Efficient Frontier
for i=1:length(vdHs)
    for j=1:length(vdAlphas)
        dImplGamma = calcImpliedGamma(vdMu, mdSigma, vdHs(i), vdAlphas(j));
        vdWeights = calcMVWeights_y(vdMu,mdSigma,dImplGamma);
        cEFMA(j,i).ExpectedReturn = vdWeights' * vdMu;
        cEFMA(j,i).StdDev = sqrt(vdWeights' * mdSigma * vdWeights);
        cEFMA(j,i).Alpha = vdAlphas(j);
        cEFMA(j,i).H =vdHs(i);
    end
    subplot(1,length(vdHs),i);
    plot([cEFMA(:,i).Alpha],[cEFMA(:,i).ExpectedReturn]);
    xlim([min(vdAlphas),max(vdAlphas)]);
    set(gca,'FontSize',9);
    if length(vdHs)>2
        xlabel({'$Prob[r(p)<H]$,';strcat('$H=',num2str(vdHs(i)*100),'\%$')},'Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
    else
        xlabel({strcat('$Prob[r(p)<H]$, $H=',num2str(vdHs(i)*100),'\%$')},'Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
    end
    if (i==1)
        ylabel('Expected Return $E$','Fontname',sFontName,'FontSize',iLabelFontSize,'Interpreter','latex');
    end
    
end

%% Title
ha = axes('Position',[0 0 1 1],'XLim',[0 1],'YLim',[0 1],'Box','off','Visible','off','Units','normalized','clipping','off');
text(0.5, 1, '\textbf{MA Ef\/f\/icient Frontiers}','Fontname',sFontName,'FontSize',iTitleFontSize,'Interpreter','latex','HorizontalAlignment','center','VerticalAlignment','top');

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