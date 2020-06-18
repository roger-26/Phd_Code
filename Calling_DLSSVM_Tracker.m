%Ejecutando el tracker DLSSVM
tic
clear all
clc
close all
addpath(genpath('C:\Dropbox\Javeriana\current_work\tracker_prediction\'))
video_path ='C:\Dropbox\git\DSVD_test_Sequences\001Pri_IndPW_FQ_C4\'
init_rect = [1715 187 129 239];
disp_vd = true;
end_frame = 6;
cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction\DLSSVM_only_code\mex\compile'
results = tracker([video_path '\img'],'jpg',disp_vd,init_rect,1,end_frame,1);
toc