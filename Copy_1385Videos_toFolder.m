clear all
clc

videos_selected = ...
    csvimport...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker/videos_MFTMayor05_30FPS_1385.csv');

FilePath=('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker/shell_MoveVideos_1385.txt');
fid = fopen(FilePath,'w');
for i=1:size(videos_selected,1)
    number_current_video=videos_selected{i};
    [filepath,name_individual_video,ext] =fileparts(number_current_video);   
    video_name=name_individual_video;
    command1=strcat("sudo cp /home/vigilcali/roger_nieto/AD-VSD/surveillanceVideosDataset/surveillanceVideos/",video_name,...
        ".mp4 /home/vigilcali/roger_nieto/set1385_Original_OnlyVideos/")
    fprintf(fid,'%s\n', command1);
end
fclose(fid)

