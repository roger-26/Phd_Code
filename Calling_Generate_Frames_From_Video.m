clc;
load('G:\datasets\DatasetCS\IEEE Dataport\surveillanceVideosDataset\surveillanceVideos\name_videos_ADVSD.mat');
parfor current_video=3:4476
    tic
    
    folder_save_video_frames =...
        'G:\datasets\DatasetCS\IEEE Dataport\surveillanceVideosDataset\surveillanceVideos_Frames\';
%     current_video = 2;
    [filepath,name_individual_video,ext] =fileparts(name_videos{current_video})
    folder_video_individual_frames = strcat(folder_save_video_frames,name_individual_video);
    
    mkdir(folder_video_individual_frames);
    path_frames = strcat(folder_video_individual_frames,'\img');
    mkdir(path_frames);
    % path_frames = ...
    %     'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0284Exp_IndWL_MQ_C3\img';
    
    % path_video = ...
    % 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0284Exp_IndWL_MQ_C3\0284Exp_IndWL_MQ_C3.mp4'
    
    folder_containing_videos =...
        'G:\datasets\DatasetCS\IEEE Dataport\surveillanceVideosDataset\surveillanceVideos\';
    path_video = strcat(folder_containing_videos,name_videos{current_video});
    
    
    Initial_Frame = 0
    change_size_flag = 0;
    Desired_Type_File = 'png'
    [Number_Of_Frames] = ...
        Generate_Frames_From_Video(path_frames,path_video, Desired_Type_File,Initial_Frame, change_size_flag)
    toc
end








