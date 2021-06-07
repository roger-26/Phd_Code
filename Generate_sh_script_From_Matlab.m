%Código para guardar un scrip con comandos bash o shell generados en un txt
%desde Matlab, de forma automática.
%Author: Roger Gomez Nieto
% Date: 21 de abril de 2021.
videos_selected = load('C:\Dropbox/Javeriana/current_work/tracker_prediction/Deblurred_Videos/selected_videos2.csv');
ADVSD_names = load('C:\Dropbox/Javeriana/datasets/AD-VSD/videos_Ad_VSD.mat')
FilePath=('C:\Dropbox\Javeriana\datasets\AD-VSD/shell2.txt');
fid = fopen(FilePath,'w');
for i=1:size(videos_selected,1)
    number_current_video=videos_selected(i);
    current_video_name_with_ext = char(ADVSD_names.name_videos(number_current_video))
    [filepath,name_individual_video,ext] =fileparts(current_video_name_with_ext);   
    video_name=name_individual_video;
    command1=strcat("sudo mv /home/vigilcali/roger_nieto/AD-VSD/surveillanceVideosDataset/surveillanceVideosGT/",video_name,...
        "_gt.txt /home/vigilcali/roger_nieto/Videos_Set2_211Videos_InFrames/deblurred_videos/",video_name,"_deblurredSRN/groundtruth.txt")
    fprintf(fid,'%s\n', command1);
end
fclose(fid)
