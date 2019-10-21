clc;
close all;


%This code extract V-BLIINDS features of all mp4 videos in one folder
%Author: Roger Gomez Nieto
%email: rogergomez@ieee.org
%date:  october 21, 2019

cd '/media/javeriana/HDD_4TB/datasets/LIVEVQCPrerelease/LIVEVQCPrerelease/'

for i=1:size(set3,1)
    tic
    %reading the video. Se debe cargar de manera manual el set de names de
    %los videos que se van a procesar, abriendolos desde la current folder
    video = set3(i,1);
    video_name= table2cell(video);
    video_listo = char(num2str(video_name{1}))
    vid1=VideoReader(strcat(...
        '/media/javeriana/HDD_4TB/datasets/LIVEVQCPrerelease/LIVEVQCPrerelease/',video_listo))
    %calculating the features

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
end