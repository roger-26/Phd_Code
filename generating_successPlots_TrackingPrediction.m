clc
clear all
close all
%generando success plots para tracking prediction
% cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_mpeg4_high'

% GT= load ('C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_pristine\groundtruth_rect.mat');
% GT= load('groundtruth_rect_Gaussian.mat')

GT = load('0284Exp_IndWL_MQ_C3_gt.txt');
DLSSV_Reuslts = load('0284Exp_IndWL_MQ_C3_DLSSVM.mat');
FRIQUEE_Tracking_Results = load ('0284Exp_IndWL_MQ_C3_FRIQUEE560_Normalized.mat');

TLVQM_LC_Tracking_Results = load('0284Exp_IndWL_MQ_C3_LC_TLVQM.mat');
TLVQM_HC_Tracking_Results = load('0284Exp_IndWL_MQ_C3_HC_TLVQM.mat');
TLVQM_Tracking_Results = load('0284Exp_IndWL_MQ_C3_TLVQM.mat');
%%
DLSSVM_Results = uint16(DLSSV_Reuslts.tracker_results);
FRIQUEE_Results = uint16(FRIQUEE_Tracking_Results.tracker_results);

TLVQM_Results_LC   = uint16(TLVQM_LC_Tracking_Results.tracker_results);
TLVQM_Results_HC   = uint16(TLVQM_HC_Tracking_Results.tracker_results);
TLVQM_Results   = uint16(TLVQM_Tracking_Results.tracker_results);
%  GT = uint16(GT.groundtruthrect);
% GT= table2array(GT.groundtruthrectGaussian);%Esto es cuando el GT viene en formato de tabla
% [AUC,Success_rate] = success_plot(DLSSVM_TrackingResults_Video1MP4(1:505,:),groundtruthrect,'video1_pristine',0.01)
% hold on
% [AUC_FRIQUEE,Success_rate] = success_plot(DLSSVM_FRIQUEE_TrackingResults_Video1MP4(1:505,:),groundtruthrect,'video1_pristine',0.01)

%Gaussian proque tiene menos frames
[AUC,Success_rate] = success_plot(DLSSVM_Results,GT(),'video1_GaussianHigh',0.01,[0.9 0.6 0]);
% title(['Success plot of video 1 pristine, AUC= ',num2str(AUC)],'FontSize',24);
hold
[AUC_FRIQUEE,Success_rate] = ...
    success_plot(FRIQUEE_Results,GT(),'video1_pristine',0.01,[0.35 0.7 0.9]);

[AUC_TLVQM_LC,Success_rate] = ...
    success_plot(TLVQM_Results_LC,GT(),'video1_pristine',0.01,[0 0.6 0.5]);

[AUC_TLVQM_HC,Success_rate] = ...
    success_plot(TLVQM_Results_HC,GT(),'video1_pristine',0.01,[0.95 0.9 0.25]);

[AUC_TLVQM,Success_rate] = ...
    success_plot(TLVQM_Results,GT(),'video1_pristine',0.01,[0.8 0.6 0.7]);

str =  strcat('DLSSVM   = ' , num2str(AUC,4))
str2 = strcat('FRIQUEE  = ', num2str(AUC_FRIQUEE,4))
str3 = strcat('LC TLVQM= ', num2str(AUC_TLVQM_LC,4))
str4 = strcat('HC TLVQM= ', num2str(AUC_TLVQM_HC,4))
str5 = strcat('TLVQM      = ', num2str(AUC_TLVQM,4))
% plot your data
legend(str,str2,str3,str4,str5)

% legend('DLSSVM','DLSSVM with FRIQUEE features');
grid minor
