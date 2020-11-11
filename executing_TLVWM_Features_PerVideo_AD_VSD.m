function [name_to_save_mat]=executing_TLVWM_Features_PerVideo_AD_VSD(video_start,video_end)


%calcular las TLVQM features de un video
tic
name_videos_in_folder =load('C:\Dropbox\Javeriana\datasets\AD-VSD\videos_Ad_VSD.mat');
name_videos = name_videos_in_folder.name_videos;
folder_2_save_YUV = 'C:\surveillanceVideos_YUV';

%  filename = 'C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideos\0001Pri_IndWL_MQ_C4.mp4';
% filename ='C:\Users\PUJC\Videos\toy1_AD-VSD.mp4';

% [features] = TLVQM_Features_PerVideo(folder_2_save_YUV, filename)
% toc
TLVQM_Features_ADVSD(:).features=zeros(4475,75);
% video_start=1;
% video_end=200;
videos_processed =0;
name_to_save_mat = strcat...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\Results\TLVQM_Features_ADVSD_',num2str(video_start),'_',num2str(video_end),'.mat');
for i =video_start:video_end
    
        name_current_video = name_videos{i};
        Total_Path_Video = ...
            strcat('C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideos\',name_current_video);
%     Total_Path_Video ='C:\Users\PUJC\Videos\toy2_AD-VSD.mp4';
    
    [features,video_proccessed] = TLVQM_Features_PerVideo(folder_2_save_YUV, Total_Path_Video);
    
    TLVQM_Features_ADVSD(i,:).features=features;
    TLVQM_Features_ADVSD(i,:).video=video_proccessed;
    save(name_to_save_mat,'TLVQM_Features_ADVSD');
    videos_processed = videos_processed+1;
    if videos_processed >1
        %para que elimine el archivo YUV y no se llene el disco
        Total_Path_Video_YUV = strcat(folder_2_save_YUV,'\',TLVQM_Features_ADVSD(i-1).video,'_YUV.avi')
%         Total_Path_Video_YUV = strcat(folder_2_save_YUV,'\',video_proccessed,'_YUV.avi');
        delete(Total_Path_Video_YUV);   
    end
end
toc
end