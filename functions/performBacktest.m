function [ cBacktestResults] = performBacktest( cSettings, cBacktest, cDiagnostics, mdRawData, cData,FreqTable)
%performBacktest performs Backtest
%
%   * transforms log-returns to discrete returns  
%   * calculates portfolio returns, equity curves...
%
%   Input:
%   cSettings:          structure of settings, as specified in Runtime.m
%   cBacktest:          structure containing backtest statistics , returned from initBacktest
%   cDiagnostics:       structure of diagnostic summary statistics
%   mdRawData:          matrix of raw data (first col. dates, all others returns)
%   cData:              structure of data, as returned by dataImport
%   FreqTable:          table of possile frequencies and their conversion to days
%
%   Output:
%   cBacktesResults:    structure containing backtest result statistics

[~, iNAssets] = size(mdRawData(:,2:end));
iNoGamma = length(cSettings.Gamma);
iNoAlpha = length(cSettings.Alpha);
iScalingRf = FreqTable.(cSettings.Frequency);

for i=1:length(cBacktest)-1
    % find  indices of dates
    iFirstIndex = find(mdRawData(:,1)==cBacktest(i).Date);
    iLastIndex = find(mdRawData(:,1)==cBacktest(i+1).Date);
    mdDataSubset = mdRawData(iFirstIndex:iLastIndex,:);
    
    if (i~=1)
        iFirstIndex = iFirstIndex +1;
        mdDataSubset = mdRawData(iFirstIndex:iLastIndex,:);
        mdDiscReturns = [(mdDataSubset(:,2)/iScalingRf),exp(mdDataSubset(:,3:end))-1];
    else
        mdDiscReturns = [zeros(1,iNAssets);(mdDataSubset(2:end,2)/iScalingRf),exp(mdDataSubset(2:end,3:end))-1];
    end

    % fill dates
    cBacktest(i).PortReturnsMVPT(1:iLastIndex-iFirstIndex+1,1) = mdDataSubset(:,1);
    cBacktest(i).PortReturnsMA(1:iLastIndex-iFirstIndex+1,1) = mdDataSubset(:,1);
    cBacktest(i).PortReturnsAssets(1:iLastIndex-iFirstIndex+1,1) = mdDataSubset(:,1);

    %Prepare Weights Matrix
    cBacktest(i).Weights.MV(1:iNoGamma,1:iNAssets+1) = [repmat(cBacktest(i).Date,iNoGamma,1), cBacktest(i).Weights.MeanVariance'];
    cBacktest(i).Weights.MA(1:iNoAlpha,1:iNAssets+1) = [repmat(cBacktest(i).Date,iNoGamma,1), cBacktest(i).Weights.MentalAccounting'];

    for k=1:iNoGamma
        vdWeights = cBacktest(i).Weights.MeanVariance(:,k);
        cBacktest(i).PortReturnsMVPT(1:iLastIndex-iFirstIndex+1,1+k) = mdDiscReturns * vdWeights;
        cBacktest(i).WeightsMV(k,1:iNAssets) = vdWeights';
    end
    for k=1:iNoAlpha
        vdWeights = cBacktest(i).Weights.MentalAccounting(:,k);
        cBacktest(i).PortReturnsMA(1:iLastIndex-iFirstIndex+1,1+k) = mdDiscReturns * vdWeights;
        cBacktest(i).WeightsMA(k,1:iNoAlpha) = vdWeights';
    end
    cBacktest(i).PortReturnsAssets(1:iLastIndex-iFirstIndex+1,2:1+iNAssets) = mdDiscReturns;
end

if (length(cBacktest) <= 2 )
    % Write Final Weights
    matrix2latex(cBacktest(1).Weights.MeanVariance, strcat(cSettings.TableFolder,'\MVPTWeights_final.tex'), 'rowLabels', [{'ON Libor'},cSettings.Securities], 'columnLabels', {'Subportfolio 1', 'Subportfolio 2', 'Subportfolio 3'}, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(cBacktest(1).Weights.MentalAccounting, strcat(cSettings.TableFolder,'\MAWeights_final.tex'), 'rowLabels', [{'ON Libor'},cSettings.Securities], 'columnLabels', {'Subportfolio 1', 'Subportfolio 2', 'Subportfolio 3'}, 'alignment', 'c', 'format', '%-6.2f');
    cBacktestResults = 0;
    return
end

mdAggCurveMVPT = equityCurve(vertcat(cBacktest.PortReturnsMVPT),2,'Discrete');
mdAggCurveMA = equityCurve(vertcat(cBacktest.PortReturnsMA),2,'Discrete');
mdAggCurveAssets = equityCurve(vertcat(cBacktest.PortReturnsAssets),2,'Discrete');

%% Set Equity to zero
for i=1:iNoGamma
    mdAggCurveMVPT(find(mdAggCurveMVPT(:,1+i)<=0,1):end,1+i) = 0;
end
for i=1:iNoAlpha
    mdAggCurveMA(find(mdAggCurveMA(:,1+i)<=0,1):end,1+i) = 0;
end
for i=1:iNAssets
    mdAggCurveAssets(find(mdAggCurveAssets(:,1+i)<=0,1):end,1+i) = 0;
end

mdMVWeights = vertcat(cBacktest.WeightsMV);
mdMAWeights = vertcat(cBacktest.WeightsMA);
vdDates = vertcat(cBacktest.Date);

cBacktestResults.mdAggCurveMVPT = mdAggCurveMVPT;
cBacktestResults.mdAggCurveMA = mdAggCurveMA;
cBacktestResults.mdAggCurveAssets = mdAggCurveAssets;
cBacktestResults.mdMVWeights = mdMVWeights;
cBacktestResults.mdMAWeights = mdMAWeights;
cBacktestResults.vdDates = vdDates;

%% Create Labels
cLabelsMVPT = cell(1,iNoGamma);
cLabelsMA =cell(1,iNoAlpha);
cSecuritiesLabels = cell(1,iNAssets);
sDec = '%.2f   ';
for i=1:iNoGamma
    cLabelsMVPT{i} =  horzcat('$\gamma = ',num2str(cSettings.Gamma(i),'%.4f   '),'$'); 
end
for i=1:iNoAlpha
    cLabelsMA{i} =  horzcat('$\alpha = ',num2str(cSettings.Alpha(i),sDec),'$, $H = ', num2str(cSettings.H(i),sDec),'$'); 
end
for i=1:iNAssets
    cSecuritiesLabels{i} =  cData(i).Asset;
end
cLabelsPortf = [cLabelsMVPT , cLabelsMA];
cLabelsAll = [cLabelsPortf , cSecuritiesLabels];

%% MVPT Plot
h = plotEquityCurve(mdAggCurveMVPT(:,1),mdAggCurveMVPT(:,2:end),cLabelsMVPT,{'\makebox[4in][c]{\textbf{Equity Curves}}';'\makebox[4in][c]{\textbf{MVPT optimized Portfolios}}'});
savePlot(h,strcat(cSettings.PlotFolder,'\EquityCurvesMVPTopt.pdf'));

%% MA Plot
h = plotEquityCurve(mdAggCurveMA(:,1),mdAggCurveMA(:,2:end),cLabelsMA,{'\makebox[4in][c]{\textbf{Equity Curves}}';'\makebox[4in][c]{\textbf{MA optimized Portfolios}}'});
savePlot(h,strcat(cSettings.PlotFolder,'\EquityCurvesMAopt.pdf'));

%% Combined Plot
mdAggCurveComb = [mdAggCurveMVPT, mdAggCurveMA(:,2:end)];
h = plotEquityCurve(mdAggCurveComb(:,1),mdAggCurveComb(:,2:end),cLabelsPortf,{'\makebox[4in][c]{\textbf{Equity Curves}}';'\makebox[4in][c]{\textbf{all optimized Portfolios}}'});
savePlot(h,strcat(cSettings.PlotFolder,'\EquityCurvesCombinedopt.pdf'));

%% Plot All
mdAggCurveAll = [mdAggCurveComb, mdAggCurveAssets(:,2:end)];
h = plotEquityCurve(mdAggCurveAll(:,1),mdAggCurveAll(:,2:end),cLabelsAll,{'\makebox[4in][c]{\textbf{Equity Curves}}'});
savePlot(h,strcat(cSettings.PlotFolder,'\EquityCurvesAll.pdf'));

mdSummStats = nan(4,iNoAlpha+iNoGamma+iNAssets);
mdSummStats(1,:) = (log(mdAggCurveAll(end,2:end))-log(mdAggCurveAll(1,2:end)))/ yearfrac(mdAggCurveAll(1,1),mdAggCurveAll(end,1),2);
mdSummStats(2,:) = std(mdAggCurveAll(:,2:end)) / yearfrac(mdAggCurveAll(1,1),mdAggCurveAll(end,1),2);
mdSummStats(3,:) = maxdrawdown(mdAggCurveAll(:,2:end));
mdSummStats(4,:) = portvrisk(mdSummStats(1,:),mdSummStats(2,:),0.05)';
cRowLabels = {'Mean Annualized Return', 'Annualized Std. Dev', 'Maximum Drawdown in %','$VaR_{0.05}$'};
matrix2latex(mdSummStats, strcat(cSettings.TableFolder,'\PortfStats.tex'), 'rowLabels', cRowLabels, 'columnLabels', cLabelsAll, 'alignment', 'c', 'format', '%-6.2f');
cBacktestResults.mdSummStats = mdSummStats;    

%% Weights Plots & ImplGamma
for k=1:iNoGamma
    h= plotWeights(vdDates(1:end-1,:), mdMVWeights(k:iNoGamma:end,:), cSecuritiesLabels,{'\makebox[4in][c]{\textbf{Asset Allocation}}';horzcat('\makebox[4in][c]{for MVPT Portfolio ',num2str(k),'}')});
    savePlot(h,strcat(cSettings.PlotFolder,'\AssetAllocation_MV_',num2str(k),'.pdf'));
end

mdImpliedGamma = vertcat(cDiagnostics.ImplGamma);
for k=1:iNoAlpha
    % Weights
    h= plotWeights(vdDates(1:end-1,:),mdMAWeights(k:iNoAlpha:end,:), cSecuritiesLabels, {'\makebox[4in][c]{\textbf{Asset Allocation}}';horzcat('\makebox[4in][c]{for MA Portfolio ',num2str(k),'}')});
    saveas(h,strcat(cSettings.PlotFolder,'\AssetAllocation_MA_',num2str(k),'.pdf'));
    % Implied Gamma  
    h = plotImpliedGamma( vdDates(1:end-1,:), mdImpliedGamma(:,k));
    saveas(h,strcat(cSettings.PlotFolder,'\ImpliedGamma_',num2str(k),'.pdf'));
end

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