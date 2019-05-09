function [Number_Frames_Video,name_video] = generate_imgs_groudtruth_from_video(path_video,BB)
[folder_video,name_video,ext_video] = fileparts(path_video);

Name_Folder_Frames='img';
path_mainFolder_Tracking=strcat('/home/javeriana/roger_gomez/STRCF/sequences/',name_video);
%creating folder for save images (required for DSST Tracker)
mkdir( fullfile(path_mainFolder_Tracking, Name_Folder_Frames) );


Want_Resize = 0; % write 1 if want resize frame
%type of format desired
Desired_Type_File   ='.jpg';
Name_Images         = ''; 
a                   =VideoReader(path_video);
Number_Frames_Video =a.NumberOfFrames;
%Add an offset for don't initiate since frame 1
Last_Numbre=0;
disp('generating frames from video')
Folder_With_Frames = strcat(path_mainFolder_Tracking,'/img');
for img = 1+Last_Numbre:Number_Frames_Video+Last_Numbre
    %esta numeración es la que pide el tracker STRUCK para no dar error en
    %la consecución de los frames. 
    filename        =strcat(Name_Images,num2str(img,'%04i'),Desired_Type_File);
    fullDestinationFileName = fullfile(Folder_With_Frames, filename);
    b               = read(a, img-Last_Numbre); 
    if Want_Resize == 1
        b = imresize(b , desired_size); %Si se quiere convertir en QVGA
    end
    %imshow(b);
    imwrite(b,fullDestinationFileName,'jpg');
     if mod(img,200)==0
        img
    end
end


%this part generate a txt file with number of frames
%last_frame = length(number_frames_obtained);
name_file_frames=strcat(path_mainFolder_Tracking,'/', name_video,'_frames.txt');
fileID = fopen(name_file_frames,'w');
nbytes = fprintf(fileID,'1,%d',Number_Frames_Video);
fclose(fileID);


%%
%Generate a txt file with Bounding Box given by C++
name_file_GT=strcat(path_mainFolder_Tracking,'/', 'groundtruth_rect.txt');
%Name_GroundTruth='/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/DSVD_gt.txt';
fileID = fopen(name_file_GT,'w');
dlmwrite(name_file_GT,BB,'delimiter',',');

end