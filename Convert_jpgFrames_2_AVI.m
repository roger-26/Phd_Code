function [] = Convert_jpgFrames_2_AVI(fps,NumberOfFrames,number_zeros,folder_jpg_frames,folder_tosave_video,name_video)

%generate a AVI Uncompressed o MP4 file from a set of frames 
%genera un archivo mp4 a partir de frames jpg


%parameters
% fps = Number of frames per second for the video
% folder_jpg_frames folder that contains the frames to generate the video e.g. 'G:\datasets\VOT2019\SequenceBallet\';
% folder_tosave_video--> Folder where the will be save the resulting video e.g. 'G:\datasets\VOT2019\';
% name_video --> name for the resulting video e.g. 'SequenceBallet';
% NumberOfFrames--> Number of frames available to generate the video e.g. 1389;
% number_zeros --> Number of zeros that contains the name of the first frame e.g. 00000001.jpg is 7;


writerObj1 = VideoWriter(strcat(folder_tosave_video,name_video),'Uncompressed AVI');
writerObj1.FrameRate=fps;
open(writerObj1);
switch number_zeros
    case 7
        adittional_zeros = '0000';
    case 6
        adittional_zeros = '000';
    case 5
        adittional_zeros = '00';
    case 4
        adittional_zeros = '0';
    otherwise
        adittional_zeros = '';
end
for i = 1 : NumberOfFrames
    if i<10
        name=strcat(adittional_zeros,'000',num2str(i),'.jpg');
    elseif i<100
        name=strcat(adittional_zeros,'00',num2str(i),'.jpg');
    elseif i<1000
        name=strcat(adittional_zeros,'0',num2str(i),'.jpg');
    elseif i<10000
        name=strcat(adittional_zeros,'',num2str(i),'.jpg');
    end
    name_image = strcat(folder_jpg_frames,name);
    im=imread(name_image);
    writeVideo(writerObj1,im);
    i
end
close(writerObj1)
end