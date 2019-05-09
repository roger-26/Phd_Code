clc
close all
clear all
%No olvidar colocar al final el /
%Esta función se usa para llamar la función que ejecuta el tracker dsst
%pasandole el BB, la ruta absoluta del video y una ruta donde debe guardar
%todos los archivos de resultados
%Autor: Roger Gomez Nieto  Date: 28-08-2018
%% EJECUTANDO EL TRACKER
video_path=...
    '/home/javeriana/roger_gomez/Dropbox/Javeriana/Courses/DSP/Set_Roger/020ExFo_IndPW_FQ_C3.avi';
[folder_video,name_video,ext_video] = fileparts(video_path)
path_mainFolder_Tracking=...
    '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/020ExFo_IndPW_FQ_C3'
ground_truth_path=...
    '/home/javeriana/roger_gomez/Dropbox/Javeriana/Courses/DSP/Set_Roger/020ExFo_IndPW_FQ_C3.txt';

path_save_results=strcat(path_mainFolder_Tracking,name_video);
mkdir(path_save_results);
BB=[1727,214,61,220]

tracker_dsst(BB,video_path, path_save_results)

%% CONFIGURANDO LAS RUTAS PARA LOS ARCHIVOS DE RESULTADOS Y GT
%cargando los resultados del tracker
failures=0;
path_positions=strcat(path_save_results,'/',name_video,'_results.txt');
delimiterIn = ',';
positions = importdata(path_positions,delimiterIn);

%cargando el ground truth original, con todos los datos
ground_truth = importdata(ground_truth_path,delimiterIn);

%% CALCULANDO SI HAY FALLOS TOTALES
distance_precision_threshold = 20;
%distance_precision es el porcentaje de frames donde la distance entre BB
%es menor al precision_threshold
[distance_precision, average_center_location_error, overlaps] = ...
    tracking_performance_measures(positions, ground_truth, distance_precision_threshold);
first_zero=find(overlaps==0,1)
%Encontrando donde drafts the tracker
while (first_zero ~= 0)
    first_zero=0
    failures=failures+1
    
    %definir el nombre del video
    
    %add 5 frames to restart the tracker
    New_start = first_zero+5
    path_video_saved=...
        Generate_New_Video(New_start,0, video_path, failures,path_save_results)
    BB_new = ground_truth (New_start,:)
    path_save_results_failure = strcat(path_save_results,'/',failures)
    %Se debe cambiar la carpeta de las imgs
    tracker_dsst(BB_new, path_video_saved, path_save_results)
    % configurar el nuevo GT
    
    %leyendo las posiciones del tracker
    path_positions=strcat(path_save_results,'/',name_video,'_results.txt');
    delimiterIn = ',';
    positions = importdata(path_positions,delimiterIn);
    
    [distance_precision, average_center_location_error, overlaps] = ...
        tracking_performance_measures(positions, ground_truth, distance_precision_threshold);
    first_zero=find(overlaps==0,1)
end

