function [ vdMu, mdCovMat ] = mixDistributions(vdWeights, mdMu, arrCovMat )
% mixDistributions 
%
%   * mixes distributions according to weights
%
%   Input:
%   vdWeights:  column-vector of weights
%   mdMus:      matrix of mus (assets in columns, states in columns)
%   arrCovMat:  array of covariance matrices (assets in rows and columns, states in 3d dimension)
%
%   Output:
%   vdMu:       vector of mixed means of distribution
%   mdCovMat:   mixed covariance matrix

%% Settings
[iNAssets,~,iNStates ] = size(arrCovMat);
mdCovMat = NaN(iNAssets,iNAssets);
iNoCombinations = (iNStates^2-iNStates)/2;

%% Calculate Means
vdMu = mdMu * vdWeights;
 
%% Calulate Covariance Matrix
for i = 1 : iNAssets
   for j = 1 :iNAssets
       mdCovMat(i,j) =  vdWeights.^2' * squeeze(arrCovMat(i,j,:)) ; % Initialise with squared weight times Cov across all states
       state1 = 1;
       state2 = 2;
       for k =1 : iNoCombinations
           crossterm = mdMu(i,state1) * mdMu(j,state1) + mdMu(i,state2) * mdMu(j,state2) + arrCovMat(i,j,state1) + arrCovMat(i,j,state2) - mdMu(i,state1) * mdMu(j,state2) - mdMu(i,state2) * mdMu(j,state1);
           mdCovMat(i,j) = mdCovMat(i,j) + vdWeights(state1) * vdWeights(state2) * crossterm;
           % Reset States
           if state2 + 1 > iNStates
               state1 = state1 + 1;
               state2 = state1 + 1;
           else
               state2 = state2 + 1;
           end
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