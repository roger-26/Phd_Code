clc;
close all;
clear all;

%con este c�digo entreno en la LIVE-VQC y pruebo con la misma base de datos. Usando un esquema de
%80-20.

Training_Percentage = 0.8;
Test_Percentaje = 0.2;
SVR_Iterations = 350;

%loading data from LIVEVQC dataset
% data_LIVEVQC= load('G:\datasets\LIVEVQCPrerelease\LIVE_VQC_YCbCr_8Frames_C3D_Features\data_LIVEVQC.mat');
% MOS_LIVEVQC= load('G:\datasets\LIVEVQCPrerelease\LIVE_VQC_YCbCr_8Frames_C3D_Features\MOS_LIVEVQC.mat');


% data_LIVEVQC= load('C:\Dropbox\Javeriana\current_work\LIVEVQC_TestVQA\data_LIVEVQC.mat');
% MOS_LIVEVQC= load('C:\Dropbox\Javeriana\current_work\LIVEVQC_TestVQA\MOS_LIVEVQC.mat');
% data_LIVEVQC=data_LIVEVQC.LIVEVQC_Data_Averaged;
% MOS_LIVEVQC = MOS_LIVEVQC.MOS_LIVE_VQC;

data_LIVEVQC = load('/home/javeriana/roger_gomez/Dropbox/Javeriana/current_work/LIVEVQC_TestVQA/data_LIVEVQC.mat');
MOS_LIVEVQC =  load('/home/javeriana/roger_gomez/Dropbox/Javeriana/current_work/LIVEVQC_TestVQA/MOS_LIVEVQC.mat');
data_LIVEVQC=data_LIVEVQC.LIVEVQC_Data_Averaged;
MOS_LIVEVQC = MOS_LIVEVQC.MOS_LIVE_VQC;

for i=1:1000
    tic
    [trainInd,valInd,testInd] = dividerand(585,Training_Percentage,0,Test_Percentaje); %Divido aleatoriamente el 80% de la base de datos
    %para entrenamiento
    
    Training_Data = data_LIVEVQC(trainInd,:);
    Training_MOS = MOS_LIVEVQC (trainInd);
    
    Test_Data = data_LIVEVQC(testInd,:);
    Test_MOS = MOS_LIVEVQC (testInd)';
    
    Mdl=fitrsvm(Training_Data,Training_MOS,'Standardize',...
        false,...
        'OptimizeHyperparameters',...
        {'BoxConstraint', 'Epsilon', 'KernelFunction'},...
        'CacheSize','maximal',...
        'HyperparameterOptimizationOptions',struct('UseParallel',1,'MaxObjectiveEvaluations',SVR_Iterations,...
        'ShowPlots',false));
    
    yfit_LIVE= predict(Mdl,Test_Data);
    R_LIVE = corrcoef(yfit_LIVE,Test_MOS);
    
    %probando con los mismos datos de entrenamiento, el resultado deberia ser cercano a 1
    yfit_SameTraining= predict(Mdl,Training_Data);
    R_SameTraining = corrcoef(yfit_SameTraining,Training_MOS)
    
    Pearson(i)=R_LIVE(1,2)
    Spearman(i)=corr(yfit_LIVE,Test_MOS','Type','Spearman')
    Kendall_COrrelation(i) = corr(yfit_LIVE,Test_MOS','type','Kendall');
    RMSE(i) = sqrt(mean((yfit_LIVE-Test_MOS').^2));
    fprintf('Iteration %d\n',i);
    max(Pearson)
    max(Spearman)
    max(Kendall_COrrelation)
    min(RMSE)
    toc
end


