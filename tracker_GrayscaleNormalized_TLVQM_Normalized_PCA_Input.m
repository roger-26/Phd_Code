% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function: implement the dlssvm tracker                             %
% parameters:                                                        %
%      input: path of image sequences                                %
%      ext:extension name of file, for example, '.jpg'               %
%      show_img:                                                     %
%      init_rect: initial position of the target                     %
%      start_frame:                                                  %
%      end_frame:                                                    %
%      s_frames: the number of frames                                %
%                                                                    %
% ********************************************************************
%     you need configure the opencv for run this program.            %
%     The program is successfully run under opencv 2.4.8             %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [result] = tracker_TLVQM_Features_PCA_Input(input, ext, show_img, init_rect, start_frame, end_frame, prep, s_frames)

% Display runtime result

% vgt = zeros(size(init_rect,1),1);
% vgt(randi([1, length(vgt)],1,5)) = 1;
% vgt(1) = 1;
%vgt(11:15) = 1;

global HC_LC_Combined;

addpath(genpath('.'));
D = dir(fullfile(input, ['*.', ext]));
file_list = { D.name };
% Load images 'input/*.ext' to file_list

if nargin < 4
    init_rect = -ones(1, 4);
    % The default starting rectangle is [x=-1, y=-1, w=-1, h=-1]
end

if size(init_rect,1) > 1
    ground_truth = init_rect;
    init_rect = ground_truth(1,:);
    gt = true;
else
    gt = false;
end


if nargin < 5
    start_frame = 1;
    % Default starting frame
end
if nargin < 6
    end_frame = numel(file_list);
    % Default ending frame
end

if end_frame > numel(file_list)
    end_frame = numel(file_list);
end

vw0=[];

global sampler
global tracker
global config
global finish

config.display = true;
% Whether to display runtime result.
% This is redundant because in "makeConfig.m", it will be set to show_img

sampler = createSampler();
% THIS IS JUST:
% sampler.radius = 1

finish = 0;
timer = 0;
result.res = nan(end_frame - start_frame + 1, 4);
% "nan()" is like "ones()", NaNs instead of 1's
% e.g., nan(1,1) is [NaN] and nan(2) is [Nan NaN; NaN NaN]
result.len = end_frame - start_frame + 1;
result.startFrame = start_frame;
result.type = 'rect';

if show_img
    figure(1);
    set(1,'KeyPressFcn', @handleKey);
    % You can press any key interrupt the execution.
end

output = zeros(1,4);

patterns = cell(1, 1);
% Don't know what is "cell"? See: https://www.mathworks.com/help/matlab/ref/cell.html

params = makeParams();
% THIS IS JUST:
% params.lambda = 100
% params.nBudget = 100

k = 1; % Pattern index
%outv = zeros(result.len,4);

%% Crear folder para guardar los frames con las modificaciones de calidad
folder_created_Modified_frames = 'GrayscaleNormalized_TLVQM_Normalized';
mkdir(input, folder_created_Modified_frames);  

%%
for frame_id = start_frame:end_frame
    start=tic;
    % if show_img == true (line 64), Pressing press the key, you can just stop the process.
    if finish == 1
        break;
    end
    
    if ~config.display
        %clc  % clear display
        %display(input);  %folder
        if mod(frame_id,500)==0
            display(['frame: ',num2str(frame_id),'/',num2str(end_frame)]); % Now Schedule  ex: "frame: 10/725"
        end
    end
    
    
    if nargin == 8
        I_orig = imread(s_frames{frame_id-start_frame+1});
        I_orig_next = imread(s_frames{frame_id-start_frame+2});
        I_orig_previous = imread(s_frames{frame_id-start_frame});
        % I_orig = img( s_frame{ the_num_of_current_loop } )
    else
        
        I_orig = imread(fullfile(input,file_list{frame_id}));
        
        if frame_id == end_frame
            I_orig_next = I_orig;
        else
            I_orig_next = imread(fullfile(input,file_list{frame_id+1}));
        end
        
        if frame_id == 1
            I_orig_previous = I_orig;
        else
            I_orig_previous = imread(fullfile(input,file_list{frame_id-1}));
        end
        %
        %                 % Default I_orig = img( frame_id )
        %
        %                 catch
        %                     I_orig = imread(fullfile(input,file_list{frame_id-1}));
        
    end
    
    
    
    %% Calculando la variación con las TLVQM features para añadirlas al video de entrada.
    disp(['calculating TLVQM features in patches in frame: ',num2str(frame_id)]);
    [rows, columns, numberOfColorChannels] = size(I_orig);
    Number_divisions = 48;
    I=I_orig;
    size_patch = [floor(rows/Number_divisions), columns/Number_divisions];
%     imshow(I)
%     figure
    patch_counter=0;
    time_LC = tic;
    for i=1:Number_divisions
        for j=1: Number_divisions
            patch_counter =patch_counter+1;
            patch(patch_counter).position=[j,i];
            rectangle_to_crop = [(size_patch(2)*(i-1))+1, (size_patch(1)*(j-1))+1, size_patch(2)-1,size_patch(1)-1];
            patch(patch_counter).data =imcrop(I, rectangle_to_crop);
            patch(patch_counter).YUV_Data = im2double(rgb2yuv(patch(patch_counter).data,0));
            
            %previous patch
            patch(patch_counter).PreviousFrame_patches =imcrop(I_orig_previous, rectangle_to_crop);
            patch(patch_counter).YUV_PreviousFrame = im2double(rgb2yuv(patch(patch_counter).PreviousFrame_patches,0));
            
            %next_patch
            patch(patch_counter).NextFrame_patches =imcrop(I_orig_next, rectangle_to_crop);
            patch(patch_counter).YUV_NextFrame = im2double(rgb2yuv(patch(patch_counter).NextFrame_patches,0));
            
            % Compute temporal features for each patch
            patch(patch_counter).TLVQM_LC = compute_LC_features_TLVQM(patch(patch_counter).YUV_Data, ...
                patch(patch_counter).YUV_PreviousFrame, ...
                patch(patch_counter).YUV_NextFrame);
            
            patch(patch_counter).TLVQM_HC = compute_HC_features_TLVQM(patch(patch_counter).YUV_Data);%30 features
            patch(patch_counter).TLVQM_HC_LC=[patch(patch_counter).TLVQM_LC patch(patch_counter).TLVQM_HC];
            
            [coeff,score,latent,tsquared,explained] = pca(patch(patch_counter).TLVQM_HC_LC');
            patch(patch_counter).TLVQM_HC_LC_PCA_FirstTwoComponents = score(1:2);
% scatter3(score(:,1),score(:,2),score(:,3))
            %             figure
%                         imshow(patch(patch_counter).data);
            Patch_PCA(j,i,1)=score(1);
            Patch_PCA(j,i,2)=score(2);
        end
    end
    toc(time_LC);
    
    J = imresize(Patch_PCA,[size(I_orig,1) size(I_orig,2)]);
    
    
    
    
    
    
    
    
    
    
    %%
    if prep == 1
        [m1,m2,m3]=size(I_orig);
        Iaux = zeros(m1,m2,m3);
        for iindx = 1:m3
            I=double(I_orig(:,:,iindx));
            a=min(min(I));
            b=max(max(I));
            t=1;
            I2=zeros(m1,m2);
            for i=1:m1
                for j=1:m2
                    I2(i,j)=(t/(b-a))*(I(i,j)-a);
                end
            end
            I2=uint8(I2);
            Iaux(:,:,iindx) = I2;
        end
        I_orig = Iaux;
    end
    
    %% Se anexan los dos canales de Video Quality a la imagen original
    
    hacer_graficas = 0;
    %Graficando las diferentes configuraciones con normalización y
    %escalamiento
    grayscale_normalized=zscore(double(I_orig(:,:,1)));
    TLVQM_Features_Normalized=zscore(J);
    I_orig3 = cat(3, grayscale_normalized,TLVQM_Features_Normalized);
    I_orig2 = cat(3, I_orig(:,:,1),TLVQM_Features_Normalized);
    normalizada_escalada=grayscale_normalized*(255/max(grayscale_normalized(:)));
    I_orig4 = cat(3, normalizada_escalada,TLVQM_Features_Normalized);
    TLVQM_Features_Normalized_scaled255=TLVQM_Features_Normalized*(255/max(TLVQM_Features_Normalized(:)));
    I_orig5 = cat(3, normalizada_escalada,TLVQM_Features_Normalized_scaled255);
    disp('concatening TLVQM features 2 channels with grayscale original channel');
    if hacer_graficas
        figure
        imshow(grayscale_normalized)
        title('Grayscale Image with z-score normalization');
        figure
        imshow(I_orig3)
        title('Grayscale channel normalized with TLVQM 2 channels normalized');
        figure
        imshow(I_orig2)
        title('original grayscale channel with TLVQM 2 channels normalized');
        figure
        imshow(normalizada_escalada)
        title('grayscale channel normalized and scaled to 255 maximum');
        figure
        imshow(I_orig4)
        title('rgb image with grayscale channel normalized and scaled and 2ch TLVQM normalized');
        figure
        imshow(I_orig5)
        title('rgb image with grayscale channel normalized and scaled and 2ch TLVQM normalized scaled(max=255)');
    end
    %Aqui se decide cual va a usarse, de las anteriores configuraciones.
    I_orig = I_orig3;
    
    %Guardando la imagen que va a tener el tracker de entrada
    name_to_save_PCAVQA_Image = strcat(num2str(frame_id),'.png');
    imwrite(I_orig5,strcat(input, '\',folder_created_Modified_frames,'\', name_to_save_PCAVQA_Image))
%     Video_PCA_TLVQM_Features(frame_id).frame = I_orig5;
    imshow(I_orig)
    title('input frame to tracker');
    %%
    % For the first frame loop
    if frame_id == start_frame
        init_rect = round(init_rect); % [x y width height]
        % Using round in case the indexes are not integers (4æ?¨5å…¥)
        
        % Set config parameters according to the region size of the first frame
        config = makeConfig(I_orig, init_rect, true, false, true, show_img);
        % PARAMS:
        % I_orig - The first frame
        % init_rect - The round of selected rectangle
        % true - Whether to use color
        % false - Whether to use Experts
        % true - Whether to use IIF (Illumination Invariant Feature)
        % show_img - Whether to display runtime result
        
        tracker.output = init_rect * config.image_scale;
        % [x y width height] * image_scale, because the image is rescaled
        tracker.output(1:2) = tracker.output(1:2) + config.padding; % [x+padding y+padding width height]
        tracker.output_exp  = tracker.output;
        output = tracker.output;
        % output = tracker.output = tracker.output_exp
    end
    
    % ********************************************************************
    % I_orig is the raw frame image
    [I_scale]= getFrame2Compute(I_orig);
    %para obtener el anterior y el siguiente frame
    [I_scale_next]= getFrame2Compute(I_orig_next);
    [I_scale_previous]= getFrame2Compute(I_orig_previous);
    
    % THIS IS JUST:
    % 1. resizing I_orig with config.image_scale
    % 2. padding top, bottom, left, right of I_orig with the width of config.padding(4)
    
    sampler.roi = rsz_rt(output,size(I_scale),config.search_roi,true);
    % rsz_rt IS JUST RESIZING RECTANGLE,
    % note that output = [x y width height].
    % 1. let r = sqrt(width * height)
    % 2. x0 = x - 0.5 * config.search_roi(2) * r
    %    y0 = y - 0.5 * config.search_roi(2) * r
    %    x1 = x + width + 0.5 * config.search_roi * r
    %    y1 = y + height + 0.5 * config.search_roi * r
    % 3. let rect = [x0 y0 x1 y1]
    % 4. Shift rect inside if it goes outside I_scale // because "rect" is bigger then "output"
    % 5. sampler.roi = rect
    
    
    I_crop = I_scale(round(sampler.roi(2):sampler.roi(4)),round(sampler.roi(1):sampler.roi(3)),:);
    
    I_crop_next = I_scale_next(round(sampler.roi(2):sampler.roi(4)),round(sampler.roi(1):sampler.roi(3)),:);
    I_crop_previous = I_scale_previous(round(sampler.roi(2):sampler.roi(4)),round(sampler.roi(1):sampler.roi(3)),:);
    
    % crop a rectangle image from I_scale by the [x0 y0 x1 y1] abov
    
    [BC, F] = getFeatureRep(I_crop, config.hist_nbin);
    % These are the features used in MEEM, you shoud see the other paper called
    % "MEEM: Robust Tracking via Multiple Experts using Entropy Minimization"
    % I guess, it transforms RGB into Lab(1) and LRT(2) channel:
    % (1) Lab color space: Lightness, green-red and blue-yellow (color-opponents),
    %                      and it is designed to approximate human vision.
    % (2) Local Rank Transform: I don't know, you can Google it yourself.
    % I noticed that only BC will be used in the rest of the code
    % ********************************************************************
    
    
    
    
    %% TLVQM Features
    %converting to YUV
    [I_crop_next_YUV] = rgb2yuv(I_crop_next,0);
    [I_crop_previous_YUV] = rgb2yuv(I_crop_previous,0);
    
    [I_crop_YUV] = rgb2yuv(I_crop,0);
    
    I_crop_YUV_Double = im2double(I_crop_YUV);
    
    
    % Compute temporal features for e+ach frame
    LC_vec = compute_LC_features_TLVQM(I_crop_YUV_Double, ...
        im2double(I_crop_previous_YUV), ...
        im2double(I_crop_next_YUV));
    
    HC_vec = compute_HC_features_TLVQM(I_crop_YUV_Double);%30 features
    
    LC_Normalized = zscore(LC_vec);
    HC_Normalized = zscore(HC_vec);
    
    HC_LC_Combined = [LC_Normalized HC_Normalized];%58 features
    
    Number_Of_Features = 28;
    Features_To_Use = LC_Normalized;
    for i=1:size(I_crop,1)
        for j=1:size(I_crop,2)
            TLVQM_Features_Replicated(i,j,1:Number_Of_Features) = Features_To_Use;
        end
    end
    %uno con las caracteristicas originales del tracker
    New_BC_With_TLVQM_Features = cat(3,BC,TLVQM_Features_Replicated);
    %     BC = New_BC_With_TLVQM_Features;
    clearvars TLVQM_Features_Replicated
    %% FRIQUEE features 560
    %
    %         [FRIQUEE_Features]= Calculate_FRIQUEE_Features(I_crop);
    %         %replico para que cada pixel tenga las 560 FRIQUEE features
    %     FRIQUEE_Normalized = zscore(FRIQUEE_Features); %normalizando con Z-score
    %     Number_Of_Features = 560;
    %         for i=1:size(I_crop,1)
    %             for j=1:size(I_crop,2)
    %                 FRIQUEE_Replicated(i,j,1:560) = FRIQUEE_Normalized;
    %             end
    %         end
    %         %uno con las caracteristicas originales del tracker
    %         New_BC_With_FRIQUEE = cat(3,BC,FRIQUEE_Replicated);
    %         BC = New_BC_With_FRIQUEE;
    %         clearvars FRIQUEE_Replicated
    %
    %% FRIQUEE Features PCA 16 components
    
    %     [FRIQUEE_Features]= Calculate_FRIQUEE_Features(I_crop);
    %     FRIQUEE_Normalized = zscore(FRIQUEE_Features); %normalizando con Z-score
    %     B = repmat(FRIQUEE_Normalized,[560 1]);   %Esto es para que el PCA se aplique a una matriz y no a un vector
    %     number_components = 16;
    %     [coeff,score,latent,tsquared,explained] = pca(B','NumComponents',number_components);
    %
    %
    %
    %     FRIQUEE_PCA16_FRIQUEE = coeff(20,:);%el 20 es porque ya en esa linea no varia y todos son iguales en adelante
    %     %replico para que cada pixel tenga las 560 FRIQUEE features
    %     for i=1:size(I_crop,1)
    %         for j=1:size(I_crop,2)
    %             FRIQUEE_Replicated(i,j,1:16) = FRIQUEE_PCA16_FRIQUEE;
    %         end
    %     end
    %     %uno con las caracteristicas originales del tracker
    %     New_BC_With_FRIQUEE = cat(3,BC,FRIQUEE_Replicated);
    %     BC = New_BC_With_FRIQUEE;
    %     clearvars FRIQUEE_Replicated
    
    %%
    tic
    
    
    
    
    
    
    
    if frame_id == start_frame
        initSampler_Modified(tracker.output, BC, F, config.use_color,HC_LC_Combined);
        % Here you should refer to "initSampler.m", it is very important.
        % Although F is passed in the function, it is not used at all, just ignore it.
        
        patterns{1}.X = sampler.patterns_dt;
        % "sampler.patterns_dt" is calculated in "resample.m"
        %% patterns{1}.X is denoted by phi_i(y) = phi(x_i,y_i) - phi(x_i,y) in the next line
        
        patterns{1}.X = repmat(patterns{1}.X(1, :), size(patterns{1}.X, 1), 1) - patterns{1}.X;
        % patterns{1}.X(1, :) is tracker.output_feat
        % patterns{1}.X = [
        %     tracker.output_feat - tracker.output_feat ;
        %     tracker.output_feat - im2colstep(...)
        % ]
        
        patterns{1}.Y = sampler.state_dt;
        % Calculated in "resample.m"
        % "structured output"
        % patterns{1}.Y = [
        %     tracker.output ;
        %     tracker.output
        % ]
        
        patterns{1}.lossY = sampler.costs;      % loss function: L(y_i,y), computed in resample
        patterns{1}.supportVectorNum = [];      % save structured output index whose alpha is not zero
        patterns{1}.supportVectorAlpha = [];    % save dual variable
        patterns{1}.supportVectorWeight = [];   % save weight related to dual variable
        
        w0 = zeros(1, size(patterns{1}.X, 2));  % initilize the classifer w0
        
        % Training classifier w0 by the proposed dlssvm optimization method
        [w0, patterns] = dlssvmOptimization(patterns,params, w0);
        % Read paper yourself
        
        if config.display    % show_img
            figure(1);
            imshow(I_orig);
            res = tracker.output;
            res(1:2) = res(1:2) - config.padding;
            res = res / config.image_scale;
            rectangle('position',res,'LineWidth',2,'EdgeColor','b')
            % Show tracker.output on the frame
        end
    else
        if config.display
            figure(1)
            imshow(I_orig);
            % roi_reg = sampler.roi; roi_reg(3:4) = sampler.roi(3:4)-sampler.roi(1:2)+1;
            % Recall: sampler.roi [x0 y0 x1 y1]
            % is the shifted resized padded tracker.output
            % roi_reg(1:2) = roi_reg(1:2) - config.padding;
            % rectangle('position',roi_reg/config.image_scale,'LineWidth',1,'EdgeColor','r');
            % Show sampler.roi on the image
            % figure(2)
            % imshow(I_orig);
        end
        
        %aqui siguen binarias
        feature_map = imresize(BC, config.ratio,'nearest');
        % Get the feature map of candiadte region
        % Recall: BC is the MEEM features computed from sampler.roi cropped from the frame
        
        ratio_x = size(BC,2)/size(feature_map,2);
        ratio_y = size(BC,1)/size(feature_map,1);
        %reordena los bloques de la matrix en columnas
        detX = im2colstep(feature_map,[sampler.template_size(1:2), size(BC,3)],[1, 1, size(BC,3)]);
        % ?
        
        x_sz = size(feature_map,2)-sampler.template_size(2)+1;
        y_sz = size(feature_map,1)-sampler.template_size(1)+1;
        [X, Y] = meshgrid(1:x_sz,1:y_sz);
        xbb = tracker.output(3);
        ybb = tracker.output(4);
        [Xbb, Ybb] = meshgrid(linspace(1.1*xbb,0.9*xbb,x_sz),linspace(1.1*ybb,0.9*ybb,y_sz));
        detY = repmat(tracker.output,[numel(X),1]);
        detY(:,1) = (X(:)-1)*ratio_x + sampler.roi(1);
        detY(:,2) = (Y(:)-1)*ratio_y + sampler.roi(2);
        Xbb = Xbb(:);
        Ybb = Ybb(:);
        nbx = length(Xbb);
        detY(:,3) = Xbb(randperm(nbx));
        detY(:,4) = Ybb(randperm(nbx));
        
        % detect the object
        % detX is feature(Lab+LIF+Explicit feature map), w0 is linear classifer
        % because we use linear w0, we can evaluate the candidate region by simple dot product
        score = w0 * detX;
        [ss_score, idx_score] = sort(score,'descend');
        ss_score = ss_score(1:min([20, length(score)]));
        idx_score = idx_score(1:min([20, length(score)]));
        mxscore = max(ss_score);
        mnscore = min(ss_score);
        ss_score = (ss_score-mnscore)/(mxscore-mnscore);
        ss_score = 1-0.5*ss_score;
        vw0=[vw0, norm(w0,2)];
        %         if config.display
        %             for ss = length(ss_score):-1:1
        %                 figure(2)
        %                 res = detY(idx_score(ss),:);
        %                 res(1:2) = res(1:2) - config.padding;
        %                 res = res/config.image_scale;
        %                 % display the object
        %                 rectangle('position',res,'LineWidth',2,'EdgeColor',[ss_score(ss),ss_score(ss), 1]);
        %                 title(['Frame: ' num2str(frame_id)])
        %                 pause(0.001)
        %             end
        %         end
        
        [~,maxInd]=max(score);
        output = detY(maxInd, :);  % detect the target position by maximal response
        %        if vgt(frame_id) == 1
        %            output = ground_truth(frame_id,:)*config.image_scale;
        %            output(1:2) = output(1:2) + config.padding;
        %       end
        % end to detect the object
        
        if config.display
            figure(1)
            res = output;
            res(1:2) = res(1:2) - config.padding;
            res = res/config.image_scale;
            % display the object
            rectangle('position',res,'LineWidth',2,'EdgeColor','b');
            if gt
                rectangle('position',ground_truth(frame_id,:),'LineWidth',1,'EdgeColor','g');
            end
            title(['Frame: ' num2str(frame_id)])
            pause(0.001)
        end
        
        step = round(sqrt((y_sz*x_sz)/120));
        mask_temp = zeros(y_sz,x_sz);
        mask_temp(1:step:end, 1:step:end) = 1;
        mask_temp = mask_temp > 0;
        mask_temp(maxInd) = 0;
        k = k + 1;
        
        % construct the training set from the current tracking results.
        % detX(:,maxInd) (tracking results) is true output, its loss is zero.
        patterns{k}.X = [detX(:, maxInd)'; detX(:, mask_temp(:))'];
        patterns{k}.X = repmat(patterns{k}.X(1, :), size(patterns{k}.X, 1), 1) - patterns{k}.X;
        patterns{k}.Y = [detY(maxInd, :); detY(mask_temp(:), :)];
        patterns{k}.lossY = 1 - getIOU(patterns{k}.Y, output);
        
        patterns{k}.supportVectorNum = [];
        patterns{k}.supportVectorAlpha = [];
        patterns{k}.supportVectorWeight = [];
        [w0, patterns] = dlssvmOptimization(patterns, params, w0);
        k = size(patterns, 2);
    end
    
    timer = timer + toc;
    res = output;
    %outv(frame_id,:) = output;
    res(1:2) = res(1:2) - config.padding;
    result.res(frame_id - start_frame+1,:) = res / config.image_scale;
    %measuring time per frame
    time_frame = toc(start);
    disp(['frame ',num2str(frame_id),' took ',num2str(time_frame)]);
end

result.fps = result.len / timer;
result.vw0 = vw0;

clearvars -global sampler tracker config finish
