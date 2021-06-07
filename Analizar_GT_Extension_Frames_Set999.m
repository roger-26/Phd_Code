%Este código se usa para caracterizar el GT de los 999 videos selected for
%deblurring. La idea es saber la extensión en frames que tienen estos GT.
clear all;
videos_selected = load('C:\Dropbox\Javeriana\current_work\Deblur_Tracking/videos_set_1K.txt');
ADVSD_names = load('C:\Dropbox/Javeriana/datasets/AD-VSD/videos_Ad_VSD.mat')
FilePath=('C:\Dropbox\Javeriana\datasets\AD-VSD/shell2.txt');
fid = fopen(FilePath,'w');
for i=1:size(videos_selected,1)
    number_current_video=videos_selected(i);
    number_current_video2 = sprintf('%04d',number_current_video);
    current_video_name_with_ext = char(ADVSD_names.name_videos(number_current_video));
    [filepath,name_individual_video,ext] =fileparts(current_video_name_with_ext);
    video_name=name_individual_video;
    
    path_GT= strcat('C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideosGT/',video_name,'_gt.txt');
    aux3=load(path_GT);
    size_GT=size(aux3,1);
    
    gt_name{i,1}=video_name;
    gt_ext(i,1)=size_GT;
end
fclose(fid)