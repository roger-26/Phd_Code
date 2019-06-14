clc;
close all;
clear all;

% esta funci�n genera la mtriz de entrenamiento para el SVR. Hace coincidir
% el orden de los MOS dados por LIVE con los datos promediados que se
% encuentran en la carpeta. Busca entre el archivo
% qualcommSubjectiveData.mat que es el archivo que genera LIVE para definir
% el orden de los MOS y los videos. Este code hace coincidir los dos
% nombres, para que se guarde en el orden en el que estan en LIVE. En la
% carpeta deberian existir 208 videos, que son el total de los que hay en
% LIVE. Al final se dice el porcentaje de valores de esta matriz que son
% 0s. 
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
Consecutivo_Video_Save=0;
for i=1:Number_Videos
    aux1=qualcommVideoData.vidNames(i);
    aux3=char(aux1);
    C = strsplit(aux3,'.');%separa por el punto para que no guarde como nombre la extensi
    name_video_MOS_ACTUAL=char(C(1));
    Exit=0;
    for q = 1:length(mat)%Este es el n�mero de videos que hay en la carpeta
        if Exit==0
            Current_Video_to_Process=    mat(q).name;
            
            %IMPRIMe el nombre del video en pantalla
            if contains(Current_Video_to_Process,name_video_MOS_ACTUAL)
                i
                Consecutivo_Video_Save=Consecutivo_Video_Save+1
                Videos_Procesados(Consecutivo_Video_Save)=q;
                MOS_Videos_Folder(Consecutivo_Video_Save)=MOS_Unbiased(i);
                Exit =1;
                Current_Video_to_Process
                name_video_MOS_ACTUAL
                aux = load(mat(q).name);
                variable_containing_data = aux.average_features;
%                 variable_containing_data = au
                %variable_containing_dx.average_features;
                current_value_to_Save= variable_containing_data;
                [rows normal_size]=size(current_value_to_Save);
                for i1=1:rows
                    %guarda los datos en las filas correspondientes para que al
                    %final quede un matriz de n filas
                    %y 4096 columnas, donde n es el n�mero de caracter�sticas para cada
                    %uno de los videos de la carpeta, este n�mero depende de la duraci�n y
                    %cantidad de los videos
                    data(Consecutivo_Video_Save,:)= variable_containing_data(i1,:);
                    rows_data=rows_data+1;
                end
            end
        end
    end
    
end

save('Data_Videos_UniqueScene_Qualcomm','data')
save('MOS_Videos_UniqueScene_Qualcomm','MOS_Videos_Folder')

%% Calculando el n�mero de ceros en la matriz

size_Matrix_Total=size(data);
Number_Elements_Matrix=size_Matrix_Total(1)*size_Matrix_Total(2);
Number_zeros=sum(~data(:));
Percentage_zeros=(Number_zeros*100)/Number_Elements_Matrix;
disp(['The matrix have ', num2str(Percentage_zeros),'% of zeros']);