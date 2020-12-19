% function y = Extract_TLVQM_Features_Frame(I,I_next,I_previous)


%% las 3 imágenes deben ser iguales en tamaño
% if size(I) == I_next == I_previous
    
    [rows, columns, numberOfColorChannels] = size(I_orig);
    Number_divisions = 8;
    I=I_orig;
    size_patch = [rows/Number_divisions, columns/Number_divisions];
    for i=1:Number_divisions
        for j=1: Number_divisions
            patch =imcrop(I, [(size_patch(1)*(i-1))+1, (size_patch(2)*(j-1))+1, size_patch(1)*i, size_patch(2)*j]);
        end 
    end
    
    
    
    
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
    
% end
% end