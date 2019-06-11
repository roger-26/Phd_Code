clc;
close all;
clear all;

% recibe un conjunto de frames ordenados seg?n el nombre y genera un
% archivo mp4
Video_Cropped_Name='camaro';
NumberOfFrames=945;
writerObj1 = VideoWriter(Video_Cropped_Name,'MPEG-4');
writerObj1.FrameRate=30;
open(writerObj1);
for i = 1 : NumberOfFrames
    if i<10
    name=strcat('000',num2str(i),'.jpg');
    elseif i<100 
        name=strcat('00',num2str(i),'.jpg');
    elseif i<1000
        name=strcat('0',num2str(i),'.jpg');
    elseif i<10000
        name=strcat('',num2str(i),'.jpg');
    end
  im=imread(name);
  writeVideo(writerObj1,im);  
end
close(writerObj1)
