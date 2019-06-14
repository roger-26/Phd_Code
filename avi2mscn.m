function [successful_conversion]=avi2mscn(Name_Video,path2folder)
% This code converts a RGB video in AVI format to MSCN (Mean Substracted Contrast Normalization
% Format)
% Roger Gomez Nieto -  June 12 2019

% Read the AVI file
% addpath('C:\Users\DeepLearning_PUJ\Documents\javeriana')
addpath(path2folder);
% Name_Video='0723_ManUnderTree_GS5_03_20150723_130016.avi'

vid1=VideoReader(Name_Video)
Number_Frames_Video=vid1.NumberOfFrames;

 Full_Name_Divided= strsplit(Name_Video,'.');
    %To extract only the name, without the point from extension
    Only_Name_NoExt= char(Full_Name_Divided(1));
namevideo_msnc=strcat(Only_Name_NoExt,'_mscn');

writerObj1 = VideoWriter(namevideo_msnc,'Uncompressed AVI');


writerObj1.FrameRate=vid1.FrameRate;
open(writerObj1);
Number_Of_Frames=vid1.NumberOfFrames
for i = 1 : vid1.NumberOfFrames
    im=read(vid1,i);

    %obtaining mscn representation
    [score,activityMask,noticeableArtifactsMask,noiseMask,mscn_aux] = my_piqe(im);
    imgOut=normalize(mscn_aux,'range');
    
    
    writeVideo(writerObj1,imgOut);
    if mod(i,100)==0
    i
    end
end
close(writerObj1)
successful_conversion=1;