clc;
close all;
clear all;

%loading data from LIVE QUalcomm
data_LIVE_QUALCOMM= load('C:\Dropbox\Javeriana\current_work\LIVEVQC_TestVQA\data_LIVEQualcomm.mat');
MOS_LIVE_QUALCOMM= load('C:\Dropbox\Javeriana\current_work\LIVEVQC_TestVQA\MOS_LIVEQualcomm.mat');
TrainingData_AveragedFeaturesPerVideo = data_LIVE_QUALCOMM.TrainingData_AveragedFeaturesPerVideo;
TrainingMOS_AveragedFeaturesPerVideo = MOS_LIVE_QUALCOMM.TrainingMOS_AveragedFeaturesPerVideo;
%loading data from LIVEVQC dataset
data_LIVEVQC= load('C:\Dropbox\Javeriana\current_work\LIVEVQC_TestVQA\data_LIVEVQC.mat');
MOS_LIVEVQC= load('C:\Dropbox\Javeriana\current_work\LIVEVQC_TestVQA\MOS_LIVEVQC.mat');
data_LIVEVQC=data_LIVEVQC.LIVEVQC_Data_Averaged;
MOS_LIVEVQC = MOS_LIVEVQC.MOS_LIVE_VQC;
for i=1:1000
    tic
    %Training stage
    Mdl=fitrsvm(TrainingData_AveragedFeaturesPerVideo,TrainingMOS_AveragedFeaturesPerVideo,'Standardize',...
        false,...
        'OptimizeHyperparameters',...
        {'BoxConstraint', 'Epsilon', 'KernelFunction'},...
        'CacheSize','maximal',...
        'HyperparameterOptimizationOptions',struct('UseParallel',1,'MaxObjectiveEvaluations',10,...
        'ShowPlots',false));
    
    
    
    
    yfit_LIVE= predict(Mdl,data_LIVEVQC);
    R_LIVE = corrcoef(yfit_LIVE,MOS_LIVEVQC);
    
    yfit= predict(Mdl,TrainingData_AveragedFeaturesPerVideo);
    R = corrcoef(yfit,TrainingMOS_AveragedFeaturesPerVideo);
    
    Pearson(i)=R_LIVE(1,2)
    Spearman(i)=corr(yfit_LIVE,MOS_LIVEVQC,'Type','Spearman')
    fprintf('Iteration %d\n',i);
    max(Pearson)
    max(Spearman)
    toc
end