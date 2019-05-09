%Este script permite convertir archivos que esten en mp4 a -AVI con un número determinado de bitrate
%and FPS

clc;
Video_Name= ' 041Pri_OutRK_FQ_C';
bitrate=' 5M';
%para que la frame rate se configure en 10 -r 10
execute_string= strcat('ffmpeg -i ',Video_Name,'1.mp4 -r 10 -b:v ',bitrate,' ', Video_Name,'1.avi')
execute_string2= strcat('ffmpeg -i ',Video_Name,'2.mp4 -r 10 -b:v ',bitrate,' ', Video_Name,'2.avi')
execute_string3= strcat('ffmpeg -i ',Video_Name,'3.mp4 -r 10 -b:v ',bitrate,' ', Video_Name,'3.avi')
execute_string4= strcat('ffmpeg -i ',Video_Name,'4.mp4 -r 10 -b:v ',bitrate,' ', Video_Name,'4.avi')
system(execute_string)
system(execute_string2)
system(execute_string3)
system(execute_string4)


%% Para convertir video a escala de grises





