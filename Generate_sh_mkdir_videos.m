%Código para guardar un scrip con comandos bash o shell generados en un txt
%desde Matlab, de forma automática.
%Author: Roger Gomez Nieto
% Date: 21 de abril de 2021.



addpath 'C:\Dropbox\git'
videos_selected = ...
    csvimport('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker/videos_MFTMayor05_30FPS_1385.csv');
% ADVSD_names = load('C:\Dropbox/Javeriana/datasets/AD-VSD/videos_Ad_VSD.mat')
FilePath=('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker/script_mkdir-set1385.txt');
fid = fopen(FilePath,'w');
for i=1:1385
    number_current_video=videos_selected(i);
    current_video_name_with_ext = number_current_video
    [filepath,name_individual_video,ext] =fileparts(char(current_video_name_with_ext));   
    video_name=name_individual_video;
    command1=strcat("mkdir /home/r/Current_Work_Phd/set_1385_VariacionResolucion/1_2/", video_name)
    fprintf(fid,'%s\n', command1);
end
fclose(fid)
