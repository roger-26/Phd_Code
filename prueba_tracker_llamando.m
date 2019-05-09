clc;
clear all;
path_video= '/home/javeriana/www/html/vas/temp/Human4.mp4';
BB=[99,237,27,82];
path_mainFolder_Tracking='/home/javeriana/www/html/vas/trcout/0123.mp4';

[path_video_output]= tracker_dsst(BB,path_video,path_mainFolder_Tracking)