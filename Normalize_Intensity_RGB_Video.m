%Normalize video RGB only in intensity to obtain a [0 1] range

%% reading the video
tic
clc;
close all;
clear all;

Name_Video_Full='039Fo_IndLPW_MQ_C4.avi';
[filepath,Name_Video,ext] = fileparts(Name_Video_Full)
a=VideoReader(Name_Video_Full)
Number_Frames_Video=a.NumberOfFrames;

Video_Cropped_Name=strcat('Normalized_Intensity_',Name_Video);
writerObj1 = VideoWriter(Video_Cropped_Name,'Uncompressed AVI');
% writerObj1 = VideoWriter(Video_Cropped_Name,'Motion JPEG AVI');
writerObj1.FrameRate=a.FrameRate
open(writerObj1);

%%
for img = 1:Number_Frames_Video
    b = read(a, img);
    
    %imshow (b)
    
    %b is an RGB image of 3 channels
      
    img

    
    img_r=double(b);
   
    normalized_frame(:,:,3)=img_r(:,:,3)/255;
    normalized_frame(:,:,2)=img_r(:,:,2)/255;
    normalized_frame(:,:,1)=img_r(:,:,1)/255;
    
%     Maximum_Original_Image=max(b(:))
%     Minimum_Original_Image=min(b(:))
%     Mean_Original_Image = mean(b(:))
%     Maximum_Normalized_Image=max(normalized_frame(:))
%     Minimum_Normalized_Image=min(normalized_frame(:))
%     Mean_Normalized_Image = mean(normalized_frame(:))

    %imshow(normalized)
    %figure;
%     imshowpair(b, normalized_frame, 'montage')
    
    
    writeVideo(writerObj1,normalized_frame);
end
Name_Video_Full
 writerObj1.FrameRate
 close(writerObj1)
 toc