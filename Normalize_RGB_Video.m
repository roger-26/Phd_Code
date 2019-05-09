%Normalize video RGB
%Este código normaliza un video RGB en intensidad e iluminación hasta que llega a un threshold

%% Leyendo el video
tic
clc;
close all;
clear all;

Name_Video_Full='050ExFo_OutRK_FQ_C1.avi';
[filepath,Name_Video,ext] = fileparts(Name_Video_Full)
a=VideoReader(Name_Video_Full)
Number_Frames_Video=a.NumberOfFrames;

Video_Cropped_Name=strcat('Normalized_',Name_Video);
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
    
    normalized = comprehensive_colour_normalization(b);
    %convirtiendo de nuevo a uint8 y preservando el formato de la imagen 
    normalized_frame=im2uint8(normalized);
    %imshow(normalized)
    %figure;
    imshowpair(b, normalized_frame, 'montage')
    maximum= max(normalized_frame(:))
    maximum_original= max(b(:))
    writeVideo(writerObj1,normalized_frame);
end
Name_Video_Full
 writerObj1.FrameRate
 close(writerObj1)
 toc
%% normalization in rgb space
%When normalizing the RGB values of an image, you divide each pixel's value by the sum of the pixel's
%value over all channels. So if you have a pixel with intensitied R, G, and B in the respective channels... 
%its normalized values will be R/S, G/S and B/S (where, S=R+G+B).


%% contrast stretching in RGB space
%I = imread('rice.png');
%J = imadjust(I,stretchlim(I),[0 1]);

%The contrast stretching transformation is used to improve details of images that are
%acquired using poor illumination conditions, an image sensor with a less dynamic
%range, or the wrong camera lens setting. The



%% Greyworld normalization ICIAP 2009 pag 200
%Se divide cada pixel por el valor promedio de la imagen en cada canal


%%  normalizes images for both illumination intensity and illumination color effects
%Cï¿½digo de MATLAB que se descargï¿½


