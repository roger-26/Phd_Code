function [Number_Of_Frames] = ...
Generate_Frames_From_Video(path_frames,path_video, Desired_Type_File,Initial_Frame, change_size_flag, new_high, new_width)

%este codigo convierte un video en frames en una carpeta dada

%path_video --> Path where is the video i.e.
%'D:\javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_blur_high\video1_blur_high.mp4' 
%path_frames --> Path where you want to save the video i.e.'D:\javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_blur_high\video1_blur_high.mp4'
%('D:\javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_blur_high')
%Desired_Type_File --> Format to save the images ('jpg', 'png')
%Initial_Frame --> If you want to save since frame different to the first, add this offset, i.e. if you want to save 
%from frame 10, this value must be 9, default is 0
%change_size_flag --> 1 if you want to change the size of images respect to original video
%path_frames --> Folder where will save the frames of video
%Number_Of_Frames --> returns the number of frames of video
%Roger Gomez Nieto   24 june 2020 - rogergomez@ieee.org

%% extracting frames from video
% destinationFolder =  path_video;
% %    'D:\javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_blur_high';
% Name_Video=...
% 'D:\javeriana\current_work\tracker_prediction\Test_Videos_Tracking\video1_blur_high\video1_blur_high.mp4';

%cutting video path 
[folder_video,name_video,ext_video] = fileparts(path_video);

% Name_Folder_Frames='img';
% %creating folder for save images (required for DSST Tracker)
% mkdir( fullfile(folder_video, Name_Folder_Frames) );

% change_size_flag = 0 % write 1 if want resize frame
% Desired_Type_File   ='.jpg';%type of format desired
Name_Images         = ''; 
a                   =VideoReader(path_video);
Number_Of_Frames =a.NumberOfFrames;
Number_frames_newFunction = a.NumFrames;
% Initial_Frame=0; %Add an offset for don't initiate since frame 1
disp('generating frames from video')
% Folder_With_Frames = strcat(folder_video,'/img')
for img = 1+Initial_Frame:Number_Of_Frames
    %esta numeración es la que pide el tracker STRUCK para no dar error en
    %la consecución de los frames. 
    filename        =strcat(Name_Images,num2str(img,'%04i'),'.',Desired_Type_File);
    fullDestinationFileName = fullfile(path_frames, filename);
    b               = read(a, img-Initial_Frame); 
    if change_size_flag == 1
        b = imresize(b , desired_size); %Si se quiere convertir en QVGA
    end
    %imshow(b);
    imwrite(b,fullDestinationFileName,Desired_Type_File);
     if mod(img,50)==0
        img
    end
end
%this part generate a txt file with number of frames
%last_frame = length(number_frames_obtained);
name_file_frames=strcat(path_frames,'/', name_video,'_frames.txt');
fileID = fopen(name_file_frames,'w');
nbytes = fprintf(fileID,'1,%d',Number_Of_Frames);
fclose(fileID);
end