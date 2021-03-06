clc
clear all
close all
%generando success plots para tracking prediction
% cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_mpeg4_high'

% GT= load ('C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_pristine\groundtruth_rect.mat');
% GT= load('groundtruth_rect_Gaussian.mat')

GT = load('0322Fo_IndWL_LQ_C1_gt.txt');

DLSSV_Reuslts = load('0322Fo_IndWL_LQ_C1_DLSSVM.mat');
FRIQUEE_Tracking_Results = load ('0322Fo_IndWL_LQ_C1_DLSSVM_FRIQUEE560_Normalized.mat');
%%
DLSSVM_Results = uint16(DLSSV_Reuslts.tracker_results);
FRIQUEE_Results = uint16(FRIQUEE_Tracking_Results.tracker_results);
%  GT = uint16(GT.groundtruthrect);

% GT= table2array(GT.groundtruthrectGaussian);%Esto es cuando el GT viene en formato de tabla

% [AUC,Success_rate] = success_plot(DLSSVM_TrackingResults_Video1MP4(1:505,:),groundtruthrect,'video1_pristine',0.01)
% hold on
% [AUC_FRIQUEE,Success_rate] = success_plot(DLSSVM_FRIQUEE_TrackingResults_Video1MP4(1:505,:),groundtruthrect,'video1_pristine',0.01)

%Gaussian proque tiene menos frames
[AUC,Success_rate] = success_plot(DLSSVM_Results,GT(),'video1_GaussianHigh',0.01,'r');
% title(['Success plot of video 1 pristine, AUC= ',num2str(AUC)],'FontSize',24);
hold on
[AUC_FRIQUEE,Success_rate] = success_plot(FRIQUEE_Results,GT(),'video1_pristine',0.01,'b');
grid minor
title('Video with severe Focus distortion');
legend('DLSSVM','DLSSVM with 560 normalized FRIQUEE features');
