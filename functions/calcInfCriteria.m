function [ vdAICWeights, vdBICProb] = calcInfCriteria( vdLogLik, vdNoParams, iNobs )
%calcInfCriteria calculates AIC_c and BIC model weights
%   * calculates AIC_c and BIC model weights                   
%
%   Input:
%   vdLogLik    log-likelihood of each model in a vector
%   vdNoParams: number of parameters of each model in a vector
%   iNobs:      number of observations
%
%   Output:
%   vdAICWeights:   vector of AIC_c weights
%   vdBICProb:      vector of BIC posterior probabilities
%
% Additional info:  models with delta <=2 have substantial support, 4<= delta >= 7 considerably less support, >= 10 essentially no support 

%% use standard matlab formula as starting point for AIC & BIC
[aic, bic] = aicbic(vdLogLik, vdNoParams, iNobs);

% add AIC_c correction term
aic = aic + (2 .* vdNoParams .* (vdNoParams -1)) / (iNobs - vdNoParams - 1);

% to eliminate constant representing E_f[log(f(x))] calculate delta_i (cf. Burnham / Anderson 2004, p.271)
vdDeltaAIC = aic - min(aic);
vdDeltaBIC = bic - min(bic);

%% calculate AIC_c weights (p.272)
dNormSumAIC = sum(exp(-vdDeltaAIC/2));
vdAICWeights = exp(-vdDeltaAIC/2)/dNormSumAIC;

%% compute BIC posterior model probabilities (p. 275)
dNormSumBIC = sum(exp(-vdDeltaBIC/2));
vdBICProb = exp(-vdDeltaBIC/2)/dNormSumBIC;

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