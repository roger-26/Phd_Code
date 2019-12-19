function  [ROC_accuracy_pristine, ROC_accuracy, AOS_threshold_array]=...
    Test_ROC_AOS_MVC_NSS_Prueba(Distortion,v,NSS,Cs,Display,saveas, PC,Norm,Generar_MP4)
%function  Test_ROC_AOS_MVC_NSS_Prueba(Distortion,v,NSS,Cs,Display,saveas, PC,Norm)
% Generates success plots from the tracker performance on the video number
% v affected by three levels of the distortion of image quality specified
% by the string Distortion ('pristine', 'MPEG4', 'Gaussian', 'S & P' or
% 'Blur'). NSS = 1 includes NSS features in the SVM training; NSS = 0 uses
% only HOG features. The parameter Cs is the scaling factor for the NSS
% features (Cs = 1 denotes no scaling).

% Test_ROC_AOS_MVC_train Ultima version del tracker

%path(path,'./05_pedestrian3')
%path(path,'./04_pedestrian2')
%path(path,'./03_pedestrian1')
%path(path,'./06_car')
%path(path,'./02_jumping')
path(path,'./functions')
path(path,'./MeanShift_Code')
path(path,'./bbox_configs')
path(path,'./matlab')
path(path,'./videos')
path(path,'./AOS_Results')
addpath '/home/rogergo/Phd_Code/'
Results_Roger_Path = '/home/rogergo/AppDrivenTracker/Results_Roger/';

NSS = logical(NSS);

% List of used videos
%vid_pristineX_Y_Z_A
%X is the consecutive number of original video
%Y is the part of video to be processed
%Z  is the Numero de partes en la cual sera dividido el video
%A is the scale size of video (100 original)
vidName = {...
    'vid_pristine1_1_1_25',...%1
    'vid_pristine2_1_1_25',...
    'vid_pristine3_1_1_25',...
    'vid_pristine4_1_1_25',...
    'vid_pristine5_1_1_25',...
    'vid_pristine6_1_1_25',...
    'vid_pristine7_1_1_25',...
    'vid_pristine8_1_1_25',...
    'vid_pristine9_1_1_25',...
    'vid_pristine10_1_1_25',...
    'vid_pristine11_1_1_25',...
    'vid_pristine12_1_1_25',...
    'vid_pristine13_1_1_25',...
    'vid_pristine14_1_1_25',...
    'vid_pristine15_1_1_25',...
    'vid_pristine16_1_1_25',...
    'vid_pristine17_1_1_25',...
    'vid_pristine18_1_1_25',...
    'vid_pristine19_1_1_25',...
    'vid_pristine20_1_1_25',...
    'vid_pristine21_1_1_25',...
    'vid_pristine22_1_1_25',...
    'vid_pristine23_1_1_25',...
    'vid_pristine24_1_1_25',...
    'vid_pristine25_1_1_25',...
    'vid_pristine26_1_1_25',...
    'vid_pristine27_1_1_25',...
    'vid_pristine28_1_1_25',...
    'vid_pristine29_1_1_25',...
    'vid_pristine30_1_1_25',...
    'vid_pristine31_1_1_25',...
    'vid_pristine32_1_1_25',...
    'vid_pristine33_1_1_25',...
    'vid_pristine34_1_1_25',...
    'vid_pristine35_1_1_25',...
    'vid_pristine36_1_1_25',...
    'vid_pristine37_1_1_25',...
    'vid_pristine38_1_1_25',...
    'vid_pristine39_1_1_25',...
    'vid_pristine40_1_1_25',...
    'vid_pristine41_1_1_25',...
    'vid_pristine42_1_1_25',...
    'vid_pristine43_1_1_25',...
    'vid_pristine44_1_1_25',...
    'vid_pristine45_1_1_25',...
    'vid_pristine46_1_1_25',...
    'vid_pristine47_1_1_25',...
    'vid_pristine48_1_1_25',...
    'vid_pristine49_1_1_25',...
    'vid_pristine50_1_1_25',...
    'vid_pristine51_1_1_25',...
    'vid_pristine52_1_1_25',...
    'vid_pristine53_1_1_25',...
    'vid_pristine54_1_1_25',...
    'vid_pristine55_1_1_25',...
    'vid_pristine56_1_1_25',...
    'vid_pristine57_1_1_25',...
    'vid_pristine58_1_1_25',...
    'vid_pristine59_1_1_25',...
    'vid_pristine60_1_1_25',...
    'vid_pristine61_1_1_25',...
    'vid_pristine62_1_1_25',...
    'vid_pristine63_1_1_25',...
    'vid_pristine64_1_1_25',...
    'vid_pristine65_1_1_25',...
    'vid_pristine66_1_1_25',...
    'vid_pristine67_1_1_25',...
    'vid_pristine68_1_1_25',...
    'vid_pristine69_1_1_25',...
    'vid_pristine70_1_1_25'...
    };

global BlockSize BlockOverlap CellSize Numbins

% Names of ground-truth files for each video
gtName  = {...
    'vid_pristine1_1_1_25_gt',...
    'vid_pristine2_1_1_25_gt',...
    'vid_pristine3_1_1_25_gt',...
    'vid_pristine4_1_1_25_gt',...
    'vid_pristine5_1_1_25_gt',...
    'vid_pristine6_1_1_25_gt',...
    'vid_pristine7_1_1_25_gt',...
    'vid_pristine8_1_1_25_gt',...
    'vid_pristine9_1_1_25_gt',...
    'vid_pristine10_1_1_25_gt',...
    'vid_pristine11_1_1_25_gt',...
    'vid_pristine12_1_1_25_gt',...
    'vid_pristine13_1_1_25_gt',...
    'vid_pristine14_1_1_25_gt',...
    'vid_pristine15_1_1_25_gt',...
    'vid_pristine16_1_1_25_gt',...
    'vid_pristine17_1_1_25_gt',...
    'vid_pristine18_1_1_25_gt',...
    'vid_pristine19_1_1_25_gt',...
    'vid_pristine20_1_1_25_gt',...
    'vid_pristine21_1_1_25_gt',...
    'vid_pristine22_1_1_25_gt',...
    'vid_pristine23_1_1_25_gt',...
    'vid_pristine24_1_1_25_gt',...
    'vid_pristine25_1_1_25_gt',...
    'vid_pristine26_1_1_25_gt',...
    'vid_pristine27_1_1_25_gt',...
    'vid_pristine28_1_1_25_gt',...
    'vid_pristine29_1_1_25_gt',...
    'vid_pristine30_1_1_25_gt',...
    'vid_pristine31_1_1_25_gt',...
    'vid_pristine32_1_1_25_gt',...
    'vid_pristine33_1_1_25_gt',...
    'vid_pristine34_1_1_25_gt',...
    'vid_pristine35_1_1_25_gt',...
    'vid_pristine36_1_1_25_gt',...
    'vid_pristine37_1_1_25_gt',...
    'vid_pristine38_1_1_25_gt',...
    'vid_pristine39_1_1_25_gt',...
    'vid_pristine40_1_1_25_gt',...
    'vid_pristine41_1_1_25_gt',...
    'vid_pristine42_1_1_25_gt',...
    'vid_pristine43_1_1_25_gt',...
    'vid_pristine44_1_1_25_gt',...
    'vid_pristine45_1_1_25_gt',...
    'vid_pristine46_1_1_25_gt',...
    'vid_pristine47_1_1_25_gt',...
    'vid_pristine48_1_1_25_gt',...
    'vid_pristine49_1_1_25_gt',...
    'vid_pristine50_1_1_25_gt',...
    'vid_pristine51_1_1_25_gt',...
    'vid_pristine52_1_1_25_gt',...
    'vid_pristine53_1_1_25_gt',...
    'vid_pristine54_1_1_25_gt',...
    'vid_pristine55_1_1_25_gt',...
    'vid_pristine56_1_1_25_gt',...
    'vid_pristine57_1_1_25_gt',...
    'vid_pristine58_1_1_25_gt',...
    'vid_pristine59_1_1_25_gt',...
    'vid_pristine60_1_1_25_gt',...
    'vid_pristine61_1_1_25_gt',...
    'vid_pristine62_1_1_25_gt',...
    'vid_pristine63_1_1_25_gt',...
    'vid_pristine64_1_1_25_gt',...
    'vid_pristine65_1_1_25_gt',...
    'vid_pristine66_1_1_25_gt',...
    'vid_pristine67_1_1_25_gt',...
    'vid_pristine68_1_1_25_gt',...
    'vid_pristine69_1_1_25_gt',...
    'vid_pristine70_1_1_25_gt'...
    };
% global BlockSize BlockOverlap CellSize Numbins

% List of tests numbers that yielded the best F-score for each video
% (different background distributions)
tests_array = [1, 3, 1, 2, 2, 3, 5, 3, 1, 1, 1, 1, 1, 1, ...
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, ...
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1];
% Array of AOS threshold values for generating success plots
% AOS_threshold_array = linspace(0.1,1,19);
AOS_threshold_array = linspace(0.01,1,99);
ROC_accuracy_pristine = linspace(0.01,1,99);
ROC_accuracy = linspace(0.01,1,99);


% Selected test for the specified video v
% test = tests_array(v);

hogpca=2;
nsspca=2;

saveas=logical(saveas);

u_old=0;
st_old=0;
n_patch_old=0;

tic

% Quality parameters used for generating three severity leves for each
% distortion
switch Distortion
    case 'MPEG4'
        Q = [60 30 0]; % MPEG Compression
    case 'Gaussian'
        Q = [0.01, 0.05, 0.1]; % AWGN
    case 'Blur'
        Q = [5, 10, 15]; % Blur
    case 'S & P'
        Q = [0.01, 0.05, 0.1]; % S & P
    otherwise
        Q = 0;
end


ovrlp = 1/4; %[1/2 1/3 1/4 1/5];

predict_accuracy=zeros(length(Q),1);

% Load pristine results for comparison with distortions
if ~strcmp(Distortion,'pristine')
    
    if NSS
        load(strcat('AOS_Results/AOS_NSS_Video_',num2str(v),'_pristine_Cs',num2str(Cs),'_Norm',...
            num2str(Norm)));
    else
        load(strcat('AOS_Results/AOS_HOG_Video_',num2str(v),'_pristine_Cs',num2str(Cs),'_Norm',...
            num2str(Norm)));
    end
    
    % AOS_pristine = AOS;
    ROC_accuracy_pristine = ROC_accuracy;
    % false_p_pristine = false_p;
end

% Test for each level of distortion
for o = 1 : length(Q)
    load(vidName{v},'frames');
    % Generate distorted version of the video
    switch Distortion
        case 'MPEG4'
            %configurando el bitrate segun el nivel de distorsion
            switch o
                case 1
                    bitrate = 100000;
                    name_toSave_VideoDistorted = strcat(['video' num2str(v) '_high_MPEG4.mp4']);
                case 2
                    bitrate = 1e6/5;
                    name_toSave_VideoDistorted = strcat(['video' num2str(v) '_Medium_MPEG4.mp4']);
                case 3
                    bitrate = 1e7;
                    name_toSave_VideoDistorted = strcat(['video' num2str(v) '_low_MPEG4.mp4']);
            end
            name_Current_Video = strcat('video',num2str(v),'.mp4');
            %to obtain video name to save FPS with personalized name
            %according to the video
            [filepath,Only_name_Video,ext] = fileparts(name_Current_Video)
            %change the path to load the distorted and/or pristine videos
            cd '/home/rogergo/AppDrivenTracker/videos70/'
            % cd '/media/javeriana/HDD_4TB/AppDrivenTracker/videos70/'
            %This conditional only do it one time, Generar_MP4 come as command or parameter to this function 
            if Generar_MP4 ==1
                command_FPS = strcat([...
                    'python3 /home/rogergo/Python_Source_Roger/Phd_Python/read_FPS_Video.py ' ...
                    name_Current_Video ' /home/rogergo/Videos/' Only_name_Video 'FPS.txt']);
                system(command_FPS);
                %absolute path where is saved the txt with FPS video info
                absolute_path_FPS = ['/home/rogergo/Videos/' Only_name_Video 'FPS.txt']
                %read with MATLAB the txt file with FPS info
                fileID = fopen(absolute_path_FPS);
                %is important that be f, to read decimals of FPS
                C = textscan(fileID,'%f');
                fclose(fileID);
                fps = C{1,1}
                disp4234 = ['the FPS for ' Only_name_Video ' is ' num2str(fps)];
                disp(disp4234)
                %generate mp4 distorted video
                string_to_execute = strcat...
                    (['ffmpeg -i ' name_Current_Video ' -r ' num2str(fps) ' -b ' num2str(bitrate) ' ' ...
                    name_toSave_VideoDistorted]);
                system(string_to_execute)
            end
            %             Absolute_Path_Read_Video = strcat(...
            %                 '/media/javeriana/HDD_4TB/AppDrivenTracker/videos70/',name_toSave_VideoDistorted)
            Absolute_Path_Read_Video = strcat(...
                '/home/rogergo/AppDrivenTracker/videos70/',name_toSave_VideoDistorted)
            Data_Video_Distorted_MPEG4 = read_video_ubuntu(Absolute_Path_Read_Video,strcat('video',...
                num2str(v),'.mat'));
            message_disp = ['the video sent by python has the size= ',...
                num2str(size(Data_Video_Distorted_MPEG4))]
            disp(message_disp)
            message_disp2 = ['the pristine video has the size= ',...
                num2str(size(frames))]
            disp(message_disp2)
            %veryfiing if exist difference between number of frames of
            %pristine and mp4 distorted video
            frames_distorted = size(Data_Video_Distorted_MPEG4,1);
            frames_pristine = size(frames,4);
            diff_frames = size(frames,4)-frames_distorted
            %create a variable with the same longitud that pristine video
            new_frame = frames;
            new_frame(:,:,:,1:frames_pristine-diff_frames)=permute(Data_Video_Distorted_MPEG4,[2 3 4 1]);
            %para que coja el mismo numero de frames que las otras
            %distorsiones y el mismo numero que hay en el GT
            %updates frames with distorted video info
            frames = uint8(new_frame);
            %return to folder before add mp4 distortion
            cd '/home/rogergo/AppDrivenTracker/'
            %             cd '/media/javeriana/HDD_4TB/AppDrivenTracker/'
        case 'Gaussian'
            [frames] = vidnoise(uint8(frames),'gaussian',[0, Q(o)]);
            frames = uint8(frames);
        case 'Blur'
            [frames] = vidnoise(uint8(frames),'blur',Q(o));
            frames = uint8(frames);
        case 'S & P'
            [frames] = vidnoise(uint8(frames),'salt & pepper',Q(o));
            frames = uint8(frames);
    end
    
    % Load ground-truth of the video
    load(gtName{v},'gtP');
    
    % Video parameters
    numOfFrames = size(frames,4);
    Height = size(frames,1);
    width = size(frames,2);
    imSize = [Height,width];
    %% adquirir Bounding Box
    %     % Name of the file with the initial object bounding box
    %     bboxName = strcat('bbox_',vidName{v});
    %     % If no initial bounding box, the user has to select it manually
    %     if ~exist(strcat(bboxName,'.mat'),'file')
    %         imshow(uint8(frames(:,:,:,1)),'InitialMagnification',150);
    %         h   = msgbox('Select the object-square region by clicking and dragging','Object Square','modal');
    %         objbbox = floor(getrect);
    %         save(bboxName,'objbbox');
    %     else
    %         load(bboxName,'objbbox');
    %     end
    %%
    
    %estas lineas son para que lea el bounding box del gt, se deben desactivar
    %con un nuevo video y descomentar la seccion anterior
    bboxName = strcat('bbox_',vidName{v});
    objbbox =  gtP(1,:);
    save(bboxName,'objbbox');
    
    
    [objP,context,bgP,bgKeys,binCode,points,bgTsh4,...
        CellSize,BlockSize,...
        BlockOverlap,Numbins,N_HOG] = FBTandMSTInit(objbbox,frames(:,:,:,1));
    
    % Load variables for the video (object and background boxes, etc.)
    %     load(strcat(bboxName,'Test',num2str(test)),...
    %        'objP','bgP','objbbox','context','bgKeys',...
    %        'binCode','points','bgTsh4',...
    %        'CellSize','BlockSize','BlockOverlap','Numbins','N_HOG');
    
    Nbg  = size(bgP,1);     % Number of background patches
    Nobj = size(objP,1);    % Number of object patches
    Nobj_max = N_HOG - Nbg; % Maximum number of possible object patches
    
    objbbox = objP(1,:);
    % MST params
    index_start = 1;
    % Similarity Threshold
    f_thresh = 0.16;
    % Number max of iterations to converge
    max_it = 5;
    % Parzen window parameters
    kernel_type = 'Gaussian';
    radius      = 1;
    % Calculation of the Parzen Kernel window
    [k,gx,gy] = Parzen_window(objbbox(1,4),objbbox(1,3),radius,kernel_type,0);
    
    if size(frames,3)==3
        I = double(rgb2gray(uint8(frames(:,:,:,1))));
    else
        I = double(frames(:,:,:,1));
    end
    % bgPVar_init = patchVariance(I,bgP);
    
    % Initial sliding window patches
    wP = slidingWindow(1,1,imSize(2),imSize(1),objbbox(3),objbbox(4),ovrlp);
    objFrames = ones(Nobj,1);
    
    % Display the video frames during processing
    if Display
        figure; imshow(uint8(drawPatches(frames(:,:,:,1),objbbox(1,:),1)));
    end
    objboxdraw = objbbox(1,:);
    
    % Extraction of HOG and NSS features from all the patches
    %     hogS   = hogFeat(I,[objP;bgP]);
    [featuresS,u_old,st_old,n_patch_old] = hogNSSFeat(I,[objP;bgP],NSS,Cs,Norm,u_old,st_old,n_patch_old);
    if NSS
        hogS = featuresS(:,1:end-36);
        nssS = featuresS(:,end-35:end);
        if PC
            hogS = PCA_(hogS,hogpca);
            nssS = PCA_(nssS,nsspca);
        end
    else
        hogS = featuresS;
        if PC
            hogS = PCA_(hogS,hogpca);
        end
    end
    
    % Averages of HOG features for object and background patches
    hogSobj_avg = mean(hogS(1:Nobj,:));
    hogSbg_avg  = mean(hogS(Nobj+1:Nobj+Nbg,:));
    
    % Euclidean distances between object and bg HOG features to the average
    dist1 = pdist2(hogS(1:Nobj,:),hogSobj_avg);
    dist2 = pdist2(hogS(Nobj+1:Nobj+Nbg,:),hogSbg_avg);
    [dist1_,Idist1] = sort(dist1,'ascend');
    [~,Idist2] = sort(dist2,'ascend');
    
    % Sort HOG features
    hogS(1:Nobj,:) = hogS(Idist1,:);
    hogS(Nobj+1:Nobj+Nbg,:) = hogS(Idist2+Nobj,:);
    bgKeys = bgKeys(Idist2);
    
    % Sort and concatenate NSS features
    if NSS
        nssS(1:Nobj,:) = nssS(Idist1,:);
        nssS(Nobj+1:Nobj+Nbg,:) = nssS(Idist2+Nobj,:);
        featuresS = [hogS, nssS];  % Concatenation of NSS features to HOG features
    else
        featuresS = hogS;  % Only HOG features
    end
    
    % Training of SVM classifier
    %     model = svmtrain([ones(Nobj,1);zeros(Nbg,1)],double(featuresS),'-t 0 -c 100');
    model = svmtrain2([ones(Nobj,1);zeros(Nbg,1)],double(featuresS),'-t 0 -c 100');
    % Accuracy of SVM classifier prediction
    [~, accuracy_L, ~] = svmpredict2([ones(Nobj,1);zeros(Nbg,1)],featuresS,model);...
        %%OJO ESTABA SIN PUNTO Y COMA
    predict_accuracy(o ,1) = accuracy_L(1)/100;
    
    % Neighbouring window for object search
    D = searchWindow(objbbox);
    
    flag = zeros(1,size(frames,4));     % MST flag
    objbbox = zeros(size(frames,4),4);
    objbbox(1,:) = objP(1,:);
    Length = size(frames,4);
    
    patch_width = objbbox(1,3); patch_height = objbbox(1,4);
    
    % Loops from the second frame to the end
    for i = 2 : size(frames,4)
        percentage = i*100/size(frames,4)
        
        % Convert current frame to grayscale
        if size(frames,3)==3
            I = double(rgb2gray(uint8(frames(:,:,:,i))));
        else
            I = double(frames(:,:,:,i));
        end
        
        % If the object was detected in the previous frame, search in the
        % neighbouring window
        if sum(isnan(objbbox(i-1,:)))==0
            bbox = ones(size(D,1),1)*objbbox(i-1,:) + D; % posible bboxes where the object is located in frame t + 1
            % Remove boxes outside the frame
            bbox(bbox(:,1)<1 | bbox(:,2)<1 | (bbox(:,1)+bbox(:,3)-1)>width | (bbox(:,2)+bbox(:,4)-1)>...
                Height,:)=[];
            
            %             hogS_nxt = hogFeat(I,bbox); % HOG features of the window boxes
            
            % HOG and NSSfeatures of the window boxes
            [features_nxt,u_old,st_old,n_patch_old] = hogNSSFeat(I,bbox,NSS,Cs,Norm,u_old,st_old,...
                n_patch_old);
            
            % If there is ground-truth for the current frame
            if isempty(find(isnan(gtP(i,:)), 1))
                % Adjust size of ground-truth patch to match object patches
                gt_center = [gtP(i,1)+round(gtP(i,3)/2), gtP(i,2)+round(gtP(i,4)/2)];
                gtP(i,:) = [gt_center(1)-round(patch_width/2), gt_center(2)-round(patch_height/2),...
                    patch_width, patch_height];
                
                % Label as matches the window patches with overlap greater
                % than 0.7 with the ground-truth for accuracy estimation
                labels_gt = bboxOverlapRatio(gtP(i,:),bbox)>=0.7;
                
                % SVM classifier prediction
                [labels, ~, ~] = svmpredict2(double(labels_gt'),features_nxt,model);
                predict_accuracy(o,i) = length(find(labels(labels_gt)))/length(find(labels_gt));
                
                % If there is no ground-truth for the current frame, does not
                % calculate prediction accuracy
            else
                [labels, ~, ~] = svmpredict2(ones(size(bbox,1),1),features_nxt,model);
                predict_accuracy(o,i) = NaN;
            end
            
            % Select patches that were classified as object (1)
            objP_nxt = bbox(labels==1,:);
            
            % If the object was not detected in the previous frame, search in
            % the whole frame (wP)
        else
            %             hogS_nxt = hogFeat(I,wP);
            [features_nxt,u_old,st_old,n_patch_old] = hogNSSFeat(I,wP,NSS,Cs,Norm,u_old,...
                st_old,n_patch_old);
            
            
            if isempty(find(isnan(gtP(i,:)), 1))
                gt_center = [gtP(i,1)+round(gtP(i,3)/2), gtP(i,2)+round(gtP(i,4)/2)];
                gtP(i,:) = [gt_center(1)-round(patch_width/2), gt_center(2)-round(patch_height/2),...
                    patch_width, patch_height];
                
                labels_gt = bboxOverlapRatio(gtP(i,:),wP)>=0.7;
                [labels, ~, ~] = svmpredict2(double(labels_gt'),features_nxt,model);
                predict_accuracy(o,i) = length(find(labels(labels_gt)))/length(find(labels_gt));
            else
                [labels, ~, ~] = svmpredict2(ones(size(wP,1),1),features_nxt,model);
                predict_accuracy(o,i) = NaN;
            end
            objP_nxt = wP(labels==1,:);
        end
        
        % If the object was not detected in the current frame but it was
        % found in the previous frame, use MST
        if isempty(objP_nxt) && sum(isnan(objbbox(i-1,:)))==0
            flag(i) = 1;    % MST flag
            T_ = selectPatch(frames(:,:,:,i-1),objbbox(i-1,:));
            x0=objbbox(i-1,1); y0= objbbox(i-1,2);
            W1 =objbbox(i-1,3); H = objbbox(i-1,4);
            
            % Conversion from RGB to Indexed colours
            % to compute the colour probability functions (PDFs)
            
            if size(frames,3) == 3
                [~,map] = rgb2ind(frames(:,:,:,i-1),65536);
                T = rgb2ind(T_,map);
            else
                [~,map] = gray2ind(frames(:,:,:,i-1),65536);
                T = gray2ind(T_,65536);
            end
            Lmap = length(map)+1;
            % Estimation of the target PDF
            q = Density_estim(T,Lmap,k,H,W1,0);
            % Flag for target loss
            loss = 0;
            % Similarity evolution along tracking
            f = zeros(1,(Length-1)*max_it);
            % Sum of iterations along tracking and index of f
            f_indx = 1;
            %%%% TRACKING
            for t=i
                % Next frame
                if size(frames,3) == 3
                    I2 = rgb2ind(frames(:,:,:,i),map);
                else
                    I2 = gray2ind(frames(:,:,:,i),65536);
                end
                % Apply the Mean-Shift algorithm to move (x,y)
                % to the target location in the next frame.
                [x,y,loss,f,f_indx] = MeanShift_Tracking(q,I2,Lmap,...
                    Height,width,f_thresh,max_it,x0,y0,H,W1,k,gx,...
                    gy,f,f_indx,loss);
                % Check for target loss. If true, end the tracking
                if loss == 1
                    break;
                else
                    y0 = y;
                    x0 = x;
                end
            end
            if loss == 0
                objP_nxt = round([x0,y0,W1,H]); % Object detected
            else
                objP_nxt = [NaN,NaN,NaN,NaN];  % Object not detected
            end
        end
        
        % If the object was detected
        if ((sum(isnan(objP_nxt))==0) & (isempty(objP_nxt)==0))
            % object location estimation
            overlap  = (sum(bboxOverlapRatio(objP_nxt,objP_nxt))-1)';
            objP_nxt_= objP_nxt(overlap>=max(overlap)*0.8,:);
            objbbox(i,:)  = (size(objP_nxt,1)==1)*objP_nxt(1,:) + (1-(size(objP_nxt,1)==1))*round...
                (median(objP_nxt_));
            
            % Update object model and retrain SVM
            if flag(i) == 0
                
                if NSS
                    [hogS,~,nssS,u_old,st_old,n_patch_old] = bgUpdateNSS(I,'mvc',0.05,objbbox(i,:),...
                        bgP,bgKeys,hogS,nssS,Cs,Norm,u_old,st_old,n_patch_old);
                    if PC
                        hogS=PCA_(hogS,hogpca);
                        nssS=PCA_(nssS,hogpca);
                    end
                else
                    
                    [hogS,u_old,st_old,n_patch_old,~] = bgUpdate(I,'mvc',0.05,objbbox(i,:),bgP,...
                        bgKeys,hogS,Norm,u_old,st_old,n_patch_old);
                    if PC
                        hogS=PCA_(hogS,hogpca);
                    end
                end
                
                I_objP  = selectPatch(I,objbbox(i,:));
                objCode = briefDescriptor(I_objP,points);
                if min(pdist2(objCode,binCode,'hamming')) <= bgTsh4
                    disp(':|')
                    %                         hogSobj   = hogFeat(I,objbbox(i,:));
                    [featuresSobj,u_old,st_old,n_patch_old] = hogNSSFeat(I,objbbox(i,:),NSS,Cs,Norm,u_old,...
                        st_old,n_patch_old);
                    if NSS
                        hogSobj = featuresSobj(:,1:end-36);
                        nssSobj= featuresSobj(:,end-35:end);
                        if PC
                            hogSobj=PCA_(hogSobj,hogpca);
                            nssSobj=PCA_(nssSobj,hogpca);
                        end
                    else
                        hogSobj = featuresSobj;
                        if PC
                            hogSobj=PCA_(hogSobj,hogpca);
                        end
                    end
                    
                    dist1_add = sqrt(sum((hogSobj - hogSobj_avg).^2,2));
                    if Nobj == Nobj_max
                        hogS(Nobj,:) = hogSobj;
                        objP(Nobj,:) = objbbox(i,:);
                        objFrames(Nobj) = i;
                        binCode(Nobj,:) = objCode;
                        dist1(Nobj)     = dist1_add;
                        if NSS
                            nssS(Nobj,:) = nssSobj;
                        end
                    else
                        hogS    = [hogS(1:Nobj,:);hogSobj;hogS(Nobj+1:Nobj+Nbg,:)];
                        objP    = [objP;objbbox(i,:)];
                        objFrames = [objFrames;i];
                        binCode   = [binCode;objCode];
                        dist1     = [dist1_;dist1_add];
                        if NSS
                            nssS    = [nssS(1:Nobj,:);nssSobj;nssS(Nobj+1:Nobj+Nbg,:)];
                        end
                        Nobj      = Nobj + 1;
                    end
                end
                [dist1_,Idist1] = sort(dist1,'ascend');
                hogS(1:Nobj,:) = hogS(Idist1,:);
                binCode = binCode(Idist1,:);
                objFrames = objFrames(Idist1);
                objP    = objP(Idist1,:);
                hogS(Nobj+1:Nobj+Nbg,:) = hogS(Idist2+Nobj,:);
                hogSobj_avg = mean(hogS(1:Nobj,:));
                hogSbg_avg  = mean(hogS(Nobj+1:Nobj+Nbg,:));
                
                if NSS
                    nssS(1:Nobj,:) = nssS(Idist1,:);
                    nssS(Nobj+1:Nobj+Nbg,:) = nssS(Idist2+Nobj,:);
                    featuresS = [hogS, nssS];  % Concatenation of NSS features to HOG features
                else
                    featuresS = hogS;  % Only HOG features
                end
                
                model = svmtrain2([ones(Nobj,1);zeros(Nbg,1)],double(featuresS),'-t 0 -c 100');
            end
        else
            objbbox(i,:) = [NaN,NaN,NaN,NaN];  % Object not detected (lost)
        end
        if isempty(find(isnan(objbbox(i,:)),1))
            objboxdraw = objbbox(i,:);
            object_found(i) = 1;
        else
            object_found(i) = 0;
        end
        if objboxdraw(1) < 0
            objboxdraw(3) = objboxdraw(3) + objboxdraw(1) - 1;
            objboxdraw(1) = 1;
        end
        if objboxdraw(2) < 0
            objboxdraw(4) = objboxdraw(4) + objboxdraw(2) - 1;
            objboxdraw(2) = 1;
        end
        
        % Display frame and object box
        if Display
            title(['Frame ',num2str(i)]);
            if object_found(i)
                imshow(uint8(drawPatches(frames(:,:,:,i),objboxdraw,1)));
            else
                imshow(uint8(frames(:,:,:,i)));
            end
        end
        toc
    end
    [fs(o),precision(o),recall(o),overlap] = fscore(objbbox,gtP);
    total_object_found(o,:) = object_found;
    flag_lvl(o,:) = flag;
    
    % Estimate AOS score
    for thresh = 1:length(AOS_threshold_array)
        AOS_thresh = AOS_threshold_array(thresh);
        [AOS(o,thresh), false_p(o,thresh), ROC_accuracy(o,thresh), ~] = AOS_score(objbbox,...
            gtP,AOS_thresh);
    end
    if Display
        close
    end
end

toc

% Generate success plots for every level of distortion and the pristine
% video in one figure
if saveas
    
    color_array = 'brmgck';
    
    figure;
    if ~strcmp(Distortion,'pristine')
        plot(AOS_threshold_array,ROC_accuracy_pristine(1,:),'k','DisplayName','Pristine');
        hold on, grid on;
        aux3 = ROC_accuracy_pristine(1,:);
        aux4 = vidName(v);
        name_video = strcat(aux4{1,1},Distortion);;
        AUC_Video_Pristine = trapz(AOS_threshold_array,ROC_accuracy_pristine(1,:));
        for o = 1:length(Q)
            %plot(false_p(o,:),ROC_accuracy(o,:),color_array(o),'DisplayName',num2str(o));
            plot(AOS_threshold_array,ROC_accuracy(o,:),color_array(o),'DisplayName',num2str(Q(o)));
            grid on;
            AUC_Video_Distorted(o) = trapz(AOS_threshold_array,ROC_accuracy(o,:));
            Data_Video_Distorted(o,:,:)=ROC_accuracy(o,:);
        end
        hold off
        if NSS
            title(sprintf('Video %u, %s distortion with NSS',v,Distortion));
            name_file_2_Save = strcat(name_video,'_withNSS','_Norm',num2str(Norm));
        else
            title(sprintf('Video %u, %s distortion only HOG',v,Distortion));
            name_file_2_Save = strcat(name_video,'_onlyHOG','_Norm',num2str(Norm));
        end
        save(strcat(Results_Roger_Path,...
            name_file_2_Save),'Data_Video_Distorted', 'AUC_Video_Distorted')
        %         save(strcat('/media/javeriana/HDD_4TB/AppDrivenTracker/Results_Roger/',...
        %             name_file_2_Save),'Data_Video_Distorted', 'AUC_Video_Distorted')
    else
        aux3 = ROC_accuracy(1,:);
        aux4 = vidName(v);
        name_video = aux4{1,1};
        AUC_Video = trapz(AOS_threshold_array,ROC_accuracy(1,:));
        plot(AOS_threshold_array,ROC_accuracy(1,:),'k','DisplayName','Pristine');
        if NSS
            title(sprintf('Video %u pristine with NSS',v));
            name_file_2_Save = strcat(name_video,'_withNSS','_Norm',num2str(Norm));
        else
            title(sprintf('Video %u pristine only HOG',v));
            name_file_2_Save = strcat(name_video,'_onlyHOG','_Norm',num2str(Norm));
        end
        %guardo el AUC y los valores del plot para cada video
        save(strcat(Results_Roger_Path,....
            name_file_2_Save),'AOS_threshold_array','aux3', 'AUC_Video')
    end
    
    plot_ax = gca;
    plot_ax.FontSize = 16;
    xlabel('Overlap threshold');
    ylabel('Success rate');
    legend('show','Location','southwest');
    %saveas(gcf,strcat('./SVM_new_results/Video_',num2str(v),'_SP_',Distortion,'_Cs',num2str(Cs)),'epsc');
    %saveas(gcf,strcat('./SVM_new_results/Video_',num2str(v),'_SP_',Distortion,'_Cs',num2str(Cs)),'png');
    %close;
    
    % Save tests results
    if NSS
        if strcmp(Distortion,'S & P')
            save(strcat('AOS_Results/AOS_NSS_Video_',num2str(v),'_S_P_Cs',num2str(Cs),...
                '_Norm',num2str(Norm)),'predict_accuracy','AOS','ROC_accuracy','false_p','fs',...
                'total_object_found','flag_lvl');
        else
            save(strcat('AOS_Results/AOS_NSS_Video_',num2str(v),'_',Distortion,'_Cs',num2str(Cs),...
                '_Norm',num2str(Norm)),'predict_accuracy','AOS','ROC_accuracy','false_p','fs',...
                'total_object_found','flag_lvl');
        end
    else
        if strcmp(Distortion,'S & P')
            save(strcat('AOS_Results/AOS_HOG_Video_',num2str(v),'_S_P','_Norm',num2str(Norm)),...
                'predict_accuracy','AOS','ROC_accuracy','false_p','fs','total_object_found',...
                'flag_lvl');
        else
            save(strcat('AOS_Results/AOS_HOG_Video_',num2str(v),'_',Distortion,'_Cs',num2str(Cs),...
                '_Norm',num2str(Norm)),'predict_accuracy','AOS','ROC_accuracy','false_p','fs',...
                'total_object_found','flag_lvl');
        end
    end
    
    for o = 1 : length(Q)
        formatSpec = 'In level %u the portion of frames where MS was used is %d.';
        str = sprintf(formatSpec,o,sum(flag_lvl(o,:))/numOfFrames)
    end
end
