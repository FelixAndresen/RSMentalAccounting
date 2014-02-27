function [ vdWeights ] = calcMVWeights_Er( vdMu, mdSigma, dER )
%calcMVWeights_Er calculate MVPT weights using expected return
%                   
%   * solve MVPT problem for expected return using analytical solution
%
%   Input:
%   vdMu:       vector of asset expected return
%   mdSigma:    covariance matrix
%   dER:        double, expected return
%
%   Output:
%   vdWeights:  vector MVPT weights

%% use analytical solution
viOnes = ones(length(vdMu),1);
A = viOnes' * inv(mdSigma) * vdMu;
B = vdMu' * inv(mdSigma) * vdMu; 
C = viOnes' * inv(mdSigma) * viOnes;
D = B*C-A^2;
lambda = (C * dER - A)/D;
gamma = (B-A*dER)/D;

vdWeights = lambda * inv(mdSigma) * vdMu + gamma * inv(mdSigma) * viOnes;

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