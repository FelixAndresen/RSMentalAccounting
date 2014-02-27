function [ cBacktest] = initBacktest(iPeriod, cSettings, cBacktest, cTree, iDate)
%initBacktest fills cBacktest structure with asset allocation
%
%   * fills cBacktest structure with asset allocation, expected Return and Std. Dev
%
%   Input:
%   iPeriod:    number of rolling period that called the function
%   cSettings:  structure of settings, as specified in Runtime.m
%   cBacktest:  structure containing backtest statistics  
%   cTree:      structure of scenario tree, as returned from buildTree
%   iDate:      date of the current backtest period end
%
%   Output:
%   cBacktest:  structure containing backtest statistics

iNAssets = length(cTree{1,1}.Distribution.Sigma);
cBacktest(iPeriod).Date = iDate;

for k=1:length(cSettings.Gamma)
    % Weights
    cBacktest(iPeriod).Weights.MeanVariance(1:iNAssets,k) = cTree{1,1}.Weights.MeanVariance(1:iNAssets,k);
    cBacktest(iPeriod).Weights.MentalAccounting(1:iNAssets,k) = cTree{1,1}.Weights.MentalAccounting(1:iNAssets,k);
    % Expected Return
    cBacktest(iPeriod).ExpectedReturn.MeanVariance(k) = cTree{1,1}.ExpectedReturn.MeanVariance(k);
    cBacktest(iPeriod).ExpectedReturn.MentalAccounting(k) = cTree{1,1}.ExpectedReturn.MentalAccounting(k);
    % Standard Deviation
    cBacktest(iPeriod).StdDev.MeanVariance(k) = cTree{1,1}.StdDev.MeanVariance(k);
    cBacktest(iPeriod).StdDev.MentalAccounting(k) = cTree{1,1}.StdDev.MentalAccounting(k);
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