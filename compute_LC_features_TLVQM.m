function features = compute_LC_features_TLVQM(this_fr, prev_fr, next_fr)

    [height,width,~] = size(this_fr);
    
    % Try to detect interlacing
%     
%     im_odd_hor = this_fr(1:2:end,:,1);
%     im_even_hor = this_fr(2:2:end,:,1);
%     im_odd_ver = this_fr(:,1:2:end,1);
%     im_even_ver = this_fr(:,2:2:end,1);
    
    
    im_odd_hor = this_fr(1:2:end,:,1);
    im_even_hor = this_fr(1:2:end,:,1);
    im_odd_ver = this_fr(:,1:2:end,1);
    im_even_ver = this_fr(:,1:2:end,1);
    
    vec_v = sort((im_odd_ver(:)-im_even_ver(:)).^2,'descend');
    vec_h = sort((im_odd_hor(:)-im_even_hor(:)).^2,'descend');
    ver = mean(vec_v(1:floor(0.001*end)));
    hor = mean(vec_h(1:floor(0.001*end)));
    
    interlace = 0;
    if ver>0 || hor>0
        interlace = min(ver,hor)/max(ver,hor);
    end
    
    % Simple blurriness estimation
    H = [-1 -2 -1; 1 2 1; 0 0 0]./8;
    sob_h_this = imfilter(this_fr(:,:,1),H'); 
    sob_v_this = imfilter(this_fr(:,:,1),H);
    sob_h_this_2 = imfilter(sob_h_this,H');
    sob_v_this_2 = imfilter(sob_v_this,H);  
    sob_h_this = sob_h_this(4:end-3,4:end-3);
    sob_v_this = sob_v_this(4:end-3,4:end-3);
    sob_h_this_2 = sob_h_this_2(3:end-2,3:end-2);
    sob_v_this_2 = sob_v_this_2(3:end-2,3:end-2);
    sob_1 = (sob_h_this(:).^2+sob_v_this(:).^2);
    sob_1 = sort(sob_1,'descend');
    sob_2 = (sob_h_this_2(:).^2+sob_v_this_2(:).^2);
    sob_2 = sort(sob_2,'descend');
     
    mean_sob = mean(sob_1(1:floor(0.1*end)));
    mean_sob_2 = mean(sob_2(1:floor(0.1*end)));
    blur = 0;
    if mean_sob>0
        blur = (mean_sob_2/mean_sob);
    end     
     
    % Initialize parameters 
    bl_size = floor(width/40);  
    src_win = floor(width/40);
    
    % The following computations are done with reduced resolution
    this_fr = imresize(this_fr,0.5); 
    prev_fr = imresize(prev_fr,0.5);  
    next_fr = imresize(next_fr,0.5);     
    [height,width,~] = size(this_fr);   
    this_Y = this_fr(:,:,1);
    prev_Y = prev_fr(:,:,1);
    next_Y = next_fr(:,:,1);
    this_fr = ycbcr2rgb(this_fr);    
    
    % Apply Sobel filter to the frames
    H = [-1 -2 -1; 0 0 0; 1 2 1]./8;
    sob_h_this = imfilter(this_Y,H'); 
    sob_v_this = imfilter(this_Y,H);
    
    % Reset edge pixels in the Sobeled frames
    sob_h_this(1:4,1:width)=0;
    sob_h_this(height-3:height,1:width)=0;
    sob_h_this(1:height,1:4)=0;
    sob_h_this(1:height,width-3:width)=0;
    sob_v_this(1:4,1:width)=0;
    sob_v_this(height-3:height,1:width)=0;
    sob_v_this(1:height,1:4)=0;
    sob_v_this(1:height,width-3:width)=0;
          
    sob_tot = sqrt(sob_v_this.^2+sob_h_this.^2);   
    sob_h_prev = imfilter(prev_Y,H');
    sob_v_prev = imfilter(prev_Y,H); 
    sob_h_next = imfilter(next_Y,H');
    sob_v_next = imfilter(next_Y,H);     
    
    H1 = [1 1 1 1 1;1 1 1 1 1;-2 -2 0 1 1;-2 -2 -2 1 1;-2 -2 -2 1 1]./32;
    H2 = [-2 -2 -2 1 1;-2 -2 -2 1 1;-2 -2 0 1 1;1 1 1 1 1;1 1 1 1 1]./32;
    H3 = [1 1 -2 -2 -2;1 1 -2 -2 -2;1 1 0 -2 -2;1 1 1 1 1;1 1 1 1 1]./32;
    H4 = [1 1 1 1 1;1 1 1 1 1;1 1 0 -2 -2;1 1 -2 -2 -2;1 1 -2 -2 -2]./32;
    
    corner_avg(:,:,1) = abs(imfilter(this_Y, H1));
    corner_avg(:,:,2) = abs(imfilter(this_Y, H2));
    corner_avg(:,:,3) = abs(imfilter(this_Y, H3));
    corner_avg(:,:,4) = abs(imfilter(this_Y, H4));   
    corner_max = max(corner_avg,[],3);
    corner_this = corner_max-min(corner_avg,[],3); 
    
    mot_threshold = 0.01; 
    
    cor_max = sort(corner_max(:),'ascend');
    glob_blockiness = 0;
    if std2(cor_max(1:floor(0.99*end)))>0
        glob_blockiness = 0.5*((mean(cor_max(1:floor(0.99*end)))/ ...
                          std2(cor_max(1:floor(0.99*end))))^2);
    end
       
    % Reset edge pixels in the corner point filtered frame
    corner_this(1:src_win+3,1:width)=0;
    corner_this(height-src_win-2:height,1:width)=0;
    corner_this(1:height,1:src_win+3)=0;
    corner_this(1:height,width-src_win-2:width)=0;
                                              
    corner_this_copy = corner_this(:);   
    key_pix = zeros((height-6)*(width-6),2);
    n_key_pix = 0;
    
    im_y_vec = mod(0:width*height, height)+1;
    im_x_vec = floor((0:width*height-1)/height)+1;
    sob_this_cp = corner_this_copy(corner_this_copy>mot_threshold);
    im_y_vec = im_y_vec(corner_this_copy>mot_threshold);
    im_x_vec = im_x_vec(corner_this_copy>mot_threshold);
    
    % In the following loop, find the key pixels
    [mx,idx] = max(sob_this_cp);
    if ~isempty(idx)
        while mx>mot_threshold
            i = im_y_vec(idx(1));
            j = im_x_vec(idx(1));

            n_key_pix = n_key_pix + 1;
            key_pix(n_key_pix,:) = [i j];

            idx_remove = find(im_y_vec>=i-floor(bl_size) & ...
                              im_y_vec<=i+floor(bl_size) & ...
                              im_x_vec>=j-floor(bl_size) & ...
                              im_x_vec<=j+floor(bl_size));
            sob_this_cp(idx_remove)=[];
            im_y_vec(idx_remove)=[];
            im_x_vec(idx_remove)=[];

            [mx,idx] = max(sob_this_cp);
        end
    end
    key_pix=key_pix(1:n_key_pix,:);
       
    non_mot_area = ones(height, width);
    
    num_mot_points = 0;
    max_mot_points = (height/bl_size)*(width/bl_size);
    
    %tic
    % In the following loop, find the motion vectors for each key pixel
    motion_vec = [];
    
    distance_matrix = ones(2*src_win+1);
    for i=1:2*src_win+1
        for j=1:2*src_win+1
            distance_matrix(i,j) = ...
                sqrt((1+src_win-i).^2+(1+src_win-j).^2)/sqrt(2*src_win^2);
        end
    end
    distances = distance_matrix(:);
    
    uncertain = 0;

    % Loop through the key pixels
    for z = 1:n_key_pix

        tar_y = key_pix(z,1);
        tar_x = key_pix(z,2);
        match_y_bw = tar_y;
        match_x_bw = tar_x;
        match_y_fw = tar_y;
        match_x_fw = tar_x;
        
        surr_win_v_prev = sob_v_prev(tar_y-src_win-2:tar_y+src_win+2, ...
                                     tar_x-src_win-2:tar_x+src_win+2);
        surr_win_h_prev = sob_h_prev(tar_y-src_win-2:tar_y+src_win+2, ...
                                     tar_x-src_win-2:tar_x+src_win+2);
        diff_win_prev = (sob_v_this(tar_y, tar_x)-surr_win_v_prev).^2 + ...
                        (sob_h_this(tar_y, tar_x)-surr_win_h_prev).^2;
                    
        surr_win_v_next = sob_v_next(tar_y-src_win-2:tar_y+src_win+2, ...
                                     tar_x-src_win-2:tar_x+src_win+2);
        surr_win_h_next = sob_h_next(tar_y-src_win-2:tar_y+src_win+2, ...
                                     tar_x-src_win-2:tar_x+src_win+2);
        diff_win_next = (sob_v_this(tar_y, tar_x)-surr_win_v_next).^2 + ...
                        (sob_h_this(tar_y, tar_x)-surr_win_h_next).^2;
                    
        for i=-1:1
            for j=-1:1
                if i~=0 || j~=0
                    diff_win_prev(3:end-2,3:end-2) = ...
                        diff_win_prev(3:end-2,3:end-2) + ...
                        (sob_v_this(tar_y+i, tar_x+j)- ...
                          surr_win_v_prev(3+i:end-2+i,3+j:end-2+j)).^2+ ...
                        (sob_h_this(tar_y+i, tar_x+j)- ...
                          surr_win_h_prev(3+i:end-2+i,3+j:end-2+j)).^2;   
                    diff_win_next(3:end-2,3:end-2) = ...
                        diff_win_next(3:end-2,3:end-2) + ...
                        (sob_v_this(tar_y+i, tar_x+j)- ...
                          surr_win_v_next(3+i:end-2+i,3+j:end-2+j)).^2+...
                        (sob_h_this(tar_y+i, tar_x+j)- ...
                        surr_win_h_next(3+i:end-2+i,3+j:end-2+j)).^2;   
                end
            end
        end
        diff_win_prev = diff_win_prev(3:end-2,3:end-2);
        diff_win_next = diff_win_next(3:end-2,3:end-2);
                    
        orig_diff_bw = diff_win_prev(1+src_win,1+src_win);
        orig_diff_fw = diff_win_next(1+src_win,1+src_win);
 
        diff_bw = diff_win_prev(1+src_win,1+src_win);   
        if orig_diff_bw>0.005
            [sorted,idx] = sort(diff_win_prev(:),'ascend');
            min_diff = orig_diff_bw;
            if length(sorted)>=2
                if sorted(1)<=0.8*sorted(2) || ...
                   distances(idx(1))<distances(idx(2))
                    min_diff = sorted(1);
                else
                    [idx,~] = find(0.8.*diff_win_prev(:)<=sorted(1));
                    [~,idx2] = sort(distances(idx),'ascend');
                    if diff_win_next(idx(idx2(1)))<1.1*sorted(1)
                        min_diff = diff_win_prev(idx(idx2(1)));
                    elseif sorted(1)<diff_bw*0.9
                        min_diff = sorted(1);
                    end
                    uncertain = uncertain + 1;
                end
                if min_diff*1.01<orig_diff_bw
                    [y,x] = find(diff_win_prev==min_diff);
                    match_y_bw = tar_y+y(1)-src_win-1;
                    match_x_bw = tar_x+x(1)-src_win-1;        
                    diff_bw = diff_win_prev(y(1),x(1));
                end
            end
        end
        
        diff_fw = diff_win_next(1+src_win,1+src_win);  
        if orig_diff_fw>0.005
            [sorted,idx] = sort(diff_win_next(:),'ascend');
            min_diff = orig_diff_fw;
            if length(sorted)>=2
                if sorted(1)<0.8*sorted(2) || ...
                   distances(idx(1))<distances(idx(2))
                    min_diff = sorted(1);
                else                
                    [idx,~] = find(0.8.*diff_win_next(:)<=sorted(1));
                    [~,idx2] = sort(distances(idx),'ascend');
                    if diff_win_next(idx(idx2(1)))<1.1*sorted(1)
                        min_diff = diff_win_next(idx(idx2(1)));
                    elseif sorted(1)<diff_fw*0.9
                        min_diff = sorted(1);
                    end
                    uncertain = uncertain + 1;
                end
                if min_diff*1.01<orig_diff_fw
                    [y,x] = find(diff_win_next==min_diff);
                    match_y_fw = tar_y+y(1)-src_win-1;
                    match_x_fw = tar_x+x(1)-src_win-1;        
                    diff_fw = diff_win_next(y(1),x(1));
                end  
            end
        end
             
        % Add motion vector to the list of motion vectors
        if (orig_diff_bw > diff_bw*1.01 && ...
                (tar_y ~= match_y_bw || tar_x ~= match_x_bw)) || ...
           (orig_diff_fw > diff_fw*1.01 && ...
                (tar_y ~= match_y_fw || tar_x ~= match_x_fw))     

            non_mot_area(max(1,tar_y-bl_size):min(height,tar_y+bl_size),...
                max(1,tar_x-bl_size):min(width,tar_x+bl_size))=0;
            non_mot_area(max(1,match_y_bw-bl_size): ...
                min(height,match_y_bw+bl_size),...
                max(1,match_x_bw-bl_size):...
                min(width,match_x_bw+bl_size)) = 0;
            non_mot_area(max(1,match_y_fw-bl_size):...
                min(height,match_y_fw+bl_size),...
                max(1,match_x_fw-bl_size):...
                min(width,match_x_fw+bl_size)) = 0;
        end
        
        num_mot_points = num_mot_points + 1;
        motion_vec = [motion_vec; ...
                      tar_y-match_y_bw tar_x-match_x_bw ...
                      match_y_fw-tar_y match_x_fw-tar_x ...
                      tar_y tar_x ...
                      orig_diff_bw diff_bw ...
                      orig_diff_fw diff_fw];
    end
    %toc 
    
    % Compute motion point related statistics
    motion_uncertainty = 0.5*uncertain/max_mot_points;
    motion_density = 0;
    motion_intensity = 0;
    std_mot_intensity = 0;
    avg_mot_pos = 0;
    avg_mot_sprd = 0;
    mot_pred_acc = 0;
    mot_y = 0.5;
    mot_x = 0.5;
    jerkiness = 0;
    jerk_cons = 0;
    motion_vec_bg = [];
    num_bg_mot_points = 0;
    if num_mot_points>0
        motion_density = num_mot_points/(width*height/bl_size^2);    
        mot_intensity_vec = sqrt(((motion_vec(:,1)./src_win).^2 + ...
                                  (motion_vec(:,2)./src_win).^2 + ...
                                  (motion_vec(:,3)./src_win).^2 + ...
                                  (motion_vec(:,4)./src_win).^2)./4.0);
        sum_mot_int = sum(mot_intensity_vec);
        motion_intensity = (sum(mot_intensity_vec)/max_mot_points)^0.25;
        std_mot_intensity = std(mot_intensity_vec);
        
        if sum_mot_int>0
            % Compute motion position in relation with the screen midpoint
            avg_motp_y = sum(mot_intensity_vec.*motion_vec(:,5))/...
                           sum_mot_int;
            std_motp_y = sqrt(sum(mot_intensity_vec.*...
                           (motion_vec(:,5)-avg_motp_y).^2)/sum_mot_int);
            avg_mot_pos_y = (avg_motp_y-height/2)/(height/2);
            sprd_mot_pos_y = std_motp_y/height;  
            avg_motp_x = sum(mot_intensity_vec.*motion_vec(:,6))/...
                           sum_mot_int;
            std_motp_x = sqrt(sum(mot_intensity_vec.*...
                           (motion_vec(:,6)-avg_motp_x).^2)/sum_mot_int);
            avg_mot_pos_x = (avg_motp_x-width/2)/(width/2);
            sprd_mot_pos_x = std_motp_x/width;

            avg_mot_pos = sqrt(avg_mot_pos_y^2+avg_mot_pos_x^2);  
            avg_mot_sprd = sqrt(sprd_mot_pos_y^2+sprd_mot_pos_x^2);

            % Mean motion along x and y axis
            mot_y = mean(0.25.*(motion_vec(:,1)+motion_vec(:,3))./ ...
                      src_win+0.5);    
            mot_x = mean(0.25.*(motion_vec(:,2)+motion_vec(:,4))./ ...
                      src_win+0.5);

            % Average motion prediction improvement
            mot_pred_acc_bw = mean(motion_vec(:,7)-motion_vec(:,8));
            mot_pred_acc_fw = mean(motion_vec(:,9)-motion_vec(:,10));
            mot_pred_acc = 0.5*(mot_pred_acc_bw+mot_pred_acc_fw).^0.5;

            % Motion jerkiness
            mot_y_diff = 0.5.*(motion_vec(:,1)'-motion_vec(:,3)')./src_win;
            mot_x_diff = 0.5.*(motion_vec(:,2)'-motion_vec(:,4)')./src_win;
            mot_diff = sqrt(mot_y_diff.^2+mot_x_diff.^2);
            jerkiness = mean(mot_diff.^0.5);        
            jerk_cons = std(mot_diff.^0.5);
        end
        
        avg_mot_x = mean(0.5.*motion_vec(:,2)+0.5.*motion_vec(:,4));
        avg_mot_y = mean(0.5.*motion_vec(:,1)+0.5.*motion_vec(:,3));
        std_mot_x = std(0.5.*motion_vec(:,2)+0.5.*motion_vec(:,4));
        std_mot_y = std(0.5.*motion_vec(:,1)+0.5.*motion_vec(:,3));

        for z=1:num_mot_points
            mot_x_this = 0.5*motion_vec(z,2)+0.5*motion_vec(z,4);
            mot_y_this = 0.5*motion_vec(z,1)+0.5*motion_vec(z,3);
            if mot_x_this > avg_mot_x-std_mot_x && ...
               mot_x_this < avg_mot_x+std_mot_x && ...
               mot_y_this > avg_mot_y-std_mot_y && ...
               mot_y_this < avg_mot_y+std_mot_y

                num_bg_mot_points = num_bg_mot_points + 1;
                motion_vec_bg = [motion_vec_bg; motion_vec(z,:)];
            end
        end
    end
    
    % Compute motion point related statistics
    egomotion_density = 0;
    egomotion_intensity = 0;
    std_egomot_intensity = 0;
    avg_egomot_pos = 0;
    avg_egomot_sprd = 0;
    egomot_pred_acc = 0;
    mot_y_bg = 0.5;
    mot_x_bg = 0.5;
    if num_bg_mot_points>0
        egomotion_density = num_bg_mot_points/(width*height/bl_size^2);    
        bg_mot_intensity_vec = sqrt(((motion_vec_bg(:,1)./src_win).^2 + ...
                                     (motion_vec_bg(:,2)./src_win).^2 + ...
                                     (motion_vec_bg(:,3)./src_win).^2 + ...
                                     (motion_vec_bg(:,4)./src_win).^2)  ...
                                      ./4.0);
        sum_bg_mot_int = sum(bg_mot_intensity_vec);
        egomotion_intensity = (sum(bg_mot_intensity_vec)/...
                                max_mot_points)^0.25;
        std_egomot_intensity = std(bg_mot_intensity_vec);
        
        % Compute motion position in relation with the screen midpoint
        if sum_bg_mot_int>0
            avg_motp_y = sum(bg_mot_intensity_vec.*motion_vec_bg(:,5))/...
                           sum_bg_mot_int;
            std_motp_y = sqrt(sum(bg_mot_intensity_vec.*...
                           (motion_vec_bg(:,5)-avg_motp_y).^2)/...
                              sum_bg_mot_int);
            avg_mot_pos_y = (avg_motp_y-height/2)/(height/2);
            sprd_mot_pos_y = std_motp_y/height;  
            avg_motp_x = sum(bg_mot_intensity_vec.*motion_vec_bg(:,6))/...
                           sum_bg_mot_int;
            std_motp_x = sqrt(sum(bg_mot_intensity_vec.*...
                           (motion_vec_bg(:,6)-avg_motp_x).^2)/...
                           sum_bg_mot_int);
            avg_mot_pos_x = (avg_motp_x-width/2)/(width/2);
            sprd_mot_pos_x = std_motp_x/width;

            avg_egomot_pos = sqrt(avg_mot_pos_y^2+avg_mot_pos_x^2);  
            avg_egomot_sprd = sqrt(sprd_mot_pos_y^2+sprd_mot_pos_x^2);

            % Average egomotion prediction improvement
            mot_pred_acc_bw = mean(motion_vec_bg(:,7)-motion_vec_bg(:,8));
            mot_pred_acc_fw = mean(motion_vec_bg(:,9)-motion_vec_bg(:,10));
            egomot_pred_acc = 0.5*(mot_pred_acc_bw+mot_pred_acc_fw).^0.5;

            mot_y_bg = mean(0.25.*(motion_vec_bg(:,1)+...
                                   motion_vec_bg(:,3))./src_win+0.5);    
            mot_x_bg = mean(0.25.*(motion_vec_bg(:,2)+...
                                   motion_vec_bg(:,4))./src_win+0.5);        
        end
    end

    mot_size = sum(sum(1-non_mot_area));  
    non_mot_size = sum(sum(non_mot_area));  
    
    % Simple colorfulness
    cr = this_fr(:,:,1);
    cg = this_fr(:,:,2);
    cb = this_fr(:,:,3);   
    clrvec = max([cr(:)'; cb(:)'; cg(:)'])-min([cr(:)'; cb(:)'; cg(:)']);
    clrvec = sort(clrvec(:),'descend');
    colorfulness = mean(mean(clrvec(1:floor(0.1*end))));
   
    static_area_flicker = 0;
    static_area_flicker_std = 0;
    if non_mot_size>0
        % Sum of the pixel differences in the static area
        static_area_flicker_bw = sum(non_mot_area(:) .* ...
                                 abs(this_Y(:)-prev_Y(:)))/non_mot_size;
        static_area_flicker_fw = sum(non_mot_area(:) .* ...
                                 abs(this_Y(:)-next_Y(:)))/non_mot_size;
        static_area_flicker = 0.5*(static_area_flicker_bw + ...
                                   static_area_flicker_fw);
        % Variance of pixel differences in the static area
        st_diff_bw = abs(this_Y(:)-prev_Y(:));
        st_diff_fw = abs(this_Y(:)-next_Y(:));
        static_area_flicker_std = sum(non_mot_area(:)' .* ...
                                  abs(max([st_diff_bw'; st_diff_fw']) - ...
                                  static_area_flicker))/non_mot_size;
    end
    
    % Spatial activity in the static area
    si = std2(sob_tot).^0.25;
    
    %[blur glob_blockiness si]
    
    % Temporal activity standard deviation in the static area
    ti_prev = mean(abs(this_Y(:)-prev_Y(:)));
    ti_next = mean(abs(this_Y(:)-next_Y(:)));
    ti_mean = mean([ti_prev ti_next]).^0.25;
      
    % Normalize static area size
    mot_size = mot_size / (width*height);
 
    % Create feature vector: first ten to be used for difference
    features = [motion_intensity           egomotion_density          ...
                egomotion_intensity        std_mot_intensity          ...
                std_egomot_intensity       avg_mot_pos                ...
                avg_mot_sprd               avg_egomot_pos             ...
                avg_egomot_sprd            mot_pred_acc               ...
                blur                       si                         ...
                interlace                  motion_uncertainty         ...
                glob_blockiness            jerkiness                  ...
                jerk_cons                  ti_mean                    ...
                mot_y                      mot_x                      ...
                static_area_flicker        static_area_flicker_std    ...
                mot_y_bg                   mot_x_bg                   ...
                colorfulness               egomot_pred_acc            ...
                motion_density             mot_size                   ];

end    