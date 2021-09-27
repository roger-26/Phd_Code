%% Load the video
close all
clc;
base_folder_videos = 'C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideos/';
addpath 'C:\Dropbox\git'
videos_selected = ...
    csvimport...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker/videos_MFTMayor05_30FPS_1385.csv');
resolucion_scale=0.2;

for video_number=954:size(videos_selected,1)
    video_number
    tic
    current_video_name_with_ext = char(videos_selected(video_number));
    [filepath,name_individual_video,ext] =fileparts(char(current_video_name_with_ext));
    video_name=name_individual_video
    existe_video =  exist(strcat(base_folder_videos,video_name,'.mp4'),'file');
    if existe_video==2
        v = VideoReader(strcat(base_folder_videos,video_name,'.mp4'));
        Number_Frames_Video =v.NumberOfFrames;
        %     Number_Frames_Video = 451;
        mkdir('C:\Users\roger\Documents\Videos_1_5_resolution/',video_name);
        Destination_Frame = strcat...
            ('C:\Users\roger\Documents\Videos_1_5_resolution/',video_name,'/img');
        mkdir(Destination_Frame)
        % system(char(strcat("sudo mkdir ",Destination_Frame)));
        disp('saving video frames');
        parfor (i=1:Number_Frames_Video,4)
            %         for i=1:Number_Frames_Video
            frame=read(v,i);
            frame_12=imresize(frame,resolucion_scale,'bilinear');
            %     figure
            %     subplot(2,1,1)
            %     imshow(frame)
            %     title('original frame');
            %     subplot(2,1,2)
            %     imshow(frame_12)
            %     title('1/2');
            number_current_video2 = sprintf('%04d',i);
            name_to_save_Frame = strcat(num2str(number_current_video2),'.jpg');
            imwrite(frame_12,fullfile(Destination_Frame,name_to_save_Frame),'jpg');
        end
    end
    toc
end