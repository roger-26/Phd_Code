function  [results, ground_truth_original]= ...
    Call_MCCT_Tracker(path_video,path_mainFolder_Tracking, name_video)
%% creación de la carpeta con imágenes
[folder_video,name_video_Noutilizable,ext_video] = fileparts(path_video);

Name_Folder_Frames='img';
% %para el MCCT se debe crear una carpeta con el nombre del video
 Video_Folder= fullfile(path_mainFolder_Tracking, name_video) ;
 mkdir(Video_Folder)

%loading GT
path_groundtruth = strcat(Video_Folder, '/','groundtruth_rect.txt'); 
delimiter = ',';
ground_truth_original = importdata(path_groundtruth,delimiter);


Want_Resize = 0 % write 1 if want resize frame
%type of format desired
Desired_Type_File   ='.jpg';
Name_Images         = '';
a                   =VideoReader(path_video);
Number_Frames_Video =a.NumberOfFrames;
%Add an offset for don't initiate since frame 1
Last_Numbre=0;
disp('generating frames from video')
Folder_With_Frames = strcat(Video_Folder,'/img')
mkdir(Folder_With_Frames)
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
    if mod(img,50)==0
        img
    end
end

%Tracker MCCT
addpath('./tracker');
addpath('./utility');
addpath('model','matconvnet/matlab');
vl_setupnn();
%%% Note that the default setting is CPU. TO ENABLE GPU, please recompile the MatConvNet toolbox
vl_compilenn('enableGpu',true);
global enableGPU;
enableGPU = true;
params.visualization = 1;                  % show output bbox on frame

%% load video info
videoname = name_video;
img_path =strcat(Folder_With_Frames,'/');
base_path = strcat(path_mainFolder_Tracking,'/');
[img_files, pos, target_sz, video_path] = load_video_info_MCCT(base_path, videoname);

%% DCF related
params.hog_cell_size = 4;
params.fixed_area = 200^2;                 % standard area to which we resize the target
params.n_bins = 2^5;                       % number of bins for the color histograms (bg and fg models)
params.lr_pwp_init = 0.01;                 % bg and fg color models learning rate
params.inner_padding = 0.2;                % defines inner area used to sample colors from the foreground
params.output_sigma_factor = 0.1;          % standard deviation for the desired translation filter output
params.lambda = 1e-4;                      % regularization weight
params.lr_cf_init = 0.01;                  % DCF learning rate
params.period = 5;                         % time period, \Delta t
params.update_thres = 0.7;                 % threshold for adaptive update
params.expertNum = 7;

%% scale related
params.hog_scale_cell_size = 4;            % from DSST
params.learning_rate_scale = 0.025;
params.scale_sigma_factor = 1/2;
params.num_scales = 33;
params.scale_model_factor = 1.0;
params.scale_step = 1.03;
params.scale_model_max_area = 32*16;

%% start trackerMain.m
im = imread([img_path img_files{1}]);
% is a grayscale sequence ?
if(size(im,3)==1)
    params.grayscale_sequence = true;
end
if(size(im,3)==3)
    params.grayscale_sequence = false;
end
params.img_files = img_files;
params.img_path = img_path;
% init_pos is the centre of the initial bounding box
params.init_pos = pos;
params.target_sz = target_sz;
[params, bg_area, fg_area, area_resize_factor] = initializeAllAreas(im, params);
if params.visualization
    params.videoPlayer = vision.VideoPlayer('Position', [100 100 [size(im,2), size(im,1)]+30]);
end
% start the actual tracking
results = trackerMain(params, im, bg_area, fg_area, area_resize_factor);
end
