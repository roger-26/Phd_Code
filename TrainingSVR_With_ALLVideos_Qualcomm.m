clc
close all;
clear all;

%This code train the SVR for VQA assessment using all videos from dataset.
%Author: Roger Gomez Nieto    August 28 2019


addpath('C:\Dropbox\Ubuntu\Features_fc6_Avance8Frames_YCbCr\Features_Per_Distortion_1Matrix_DataMOS');

cd 'C:\Dropbox\Ubuntu\Features_fc6_Avance8Frames_YCbCr\Features_Per_Distortion_1Matrix_DataMOS'


%Obteniendo los conjuntos de training and test for all distortions.
commonName_DataMat='DATA_fc6_Overlap8_YCbCr_';
commonName_MOSMat = 'MOS_fc6_Overlap8_YCbCr_';

%Stabilization
dataFile= strcat(commonName_DataMat,'Stabilization.mat');
MOS_File =       strcat(commonName_MOSMat,'Stabilization.mat');


aux1=load(dataFile);
aux3=load(MOS_File);

Distortion_data=aux1.data;
Distortion_MOS= aux3.MOS_fc6;

Training_Data_Stabilization_Averaged= squeeze(mean(Distortion_data,2));

TrainingData_AveragedFeaturesPerVideo = Training_Data_Stabilization_Averaged;
TrainingMOS_AveragedFeaturesPerVideo = Distortion_MOS;

% Focus

dataFile= strcat(commonName_DataMat,'Focus.mat');
MOS_File =       strcat(commonName_MOSMat,'Focus.mat');
aux1=load(dataFile);
aux3=load(MOS_File);
Focus_data=aux1.data;
Focus_MOS= aux3.MOS_fc6;
Training_Data_Focus_Averaged= squeeze(mean(Focus_data,2));
TrainingData_AveragedFeaturesPerVideo =...
    [TrainingData_AveragedFeaturesPerVideo;Training_Data_Focus_Averaged];
TrainingMOS_AveragedFeaturesPerVideo =...
    [TrainingMOS_AveragedFeaturesPerVideo,Focus_MOS];

%sharpness
dataFile= strcat(commonName_DataMat,'Sharpness.mat');
MOS_File =       strcat(commonName_MOSMat,'Sharpness.mat');
aux1=load(dataFile);
aux3=load(MOS_File);
Distortion_data=aux1.data;
Distortion_MOS= aux3.MOS_fc6;
Training_Data_Distortion_Averaged= squeeze(mean(Distortion_data,2));
TrainingData_AveragedFeaturesPerVideo =...
    [TrainingData_AveragedFeaturesPerVideo;Training_Data_Distortion_Averaged];
TrainingMOS_AveragedFeaturesPerVideo =...
    [TrainingMOS_AveragedFeaturesPerVideo,Distortion_MOS];

%Artifacts
dataFile= strcat(commonName_DataMat,'Artifacts.mat');
MOS_File =       strcat(commonName_MOSMat,'Artifacts.mat');
aux1=load(dataFile);
aux3=load(MOS_File);
Distortion_data=aux1.data;
Distortion_MOS= aux3.MOS_fc6;
Training_Data_Distortion_Averaged= squeeze(mean(Distortion_data,2));
TrainingData_AveragedFeaturesPerVideo =...
    [TrainingData_AveragedFeaturesPerVideo;Training_Data_Distortion_Averaged];
TrainingMOS_AveragedFeaturesPerVideo =...
    [TrainingMOS_AveragedFeaturesPerVideo,Distortion_MOS];

%Exposure
dataFile= strcat(commonName_DataMat,'Exposure.mat');
MOS_File =       strcat(commonName_MOSMat,'Exposure.mat');
aux1=load(dataFile);
aux3=load(MOS_File);
Distortion_data=aux1.data;
Distortion_MOS= aux3.MOS_fc6;
Training_Data_Distortion_Averaged= squeeze(mean(Distortion_data,2));
TrainingData_AveragedFeaturesPerVideo =...
    [TrainingData_AveragedFeaturesPerVideo;Training_Data_Distortion_Averaged];
TrainingMOS_AveragedFeaturesPerVideo =...
    [TrainingMOS_AveragedFeaturesPerVideo,Distortion_MOS];

%Color
dataFile= strcat(commonName_DataMat,'Color.mat');
MOS_File =       strcat(commonName_MOSMat,'Color.mat');
aux1=load(dataFile);
aux3=load(MOS_File);
Distortion_data=aux1.data;
Distortion_MOS= aux3.MOS_fc6;
Training_Data_Distortion_Averaged= squeeze(mean(Distortion_data,2));
TrainingData_AveragedFeaturesPerVideo =...
    [TrainingData_AveragedFeaturesPerVideo;Training_Data_Distortion_Averaged];
TrainingMOS_AveragedFeaturesPerVideo =...
    [TrainingMOS_AveragedFeaturesPerVideo,Distortion_MOS];

%loading data from LIVEVQC dataset
data_LIVEVQC= load('G:\datasets\LIVEVQCPrerelease\LIVE_VQC_YCbCr_8Frames_C3D_Features\data_LIVEVQC.mat');
MOS_LIVEVQC= load('G:\datasets\LIVEVQCPrerelease\LIVE_VQC_YCbCr_8Frames_C3D_Features\MOS_LIVEVQC.mat');
data_LIVEVQC=data_LIVEVQC.LIVEVQC_Data_Averaged;
MOS_LIVEVQC = MOS_LIVEVQC.MOS_LIVE_VQC;
for i=1:1000
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
end