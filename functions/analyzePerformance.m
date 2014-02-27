function [ adMu, adSigma, adMAD, adVaR ] = analyzePerformance( cSettings, cResults, cFrequency, viRollingPeriods, miNPeriods )
%analyzePerformance calculates and displays several risk and performance metrics for all tested models
%                   
%   * creates and plots heatmaps of output arrays
%   * creates plot of frequency of calibrated HMM model state for each hypothesis
%   * writes miNPeriods to Latex table
%   
%   Input:
%   cSettings:          structure of settings, as specified in Runtime.m
%   cResults:           matrix structure of cBacktestResults and cDiagnostics for each tested  model         
%   mdRawData:          matrix of raw data (first col. dates, all others returns)
%   cFrequency:         structure of descriptions for length of forecasting period $\delta t$
%   viRollingPeriods:   vector of integers, indicating length of rolling calibration data series $\Pi$    
%   miNPeriods:         matrix of number of periods for each tested model
%
%   Output:
%   adMu:       array of annualized rate of return for each hypothesis
%   adSigma:    array of return standard deviation for each hypothesis
%   adMAD:      array of equity curve (basis: 100) maximum drawdown for each hypothesis
%   adVaR:      array of equity curve (basis: 100) Value at Risk (VaR) for each hypothesis

%% Input
iNoFrequency = length(cFrequency);
iNoRollingPeriods = length(viRollingPeriods);
iNoPortfolios = length(cResults{1,1}.cBacktestResults.mdSummStats(1,:));
iNoMVPTPortfolios = length(cSettings.Gamma);
iNoMAPortfolios = length(cSettings.Alpha);

[adMu, adSigma , adMAD, adVaR] = deal(NaN(iNoFrequency,iNoRollingPeriods,iNoPortfolios));
cNoStates = cell(iNoFrequency,iNoRollingPeriods);

%% Create Output Arrays
% creates & plots output arrays
for i=1: iNoFrequency
    for j=1:iNoRollingPeriods
        for k=1: iNoPortfolios
            adMu(i,j,k) = cResults{i,j}.cBacktestResults.mdSummStats(1,k);
            adSigma(i,j,k) = cResults{i,j}.cBacktestResults.mdSummStats(2,k);
            adMAD(i,j,k) = cResults{i,j}.cBacktestResults.mdSummStats(3,k);
            adVaR(i,j,k) = cResults{i,j}.cBacktestResults.mdSummStats(4,k);
        end
            cNoStates{i,j} = [cResults{i,j}.cDiagnostics.NoStates];
    end
end

% Deal with inf and nan
adMu(adMu==-Inf)= -1;
adVaR(adVaR==Inf)= 100;

adRoMAD = adMu ./ adMAD;
adRoMAD(adRoMAD==Inf)= adMu(adRoMAD==Inf);
adExcessMu = adMu - repmat(adMu(:,:,iNoMVPTPortfolios+iNoMAPortfolios+1),[1,1,iNoPortfolios]);
adExcessMu(adExcessMu<-1.0) = -1.0;
cRowLabels = cFrequency;
% cRowLabels = cellstr(strcat('$',char(cFrequency),'$'));
cColLabels = strread(num2str(viRollingPeriods),'%s')';
cAssets = [{'ON Libor'}, cSettings.Securities];
iNoBins = 10;
iNoBinsNeg = 50;
sXlabel = 'Length of Calibration Data Series $\Pi$';
sYLabel = 'Length of Forecasting Period  $\delta t$';
for i=1:iNoMVPTPortfolios
    % Tables
    matrix2latex(adMu(:,:,i), strcat(cSettings.TableFolder,'\Mu_MVPT_',num2str(i),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adExcessMu(:,:,i), strcat(cSettings.TableFolder,'\ExcessMu_MVPT_',num2str(i),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adSigma(:,:,i), strcat(cSettings.TableFolder,'\Sigma_MVPT_',num2str(i),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adMAD(:,:,i), strcat(cSettings.TableFolder,'\MAD_MVPT_',num2str(i),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adVaR(:,:,i), strcat(cSettings.TableFolder,'\VaR_MVPT_',num2str(i),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adRoMAD(:,:,i), strcat(cSettings.TableFolder,'\RoMAD_MVPT_',num2str(i),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    
    %Plots
    h = plotHeatmap(adMu(:,:,i),cColLabels,cRowLabels,'money',iNoBins,{'\makebox[4in][c]{\textbf{MVPT Portfolio}}'; horzcat('\makebox[4in][c]{Returns for $\gamma = ',num2str(cSettings.Gamma(i)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\Mu_MVPT', num2str(i),'.pdf'));
    
    h = plotHeatmap(adExcessMu(:,:,i),cColLabels,cRowLabels,'money',iNoBins, {'\makebox[4in][c]{\textbf{MVPT Portfolio}}';horzcat('\makebox[4in][c]{Ex. Ret. for $\gamma = ',num2str(cSettings.Gamma(i)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\ExcessMu_MVPT', num2str(i),'.pdf'));
    
    h = plotHeatmap(adSigma(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg, {'\makebox[4in][c]{\textbf{MVPT Portfolio}}';horzcat('\makebox[4in][c]{Std. Dev. for $\gamma = ',num2str(cSettings.Gamma(i)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\Sigma_MVPT', num2str(i),'.pdf'));
    
    h = plotHeatmap(adVaR(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg, {'\makebox[4in][c]{\textbf{MVPT Portfolio}}';horzcat('\makebox[4in][c]{VaR for $\gamma = ',num2str(cSettings.Gamma(i)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\VaR_MVPT', num2str(i),'.pdf'));
    
    h = plotHeatmap(adMAD(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg,{'\makebox[4in][c]{\textbf{MVPT Portfolio}}'; horzcat('\makebox[4in][c]{MAD for $\gamma = ',num2str(cSettings.Gamma(i)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\MAD_MVPT', num2str(i),'.pdf'));
    
    h = plotHeatmap(adRoMAD(:,:,i),cColLabels,cRowLabels,'money',iNoBins,{'\makebox[4in][c]{\textbf{MVPT Portfolio}}';horzcat('\makebox[4in][c]{RoMAD for $\gamma = ',num2str(cSettings.Gamma(i)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\RoMAD_MVPT', num2str(i),'.pdf'));
end
for i=iNoMVPTPortfolios+1:iNoMVPTPortfolios+iNoMAPortfolios
    j = i- iNoMVPTPortfolios;
    % Tables
    matrix2latex(adMu(:,:,i), strcat(cSettings.TableFolder,'\Mu_MA_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adExcessMu(:,:,i), strcat(cSettings.TableFolder,'\ExcessMu_MA_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adSigma(:,:,i), strcat(cSettings.TableFolder,'\Sigma_MA_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adMAD(:,:,i), strcat(cSettings.TableFolder,'\MAD_MA_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adVaR(:,:,i), strcat(cSettings.TableFolder,'\VaR_MA_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adRoMAD(:,:,i), strcat(cSettings.TableFolder,'\RoMAD_MA_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    
    %Plots
    h = plotHeatmap(adMu(:,:,i),cColLabels,cRowLabels,'money',iNoBins, {'\makebox[4in][c]{\textbf{MA Portfolio}}'; horzcat('\makebox[4in][c]{Returns for $\alpha = ',num2str(cSettings.Alpha(j)),'$,$ H = ', num2str(cSettings.H(j)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\Mu_MA', num2str(j),'.pdf'));
    
    h = plotHeatmap(adExcessMu(:,:,i),cColLabels,cRowLabels,'money',iNoBins, {'\makebox[4in][c]{\textbf{MA Portfolio}}'; horzcat('\makebox[4in][c]{Ex. Ret. for $\alpha = ',num2str(cSettings.Alpha(j)),'$,$ H = ', num2str(cSettings.H(j)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\ExcessMu_MA', num2str(j),'.pdf'));
    
    h = plotHeatmap(adSigma(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg, {'\makebox[4in][c]{\textbf{MA Portfolio}}';horzcat('\makebox[4in][c]{Std. Dev. for $\alpha = ',num2str(cSettings.Alpha(j)),'$,$ H = ', num2str(cSettings.H(j)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\Sigma_MA', num2str(j),'.pdf'));
    
    h = plotHeatmap(adVaR(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg, {'\makebox[4in][c]{\textbf{MA Portfolio}}';horzcat('\makebox[4in][c]{VaR for $\alpha = ',num2str(cSettings.Alpha(j)),'$,$ H = ', num2str(cSettings.H(j)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\VaR_MA', num2str(j),'.pdf'));
    
    h = plotHeatmap(adMAD(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg,{'\makebox[4in][c]{\textbf{MA Portfolio}}';horzcat('\makebox[4in][c]{MAD for $\alpha = ',num2str(cSettings.Alpha(j)),'$,$ H = ', num2str(cSettings.H(j)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\MAD_MA', num2str(j),'.pdf'));
    
    h = plotHeatmap(adRoMAD(:,:,i),cColLabels,cRowLabels,'money',iNoBins, {'\makebox[4in][c]{\textbf{MA Portfolio}}';horzcat('\makebox[4in][c]{RoMAD for $\alpha = ',num2str(cSettings.Alpha(j)),'$,$ H = ', num2str(cSettings.H(j)),'$}')}, sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\RoMAD_MA', num2str(j),'.pdf'));
end
for i=iNoMVPTPortfolios+iNoMAPortfolios+1:iNoPortfolios
    j = i - iNoMVPTPortfolios - iNoMAPortfolios;
    % Tables
    matrix2latex(adMu(:,:,i), strcat(cSettings.TableFolder,'\Mu_Asset_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adSigma(:,:,i), strcat(cSettings.TableFolder,'\Sigma_Asset_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adMAD(:,:,i), strcat(cSettings.TableFolder,'\MAD_Asset_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adVaR(:,:,i), strcat(cSettings.TableFolder,'\VaR_Asset_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    matrix2latex(adRoMAD(:,:,i), strcat(cSettings.TableFolder,'\RoMAD_Asset_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    
    %Plots
    h = plotHeatmap(adExcessMu(:,:,i),cColLabels,cRowLabels,'money',iNoBins, horzcat('Asset Returns for ',cAssets{j}), sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\Mu_Asset', num2str(j),'.pdf'));
    
    h = plotHeatmap(adSigma(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg, horzcat('Asset Std. Dev. for ',cAssets{j}), sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\Sigma_Asset', num2str(j),'.pdf'));
    
    h = plotHeatmap(adVaR(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg, horzcat('Asset VaR for ',cAssets{j}), sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\VaR_Asset', num2str(j),'.pdf'));
    
    h = plotHeatmap(adMAD(:,:,i),cColLabels,cRowLabels,'red',iNoBinsNeg, horzcat('Asset MAD for ',cAssets{j}), sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\MAD_Asset', num2str(j),'.pdf'));
    
    h = plotHeatmap(adRoMAD(:,:,i),cColLabels,cRowLabels,'money',iNoBins, horzcat('Asset RoMAD for ',cAssets{j}), sXlabel, sYLabel);
    savePlot(h,strcat(cSettings.PlotFolder,'\RoMAD_Asset', num2str(j),'.pdf'));
    
    if(i>iNoMVPTPortfolios+iNoMAPortfolios+2)
        matrix2latex(adExcessMu(:,:,i-1), strcat(cSettings.TableFolder,'\ExcessMu_Asset_',num2str(j),'.tex'), 'rowLabels', cRowLabels, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%-6.2f');
    
        h = plotHeatmap(adExcessMu(:,:,i-1),cColLabels,cRowLabels,'money',iNoBins, horzcat('Asset Exc. Returns for ',cAssets{j}), sXlabel, sYLabel);
        savePlot(h,strcat(cSettings.PlotFolder,'\ExcessMu_Asset', num2str(j),'.pdf'));
    end
end

%% Pie Charts for No States
% frequency of calibrated HMM model state for each hypothesis
close all;
h = figure();
set(h,'Visible', 'off');
vdNoStates = [];
for i=1: iNoFrequency
    for j=1:iNoRollingPeriods
        viUnique = unique(cNoStates{i,j});
        viCounts = histc(cNoStates{i,j},viUnique);
        perc = viCounts ./ sum(viCounts) * 100;
        cLabels = cell(1,length(viUnique));
        for k=1:length(viUnique)
            cLabels{1,k} = horzcat(num2str(viUnique(k)),' States: ',num2str(perc(k),'%g'),'%');
        end
        h=pie(viCounts, cLabels);
        set(h(2:2:end),'FontSize',18);
        %title('Frequency of States')
        savePlot(gcf,strcat(cSettings.PlotFolder,'\FrequencyChart_', num2str(i),'_',num2str(j),'.pdf'));
    end
    vdNoStates = [vdNoStates, [cNoStates{i,:}]];
end

viUnique = unique(vdNoStates);
viCounts = histc(vdNoStates, viUnique);
perc = viCounts ./ sum(viCounts) * 100;
cLabels = cell(1,length(viUnique));
for k=1:length(viUnique)
    cLabels{1,k} = horzcat(num2str(viUnique(k)),' States: ',num2str(perc(k),'%g'),'%');
end
h=pie(viCounts, cLabels);
set(h(2:2:end),'FontSize',18);
%title('Overall Frequency of States')
savePlot(gcf,strcat(cSettings.PlotFolder,'\FrequencyChart_AGG.pdf'));

%% Write miNPeriods to Latex table
matrix2latex(miNPeriods, strcat(cSettings.TableFolder,'\NPeriods.tex'), 'rowLabels', {'monthly','quarterly','semi-annually','annually'}, 'columnLabels', cColLabels, 'alignment', 'c', 'format', '%d');

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