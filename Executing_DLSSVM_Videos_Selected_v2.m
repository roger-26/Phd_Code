%Ejecutando el tracker DLSSVM sobre AD-VSD, se introduce el número de los
%videos  que se quieres procesar

%Author: Roger Gomez Nieto
% Date: 19 january 2021


% clear all
clear all
profile on
tStart = tic;
tic
clc
close all
warning('off','all')

%Estas son las rutas que necesita FRIQUEE para funcionar
addpath(genpath('C:\Dropbox\Javeriana\current_work\tracker_prediction\'))
% addpath('C:\Dropbox\git\matlabPyrTools\MEX\');
% addpath('include/');
% addpath('include/C_DIIVINE');
% addpath('src/');
% addpath('data');

cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction\DLSSVM_only_code\mex\compile'

%% parte automatica
%cargando los nombres de todos los videos
name_videos_in_folder =  ...
    load('C:\Dropbox\Javeriana\datasets\AD-VSD\videos_Ad_VSD.mat');
%     load('C:\Dropbox\Javeriana\current_work\tracker_prediction\Test_Videos_Tracking\videos_Ad_VSD_extracted.mat');

%cargando la estructura con los resultados que ya se han obtenido
% load('C:\Dropbox\Javeriana\current_work\tracker_prediction\results_ADVSD_DLSSVM_TLVQMVariations_2507_2750.mat');
% initial_size_results = size(results_ADVSD,2);

%cargando los nombres de todos los videos
% load('E:\datasets\DatasetCS\IEEE Dataport\surveillanceVideosDataset\surveillanceVideos\name_videos_ADVSD.mat');
name_videos = name_videos_in_folder.name_videos;
folder_save_video_frames =...
    'C:\surveillanceVideos_Frames\';
folder_containing_videos =...
    'C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideos\';


name_videos_in_folder=name_videos_in_folder.name_videos;
% tracker_executed ='DLSSVM_Original';
disp_vd = 0;%show image with bounding box
prep=0; %Esto cambia el espacio de color si se coloca en 1
do_plot=0; %para que no haga las graficas del success plot
% i=1;

image_type = 'png';
% videos_to_test = [1,3,163,274,282,298,903,1011];
Set2_40_videos = [1131,1140,2006,2010,2022,2024,2074,2879,2911,3709];
videos_to_test = Set2_40_videos;
for j=1:size(videos_to_test,2)
    
    i=videos_to_test(j);
    %% generando el folder donde esta la carpeta img con las imágenes jpg
    time_start_frame_generation = tic;
    name_current_video = name_videos{i};
    [filepath,name_individual_video,ext] =fileparts(name_videos{i});
    folder_video_individual_frames = strcat(folder_save_video_frames,name_individual_video);
    disp(['generating png frames from video  ',name_current_video]);
    
    save_frames_video2folder(folder_video_individual_frames,folder_containing_videos,name_current_video,image_type);
    
    time_generating_frames = toc(time_start_frame_generation);
    disp(['time generating frames = ',num2str(time_generating_frames)]);
    %%
    %         str1 = strcat...
    %             ('E:\datasets\DatasetCS\IEEE Dataport\surveillanceVideosDataset\surveillanceVideos_Frames\',name_videos_in_folder(i),'\');
    %         video_path=str1{1,1};
    video_path = strcat(folder_video_individual_frames,'\');
    
    path_GT=strcat...
        ('C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideosGT\',name_individual_video,'_gt.txt');
    GT= load(path_GT);
    % GT= load(path_GT{1,1});
    init_rect = GT(1,:);
    %
    %     results_ADVSD(i).video=name_videos_in_folder(i);
    %     disp(results_ADVSD(i).video);
    size_GT = size(GT,1);
    % end_frame = 346;  %number of frames to process
    
    
    %  results = tracker_FRIQUEE([video_path '\img'],'png',disp_vd,init_rect,1,end_frame,prep);
    t1 = datetime('now');
    %% DLSSVM
    
    %                 disp(['DLSSVM ',name_videos_in_folder(i), num2cell(t1)]);
    %                 results = tracker([video_path '\img'],image_type,disp_vd,init_rect,1,size_GT,prep);
    %                 end_frame = size(results.res,1);%frames en los que se pudo calcular el resultado
    %
    %                 tracker_results = results.res;
    %                 results_ADVSD(i).DLSSVM_BB = tracker_results;
    %                 [AUC,Success_rate] = success_plot(tracker_results,GT(1:end_frame,:),name_videos_in_folder(i),0.01,do_plot,[0.9 0.6 0]);
    %                 results_ADVSD(i).DLSSVM_AUC = AUC;
    %                 results_ADVSD(i).DLSSVM_SuccessRate = Success_rate;
    %% TLVQM
    disp(['TLVQM ',name_videos_in_folder(i)]);
    %     disp('calculating TLVQM');
    results_TLVQM = ...
        DLSSV_TLVQMPatches_PCA10Frames...
        ([video_path '\img'],image_type,disp_vd,init_rect,1,size_GT,prep);
    end_frame = size(results_TLVQM.res,1);%frames en los que se pudo calcular el resultado
    results_TLVQM_2 = results_TLVQM.res;
    
    [AUC_TLVQM,Success_rate_TLVQM] = ...
        success_plot(results_TLVQM_2,GT(1:end_frame,:),name_videos_in_folder(i),0.01,do_plot,[0.9 0.6 0]);
    results_ADVSD(i).TLVQM_AUC = AUC_TLVQM;
    results_ADVSD(i).TLVQM_BB = results_TLVQM_2;
    results_ADVSD(i).TLVQM_SuccessRate = Success_rate_TLVQM;
    
    
    %                 %%
    %
    %                 disp(['TLVQM_LC ',name_videos_in_folder(i)]);
    %                 %     disp('calculating TLVQM LC');
    %                 results_TLVQM_LC = ...
    %                     tracker_TLVQM_LC_Features_CropDivided([video_path '\img'],image_type,disp_vd,init_rect,1,size_GT,prep);
    %
    %                 results_TLVQM_LC_2 = results_TLVQM_LC.res;
    %
    %                 [AUC_LC,Success_rate_LC] = success_plot(results_TLVQM_LC_2,GT(1:end_frame,:),name_videos_in_folder(i),0.01,do_plot,[0.9 0.6 0]);
    %                 results_ADVSD(i).TLVQM_LC_AUC = AUC_LC;
    %                 results_ADVSD(i).TLVQM_LC_BB = results_TLVQM_LC_2;
    %                 results_ADVSD(i).TLVQM_LC_SuccessRate = Success_rate_LC;
    %
    %
    %                 %% TLVQM_HC
    %                 disp(['TLVQM_HC ',name_videos_in_folder(i)]);
    %                 %     disp('calculating TLVQM HC');
    %                 results_TLVQM_HC = ...
    %                     tracker_TLVQM_HC_Features_CropDivided([video_path '\img'],image_type,disp_vd,init_rect,1,size_GT,prep);
    %
    %                 results_TLVQM_HC_2 = results_TLVQM_HC.res;
    %
    %                 [AUC_HC,Success_rate_HC] = success_plot(results_TLVQM_HC_2,GT(1:end_frame,:),name_videos_in_folder(i),0.01,do_plot,[0.9 0.6 0]);
    %                 results_ADVSD(i).TLVQM_HC_AUC = AUC_HC;
    %                 results_ADVSD(i).TLVQM_HC_BB = results_TLVQM_HC_2;
    %                 results_ADVSD(i).TLVQM_HC_SuccessRate = Success_rate_HC;
    
    
    
    
    
    
    
    %función para guardar dentro de un parfor
    %         temp4= results_ADVSD;
    %         parsave('C:\Dropbox\Javeriana\current_work\tracker_prediction\results_ADVSD_DLSSVM_TLVQMVariations.mat',temp4);
    %         m=matfile('C:\Dropbox\Javeriana\current_work\tracker_prediction\results_ADVSD_DLSSVM_TLVQMVariations.mat', temp4,'writable',true);
    
    %         save('C:\Dropbox\Javeriana\current_work\tracker_prediction\results_ADVSD_DLSSVM_TLVQMVariations_2507_2750.mat','results_ADVSD')
    
    %
    %     tEnd = toc (tStart)
    %     aux=results_ADVSD;
    %     save_parfor(aux);
    
    %eliminando la carpeta con los frames del video
    %         rmdir(folder_video_individual_frames,'s');
    save('C:\Dropbox\Javeriana\current_work\tracker_prediction\results_DLSSVM_ADVSD\DLSSV_TLVQMPatches_PCA10Frames_Predator_set1_Last10.mat',...
        'results_ADVSD')
end


t_total = toc(tStart)
profile viewer