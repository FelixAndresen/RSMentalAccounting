function [ cTree, cDiagnostics ] = optimTree(iPeriod, cTree, cSettings, cDiagnostics )
%optimTree optimizes asset allocation with a scenario tree using MA & MVPT, easily expandable
%
%   * calculates optimal asset allocation using MA & MVPT
%
%   Input:
%   iPeriod:        number of rolling period that called the function
%   cTree:          structure of scenario tree
%   cSettings:      structure of settings, as specified in Runtime.m
%   cDiagnostics:   structure of diagnostic summary statistics  
%
%   Output:
%   cTree:          structure of scenario tree
%   cDiagnostics:   structure of diagnostic summary statistics 

%% Input
iSteps = length(cSettings.TimeVec); 
iStates = nthroot(length(cTree),iSteps);
iNAssets = length(cTree{1,1}.Distribution.Sigma);
cDiagnostics(iPeriod).ImplGamma(1:length(cSettings.Alpha)) = NaN(1,length(cSettings.Alpha));

%% Calculate Weights
for i= iSteps:-1:1
    for j=1:iStates^(i-1)
        % MVPT
        for k=1:length(cSettings.Gamma)        
            % Weights
            cTree{j,i}.Weights.MeanVariance(1:iNAssets,k) = calcMVWeights_y(cTree{j,i}.Distribution.Mu ,cTree{j,i}.Distribution.Sigma,cSettings.Gamma(k)); 
            % Expected Return
            cTree{j,i}.ExpectedReturn.MeanVariance(k) = cTree{j,i}.Weights.MeanVariance(1:iNAssets,k)' * cTree{j,i}.Distribution.Mu;
            % Standard Deviation
            cTree{j,i}.StdDev.MeanVariance(k) = cTree{j,i}.Weights.MeanVariance(1:iNAssets,k)' * cTree{j,i}.Distribution.Sigma * cTree{j,i}.Weights.MeanVariance(1:iNAssets,k);
        end
        % MA
        for k=1:length(cSettings.Alpha)
            % Calculate Implied Gammas for MA
            dImplGamma = calcImpliedGamma(cTree{j,i}.Distribution.Mu, cTree{j,i}.Distribution.Sigma, cSettings.H(k), cSettings.Alpha(k));
            if (i==1)
                cDiagnostics(iPeriod).ImplGamma(k) = dImplGamma;
            end
            % Weights
            cTree{j,i}.Weights.MentalAccounting(1:iNAssets,k) = calcMVWeights_y(cTree{j,i}.Distribution.Mu ,cTree{j,i}.Distribution.Sigma, dImplGamma); 
            % Expected Return
            cTree{j,i}.ExpectedReturn.MentalAccounting(k) = cTree{j,i}.Weights.MentalAccounting(1:iNAssets,k)' * cTree{j,i}.Distribution.Mu;
            % Standard Deviation
            cTree{j,i}.StdDev.MentalAccounting(k) = cTree{j,i}.Weights.MentalAccounting(1:iNAssets,k)' * cTree{j,i}.Distribution.Sigma * cTree{j,i}.Weights.MentalAccounting(1:iNAssets,k);
        end
    end
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