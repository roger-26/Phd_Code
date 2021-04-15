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

% video_path= 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_SP_high\'
% video_path = 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0274Pri_IndWL_C1\';



%init_rect = [1476 207 178 520]  video1 full poscapture distortion
% init_rect = [1231 150 126 355]

 %%
% video_path = 'C:\surveillanceVideos_Frames\0100Fo_IndPW_LQ_C2'
% end_frame = 345;  %number of frames to process
% init_rect=[1315,87,1448,331];

%% Video Pristino
video_path = 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0274Pri_IndWL_C1'
end_frame = 451;  %number of frames to process
init_rect=[1231 150 126 355];
%% 


disp_vd = 1;%show image with bounding box
prep=0; %Esto cambia el espacio de color si se coloca en 1
% end_frame = 451;  %number of frames to process
cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction\DLSSVM_only_code\mex\compile'


% results = tracker_FRIQUEE([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);
% results = tracker([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);

% results = ...
%     tracker_TLVQM_Features_LC([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);


% [result] = ...
%     tracker_TLVQM_Features_PCA_Input([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);

[result] = ...
    DLSSV_TLVQMPatches_PCA_LOG10Frames([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);


tracker_results = results.res;
save(...
    'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0274Pri_IndWL_C1\0274Pri_IndWL_C1_DLSSVM_FRIQUEE560.mat'...
    ,'tracker_results')

tEnd = toc (tStart)
profile viewer