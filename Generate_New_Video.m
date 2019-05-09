function [path_video_saved]= ...
    Generate_New_Video(New_start,frames_to_quit, video_path, failures, path_save_video)
%Genera un nuevo video desde un determinado frame para reiniciar el
%tracker
[folder_video,name_video,ext_video] = fileparts(video_path)
name_video_recorted=...
    strcat(path_save_video,'/', name_video,'_Fail', num2str(failures));
vid1 = VideoReader(video_path);
writerObj1 = VideoWriter(name_video_recorted);
writerObj1.FrameRate=vid1.FrameRate;
open(writerObj1);
Number_Of_Frames=vid1.NumberOfFrames
for i = New_start : vid1.NumberOfFrames-frames_to_quit
    im=read(vid1,i);
    % %                 f = @() rectangle('position',[x y w h]);
    %     f = @() rectangle('position',gt_Initial(i,:));
    %     params = {'linewidth',1,'edgecolor','g'};
    %     imgOut = insertInImage(im,f,params);
    writeVideo(writerObj1,im);
    i
end
path_video_saved=strcat(name_video_recorted,'.avi')
close(writerObj1)
end