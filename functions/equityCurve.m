function [ mdEquityCurve ] = equityCurve( mdReturns, iStartCol , DiscreteOrContinuous)
%equityCurve creates an equity curve 
%  
%   * DiscreteOrContinuous: 'Discrete' or 'Continuous'                     
%
%   Input:
%   mdReturns:              matrix of returns, 1. col -> date
%   iStartCol:              0 if 1.col -> date, 1 if no date is required to be returned
%   DiscreteOrContinuous:   string indicating type of retunr series
%
%   Output:
%   mdEquityCurve:          depends on iStartCol, matrix of equity curve

%% Settings
viDates = mdReturns(:,1);
mdSeries = mdReturns(:,iStartCol:end);

if (sum(mdSeries(1,:)) ~= 0) && (iStartCol==1)
    iNAssets = size(mdSeries,2);
    mdSeries = [zeros(1,iNAssets);mdSeries];
end

%% Calculate Equity Curve
if strcmp(DiscreteOrContinuous,'Discrete')
    mdResult = [cumprod(1+mdSeries)*100];
elseif strcmp(DiscreteOrContinuous,'Continuous')
    mdResult = [cumprod(exp(mdSeries))*100];    
else
    error('Setting not recognized')
end

%% Return Equity Curve
if iStartCol == 1
    mdEquityCurve = mdResult;
else
    mdEquityCurve = [viDates, mdResult];
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