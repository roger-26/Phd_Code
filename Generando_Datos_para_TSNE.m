clc;
close all;
clear all;

%This code generates the labels matrix, needed in TSNE algorithm. 
%Se usa cuando ya se tiene un solo .mat por cada clase
rows_data=1;
%para leer todos los archivos .mat de la carpeta
mat = dir('*.mat');
clase =1;
Num_FIles_toSave=7; 
%el numero de matrices que quiero guardar, o número de clases que existen
SaveName_MatrixFinale= 'fc6_Qualcomm_and_Pristine_AllVideos_NoAverage_ZNorm';
for q = 1:Num_FIles_toSave 
   aux = load(mat(q).name);
    Current_Video_to_Process=    mat(q).name 
   current_value_to_Save= aux.data_normalized;   
   [rows normal_size]=size(current_value_to_Save);
   rows
   for i=1:rows
       %guarda los datos en las filas correspondientes para que al final quede un matriz de n filas
       %y 4096 columnas, donde n es el número de características para cada uno de los videos de la
       %carpeta, este número depende de la duración y cantidad de los videos 
       
        All_data(rows_data,:)= current_value_to_Save(i,:);
        All_data(rows_data,:)= current_value_to_Save(i,:);
        labels(rows_data,1) = clase;
        rows_data=rows_data+1;
   end
   clase=clase+1;
end
save(SaveName_MatrixFinale,'All_data')
save(strcat('labels_',SaveName_MatrixFinale),'labels');


%% pca
% 
% [coeff,score,latent,tsquared,explained] = pca(X);
% scatter3(score(:,1),score(:,2),score(:,3))
% axis equal
% xlabel('1st Principal Component')
% ylabel('2nd Principal Component')
% zlabel('3rd Principal Component')
% limite_clase1= 331;
% limite_clase2= 699;
% limite_clase3= 213;
% limite_clase4=166;
% scatter3(score(1:limite_clase1,1),score(1:limite_clase1,2),score(1:limite_clase1,3),'MarkerFaceColor',[0 .75 .75])
% scatter3(score(:,1),score(:,2),score(:,3),'MarkerFaceColor',[0 .75 .75])
% scatter3(score(:,1),score(:,2),score(:,3),'MarkerFaceColor',[0 .75 .75])
% scatter3(score(:,1),score(:,2),score(:,3),'MarkerFaceColor',[0 .75 .75])
% axis equal
% xlabel('1st Principal Component')
% ylabel('2nd Principal Component')
% zlabel('3rd Principal Component')
