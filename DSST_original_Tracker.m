function  [path_video_output]= tracker_dsst(BB,path_video,path_mainFolder_Tracking)
%ESTA FUNCIÓN EJECUTA EL TRACKER DSST TENIENDO COMO ENTRADA UN VIDEO,
%CONVIERTE ESTE VIDEO EN LOS FRAMES QUE LO COMPONEN, Y LUEGO CONFIGURA CON
%LA ESCALA ADECUADA DEL VIDEO PARA QUE SE MUESTRA EL BB CON LA ESCALA
%CORRECTA, FINALMENTE RETORNA UN VIDEO CON LOS RESULTADOS DEL TRACKING
%MOSTRANDO EL BB (BOUNDING BOX), y la matriz de resultados del tracker

%AUTOR: Roger Gomez Nieto  DATE: 28-08-2018


%% extracting frames from video
% destinationFolder =...
%    '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/imgs';
% Name_Video=...
% '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/043Exp_OutFIG_FQ_C3.mp4';

%cutting video path 
[folder_video,name_video,ext_video] = fileparts(path_video);

Name_Folder_Frames='imgs';
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
Folder_With_Frames = strcat(path_mainFolder_Tracking,'/imgs')
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
%this part generate a txt file with number of frames
%last_frame = length(number_frames_obtained);
name_file_frames=strcat(path_mainFolder_Tracking,'/', name_video,'_frames.txt');
fileID = fopen(name_file_frames,'w');
nbytes = fprintf(fileID,'1,%d',Number_Frames_Video);
fclose(fileID);

%%
%Generate a txt file with Bounding Box given by C++
name_file_GT=strcat(path_mainFolder_Tracking,'/', name_video,'_gt.txt');
%Name_GroundTruth='/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/DSVD_gt.txt';
fileID = fopen(name_file_GT,'w');
dlmwrite(name_file_GT,BB,'delimiter',',');

addpath(genpath('/home/javeriana/roger_gomez/DSST2/DSST2/toolboxpiotr/'))

% run_tracker.m

close all;
% clear all;

%choose the path to the videos (you'll be able to choose one with the GUI)
%base_path = 'sequences/';
%base_path = destinationFolder

%parameters according to the paper
params.padding = 1.0;         			% extra area surrounding the target
params.output_sigma_factor = 1/16;		% standard deviation for the desired translation filter output
params.scale_sigma_factor = 1/4;        % standard deviation for the desired scale filter output
params.lambda = 1e-2;					% regularization weight (denoted "lambda" in the paper)
params.learning_rate = 0.025;			% tracking model learning rate (denoted "eta" in the paper)
params.number_of_scales = 33;           % number of scale levels (denoted "S" in the paper)
params.scale_step = 1.02;               % Scale increment factor (denoted "a" in the paper)
params.scale_model_max_area = 512;      % the maximum size of scale examples

params.visualization = 1;

%*******************************************************************
%ask the user for the video
%video_path = choose_video(base_path);

%Aqui se debería colocar la ruta a las secuencias 
% video_path='sequences/DSVD/'
%***********************************************************
%NO OLVIDAR COLOCAR EL SLASH AL FINAL DE LA RUTA
%************************************************************
%video_path = path
%video_path = strcat(destinationFolder,'/')
% video_path = '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/'
 video_path = strcat(path_mainFolder_Tracking,'/');
%*******************************************************************

if isempty(video_path), return, end  %user cancelled
[img_files, pos, target_sz, ground_truth, video_path] = ...
	load_video_info(video_path);

params.init_pos = floor(pos) + floor(target_sz/2);
params.wsize = floor(target_sz);
params.img_files = img_files;
params.video_path = video_path;

%This fuction its changed for to include positions for original
%size, 3rd parameter
[positions, fps,positions_originals] = dsst(params);

%Con esto escribo los resultados del tracker a un archivo txt
Name_Final_Positions    = strcat(path_mainFolder_Tracking,'/',name_video,'_results.txt');
% Name_Final_Positions=...
%  '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/DSVD_results.txt';
fileID = fopen(Name_Final_Positions,'w');
dlmwrite(Name_Final_Positions,positions_originals,'delimiter',',');

% % calculate precisions
% [distance_precision, PASCAL_precision, average_center_location_error] = ...
%     compute_performance_measures(positions, ground_truth);
% 
% fprintf('Center Location Error: %.3g pixels\nDistance Precision: %.3g %%\nOverlap Precision: %.3g %%\nSpeed: %.3g fps\n', ...
%     average_center_location_error, 100*distance_precision, 100*PASCAL_precision, fps);
%% SAVE VIDEO WITH BB
%Generate a video with BB plotted within it
gt_Initial = importdata(Name_Final_Positions);
%  Original_Video=...
%  '/home/javeriana/roger_gomez/DSST2/DSST2/sequences/DSVD/043Exp_OutFIG_FQ_C3';
 Video_BB_Name=strcat(path_mainFolder_Tracking,'/',name_video,'_BB.mp4');
 %strcat(Original_Video,'_BB.mp4');
vid1 = a;
path_video_output=video_BB_Name
writerObj1 = VideoWriter(Video_BB_Name);
writerObj1.FrameRate=vid1.FrameRate;
open(writerObj1);
Number_Of_Frames=vid1.NumberOfFrames

%esta parte es solo si se quiere generar un viudeo con bb
% disp('generating images with tracking results BB');
% for i = 1 : vid1.NumberOfFrames
%     im=read(vid1,i);
% %                 f = @() rectangle('position',[x y w h]);
%     BB_temporal=gt_Initial(i,:);
%     BB_plot=BB_temporal;
%     %Esto solo es necesario para invertir el width and high of BB
% %     BB_plot(1,3)=BB_temporal(1,4);
% %     BB_plot(1,4)=BB_temporal(1,3)
%     %rect_position = [pos([2,1]) - target_sz([2,1])/2, target_sz([2,1])];
%     f = @() rectangle('position',BB_plot);
%     params = {'linewidth',1,'edgecolor','g'};
%     imgOut = insertInImage(im,f,params);
%     writeVideo(writerObj1,imgOut);
%     if mod(i,30)==0
%         i
%     end
% end
% close(writerObj1)
end