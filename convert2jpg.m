%Guarda los frames determinados de un video y genera un mp4 a partir de
%estos frames, sin alterar 
clc;
close all;
clear all;

Name_Video='video70.mp4';
Save_all_Frames=1;
Frame1_ExisteGT=1;
FrameEnd_ExistsgT=0;


a=VideoReader(Name_Video)
Number_Frames_Video=a.NumberOfFrames;
if Frame1_ExisteGT == 0
Frame1_ExisteGT=1;
end
if exist('FrameEnd_ExistsgT','var')==0
    FrameEnd_ExistsgT=Number_Frames_Video;
end
%type of format desired
Desired_Type_File='.jpg';




vidHeight = a.Height;
vidWidth = a.Width;
%%
Video_Cropped_Name=strcat('Crop',Name_Video);
NumberOfFrames=FrameEnd_ExistsgT-Frame1_ExisteGT;
writerObj1 = VideoWriter(Video_Cropped_Name,'MPEG-4');
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

%% 

%%
for img = Frame1_ExisteGT:NumberOfFrames+Frame1_ExisteGT
    %esta numeraci�n es la que pide el tracker STRUCK para no dar error en
    %la consecuci�n de los frames. 
    if (img-Frame1_ExisteGT+1)<10
        %Para el STRUCK el formato debe ser png. 
        filename=strcat('000',num2str(img-Frame1_ExisteGT+1),Desired_Type_File);
    else
        if (img-Frame1_ExisteGT+1)<100
            filename=strcat('00',num2str(img-Frame1_ExisteGT+1),Desired_Type_File);
        else
            if (img-Frame1_ExisteGT+1)<1000
                filename=strcat('0',num2str(img-Frame1_ExisteGT+1),Desired_Type_File);
            else 
                if (img-Frame1_ExisteGT+1)<10000
                    filename=strcat('',num2str(img-Frame1_ExisteGT+1),Desired_Type_File);
                end
            end
        end
    end
    
    b = read(a, img);
    writeVideo(writerObj1,b);  
    %b= imresize(b,[1080 1920]); %Si se quiere convertir en QVGA
    %imshow(b);
    
    imwrite(b,filename);
    img
end
 writerObj1.FrameRate
 close(writerObj1)


