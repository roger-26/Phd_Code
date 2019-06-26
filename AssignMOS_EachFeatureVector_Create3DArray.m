clc;
close all;
clear all;
%Roger Gomez Nieto June 19 1019
%Generating matrix with features C3D no averaged.

%Este código toma todos los .mat que existan en la carpeta, y luego separa cada una de las
%observaciones (1 observación en C3D son 16 frames), y a todas las observaciones del mismo video les
%asigna el mismo MOS del video al que pertenecen. Genera una matriz en 3D donde la primera dimension
%es el video, la segunda dimension es cada uno de los feature vector que pertenecen a ese video, y
%la 3ra dimensión son cada una de las características extraidas.


%%
%Cargando el archivo donde estan los MOS

FileName   = 'qualcommSubjectiveData.mat';
FolderName = 'C:\Dropbox\Javeriana\current_work';
% FolderName = 'C:\Dropbox\Ubuntu\Features_conv5b_Avance8Frames\Artifacts';

File       = fullfile(FolderName, FileName);
load(File);   %
MOS_Unbiased= qualcommSubjectiveData.unBiasedMOS;

Number_Videos=208;

Name_To_Save_Data= 'Conv5b_Advance8_RGB_Focus';
rows_data=1;
%para leer todos los archivos .mat de la carpeta
mat = dir('*.mat');

%el 50 sale porque los videos de qualcomm dataset tienen 450 frames y C3D esta
%avanzando de a 8 frames (toma 16 en cada operación pero tiene un overlap de 8
%frames). Sin embargo, hay videos que son mas cortos, entonces para que alcance a tomar esos videos
%se deja en 52 features per video. 
Number_Of_Features_PerVideo=50


Videos_QUe_Coinciden=0
for i=1:Number_Videos
    aux1=qualcommVideoData.vidNames(i); %get the name of video of the Original MOS
    aux3=char(aux1); %
    C = strsplit(aux3,'.');%separa por el punto para que no guarde como nombre la extensi
    name_video_MOS_ACTUAL=char(C(1));
    Exit=0;
    for q = 1:length(mat)%Este es el número de videos que hay en la carpeta
        if Exit==0
            Current_Video_to_Process=    mat(q).name;
            %IMPRIMe el nombre del video en pantalla
            if contains(Current_Video_to_Process,name_video_MOS_ACTUAL)
                i;
                
                Videos_QUe_Coinciden=Videos_QUe_Coinciden+1
                %                 MOS_Videos_Folder(Consecutivo_Video_Save)=MOS_Unbiased(i);
                Exit =1;
                Current_Video_to_Process
                name_video_MOS_ACTUAL
                aux = load(mat(q).name);
                %                 variable_containing_data = aux.average_features;
                variable_containing_data = aux.Feature_vect;
                %                 variable_containing_data = au
                %variable_containing_dx.average_features;
                current_value_to_Save= variable_containing_data;
                
                
                for i1=1:Number_Of_Features_PerVideo
                    %guarda los datos en las filas correspondientes para que al
                    %final quede un matriz de n filas
                    %y 4096 columnas, donde n es el número de características para cada
                    %uno de los videos de la carpeta, este número depende de la duración y
                    %cantidad de los videos
                    data(q,i1,:)= variable_containing_data(i1,:);
                    MOS_fc6(q)=MOS_Unbiased(i);
                    Video_current(i1)=q;
                    
                end
            end
        end
    end
    
end

save(strcat('DATA_', Name_To_Save_Data),'data')
save(strcat('MOS_', Name_To_Save_Data),'MOS_fc6')
% save('MOS_fc6_Overlap8_YCbCr_Stabilization','MOS_fc6')

