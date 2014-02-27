function [ vdWeights ] = calcMVWeights_y( vdMu, mdSigma, dGamma )
%calcMVWeights_y calculate MVPT weights using risk aversion coefficient
%                   
%   * solve MVPT problem for risk aversion coefficient using analytical solution
%
%   Input:
%   vdMu:       vector of asset expected return
%   mdSigma:    covariance matrix
%   dGamma:     double, implied risk aversion
%
%   Output:
%   vdWeights:  vector MVPT weights

viOnes = ones(length(vdMu),1);
vdWeights = (1/dGamma) * inv(mdSigma) * ( vdMu - ( viOnes' / mdSigma * vdMu - dGamma ) / (viOnes' / mdSigma * viOnes) * viOnes);
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