% Scipt implements and looks at all figures and formulas in the MA Paper
clear all;
close all;

vdMu = [0.05;0.1;0.25];
mdSigma = [0.0025,0.0,0.0;0.0, 0.04,0.02;0.0,0.02,0.25];
vdGamma = [3.795, 2.7063, 0.8773];
dAlpha = [0.05, 0.15, 0.2];
dH = [-0.1, -0.05, -0.15];

vdThresholds = [-0.25:0.05:0.25];

for i=1:length(vdGamma)
    cRes(i).WeightsMV = MVWeights_y(vdMu,mdSigma,vdGamma(i));
    cRes(i).ExpectedReturn = cRes(i).WeightsMV' * vdMu;
    cRes(i).StdDev = sqrt(cRes(i).WeightsMV' * mdSigma * cRes(i).WeightsMV);
    cRes(i).MAThresholds = calcMAThreshold( vdMu, mdSigma, dAlpha, vdGamma(i));
end


vdImpliedGammas = zeros(1,length(dH));
for i=1:length(dH)
    vdImpliedGammas(i) = calcImpliedGamma(vdMu, mdSigma,dH(i),dAlpha(i));
end

% Plot MVPT efficient frontier
h = plotMVPTEfficientFrontier(vdMu,mdSigma,[cRes.StdDev],[cRes.ExpectedReturn],{'Subportfolio 1', 'Subportfolio 2','Subportfolio 3'} );
saveas(h,'C:\Users\d90795\Documents\MasterThesis\Plots\Paper\MVPTEfficientFrontier','pdf');


% Plot MA efficient frontier
h=plotMAEfficientFrontier(vdMu,mdSigma,[-0.1 , 0],[0.05:0.01:0.3]);
saveas(gcf,'C:\Users\d90795\Documents\MasterThesis\Plots\Paper\MAEfficientFrontier','pdf');

    
