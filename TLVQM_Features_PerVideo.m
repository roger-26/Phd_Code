function [features,video_proccessed] = TLVQM_Features_PerVideo(Path_save_YUV, Path_Video)
%****************************************************************************************
%Author: Roger Gomez Nieto
%Esta función calcula las 75 TLVQM features de un video. Primero lo
%convierte a formato YUV y lo guarda en Path_save_YUV.

%Path_Video--> La ruta completa al video, incluyendo la extensión.
%Path_save_YUV--> La ruta a la carpeta donde se almacenara el video YUV al
%que se convierte para calcular las TLVQM features.
%features--> Un vector con 75 componentes que contiene las TLVQM features
%para el video procesado
%***************************************************************************************
tstart= tic;
[filepath,video_proccessed,ext] =fileparts(Path_Video);
video  = VideoReader(Path_Video);
frates     = get(video, 'FrameRate');%obteniendo la resolucion el FPS
width_video = get(video,  'Width');
height_video = get(video,'Height');

reso = [width_video height_video];%esta es la resolución de AD-VSD
text1 = ['converting video: ', video_proccessed,' to YUV format'];
disp(text1);
folder_2_save_YUV = Path_save_YUV;%folder donde se guardan los videos YUV generados

[path_video] = video_rgb2yuv(Path_Video,folder_2_save_YUV);
features= compute_nrvqa_features(strcat(path_video,'.avi'), reso, frates);
time2 = toc(tstart);
disp(['the video ' video_proccessed,' took ', num2str(time2),' seconds']);
end
