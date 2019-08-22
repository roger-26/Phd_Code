%This code converts a mp4 file to YCbCr format
% Created by Roger Gomez Nieto - August 22 2019


clc;
close all;
clear all;

addpath('F:\datasets\LIVEVQCPrerelease\LIVEVQCPrerelease');
% Name_Video='A001.mp4';


%para leer todos los archivos .mp4 de la carpeta
files_mp4 = dir('*.mp4');
number_of_videos=size(files_mp4,1)

%convierte todos los videos mp4 de la carpeta a ycbcr 
for video_current=1:number_of_videos
    Name_Video = files_mp4(video_current).name;
    vid1=VideoReader(Name_Video)
    Number_Frames_Video=vid1.NumberOfFrames;
    
    Full_Name_Divided= strsplit(Name_Video,'.');
    %To extract only the name, without the point from extension
    Only_Name_NoExt= char(Full_Name_Divided(1));
    namevideo_msnc=strcat(Only_Name_NoExt,'_ycbcr');
    
    writerObj1 = VideoWriter(namevideo_msnc,'MPEG-4');
    
    
    writerObj1.FrameRate=vid1.FrameRate;
    open(writerObj1);
    Number_Of_Frames=vid1.NumberOfFrames
    for i = 1 : vid1.NumberOfFrames
        im=read(vid1,i);
        
        %obtaining ycbcrrepresentation
        YCBCR=rgb2ycbcr(im);
        %     imgOut=normalize(YCBCR,'range');
        
        
        writeVideo(writerObj1,YCBCR);
        if mod(i,100)==0
            i
        end
    end
    close(writerObj1)
    successful_conversion=1
    video_current
end
