function [cData,mdRawData, cDiagnostics, cSettings] = dataImport(cSettings)
%dataImport imports data from Yahoo Finance & St.Louis Fred
%
%   * load stock / index data from Yahoo Finance
%   * get ON Libor and FX Rate from St.Louis Fred
%
%   Input:
%   cSettings:      structure of settings, as specified in Runtime.m
%
%   Output:
%   mdRawData:      matrix of raw data (first col. dates, all others returns)
%   cData:          structure of data, as returned by dataImport
%   cDiagnostics:   structure of diagnostic summary statistics
%   cSettings:      structure of settings, as specified in Runtime.m

%% Set folder
if exist(strcat(pwd,'\data\'),'dir')
else
    mkdir(strcat(pwd,'\data\'));
end

%% Load data
if (cSettings.ReloadData==0)
    %% Load saved data
    load(strcat(pwd,'\data\dat.mat'),'cData','mdRawData','cDiagnostics')
    cSettings.Securities = strrep(cSettings.Securities,'^','');
else
    %% Get Data from Sources
    iNStocks = length(cSettings.Securities);
    h = waitbar(0,'Downloading Data ...'); 
    
    % Download Currency Data
    fredConn = fred;
    waitbar(1/(iNStocks+3), h, ['Loading EUR/USD from St. Louis Federal Reserve'])
    cEURUSD = fetch(fredConn,'DEXUSEU',cSettings.DataStart,cSettings.DataEnd);
    %c3MLibor =  fetch(fredConn,'EUR3MTD156N',cSettings.DataStart,cSettings.DataEnd);
    cONLibor =  fetch(fredConn,'EURONTD156N',cSettings.DataStart,cSettings.DataEnd);
    dsONLibor = mat2dataset(cONLibor.Data,'VarNames',{'Date','ONLibor'}); % daily data in % 
    dsData = mat2dataset(cEURUSD.Data,'VarNames',{'Date','EURUSD'}); % daily data
    dsData = join(dsData,dsONLibor,'Keys','Date','Type','outer','MergeKeys',true);
    close(fredConn);
    
    % Download Adjusted Close Stock Data
    yahooConn = yahoo;
    for i=1 : iNStocks
        waitbar((1+i)/(iNStocks+3), h, [strcat('Loading ', cSettings.Securities{1,i},' from Yahoo Finance')])
        dsCurr = mat2dataset(fetch(yahooConn,cSettings.Securities{1,i},'Adj Close',cSettings.DataStart,cSettings.DataEnd,'d'),'VarNames',{'Date',cSettings.Securities{1,i}});
        dsData = join(dsData,dsCurr,'Keys','Date','Type','outer','MergeKeys',true);
    end
    close(yahooConn)
    close(h)
    
    % Adjust S&P 500 for FX-rate
    dsData.x_GSPC = dsData.x_GSPC ./ dsData.EURUSD;
    
    % Convert ON Libor to right unit
    dsData.ONLibor = dsData.ONLibor/100;
       
    % Remove FX-rates
    dsData.EURUSD = [];
    
    % Convert to specified period
    ftsData = fints(double(dsData(:,1)), double(dsData(:,3:end)));
    ftsInterestRate = fints(double(dsData(:,1)),double(dsData(:,2)),'LIBOR');
    ftsData =  convertto(ftsData,cSettings.Frequency,'CalcMethod','Exact');
    ftsInterestRate = convertto(ftsInterestRate, cSettings.Frequency,'CalcMethod','Exact');
    ftsData = merge(ftsInterestRate, tick2ret(ftsData,'Method',cSettings.ReturnMethod));

    % Remove missing data
    mdRawData = fts2mat(ftsData,1);
    ix = isnan(mdRawData);
    cDiagnostics.ImportStats.NMissing = sum(ix(:,2:end));
    cDiagnostics.ImportStats.NObs = length(ix);
    cDiagnostics.ImportStats.MissingPercent = cDiagnostics.ImportStats.NMissing/cDiagnostics.ImportStats.NObs;
    mdRawData = mdRawData(~any(ix,2),:);

    % Put into cData - struct
    h = waitbar(0,'Processing Stocks...'); 
    cData(1).Asset = 'ON Libor';
    cData(1).Dates = mdRawData(:,1);
    cData(1).Returns = mdRawData(:,2);
    cData(1).EquityCurve = [1; (1+cumsum(cData(1).Returns(2:end)/360))]*100;
    for i = 1 : iNStocks
        cData(i+1).Asset = strrep(cSettings.Securities{i},'^','');
        waitbar(i/iNStocks, h, ['Processing ' cData(i+1).Asset])
        cData(i+1).Dates = mdRawData(:,1);
        cData(i+1).Returns = mdRawData(:,i+2);
        cData(i+1).EquityCurve = equityCurve([0; (cData(i+1).Returns(2:end))],1,'Continuous');
    end
    close(h)
    % Save Data
    save(strcat(pwd,'\data\dat.mat'),'cData','mdRawData','cDiagnostics')
    cSettings.Securities = strrep(cSettings.Securities,'^','');
    
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
