%Ejecutando el tracker DLSSVM
% clear all
clear all
profile on
tStart = tic;
clc
close all
warning('off','all')

%Estas son las rutas que necesita FRIQUEE para funcionar
addpath(genpath('C:\Dropbox\Javeriana\current_work\tracker_prediction\'))
addpath('C:\Dropbox\git\matlabPyrTools\MEX\');
addpath('include/');
addpath('include/C_DIIVINE');
addpath('src/');
addpath('data');


% video_path ='C:\Dropbox\git\DSVD_test_Sequences\001Pri_IndPW_FQ_C4\'
% init_rect = [1715 187 129 239];

% video_path =...
%     'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_blur_high\'
% init_rect = [1476 207 178 520];
% init_rect = [995 141 132 311]
init_rect = [1297 156 78 266]

% video_path= 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_SP_high\'
video_path = ...
    'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0284Exp_IndWL_MQ_C3\';



disp_vd = true;%show image with bounding box
end_frame = 346;  %number of frames to process
prep=0; %Esto cambia el espacio de color si se coloca en 1

cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction\DLSSVM_only_code\mex\compile'


%  results = tracker_FRIQUEE([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);
% results = tracker([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);

% results = ...
%     tracker_TLVQM_Features_LC([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);
% results = ...
%     tracker_TLVQM_Features_HC([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);
results = ...
    tracker_TLVQM_Features([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);
%TLVQM have the combined features

tracker_results = results.res;
save(...
    'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0284Exp_IndWL_MQ_C3\0284Exp_IndWL_MQ_C3_TLVQM.mat'...
    ,'tracker_results')


tEnd = toc (tStart)
profile viewer