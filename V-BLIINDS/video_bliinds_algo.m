close all
clear
clc
time_start = tic
%%% Compute Video BLIINDS Features

disp('executing V-BLIINDS');
% load('frames.mat');
ini_fr = 1;
end_fr = 50;

listvideo = {'001Pri_IndPW_FQ_C4'};

% listvideo = {'001Pri_IndPW_FQ_C4','006Exp_IndPW_FQ_C4','020ExFo_IndPW_FQ_C3','034Fo_IndPW_MQ_C4'};
%listvideo = {'003Pri_IndLPP_FQ_C4','009Exp_IndLPP_FQ_C4'};
%listvideo = {'004Pri_IndPR_FQ_C4','007Exp_IndPR_FQ_C4'};
%listvideo = {'005Pri_IndPO_FQ_C4','008Exp_IndPO_FQ_C4_F1'};

for ll = 1:length(listvideo)
    filename = listvideo{ll};
    
    % video_path = ['C:/Users/DeepLearning_PUJ/Downloads/VideoBLIINDS_Code_MicheleSaad/VideoBLIINDS_Code_MicheleSaad/DSVD_test_Sequences/' filename];
    video_path = ['DSVD_test_Sequences/' filename]; % 'DSVD_test_Sequences/001Pri_IndPW_FQ_C4'; % Basketball
    input = ['../' video_path '/img'];
    ext = 'jpg';
    D = dir(fullfile(input, ['*.', ext]));
    file_list = { D.name };
    nfiles = length(file_list);
    frames = [];
    for ii = ini_fr:min([end_fr, nfiles])
        I_orig = imread([input, '/', file_list{ii}]);
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
    disp('calculating temporal variation');
    dt_dc_measure1 = temporal_dc_variation_feature_extraction(frames);
    [dt_dc_measure2, geo_ratio_features] = NSS_spectral_ratios_feature_extraction(frames);
    disp('calculating motion');
    [mean_Coh10x10, G] = motion_feature_extraction(frames);
    
    features_test = [niqe_features log(1+dt_dc_measure1) log(1+dt_dc_measure2) log(1+geo_ratio_features) log(1+mean_Coh10x10) log(1+G)];
    
    %%%
    
    fid = fopen('features_test.txt', 'w+');
    fprintf(fid,'%d ',features_test(1,1:end));
    fprintf(fid,'\n');
    fclose(fid);
    
    system('./predictR.r')
    
    %%% Reading data from a file
    
    predicted_dmos=textread('predicted_dmos.txt')
    save(['results/' filename],'predicted_dmos','features_test')
end
toc (time_start)
