close all
clear all
% video_names={'0314Fo_IndWL_HQ_C1', '0318Fo_IndWL_MQ_C1','0322Fo_IndWL_LQ_C1','0626Fo_IndPPP_LQ_C1','0633Fo_IndPPP_MQ_C1','0641Fo_IndPPP_HQ_C1','0836Fo_IndFG_HQ_C1','0839Fo_IndFG_MQ_C1','0863Fo_IndFG_LQ_C1',...
%     '1010Pri_OutLPP_C1','1044Fo_OutLPP_HQ_C1','1048Fo_OutLPP_MQ_C1','1052Fo_OutLPP_LQ_C1','1221Pri_OutPR_C1','1257Fo_OutPR_HQ_C1',...
%     '1261Fo_OutPR_MQ_C1','1265Fo_OutPR_LQ_C1','1657Pri_OutFG_C1','2430Pri_IndRK_C1','3121Pri_OutPPP_C1','3158Fo_OutPPP_HQ_C1','3162Fo_OutPPP_MQ_C1',...
%     '3166Fo_OutPPP_LQ_C1','3448Pri_IndPW_C1'};
% video_numbers=[314,318,322,626,633,641,836,839,863,1010,1044,1048,1052,1221,1257,1261,1265,1657,2430,3121,3158,3162,3166,3448];
video_numbers=load('C:\Dropbox/Javeriana/current_work/tracker_prediction/Deblurred_Videos/selected_videos2.csv');
opts = detectImportOptions('C:\Dropbox/Javeriana/current_work/tracker_prediction/Deblurred_Videos/selected_videos2.csv');
opts.Delimiter=' ';
opts.DataLines=[1,Inf];
set_deblur_210 = readtable('C:\Dropbox/Javeriana/current_work/tracker_prediction/Deblurred_Videos/selected_videos2.csv',opts);
set_210=set_deblur_210(:,1);
set210=table2cell(set_210);
%esto son los resultados originales de Cesar, hay que cargarlos
 load('C:\Dropbox\Javeriana\current_work\tracker_prediction\Results_Trackers_Original_Videos/RCO_Results.mat');
parfor i=1:size(video_numbers,1)
    [aux1,current_video_name,aux2] = fileparts(set210{i})
    name_result_deblurred=...
        strcat("C:\Dropbox\Javeriana\current_work\tracker_prediction\Deblurred_Videos\results\RCO_tracker_Set210\",current_video_name,...
        "_SRN_Results.txt");
    deblurred_video_results= load(name_result_deblurred);
    GT_name = strcat("C:\Dropbox\Javeriana\datasets\AD-VSD\surveillanceVideosDataset\surveillanceVideosGT\",current_video_name,"_gt.txt");
    GT = load(GT_name);
    end_frame = size(deblurred_video_results,1);
    do_plot=1;
    name_video=strcat(current_video_name," with RCO");
    [AUC_deblurred(i),Success_rate_deblurred(i,:)] = success_plot(deblurred_video_results,GT(1:end_frame,:),name_video,0.01,do_plot,[0.9 0.6 0]);  
    
    tracker_results= trackerTable{video_numbers(i),2};
    end_frame2=size(tracker_results,1);
    [AUC_Original(i),Success_rate_Original(i,:)] = success_plot(tracker_results,GT(1:end_frame2,:),name_video,0.01,do_plot,[0.1 0.8 0]);
    names_videos_set1{i}=current_video_name;
end
% load('G:\Downloads\Results-20210419T193846Z-001\Results\MFT_Results.mat');
figure
x1 = AUC_Original'; x2 = AUC_deblurred';
x = [x1;x2];
g = [ones(size(x1)); 2*ones(size(x2))];
boxplot(x,g)
set(gca,'XTickLabel',{'Original','Deblurred'})
title('AUC  210 set with RCO tracker, distorted and SNR deblurred versions');

figure
f2=mean(Success_rate_deblurred);
original_mean = mean(Success_rate_Original);
plot(f2,'g');
hold on
plot(original_mean,'r')

grid on;
title('Mean Success rate for 210 set with RCO tracker, distorted and SNR deblurred versions');
legend('deblurred video','distorted video');

figure

plot(AUC_deblurred,'ok')
hold on
plot(AUC_Original,'ob')
legend('Roger','Original');
grid on

%% Ordenando las diferencias, para encontrar los mayores cambios en performance con la versión deblurred
ii=1;
resta_AUC=AUC_deblurred-AUC_Original;
%para realizar la grafica de numero de videos vs ganancia en rendimiento
for j=-0.8:0.01:0.8
Cumplen_criterio1 = resta_AUC(:)>j;
Cumplen_criterio(ii) = nnz(Cumplen_criterio1);
ii=ii+1;
end
figure
plot((-0.8:0.01:0.8),Cumplen_criterio)
grid minor;
title('Number of videos that comply with determined Gain in RCO performance')
xlabel('gain in RCO performance with deblurred video');
ylabel('Number of videos with this performance gain');

%sacando los nombres de los videos que cumplen con un determinado umbral
Cumplen_criterio1 = resta_AUC(:)>0.4;
videos_positions=find(Cumplen_criterio1)
for i=1:size(videos_positions,1)
    name_videos_yes_condition(i,:)=names_videos_set1{videos_positions(i)};
end
