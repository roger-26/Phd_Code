%este script permite convertir los videos en formato .yuv a .AVI
%Roger Gomez Nieto - 20 de marzo de 2019
clear all
video_resolution=[1920 1080]
video_fps=30
name='0912_football_GS5_20150912_153941'
 numfrm = yuv2avi(strcat(name,'.yuv'),video_resolution,...
     strcat(name,'.avi'),'none',video_fps,'YUV420_8');
