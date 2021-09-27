%Este código se usa para copiar los ground truth al lado de la carpeta img, que ya debe estar creada y con las imágenes deseadas
%Roger - 11 de junio de 2021
%% 
clear all
clc
% videos_selected = load('C:\Dropbox\Javeriana\current_work\Deblur_Tracking/videos_set_1K.txt');
videos_selected = ...
    csvimport...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker/videos_MFTMayor05_30FPS_1385.csv');
FilePath=('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker/copy_GT.txt');
fid = fopen(FilePath,'w');
for i=1:size(videos_selected,1)
    current_video_name_with_ext = char(videos_selected(i))
    [filepath,name_individual_video,ext] =fileparts(current_video_name_with_ext);
    video_name=name_individual_video;
    command3=strcat("sudo cp /home/vigilcali/roger_nieto/tracker_prediction/Multi_resolution_Tracker/gts/surveillanceVideosGT_116/",video_name,...
        "_gt.txt ",video_name,"/groundtruth.txt")
    fprintf(fid,'%s\n', command3);
end
fclose(fid)

% /home/r/Dropbox/Javeriana/datasets/AD-VSD/surveillanceVideosDataset/surveillanceVideosGT

% /home/vigilcali/roger_nieto/tracker_prediction/Multi_resolution_Tracker/gts/surveillanceVideosGT_14