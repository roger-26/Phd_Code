close all;
cd '/home/javeriana/roger_gomez/DSST2/DSST2'

%Con esta funcion se prueba el tracker especificando cada uno de los
%parametros de entrada. 

% BB = [625 666 65 11];
% video_in ='ants.avi';
% path_video = '/media/javeriana/TOSHIBA_2TB/Dataset/vot2017/ants3/imgs/';
% video_out = 'ants_tracking';
% path_mainFolder_Tracking = '/home/javeriana/roger_gomez/DSST2/DSST2/results/';


BB = [1715,187,129,238]
video_in ='001Pri_IndPW_FQ_C4.mp4';
path_video = '/home/javeriana/roger_gomez/DSST2/DSST2/Videos_Test/';
video_out = '1_result';
path_mainFolder_Tracking = '/home/javeriana/roger_gomez/DSST2/DSST2/results/';

 [Video_BB_Name]= tracker_dsst(BB,video_in,path_video,video_out,path_mainFolder_Tracking)


