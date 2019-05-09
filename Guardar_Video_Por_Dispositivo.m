%This code agrupa todos los .mat por dispositivo, detectando si esta el
%nombre del dispositivo contenido aqui en la cadena

%agrupa todos los videos de un mismo dispositivo, sin separación en las
%características, todas las mete en una sola matriz. 

clear all
clc;
close all;
% LGG2   HTCOneVX GS6  OppoFind7  GS5 Nokia1020 Note4 iphone5
device='iphone5';
distortion='Exposure';
name_to_save_matFile= strcat(device, '_', distortion, '_C3D_Features');

rows_data=1;
mat = dir('*.mat')
videos_device=0; %al inicio no se ha detectado ningun video
for q = 1:length(mat) 
    current_video=mat(q).name;
    auxiliar= load(current_video);
    variable_containing_data = auxiliar.Feature_vect;
    evaluando_Si_es_dispositivo_deseado= contains(current_video,device);
    if (contains(current_video,device))
        q
        fprintf('The video %s is recorded with %s device\n',current_video,device);
        videos_device=videos_device+1;
        [rows, normal_size]=size(variable_containing_data);
        for i=1:rows 
      %guarda los datos en las filas correspondientes para que al final quede un matriz de n 
      %filas y 4096 columnas, donde n es el número de características para cada uno de los 
      %videos de la carpeta, este número depende de la duración y cantidad de los videos 
        data(rows_data,:)= variable_containing_data(i,:);
        rows_data=rows_data+1;
        end
    end
end
fprintf('we found %d videos of device %s\n',videos_device, device);
save(strcat(name_to_save_matFile,'.mat'),'data');

