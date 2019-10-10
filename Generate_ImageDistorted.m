clc;
close all;
clear all;

% recibe un conjunto de frames ordenados seg�n el nombre y genera un
% archivo mp4 o AVI
Video_Cropped_Name='Video1';
NumberOfFrames=505;
Frames_A_Quitar_AL_Final=0

% writerObj1 = VideoWriter(Video_Cropped_Name,'MPEG-4');
writerObj1 = VideoWriter(Video_Cropped_Name,'Uncompressed AVI');

type = 'gaussian';
m = 0; % mean
Q = [0.01, 0.05, 0.1]; %for Gaussian
v = Q(1); % variance


writerObj1.FrameRate=30;
open(writerObj1);
extension='.png';
%hay que variar el numero de ceros segun el nombre de las imagenes de la
%carpeta, en OTB100 usan 7 ceros
for i = 1 : NumberOfFrames-Frames_A_Quitar_AL_Final
    if i<10
        name=strcat('000',num2str(i),extension);
    elseif i<100
        name=strcat('00',num2str(i),extension);
    elseif i<1000
        name=strcat('0',num2str(i),extension);
    elseif i<10000
        name=strcat('',num2str(i),extension);
    end
    im=imread(name);
    im_with_noise = imnoise(im,type,m,v);
    
    writeVideo(writerObj1,im_with_noise);  
  if (mod(i,100)==0)
      i
  end
end
close(writerObj1)
