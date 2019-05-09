function  [results, ground_truth]= Call_Eco_Tracker(path_video,path_mainFolder_Tracking)
% This demo script runs the ECO tracker with deep features on the
% included "Crossing" video.

%En la carpeta path_mainFolder_Tracking debe estar el GT, con nombre groundtruth_rect.txt



[folder_video,name_video,ext_video] = fileparts(path_video);

Name_Folder_Frames='img';
%creating folder for save images (required for DSST Tracker)
mkdir( fullfile(path_mainFolder_Tracking, Name_Folder_Frames) );

Want_Resize = 0 % write 1 if want resize frame
%type of format desired
Desired_Type_File   ='.jpg';
Name_Images         = '';
a                   =VideoReader(path_video);
Number_Frames_Video =a.NumberOfFrames;
%Add an offset for don't initiate since frame 1
Last_Numbre=0;
disp('generating frames from video')
Folder_With_Frames = strcat(path_mainFolder_Tracking,'/img')
for img = 1+Last_Numbre:Number_Frames_Video+Last_Numbre
    %esta numeración es la que pide el tracker STRUCK para no dar error en
    %la consecución de los frames.
    filename        =strcat(Name_Images,num2str(img,'%08i'),Desired_Type_File);
    fullDestinationFileName = fullfile(Folder_With_Frames, filename);
    b               = read(a, img-Last_Numbre);
    if Want_Resize == 1
        b = imresize(b , desired_size); %Si se quiere convertir en QVGA
    end
    %imshow(b);
    imwrite(b,fullDestinationFileName,'jpg');
    if mod(img,50)==0
        img
    end
end



%Esto no hay que moverlo
% Add paths
setup_paths();

% Load video information
video_path =path_mainFolder_Tracking;
%se tuvo que cambiar el nombre a la funcion load_video_info porque el
%tracker DSST tiene una que se llama igual
[seq, ground_truth] = load_video_info_ECO(video_path);

% Run ECO
results = testing_ECO_gpu(seq);

end

