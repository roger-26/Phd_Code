function [name_video_YUV] = video_rgb2yuv(path_video,path_save_video_YUV)

%converts a RGB video to YUV video
%path_video is the full path of RGB video
%path_save_video_YUV --> folder where will be saved the YUV video

%author: Roger Gomez Nieto
%Date: August 12, 2020


%read video
[folder_video,name_video,ext_video] = fileparts(path_video);
a                   =VideoReader(path_video);
Number_Of_Frames =a.NumberOfFrames;
name_video_YUV = strcat(path_save_video_YUV,'\',name_video,'_YUV');
writerObj1 = VideoWriter(name_video_YUV,'Uncompressed AVI');
writerObj1.FrameRate=a.FrameRate;
open(writerObj1);
for img = 1:Number_Of_Frames
    %esta numeración es la que pide el tracker STRUCK para no dar error en
    %la consecución de los frames.
    im=read(a,img);
%     [Y U V] = rgb2yuv(im(:,:,1),im(:,:,2),im(:,:,3),yuv_format,'BT709_f');
%el 0 es para que no grafique
    [YUV_Image] = rgb2yuv(im,0);
%     YUV_Image(:,:,1)=Y;
%     YUV_Image(:,:,2)=U;
%     YUV_Image(:,:,3)=V;
%     imshow(YUV_Image);
    writeVideo(writerObj1,YUV_Image);
    if mod(img,400)==0
        img
    end
end
close(writerObj1)
successful_conversion=1;

end