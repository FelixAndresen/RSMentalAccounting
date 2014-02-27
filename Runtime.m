% Runtime 

clear all;
close all;
clc;

% --------------------------------------------------------------------
% Settings
% --------------------------------------------------------------------
cSettings.ReloadData = true;
cSettings.Securities = {'^GDAXI', '^GSPC'}; 
cSettings.DataStart = '01-Jan-2000';
cSettings.DataEnd = '01-Jan-2014'; %datestr(now,'dd-mmm-yyyy');
cSettings.Frequency = 'm'; %w,m,q,s,a
cSettings.RollingPeriod = 12; % in Frequency!
cSettings.ReturnMethod = 'Continuous'; %'Simple' (do not use)
cSettings.TimeVec = [0, 1]; % in Frequency! + include 0
cSettings.Gamma = [3.795, 2.7063, 0.8773]; 
cSettings.Alpha = [0.05, 0.15, 0.2]; % Length has to be same as H 
cSettings.H = [-0.1, -0.05, -0.15];
cSettings.NoStates = [2,3,4,5];
cSettings.HMMInitType = 'kmeans';  %'random'
cSettings.HMMCovType = 'full'; % 'diag' , 'spherical'
cSettings.NoMixingComponents = 1;
cSettings.HMMItersMax = 50;
cSettings.ModelSelCriteria = 'AIC'; % 'BIC'
cSettings.PlotDiagnostics = false;
cSettings.TableFolder = 'C:\Users\d90795\Documents\MasterThesis\Tables\';
cSettings.PlotFolder = 'C:\Users\d90795\Documents\MasterThesis\Plots\';

% --------------------------------------------------------------------
cTimeVecs = {[0,1],[0,3], [0,6], [0,12]};
cFrequency = {'M','Q','S','A'};
viRollingPeriods = [12, 18, 24, 30];
% --------------------------------------------------------------------


%% Import Data
[cData,mdRawData, cImportDiagnostics, cSettings] = dataImport(cSettings);

%% Hypotheses Testing
cResults = cell(length(cTimeVecs),length(viRollingPeriods));
miNPeriods = NaN(length(cTimeVecs),length(viRollingPeriods));

sTableFolderBasePath = cSettings.TableFolder;
sPlotFolderBasePath = cSettings.PlotFolder;

for i=1:length(cTimeVecs) % dt
    cSettings.TimeVec = cTimeVecs{i};
    for j=1:length(viRollingPeriods) % Rolling Period
        cSettings.RollingPeriod = viRollingPeriods(j);
        disp(horzcat('Testing ',cFrequency{i},num2str(cSettings.RollingPeriod)));
        
        % create and delete folder
        sTableFolder = strcat(sTableFolderBasePath,cFrequency{i},num2str(cSettings.RollingPeriod));
        sPlotFolder = strcat(sPlotFolderBasePath,cFrequency{i},num2str(cSettings.RollingPeriod));
        if exist(sTableFolder,'dir')
            rmdir(sTableFolder,'s');
            mkdir(sTableFolder);
        else
            mkdir(sTableFolder);
        end
        cSettings.TableFolder = strcat(sTableFolder);
        if exist(sPlotFolder,'dir')
            rmdir(sPlotFolder,'s');
            mkdir(sPlotFolder);
        else
            mkdir(sPlotFolder);
        end
        cSettings.PlotFolder = strcat(sPlotFolder);
        
        % start testing of models
        iModelNotTested = true;
        iCounter = 1;
        while(iModelNotTested&&(iCounter<=10))
            try
                pause(1);
                [cResults{i,j}.cBacktestResults, cResults{i,j}.cDiagnostics, miNPeriods(i,j)] = testModel(cData, mdRawData, cSettings , cImportDiagnostics);
                pause(1);
                iModelNotTested = false;
            catch
                warning('Model testing failed. Retry ...')
                iCounter = iCounter+1;
            end
        end
        if(iModelNotTested)
            warning('Model testing failed failed!!!')
        end
    end
end

%% Calibrate HMMs to all data
disp('Testing All');
cSettings.TimeVec = [0,3];
cSettings.RollingPeriod = length(mdRawData);
cSettings.PlotDiagnostics = true;
cSettings.TableFolder = 'C:\Users\d90795\Documents\MasterThesis\Tables\All\';
cSettings.PlotFolder = 'C:\Users\d90795\Documents\MasterThesis\Plots\All\';
if exist(cSettings.TableFolder,'dir')
    rmdir(cSettings.TableFolder,'s');
    mkdir(cSettings.TableFolder);
else
    mkdir(cSettings.TableFolder);
end
if exist(cSettings.PlotFolder,'dir')
    rmdir(cSettings.PlotFolder,'s');
    mkdir(cSettings.PlotFolder);
else
    mkdir(cSettings.PlotFolder);
end
[cBacktestResultsAll, cDiagnosticsAll ] = testModel(cData, mdRawData, cSettings , cImportDiagnostics);

%% Save & Load
save(strcat(pwd,'\data\resultsAll.mat'),'cBacktestResultsAll','cDiagnosticsAll');
load (strcat(pwd,'\data\resultsAll.mat'),'cBacktestResultsAll','cDiagnosticsAll');
save(strcat(pwd,'\data\results.mat'),'cResults','cFrequency','viRollingPeriods','miNPeriods');
load (strcat(pwd,'\data\results.mat'), 'cResults','cFrequency','viRollingPeriods','miNPeriods');

%% Create Results
disp('Creating Results');
cSettings.TableFolder = 'C:\Users\d90795\Documents\MasterThesis\Tables\Results';
cSettings.PlotFolder = 'C:\Users\d90795\Documents\MasterThesis\Plots\Results';
if exist(cSettings.TableFolder,'dir')
    rmdir(cSettings.TableFolder,'s');
    mkdir(cSettings.TableFolder);
else
    mkdir(cSettings.TableFolder);
end
if exist(cSettings.PlotFolder,'dir')
    rmdir(cSettings.PlotFolder,'s');
    mkdir(cSettings.PlotFolder);
else
    mkdir(cSettings.PlotFolder);
end
[ adMu, adSigma, adDD, adVaR] = analyzePerformance( cSettings, cResults, cFrequency, viRollingPeriods, miNPeriods );
