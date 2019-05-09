%este script permite convertir los videos en formato .yuv a .AVI
%Roger Gomez Nieto - 20 de marzo de 2019

%Para dejar como AVI UNCOMPRESSED se debe modificar el archivo yuv2avi.mi line 41
clc;
clear all
video_resolution=[1920 1080];
video_fps=50;
name='4_DanceKiss_1080p50';
%Si se quiere mostrar la resoluciòn del video en el nombre del archivo
% resolution_2_show=strcat('_',num2str(video_resolution(1)),'x',num2str(video_resolution(2)));
% fps_2_show= strcat('_',num2str(video_fps));

resolution_2_show='';
fps_2_show ='';

name_AVI_Save=strcat(name,resolution_2_show,fps_2_show,'.avi')
numfrm =...
yuv2avi(strcat(name,'.yuv'),video_resolution,name_AVI_Save,'none',video_fps,'YUV420_8');