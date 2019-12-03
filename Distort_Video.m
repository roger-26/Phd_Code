function [path_distorted_video] = ...
    Distort_Video(Path_Input, Path_Output, Name_video, Distortion, Level)
tic
% Author: Roger Gomez Nieto - Oct 18, 2019
% rogergomez@ieee.org
%this function generates a distorted video from an mp4 file. The distortions are
%Gaussian, MPEG4 and Blur. You can choose several distortions levels
%*************************************************************
%PARAMETERS
%Path_Input is the folder where is the video to distort
% i.e. G:\datasets\Pristine Videos\'

%Path_Output is the folder where you will save the distorted video
%i.e. G:\datasets\MP4_Videos\low\

%Name_video is the name of video with extension (i.e. 'video1.mp4')

%distortion = 'gaussian', or 'blur' or 'MPEG-4'

%level = 'low' or 'medium' or 'high' intensity of the distortion
%***************************************************************
%DEPENDENCES
%vidnoise.m
%mat2avi.m
%avi2mat.m
%***************************************************************

%% Classifying distortion
switch Distortion
    case 'MPEG-4'
        Q = [60 30 0]; % MPEG Compression
    case 'gaussian'
        Q = [0.01, 0.05, 0.1]; % AWGN
    case 'blur'
        Q = [5, 10, 15]; % Blur
end
%% Reading Video
vid1=VideoReader(strcat(Path_Input,Name_video))
Number_Frames_Video=vid1.NumberOfFrames
Full_Name_Divided= strsplit(Name_video,'.');
%extract the name without extension
Only_Name_NoExt= char(Full_Name_Divided(1));
%generate the name of distorted video
namevideo_distorted=strcat(Only_Name_NoExt,'_',Distortion,'_',Level);
%if the video is mp4, the output video have too mp4 extension. Otherwise, output video is AVI file
% if strcmp(char(Full_Name_Divided(2)),'mp4')
%     video_format_output = 'MPEG-4';
% else
%     video_format_output = 'Uncompressed AVI';
% end
video_format_output = 'Uncompressed AVI';
Path_Output_Full = strcat(Path_Output,namevideo_distorted,'.',char(Full_Name_Divided(2)));
writerObj1 = VideoWriter(strcat(Path_Output,namevideo_distorted),video_format_output);
writerObj1.FrameRate = vid1.FrameRate;
open(writerObj1);
%select the parameter of Q matrix, that contains the several intensity levels for each distortion
switch Level
    case 'low'
        o=1;
    case 'medium'
        o=2;
    case 'high'
        o=3;
end
%distort frame to frame and save all of them in an output video
for i = 1 : vid1.NumberOfFrames
    im = read(vid1,i);
    switch Distortion
        case 'MPEG-4'
            im_distorted =  vidnoise(im,Distortion,Q(o));
        case 'gaussian'
            im_distorted =  vidnoise(uint8(im),Distortion,[0, Q(o)]);
            im_distorted = uint8(im_distorted);
        case 'blur'
            im_distorted =   vidnoise(uint8(im),Distortion,Q(o));
            im_distorted = uint8(im_distorted);
    end
    writeVideo(writerObj1,im_distorted);
    %shows progress, each 100 frames
    if mod(i,100)==0
        Msg = [num2str(i),' frames processed'];
        disp(Msg)
    end
end
close(writerObj1)
%return the full path to distorted video
path_distorted_video = Path_Output_Full;
toc
end