function [ cBacktestResults, cDiagnostics, iNPeriods ] = testModel(cData, mdRawData, cSettings, cDiagnostics )
%testModel tests a single model (hypothesis)
%
%   * calibrates HMMs
%   * selects best fitting HMM
%   * builds tree 
%   * optimizes tree
%   * runs diagnostics
%   * backtests model
%   
%   Input:
%   cData:              structure of data, as returned by dataImport
%   mdRawData:          matrix of raw data (first col. dates, all others returns)
%   cSettings:          structure of settings, as specified in Runtime.m
%   cDiagnostics:       structure of diagnostic summary statistics       
%
%   Output:
%   cBacktestResults:   structure of  of annualized rate of return for each hypothesis
%   cDiagnostics:       structure of diagnostic summary statistics
%   iNPeriods:          number of how many periods were used to backtest the model

%% HashTable
FreqTable.('w')=52;
FreqTable.('m')=12;
FreqTable.('q')=4;
FreqTable.('s')=2;
FreqTable.('a')=1;

%% Backtest
iMod = mod(length(mdRawData)-cSettings.RollingPeriod, diff(cSettings.TimeVec));
iFirstIndex = iMod + 1;
iNPeriods = (length(mdRawData)-iMod-cSettings.RollingPeriod)/diff(cSettings.TimeVec)+1;
cBacktest(iNPeriods+1).Date = mdRawData(end,1);

for i=1:iNPeriods
    disp(horzcat('Backtest Period ',num2str(i),' of ', num2str(iNPeriods)));
    % Subsetting of Data
    mdDataSlice = mdRawData(iFirstIndex + ((i-1)*diff(cSettings.TimeVec)) : iFirstIndex + cSettings.RollingPeriod + ((i-1)*diff(cSettings.TimeVec)) -1 ,:);
    % Scale to yearly
    mdUseData = mdDataSlice(:,3:end)* FreqTable.(cSettings.Frequency);
    
    %Riskfree asset
    cRiskfree.Mu = mean(mdDataSlice(:,2));
    cRiskfree.Sigma = var(mdDataSlice(:,2));
   
    % Fit HMM
    cHMM = calibrateHMM( mdUseData', cSettings );
    
    % Select model
    [cDiagnostics, iHMMused] = selectModel(i, cSettings, numel(mdUseData), cHMM, cDiagnostics);
    
    % Build tree
    cTree = buildTree(cHMM, iHMMused, cRiskfree, cSettings);
    
    % Optimize Tree
    [cTree, cDiagnostics] = optimTree(i, cTree, cSettings, cDiagnostics);
    
    % Diagnostics
    if cSettings.PlotDiagnostics
        cDiagnostics = runDiagnostics(i, cSettings, cDiagnostics, cData, mdDataSlice, cHMM, iHMMused, cTree);
    end
    
    % Backtesting
    cBacktest = initBacktest(i, cSettings, cBacktest, cTree, mdDataSlice(end,1) );
end

%% Perform Backtest
disp('Performing Backtest');
cBacktestResults = performBacktest( cSettings, cBacktest, cDiagnostics, mdRawData, cData, FreqTable);

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