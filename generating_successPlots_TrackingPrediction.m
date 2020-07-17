clc
clear all
close all
%generando success plots para tracking prediction
% cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_mpeg4_high'

% GT= load ('C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_pristine\groundtruth_rect.mat');
GT= load('groundtruth_rect_Gaussian.mat')

DLSSV_Reuslts = load('DLSSVM_TrackingResults_Video1_GaussianHigh.mat');
FRIQUEE_Tracking_Results = load ('video1_GaussianHigh_DLSSVM_FRIQUEE16.mat');
%%
DLSSVM_Results = uint16(DLSSV_Reuslts.DLSSVM_TrackingResults_Video1_GaussianHigh);
FRIQUEE_Results = uint16(FRIQUEE_Tracking_Results.tracker_results);
%  GT = uint16(GT.groundtruthrect);
GT= table2array(GT.groundtruthrectGaussian);%Esto es cuando el GT viene en formato de tabla
% [AUC,Success_rate] = success_plot(DLSSVM_TrackingResults_Video1MP4(1:505,:),groundtruthrect,'video1_pristine',0.01)
% hold on
% [AUC_FRIQUEE,Success_rate] = success_plot(DLSSVM_FRIQUEE_TrackingResults_Video1MP4(1:505,:),groundtruthrect,'video1_pristine',0.01)

%Gaussian proque tiene menos frames
[AUC,Success_rate] = success_plot(DLSSVM_Results,GT(),'video1_GaussianHigh',0.01,'r');
% title(['Success plot of video 1 pristine, AUC= ',num2str(AUC)],'FontSize',24);
hold on
[AUC_FRIQUEE,Success_rate] = success_plot(FRIQUEE_Results,GT(),'video1_pristine',0.01,'b');
grid minor
legend('DLSSVM','DLSSVM with 16 FRIQUEE features');
