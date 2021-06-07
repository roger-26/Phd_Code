clear all
clc
path_csv = 'C:\Dropbox/Javeriana/current_work/tracker_prediction/Deblurred_Videos/selected_videos3.csv';
opts = detectImportOptions(path_csv);
opts.Delimiter=' ';
opts.DataLines=[1,Inf];
set_deblur_1K = readtable(path_csv,opts);
set_1K=set_deblur_1K(:,1);
set_1K=table2cell(set_1K);
FilePath=('C:\Dropbox/Javeriana/current_work/tracker_prediction/Deblurred_Videos/shell_MoveVideos_1K.txt');
fid = fopen(FilePath,'w');
for i=1:size(set_1K,1)
    number_current_video=set_1K{i};
    [filepath,name_individual_video,ext] =fileparts(number_current_video);   
    video_name=name_individual_video;
    command1=strcat("sudo mv /home/vigilcali/roger_nieto/AD-VSD/surveillanceVideosDataset/surveillanceVideos/",video_name,...
        ".mp4 /home/vigilcali/roger_nieto/deblurred_videos/Videos_Set3_1K/")
    fprintf(fid,'%s\n', command1);
end
fclose(fid)

