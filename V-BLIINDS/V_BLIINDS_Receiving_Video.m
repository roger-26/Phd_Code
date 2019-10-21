close all
clear
clc
tic
%%% Compute Video BLIINDS Features

Video = 'C:\Dropbox\Videos\VQC_TOY_short.mp4'
% Video = 'C:\Users\DeepLearning_PUJ\Videos\VQC_TOY_short.mp4'
%loading video
vid1=VideoReader(Video)
Number_Of_Frames=vid1.NumberOfFrames
frames=[];
for ii=1:Number_Of_Frames
    ii
    I_orig =  read(vid1,ii);
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
    I = rgb2gray(Iaux);
    %I = rgb2gray(imread([input, '/', file_list{ii}]));
    % I = imresize(I,[256,256]);
    frames = cat(3,frames,I);
end

niqe_features = compute_niqe_features(frames);
dt_dc_measure1 = temporal_dc_variation_feature_extraction(frames);
[dt_dc_measure2, geo_ratio_features] = NSS_spectral_ratios_feature_extraction(frames);
[mean_Coh10x10, G] = motion_feature_extraction(frames);

features_test = [niqe_features log(1+dt_dc_measure1) log(1+dt_dc_measure2) log(1+geo_ratio_features) log(1+mean_Coh10x10) log(1+G)];
toc;
%% Parte del regresor de V-BLIINDS

% fid = fopen('features_test.txt', 'w+');
% fprintf(fid,'%d ',features_test(1,1:end));
% fprintf(fid,'\n');
% fclose(fid);
% 
% system('./predictR.r')
% %%% Reading data from a file
% predicted_dmos=textread('predicted_dmos.txt')
% save(['results/' filename],'predicted_dmos','features_test')

toc

