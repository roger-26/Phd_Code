%% Graficas las medidas de rendimiento del tracker DLSSVM mejorado con las características de calidad.
% Author: Roger Gomez Nieto
% email: rogergomez@ieee.org
%date: Feb 02- 2021


%%

clc;
close all;
clear all;

%cargar los datos originales de DLSSVM original


results_DLSSVM_Originales = ...
    load('C:\Dropbox\Javeriana\current_work\tracker_prediction\results_ADVSD_DLSSVM_TLVQMVariations_Todos.mat');

results_DLSSVM_Originales= results_DLSSVM_Originales.results_ADVSD;

Set2_40_videos = [274,298,1,3,282,163,903,1011,3245,470,1113,1329,1548,1758,1870,1982,2206,2647,2743,2842,2938,3028,3230,3559,3892,...
    4113,290,314,350,1116,1131,1140,2006,2010,2022,2024,2074,2879,2911,3709];

results_set1=results_DLSSVM_Originales(Set2_40_videos);
%removiendo fields de la struct, para que solo queden los AUC.
fields = {'DLSSVM_BB','DLSSVM_SuccessRate','TLVQM_LC_BB','TLVQM_LC_SuccessRate','TLVQM_HC_BB','TLVQM_HC_SuccessRate','TLVQM_BB',...
    'TLVQM_SuccessRate'};
all_results=rmfield(results_set1,fields);

%cargando los de la otra prueba
aux_results_PCA_test1=...
    load('C:\Dropbox\Javeriana\current_work\tracker_prediction\results_DLSSVM_ADVSD\TLVQM_PCA_Input_allPatches_Videos_Selected.mat');
results_PCA_test1=aux_results_PCA_test1.results_ADVSD(Set2_40_videos);

logaritmo_results = ...
    load('C:\Dropbox\Javeriana\current_work\tracker_prediction\results_DLSSVM_ADVSD\DLSSV_TLVQMPatches_PCA_LOG10Frames_Vigilcali_set1.mat');
results_loga = logaritmo_results.results_ADVSD(Set2_40_videos);

results_PCA_10frames =load(...
    'C:\Dropbox\Javeriana\current_work\tracker_prediction\results_DLSSVM_ADVSD\DLSSV_TLVQMPatches_PCA10Frames_Predator_set1.mat');
results_PCA_10frames=results_PCA_10frames.results_ADVSD(Set2_40_videos(1:30));

results_PCA_10frames_l10 =load(...
    'C:\Dropbox\Javeriana\current_work\tracker_prediction\results_DLSSVM_ADVSD\DLSSV_TLVQMPatches_PCA10Frames_Predator_set1_Last10.mat');
results_PCA_10frames_l10=results_PCA_10frames_l10.results_ADVSD(Set2_40_videos(31:40));
%  results_PCA_10frames2=results_PCA_10frames.TLVQM_AUC;
%% haciendo los boxplots
matrix_results(:,1)=[all_results.DLSSVM_AUC];
matrix_results(:,2)=[all_results.TLVQM_LC_AUC];
matrix_results(:,3)=[all_results.TLVQM_HC_AUC];
matrix_results(:,4)=[all_results.TLVQM_AUC];
matrix_results(:,5)=[results_PCA_test1.TLVQM_AUC];
matrix_results1(:,6)=[results_PCA_10frames.TLVQM_AUC];
matrix_results2(:,1)=[results_PCA_10frames_l10.TLVQM_AUC];
aux1=matrix_results1(:,6);
aux4=results_PCA_10frames.TLVQM_AUC;
aux2=matrix_results2(:,1);
aux3=[aux1;aux2];
aux3(40)=matrix_results(40,5);
matrix_results(:,6)=aux3;
matrix_results(:,7)=[results_loga.TLVQM_AUC];
boxplot(matrix_results,{'DLSSVM','TLVQM_LC','TLVQM_HC','TLVQM','PCA1','1 PCA whole video','Log PCA'})
grid minor