clc;
close all;
clear all;
%Se usa para unificar todos los .mat de una misma clase
%ademas normaliza y estandariza los datos (z-score)
%Este c�digo une todos los .mat que estan en un folder en un solo .mat
rows_data=1;
%para leer todos los archivos .mat de la carpeta
mat = dir('*.mat');
distortion='Stabilization';
for q = 1:length(mat) 
   aux = load(mat(q).name);
    Current_Video_to_Process=    mat(q).name 
    %IMPRIMe el nombre del video en pantalla
   load(Current_Video_to_Process)
   %cambiar esta variable segun el nombre que tenga la estructura que
   %contiene los datos deseados
   variable_containing_data = aux.Feature_vect;
   current_value_to_Save= variable_containing_data;   
   [rows normal_size]=size(current_value_to_Save);
   for i=1:rows
       %guarda los datos en las filas correspondientes para que al final quede un matriz de n filas
       %y 4096 columnas, donde n es el n�mero de caracter�sticas para cada uno de los videos de la
       %carpeta, este n�mero depende de la duraci�n y cantidad de los videos 
        data(rows_data,:)= variable_containing_data(i,:);
        rows_data=rows_data+1;
   end
end

save(strcat('fc6_Qualcomm_',distortion,'_AllVideos'),'data')


%Create a Z-matrix with mean 0 and std=1, with normalized data

Z_matrix = reshape(zscore(data(:)),size(data,1),size(data,2));
maximum_number = max(Z_matrix(:))
data_normalized=Z_matrix./maximum_number;

save(strcat('fc6_Qualcomm_',distortion,'_AllVideos_ZNormalized'),'data_normalized')


