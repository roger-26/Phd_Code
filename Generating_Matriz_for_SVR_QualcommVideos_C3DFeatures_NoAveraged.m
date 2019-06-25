clc;
close all;
clear all;
%Roger Gomez Nieto May 9, 2019
%Generating matrix with features C3D no averaged.
%Este código toma todos los .mat que existan en la carpeta, y luego separa cada una de las
%observaciones (1 observación en C3D son 16 frames), y a todas las observaciones del mismo video les
%asigna el mismo MOS del video al que pertenecen. 

%Se debe colocar el current folder en la carpeta 
%C:\Dropbox\Javeriana\current_work\Features_fc6_QualcommDataset_AVIUncompressed\fc6Features_UniqueScene
%% 
%Cargando el archivo donde estan los MOS

FileName   = 'qualcommSubjectiveData.mat';
FolderName = 'C:\Dropbox\Javeriana\current_work';
File       = fullfile(FolderName, FileName);
load(File);   % 
MOS_Unbiased= qualcommSubjectiveData.unBiasedMOS;

Number_Videos=208; 


rows_data=1;
%para leer todos los archivos .mat de la carpeta
mat = dir('*.mat');
Consecutivo_Video_Save=1;
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
                [rows normal_size]=size(current_value_to_Save);
                for i1=1:rows
                    %guarda los datos en las filas correspondientes para que al
                    %final quede un matriz de n filas
                    %y 4096 columnas, donde n es el número de características para cada
                    %uno de los videos de la carpeta, este número depende de la duración y
                    %cantidad de los videos
                    data(i,Consecutivo_Video_Save,:)= variable_containing_data(i1,:);
                    MOS_fc6(i,Consecutivo_Video_Save)=MOS_Unbiased(i);
                    Video_current(Consecutivo_Video_Save)=q;
                    
                    
                    rows_data=rows_data+1;
                    Consecutivo_Video_Save=Consecutivo_Video_Save+1;
                    
                end
            end
        end
    end
    
end

save('DATA_conv5b_Artifacts_Allvideos','data')
save('MOS_Conv5b_Artifacts_Allvideos','MOS_fc6')

%% Calculando el número de ceros en la matriz

size_Matrix_Total=size(data);
Number_Elements_Matrix=size_Matrix_Total(1)*size_Matrix_Total(2);
Number_zeros=sum(~data(:));
Percentage_zeros=(Number_zeros*100)/Number_Elements_Matrix;
disp(['The matrix have ', num2str(Percentage_zeros),'% of zeros']);