function [ dImpliedGamma ] = calcImpliedGamma( vdMu, mdSigma, dH, dAlpha )
%calcImpliedGamma calculates implied risk aversion coefficient gamma
%                   
%   * calculates implied risk aversion coefficient gamma using fsolve
%
%   Input:
%   vdMu:           vector of asset expected return
%   mdSigma:        covariance matrix
%   dH:             investor required threshold return
%   dAlpha:         investor acceptable probability of failing to reach threshold return
%
%   Output:
%   dImpliedGamma:  double, implied risk aversion coefficient gamnma

%% Use fsolve to minimize costfunction
options = optimset('Display', 'off');
f = @(y) costfun(y, dH, vdMu,mdSigma,dAlpha);
dImpliedGamma = fsolve(f,2.5, options);

end


function ret = costfun(dGamma, dH, vdMu,mdSigma,dAlpha)
ret = dH - calcMAThreshold(vdMu,mdSigma,dAlpha,dGamma);
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