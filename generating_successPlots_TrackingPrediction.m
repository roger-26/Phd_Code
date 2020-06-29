clc
clear all
close all
%generando success plots para tracking prediction
% cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_mpeg4_high'
DLSSV_Reuslts = load('DLSSVM_TrackingResults_Video1MP4.mat');
GT= load ('C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_pristine\groundtruth_rect.mat');
FRIQUEE_Tracking_Results = load ('DLSSVM_FRIQUEE_TrackingResults_Video1MP4.mat');

DLSSVM_Results = uint16(DLSSV_Reuslts.DLSSVM_TrackingResults_Video1MP4);
FRIQUEE_Results = uint16(FRIQUEE_Tracking_Results.DLSSVM_FRIQUEE_TrackingResults_Video1MP4);
GT = uint16(GT.groundtruthrect);
% [AUC,Success_rate] = success_plot(DLSSVM_TrackingResults_Video1MP4(1:505,:),groundtruthrect,'video1_pristine',0.01)
% hold on
% [AUC_FRIQUEE,Success_rate] = success_plot(DLSSVM_FRIQUEE_TrackingResults_Video1MP4(1:505,:),groundtruthrect,'video1_pristine',0.01)

%Gaussian proque tiene menos frames
[AUC,Success_rate] = success_plot(DLSSVM_Results,GT(),'video1_GaussianHigh',0.01)
hold on
[AUC_FRIQUEE,Success_rate] = success_plot(FRIQUEE_Results,GT(),'video1_pristine',0.01)
grid minor
legend('DLSSVM','DLSSVM with FRIQUEE');
