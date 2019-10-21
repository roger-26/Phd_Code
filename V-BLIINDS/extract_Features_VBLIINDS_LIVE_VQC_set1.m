clc;
close all;
clear all;

%This code extract V-BLIINDS features of all mp4 videos in one folder
%Author: Roger Gomez Nieto
%email: rogergomez@ieee.org
%date:  october 21, 2019

cd '/media/javeriana/HDD_4TB/datasets/LIVEVQCPrerelease/LIVEVQCPrerelease/'
set = readtable('set1.csv','ReadVariableNames',false);


for video_set=1:size(set,1)
    tic
    %reading the video. 
    video = set(video_set,1);
    video_name= table2cell(video);
    video_listo = char(num2str(video_name{1}))
    Videos_Processed{video_set} = video_listo;
    vid1=VideoReader(strcat(...
        '/media/javeriana/HDD_4TB/datasets/LIVEVQCPrerelease/LIVEVQCPrerelease/',video_listo))
    %calculating the features
    
    Number_Of_Frames=vid1.NumberOfFrames 
    frames=[];
    disp('preparing data');
    for ii=1:Number_Of_Frames
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
    disp('computing niqe_features');
    niqe_features = compute_niqe_features(frames);
    disp('calculating dct');
    dt_dc_measure1 = temporal_dc_variation_feature_extraction(frames);
    disp('calculating NSS');
    [dt_dc_measure2, geo_ratio_features] = NSS_spectral_ratios_feature_extraction(frames);
    disp('calculating motion features');
    [mean_Coh10x10, G] = motion_feature_extraction(frames);
    
    features_test(video_set,:) = [niqe_features log(1+dt_dc_measure1) log(1+dt_dc_measure2) log(1+geo_ratio_features) log(1+mean_Coh10x10) log(1+G)];
    save('features_test_set1.mat','features_test');
    save('VideosProccessed_set1.mat','Videos_Processed');
    toc;
end