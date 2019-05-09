clc;
close all;
clear all;

% recibe un conjunto de frames ordenados seg�n el nombre y genera un
% archivo mp4
Video_Cropped_Name='007Exp_IndPR_FQ_C2_clipped';
NumberOfFrames=82;
Frames_A_Quitar_AL_Final=0

writerObj1 = VideoWriter(Video_Cropped_Name,'MPEG-4');
writerObj1.FrameRate=10;
open(writerObj1);
extension='.jpg';
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
  writeVideo(writerObj1,im);  
  if (mod(i,100)==0)
      i
  end
end
close(writerObj1)



