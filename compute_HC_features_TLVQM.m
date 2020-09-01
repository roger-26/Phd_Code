function features = compute_HC_features_TLVQM(image)

    % Initializations
    mono_image = image(:,:,1);
    image = ycbcr2rgb(image);
    lab_image = rgb2lab(image);
    [height,width,depth] = size(image);
        
    % Make Sobeled image
    mask = zeros(height,width);
    mask(2:end-1,2:end-1)=1;
    H = [1 2 1; 0 0 0; -1 -2 -1]./8;
        
    % Make Sobeled image in CIELAB color space
    sob_image_lab_x = (imfilter(lab_image(:,:,1)./100.0,H).^2 + ...
                       imfilter(lab_image(:,:,2)./50.0,H).^2 + ...
                       imfilter(lab_image(:,:,3)./50.0,H).^2).*mask;
    sob_image_lab_y = (imfilter(lab_image(:,:,1)./100.0,H').^2 + ...
                       imfilter(lab_image(:,:,2)./50.0,H').^2 + ...
                       imfilter(lab_image(:,:,3)./50.0,H').^2).*mask;
    sob_image = sqrt(sob_image_lab_x+sob_image_lab_y);

    % Compute fetures for different feature groups
    [a,b,sat_image1] = compute_saturation(mono_image,1);
    sat_bright = [a b];
    [a,b,sat_image2] = compute_saturation(mono_image,0);
    sat_dark = [a b];
    sat_image = max(sat_image1, sat_image2);
    saturation_ftr = [sat_bright sat_dark];
    
    spatial_ftr = spatial_activity_features(sob_image, sat_image);
    noisiness_ftr = noise_features(mono_image, sat_image, lab_image);
    blockiness_ftr = blockiness_features(sob_image_lab_x.^0.5, ...
                                         sob_image_lab_y.^0.5);
    contrast_color_ftr = contrast_chroma_features(lab_image, sat_image);
    dct_ftr = dct_features(mono_image);   
    sharpness_ftr = sharpness_features(sob_image);

    % Make the HC feature vector
    features = [spatial_ftr          saturation_ftr ...
                noisiness_ftr        blockiness_ftr ...
                contrast_color_ftr   dct_ftr  ...
                sharpness_ftr];
end

function [len,num,segs] = compute_saturation(image, is_bright)

    [height,width] = size(image);

    lens = [];
    num = 0;    
    
    segs = zeros(height,width);
    
    if (is_bright==1 && max(max(image))>0.9) || ...
       (is_bright==0 && min(min(image))<0.1)     
    
        segs = seg_loop(image,segs,3,3,0.05, is_bright);
        for i=1:max(max(segs))
            len = length(find(segs==i));
            if len<50
                segs(find(segs==i))=0;
            else
                lens = [lens len];
                num = num + 1;
            end
        end 
        segs(find(segs>0))=1;
    end
    
    len = sum(lens)/(width*height);
    if num > 0
        num = len / num;
    end

end

% This function is used for segmentation by measure_saturation
function segim = seg_loop(image, segs, wh, ww, interval, is_bright)

    [height,width] = size(image);

    segim = segs;
    
    maxi = max(max(image));
    mini = min(min(image));
    
    for i=1:height-wh+1
        for j=1:width-ww+1
            if (is_bright == 1 && ...
              min(min(image(i:i+wh-1,j:j+ww-1)))>maxi-interval) || ...
              (is_bright == 0 && ...
              max(max(image(i:i+wh-1,j:j+ww-1)))<mini+interval)
            
                maxsg = max(max(segim(i:i+wh-1,j:j+ww-1)));
                if maxsg>0
                    segs_temp = reshape(segim(i:i+wh-1,j:j+ww-1),wh*ww,1);
                    minsg=min(segs_temp(find(segs_temp>0)));
                    segim(i:i+wh-1,j:j+ww-1)=minsg;
                    if minsg<maxsg
                        segim(find(segim==maxsg))=minsg;
                    end
                else
                    segim(i:i+wh-1,j:j+ww-1)=max(max(segim(:,:)))+1;
                end
            end
        end
    end

end


% This function is used to compute spatial activity features
function out = spatial_activity_features(sobel_image, sat_image)
    
    [height,width] = size(sobel_image);
       
    sob_dists = zeros(1,height*width);
    sob_dists2 = zeros(height*width,2);
    sob_str = zeros(1,height*width);
    sumstr = 0;
    
    n = 0;
    for i=1:height
        for j=1:width
            if sat_image(i,j)==0
                if sobel_image(i,j)<0.01
                    sobel_image(i,j)=0;
                end
                sumstr = sumstr + sobel_image(i,j);
                if sobel_image(i,j) > 0
                    n = n + 1;
                    sob_str(n) = sobel_image(i,j);
                    sob_dists(n) = sqrt((i/height-0.5)^2+(j/width-0.5)^2);
                    sob_dists2(n,1) = i/height-0.5;
                    sob_dists2(n,2) = j/width-0.5;                   
                end
            end
        end
    end  
    
    sob_str = sob_str(1:n);
    sob_dists = sob_dists(1:n);
    sob_dists2 = sob_dists2(1:n,:);

    a = 0;
    b = 0;
    c = 0;
    d = 0;
    
    if ~isempty(sob_str)>0
        a = mean(mean(sobel_image));
        b = std2(sobel_image);
        d = w_std(sob_dists, sob_str);        
        mean_y = sum(sob_str'.*sob_dists2(:,1))/sum(sob_str);
        mean_x = sum(sob_str'.*sob_dists2(:,2))/sum(sob_str);        
        c = sqrt(mean_y^2+mean_x^2);
    end
    
    out = [a b c d];

end


% Function for "weighted standard deviation", used by function
% measure_spatial_activity
function res = w_std(input, weights)

    wg_n = sum(weights);
    wg_input = input.*weights;
    wg_mean = mean(input.*weights);
    
    res = sqrt(sum((wg_input-wg_mean).^2)/wg_n);
end


% This function is used to compute noise related features
function out = noise_features(mono_image, sat_im, lab_image)
    
    [height,width] = size(mono_image);

    new_im = zeros(height, width, 3);

    nonsat_pix = 0;
    noise_pix = 0;
    noise_int = [];
    
    % Loop through pixels to find noise pixels
    for i=5:height-4
        for j=5:width-4
            if sat_im(i,j)==0
                surr_pix = mono_image(i-2:i+2,j-2:j+2);
                surr_pix = surr_pix(:);
                surr_pix = [surr_pix(1:12); surr_pix(14:25)];
                if (mono_image(i,j)>max(surr_pix) || ...
                    mono_image(i,j)<min(surr_pix))
                    surr_pix = mono_image(i-4:i+4,j-4:j+4);
                    if std(surr_pix)<0.05
                        new_im(i,j,2) = 1;
                        pix_diff = sqrt( ...
                            (mean(lab_image(i-3:i+3,j-3:j+3,1))-...
                                 lab_image(i,j,1)).^2 + ...
                            (mean(lab_image(i-3:i+3,j-3:j+3,2))-...
                                 lab_image(i,j,2)).^2 + ...
                            (mean(lab_image(i-3:i+3,j-3:j+3,3))-...
                                  lab_image(i,j,3)).^2);
                        noise_int = [noise_int pix_diff/100]; 
                        noise_pix = noise_pix + 1;
                    end
                end
                nonsat_pix = nonsat_pix + 1;
            end
        end
    end

    a = 0;
    b = 0;
    c = 0;
    
    if nonsat_pix > 0 && noise_pix > 0
        % noise density
        a = noise_pix / nonsat_pix;
        b = mean(noise_int);
        c = std(noise_int);
    end
    
    out = [a b c];
       
end

% This function is used to compute blockiness index
function blockiness = blockiness_features(sob_y, sob_x)
    
    [height,width] = size(sob_y);
       
    hor_tot = zeros(1,height-4);
    ver_tot = zeros(1,width-4);
    
    for i=3:height-2
        hor_tot(i)=mean(sob_y(i,:)-sob_x(i,:));
    end
    for j=3:width-2
        ver_tot(j)=mean(sob_x(:,j)-sob_y(:,j));
    end
    
    % compute autocorrelations
    autocr_hor = zeros(1,23);
    autocr_ver = zeros(1,23);
    for i=0:22
        autocr_hor(i+1) = sum(hor_tot(1:end-i).*hor_tot(1+i:end));
        autocr_ver(i+1) = sum(ver_tot(1:end-i).*ver_tot(1+i:end));
    end
    
    % Find the highest local maximum (other than 0)
    localpeaks = 0;
    peakdist = 0;
    max_hor = 0;
    max_ver = 0;
    min_hor = autocr_hor(1);
    min_ver = autocr_ver(1);
    max_hor_diff = 0;
    max_ver_diff = 0;
    for i=2:22
        if autocr_hor(i)>max(autocr_hor(i-1),autocr_hor(i+1))
            localpeaks = localpeaks+1/42;
        end
        if autocr_hor(i)<min(autocr_hor(i-1),autocr_hor(i+1)) && ...
                autocr_hor(i)<min_hor
            min_hor = autocr_hor(i);
        elseif autocr_hor(i)>max(autocr_hor(i-1),autocr_hor(i+1)) && ...
                autocr_hor(i)-min_hor>max_hor_diff
            max_hor = autocr_hor(i);
            max_hor_diff = max_hor-min_hor;
            peakdist = (i-1)/21;
        end
        if autocr_ver(i)>max(autocr_ver(i-1),autocr_ver(i+1))
            localpeaks = localpeaks + 1/42;
        end
        if autocr_ver(i)<min(autocr_ver(i-1),autocr_ver(i+1)) && ...
                autocr_ver(i)<min_ver
            min_ver = autocr_ver(i);
        elseif autocr_ver(i)>max(autocr_ver(i-1),autocr_ver(i+1)) && ...
                autocr_ver(i)-min_ver>max_ver_diff
            max_ver = autocr_ver(i);
            max_ver_diff = max_ver-min_ver;
            peakdist = (i-1)/21;
        end
    end
    
    a = 0;
    if autocr_hor(1)>0 && autocr_ver(1)>0
        if max_hor>0 && max_ver>0
            a = max((max_hor_diff/autocr_hor(1)), ...
                             (max_ver_diff/autocr_ver(1)))^0.5;
        elseif max_hor>0
            a = (max_hor_diff/autocr_hor(1))^0.5;
        elseif max_ver>0
            a = (max_ver_diff/autocr_ver(1))^0.5;
        end
    end
    
    b = peakdist;
    c = localpeaks;
    blockiness = [a b c];
end

% This function is used to compute contrast and chroma related features
function out = contrast_chroma_features(lab_image, sat_image)

    a=0;
    b=0;
    c=0;
    d=0;
    
    [height,width,depth] = size(lab_image);
    yuv_int = floor(lab_image(:,:,1));
    
    %sat_image = sat_image(:);
    yuv_int2 = yuv_int(sat_image(:)==0);
    cumu_err = 0;
    cumu_tar = 0;
    if ~isempty(yuv_int2)
        for i=0:100
            cumu_tar = cumu_tar + 1/100;
            cumu_err = cumu_err + (sum(yuv_int2<=i)/length(yuv_int2) - ...
                                   cumu_tar)/100;
        end
        a = (cumu_err+1.0)/2.0;
        b = 0.5*(1-cumu_err);
    else
        a = 1;
        b = sum(sum(lab_image(:,:,1)))/50;
    end
    c = sqrt(mean(mean((lab_image(:,:,2)./50).^2 + ...
         (lab_image(:,:,3)./50).^2)));
    d = 0;
    if std2(lab_image(:,:,1))>0
        d = 0.01*(std2(lab_image(:,:,2))+std2(lab_image(:,:,3)));
    end
    
    out = [a b c d];
end


% This function is used to compute dct derived features
function out = dct_features(im)
    
    % Input is monochrome image
    [height,width] = size(im);
    
    out_im = abs(dct2(im)).^.5;
    
    area1 = imresize(out_im(1:floor(height/2),1:floor(width/2)),0.25);
    area2 = imresize(out_im(1:floor(height/2),...
                            width:-1:width-floor(width/2)+1),0.25);
    area3 = imresize(out_im(height:-1:height-floor(height/2)+1,...
                            1:floor(width/2)),0.25);
    area4 = imresize(out_im(height:-1:height-floor(height/2)+1,...
                            width:-1:width-floor(width/2)+1),0.25);
    a = max(0,max(corr(area1(:),area2(:)),corr(area1(:),area3(:))));
    b = 0;
    if mean(area1)>0
        b = mean(area4)/mean(area1);
    end
    c = 0;
    if max(mean(area2),mean(area3))>0
        c = min(mean(area2),mean(area3))/max(mean(area2),mean(area3));
    end
    
    out = [a b c];
    
end


% This function is used to compute sharpness related features
function out = sharpness_features(im)

    [~, width] = size(im);
    
    % Full HD video could be downsized
    if width>1280
        im = imresize(im,0.5);
    end
    
    H = [-1 -2 -1; 0 0 0; 1 2 1]./8;
    im_s_h = imfilter(im,H');
    im_s_v = imfilter(im,H);
    im_s = sqrt(im_s_h.^2+im_s_v.^2);
    
    [height,width] = size(im_s_h);
    bl_size = 16;
    conv_list = [];
    
    blur_im = zeros(height,width);
    edge_strong = [];
    edge_all = [];
    
    conv_cube = [];
    blurvals = [];
    
    n_blks = 0;
    
    conv_val_tot = zeros(17);
    for y=floor(bl_size/2):bl_size:height-ceil(3*bl_size/2)
        for x=floor(bl_size/2):bl_size:width-ceil(3*bl_size/2)
            
            n_blks = n_blks + 1;
            
            conv_val = zeros(17);
            for i=0:6
                for j=0:6
                    if i==0 || j==0 || i==j
                        weight_h = 1;
                        weight_v = 1;
                        if i~=0 || j~=0
                            weight_h = abs(i)/(abs(i)+abs(j));
                            weight_v = abs(j)/(abs(i)+abs(j));
                        end
                        diff_h = (im_s_h(y+i:y+bl_size+i,   ...
                                         x+j:x+bl_size+j).* ...
                                  im_s_h(y:y+bl_size,       ...
                                         x:x+bl_size));
                        diff_v = (im_s_v(y+i:y+bl_size+i,   ...
                                         x+j:x+bl_size+j).* ...
                                  im_s_v(y:y+bl_size,       ...
                                         x:x+bl_size));
                        conv_val(i+9,j+9) = weight_h*(mean(diff_h(:)))+ ...
                                            weight_v*(mean(diff_v(:)));
                    end
                end
            end
            blur_im(y:y+bl_size-1,x:x+bl_size-1)=0.5;
            edge_all =  [edge_all conv_val(9,9)];
            if conv_val(9,9)>0.0001
                edge_strong =  [edge_strong conv_val(9,9)];
                conv_val=conv_val./conv_val(9,9);
                conv_val_tot = conv_val_tot + conv_val;

                new_conv_v = [];
                for i=1:6
                    new_conv_v = [new_conv_v sum(sum(conv_val(9-i:9+i,...
                                                            9-i:9+i)))- ...
                                             sum(sum(conv_val(10-i:8+i, ...
                                                            10-i:8+i)))];
                end
                if new_conv_v(1)>0
                    new_conv_v=new_conv_v./new_conv_v(1);
                end

                conv_list = [conv_list; new_conv_v];
                conv_cube(:,:,1)=conv_val;
                blurvals = [blurvals std2(im_s(y:y+bl_size, x:x+bl_size))];

                blur_im(y:y+bl_size-1,x:x+bl_size-1) = ...
                                  0.5 + mean(new_conv_v(2:6))/5;
            end
        end
    end

    % Find the sharpest blocks
    blurs_sharp = [];
    blurs_blur = [];
    if length(blurvals)>0    
        for i=1:length(blurvals)
            if blurvals(i)>mean(blurvals)
                conv_val_tot = + conv_val_tot + conv_cube(:,:,1);
                blurs_sharp = [blurs_sharp blurvals(i)];
            else
                blurs_blur = [blurs_blur blurvals(i)];
            end
        end
    end
    
    n_sharps = length(blurs_sharp)/n_blks;
    n_blurs = length(blurs_blur)/n_blks;
    mean_sharps = 0;
    mean_blurs = 0;
    if ~isempty(blurs_sharp)
        mean_sharps = mean(blurs_sharp);
    end
    if ~isempty(blurs_blur)
        mean_blurs = mean(blurs_blur);
    end
    
    if conv_val_tot(9,9)>0
        conv_val_tot=conv_val_tot./conv_val_tot(9,9);
    end
    
    new_conv_v = zeros(1,9);
    if ~isempty(edge_strong)>0
        if length(conv_list(:,1))>1
            new_conv_v = mean(conv_list);
        else
            new_conv_v = conv_list;
        end
    end 
       
    % find local min and/or local max
    localmin=0;
    localmindist=0;
    localmax=0;
    localmaxdist=0;
    for i=9:14
        for j=9:14
            if (i~=9 && j==9) || (j~=9 && i==9) || (i==j && i>9) 
                conv_val_comp=conv_val_tot(i-1:i+1,j-1:j+1);
                conv_val_comp=conv_val_comp(:);
                if i==9
                    conv_val_comp=conv_val_comp([4 6]);
                elseif j==9
                    conv_val_comp=conv_val_comp([2 8]);
                else
                    conv_val_comp=conv_val_comp([1 9]);
                end    
                if conv_val_tot(i,j)>max(conv_val_comp) && ...
                        conv_val_tot(i,j)>localmax
                    localmax = conv_val_tot(i,j);
                    localmaxdist = sqrt((i-9)^2+(j-9)^2);
                elseif conv_val_tot(i,j)<min(conv_val_comp) && ...
                        conv_val_tot(i,j)<localmin
                    localmin = conv_val_tot(i,j);
                    localmindist = sqrt((i-9)^2+(j-9)^2);
                end
            end
        end
    end

    out = [mean(new_conv_v(2:6)) mean(new_conv_v(2:4)) new_conv_v(2) ...           
           localmaxdist/5 localmindist/5 ...
           n_sharps n_blurs mean_sharps mean_blurs];
end