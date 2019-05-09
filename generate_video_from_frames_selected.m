%Guarda los frames determinados de un video y genera un mp4 a partir de
%estos frames, sin alterar 
clc;
close all;
clear all;

Name_Video='marroquin.mp4';
Save_all_Frames=0;
Frame1_ExisteGT=20787;
FrameEnd_ExistsgT=22000;


a=VideoReader(Name_Video)
%Number_Frames_Video=a.NumberOfFrames;
Frame1_ExisteGT=20787;
FrameEnd_ExistsgT=22000;
%type of format desired
Desired_Type_File='.jpg';




vidHeight = a.Height;
vidWidth = a.Width;
%%
Video_Cropped_Name=strcat('Crop',Name_Video);
NumberOfFrames=FrameEnd_ExistsgT-Frame1_ExisteGT;
writerObj1 = VideoWriter(Video_Cropped_Name,'uncompressed AVI');
writerObj1.FrameRate=a.FrameRate
open(writerObj1);
%% leyendo todos los frames
% 
% tic
% while hasFrame(a)
%     video = readFrame(a);
% end
% whos video
% toc

%% para leer videos de larga duración 
% tic
% s = struct('cdata',zeros(vidHeight,vidWidth,3,'uint8'),...
%     'colormap',[]);
% k = 1;
% while hasFrame(a)
%     s(k).cdata = readFrame(a);
%     k = k+1;
%     if (mod(k,900)==0)
%       k
%   end
% end
% 
% whos s
% toc
%%
for img = Frame1_ExisteGT:NumberOfFrames+Frame1_ExisteGT
    
    b = image(s(img).cdata);
    writeVideo(writerObj1,b);  
    %b= imresize(b,[1080 1920]); %Si se quiere convertir en QVGA
    %imshow(b);
    %imwrite(b,filename);
    img
end
writerObj1.FrameRate
close(writerObj1)
