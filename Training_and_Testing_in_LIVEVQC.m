clc;
close all;
clear all;

%con este código entreno en la LIVE-VQC y pruebo con la misma base de datos. Usando un esquema de
%80-20. 

%loading data from LIVEVQC dataset
data_LIVEVQC= load('G:\datasets\LIVEVQCPrerelease\LIVE_VQC_YCbCr_8Frames_C3D_Features\data_LIVEVQC.mat');
MOS_LIVEVQC= load('G:\datasets\LIVEVQCPrerelease\LIVE_VQC_YCbCr_8Frames_C3D_Features\MOS_LIVEVQC.mat');
data_LIVEVQC=data_LIVEVQC.LIVEVQC_Data_Averaged;
MOS_LIVEVQC = MOS_LIVEVQC.MOS_LIVE_VQC;





