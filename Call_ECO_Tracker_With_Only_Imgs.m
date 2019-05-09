clc;
close all;
clear all;
%esta función ejecuta el ECO tracker en un conjunto de imagenes.
%El Ground truth debe estar en formatio xinitial yinitial width height
%se debe cambiar la función load_video_info segun el número de letras que
%contenga el nombre. Al final escribe un txt con los resultados. 

path='/home/javeriana/roger_gomez/ECO-master/sequences/car_otb50'

setup_paths();
video_path =path;
%se tuvo que cambiar el nombre a la funcion load_video_info porque el
%tracker DSST tiene una que se llama igual
[seq, ground_truth] = load_video_info_ECO(video_path);

% Run ECO
results = testing_ECO_gpu(seq);

New_GT    = ...
        strcat(path,'/results.txt');
    fileID = fopen(New_GT,'w');
    dlmwrite(New_GT,results.res,'delimiter',',');