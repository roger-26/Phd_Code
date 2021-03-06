clc;
close all;
clear all;

%This code save in one .mat the videos in the LIVEVQC dataset de las caracteristicas obtenidas en
%C3D, y como salen diferentes filas dependiendo de la longitud del video porque toma una fila cada 8
%frames, entonces las promedia para probar el SVR que se entrena con los videos de LIVE QUalcomm

cd 'G:\datasets\LIVEVQCPrerelease\LIVE_VQC_YCbCr_8Frames_C3D_Features'
open G:\datasets\LIVEVQCPrerelease\MOS_LIVEVQC.mat
MOS_LIVE_VQC= ans.MOS_LIVEVQC;
%Este c�digo une todos los .mat que estan en un folder en un solo .mat
rows_data=1;
%para leer todos los archivos .mat de la carpeta
mat = dir('*.mat');
Number_Videos = length(mat);
for q = 1: Number_Videos
    q
    aux = load(mat(q).name);
    Current_Video_to_Process=    mat(q).name
    %IMPRIMe el nombre del video en pantalla
    %cambiar esta variable segun el nombre que tenga la estructura que
    %contiene los datos deseados
    
    variable_containing_data = aux.Feature_vect;
    
    LIVEVQC_Data_Averaged(q,:)= squeeze(max(variable_containing_data));
    fprintf('el MOS para el video %s es %2.2f \n',mat(q).name, MOS_LIVE_VQC(q));
end

save('data_LIVEVQC_MaxPooling','LIVEVQC_Data_Averaged')
save('MOS_LIVEVQC','MOS_LIVE_VQC')




