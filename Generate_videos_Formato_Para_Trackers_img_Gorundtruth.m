%Este código se usa para guardar los frames y los groundtruth en el formato
%que exigen los tracker que es un folder con img y groundtruth.txt al lado
%de ese folder  img que contiene los frames
%Roger - 13 mayo 2021
videos_selected = load('C:\Dropbox\Javeriana\current_work\Deblur_Tracking/videos_set_1K.txt');
ADVSD_names = load('C:\Dropbox/Javeriana/datasets/AD-VSD/videos_Ad_VSD.mat')
FilePath=('C:\Dropbox\Javeriana\datasets\AD-VSD/shell2.txt');
fid = fopen(FilePath,'w');
for i=1:size(videos_selected,1)
    number_current_video=videos_selected(i);
    number_current_video2 = sprintf('%04d',number_current_video);
    current_video_name_with_ext = char(ADVSD_names.name_videos(number_current_video))
    [filepath,name_individual_video,ext] =fileparts(current_video_name_with_ext);
    video_name=name_individual_video;
    command0 = strcat("cd ",num2str(number_current_video2))
    fprintf(fid,'%s\n', command0)
    command1=strcat("mkdir img")
    fprintf(fid,'%s\n', command1)
    command2=strcat("sudo mv !(img) img")
    fprintf(fid,'%s\n', command2)
    command3=strcat("sudo mv /home/r/Dropbox/Javeriana/datasets/AD-VSD/surveillanceVideosDataset/surveillanceVideosGT/",video_name,...
        "_gt.txt ./groundtruth.txt")
    fprintf(fid,'%s\n', command3);
    command4= strcat("cd ..")
    fprintf(fid,'%s\n', command4);
end
fclose(fid)