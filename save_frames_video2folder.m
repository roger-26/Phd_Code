function [Number_Of_Frames] = ...
    save_frames_video2folder(folder_video_individual_frames,folder_containing_videos,video_name_with_ext,Desired_Type_File)
%folder_video_individual_frames --> Carpeta donde se van a guardar los frames del video
%folder_containing_videos       --> Carpeta donde esta el video 
%video_name_with_ext            --> Nombre del video con extensión
%Desired_Type_File                     --> tipo del archivo de imagen png or jpg

% load('E:\datasets\DatasetCS\IEEE Dataport\surveillanceVideosDataset\surveillanceVideos\name_videos_ADVSD.mat');

    %     current_video = 2;
    
    
    exist_folder =  exist(folder_video_individual_frames,'dir');
    if exist_folder~=7
%         folder_video_individual_frames
        mkdir(folder_video_individual_frames);
        path_frames = strcat(folder_video_individual_frames,'\img');
        mkdir(path_frames);
        % path_frames = ...
        %     'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0284Exp_IndWL_MQ_C3\img';
        
        % path_video = ...
        % 'C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\0284Exp_IndWL_MQ_C3\0284Exp_IndWL_MQ_C3.mp4'
        
      
        path_video = strcat(folder_containing_videos,video_name_with_ext);
        
        
        Initial_Frame = 0;
        change_size_flag = 0;
%         Desired_Type_File = 'jpg'
        [Number_Of_Frames] = ...
            Generate_Frames_From_Video(path_frames,path_video, Desired_Type_File,Initial_Frame, change_size_flag);
end








