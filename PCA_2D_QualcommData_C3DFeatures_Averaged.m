clc;
close all;
clear all;

%Author Roger Gomez Nieto
% Date   June 27 - 2019

%This code calculates the PCA of set of C3D Features for LIVE QUalcomm Dataset


%Se debe añadir la ruta de la carpeta donde estan las caracteristicas guardadas. estas se generan
%con la funcion AssignMOS_EachFeatureVector_Create3DArray. QUeda una matriz para DATA y otra para
%los MOS. Aunque las de los MOS no se usa para el PCA


% addpath...
%     ('C:\Dropbox\Ubuntu\Features_fc6_Avance8Frames_YCbCr\Features_Per_Distortion_1Matrix_DataMOS');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
addpath...
    ('C:\Dropbox\Ubuntu\Features_fc6_Avance16Frames_YCbCr\Features_PerDistortion_YCbCr16Frames_1Matrix');

% addpath('/home/javeriana/Dropbox/Ubuntu/Features_conv5b_Avance8Frames/Features_Per_Distortion_1Matrix_DataMOS_Conv5b_RGB/');


addpath('C:\Dropbox\git');



Stabilization   =1;
Focus           =1;
Artifacts       =1;
Sharpness       =1;
Exposure        =1;
Color           =1;
VideosTraining_PerDistortion=28;
%Cuales dimensiones del PCA se van a mostrar
dimension1=1;
dimension2=2;
% cuantas componentes de PCA se van a calcular
Number_Of_Components=2;
%Obteniendo los conjuntos de training and test for all distortions.
commonName_DataMat='DATA_fc6_Advance16Frames_YCbCr_';
commonName_MOSMat = 'MOS_fc6_Advance16Frames_YCbCr_';

%_fc6_Advance16Frames_YCbCr_

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Number_Of_Videos=0;

    %Stabilization
    tic
    TrainingData_AveragedFeaturesPerVideo=[];
    TestData_AveragedFeaturesPerVideo =[];
    TrainingMOS_AveragedFeaturesPerVideo=[];
    TestMOS_AveragedFeaturesPerVideo =[];
    if Stabilization ==1
        [ Training_Data_Stabilization,Test_Data_Stabilization,Training_MOS_Stabilization,Test_MOS_Stabilization] = ...
            divide_videos_randomly(strcat(commonName_DataMat,'Stabilization.mat'),...
            strcat(commonName_MOSMat,'Stabilization.mat'),...
            VideosTraining_PerDistortion);
        
        %Obteniendo el valor promedio para un video, Se promedian los 50 valores y queda un solo feature
        %vector per video.
        Training_Data_Stabilization_Averaged= squeeze(mean(Training_Data_Stabilization,2));
        Test_Data_Stabilization_Averaged    =   squeeze(mean(Test_Data_Stabilization,2));
        
        TrainingData_AveragedFeaturesPerVideo =...
            [Training_Data_Stabilization_Averaged];
        
        TestData_AveragedFeaturesPerVideo =...
            [Test_Data_Stabilization_Averaged];
        
        TrainingMOS_AveragedFeaturesPerVideo = ...
            [Training_MOS_Stabilization];
        
        TestMOS_AveragedFeaturesPerVideo =...
            [Test_MOS_Stabilization];
        
        %Esta es la parte que genera las etiquetas, dandole un numero segun la distorsion
        %Stabilization le de un 1 y de ahi para abajo incrementalmente
        
        % El vector limites tiene el numero de videos por distorsion. Se usa para graficar cada una
        % de las componentes PCA
        PCA_Data= [TrainingData_AveragedFeaturesPerVideo; TestData_AveragedFeaturesPerVideo];
        Number_Of_Videos=size(PCA_Data,1)+Number_Of_Videos;
        Limites(1) = Number_Of_Videos;
        Labels(1:Number_Of_Videos,1)=1;
    end
    %Focus
    if Focus ==1
        [ Training_Data_Focus,Test_Data_Focus,Training_MOS_Focus,Test_MOS_Focus] = ...
            divide_videos_randomly(strcat(commonName_DataMat,'Focus.mat'),strcat(commonName_MOSMat,'Focus.mat'),...
            VideosTraining_PerDistortion);
        
        %Obteniendo el valor promedio para un video, Se promedian los 50 valores y queda un solo feature
        %vector per video.
        Training_Data_Focus_Averaged= squeeze(mean(Training_Data_Focus,2));
        Test_Data_Focus_Averaged    =   squeeze(mean(Test_Data_Focus,2));
        
        
        
        %Uniendo las matrices de todas las distorsiones
        TrainingData_AveragedFeaturesPerVideo =...
            [TrainingData_AveragedFeaturesPerVideo;Training_Data_Focus_Averaged];
        
        TestData_AveragedFeaturesPerVideo =...
            [TestData_AveragedFeaturesPerVideo;Test_Data_Focus_Averaged];
        
        TrainingMOS_AveragedFeaturesPerVideo =...
            [TrainingMOS_AveragedFeaturesPerVideo;Training_MOS_Focus];
        
        TestMOS_AveragedFeaturesPerVideo =...
            [TestMOS_AveragedFeaturesPerVideo;Test_MOS_Focus];
        
        
        PCA_Data= [TrainingData_AveragedFeaturesPerVideo; TestData_AveragedFeaturesPerVideo];
        Labels(Number_Of_Videos+1:size(PCA_Data,1),1)=2;
        Number_Of_Videos=size(PCA_Data,1);
        Limites(2) = Number_Of_Videos;
        
    end
    
    %artifacts
    
    if Artifacts ==1
        [ Training_Data_Artifacts,Test_Data_Artifacts,Training_MOS_Artifacts,Test_MOS_Artifacts] = ...
            divide_videos_randomly(strcat(commonName_DataMat,'Artifacts.mat'),...
            strcat(commonName_MOSMat,'Artifacts.mat'),...
            VideosTraining_PerDistortion);
        
        %Obteniendo el valor promedio para un video, Se promedian los 50 valores y queda un solo feature
        %vector per video.
        Training_Data_Artifacts_Averaged= squeeze(mean(Training_Data_Artifacts,2));
        Test_Data_Artifacts_Averaged    =   squeeze(mean(Test_Data_Artifacts,2));
        
        
        
        %Uniendo las matrices de todas las distorsiones
        TrainingData_AveragedFeaturesPerVideo =...
            [TrainingData_AveragedFeaturesPerVideo;Training_Data_Artifacts_Averaged];
        
        TestData_AveragedFeaturesPerVideo =...
            [TestData_AveragedFeaturesPerVideo;Test_Data_Artifacts_Averaged];
        
        TrainingMOS_AveragedFeaturesPerVideo =...
            [TrainingMOS_AveragedFeaturesPerVideo;Training_MOS_Artifacts];
        
        TestMOS_AveragedFeaturesPerVideo =...
            [TestMOS_AveragedFeaturesPerVideo;Test_MOS_Artifacts];
        
        PCA_Data= [TrainingData_AveragedFeaturesPerVideo; TestData_AveragedFeaturesPerVideo];
        Labels(Number_Of_Videos+1:size(PCA_Data,1),1)=3;
        Number_Of_Videos=size(PCA_Data,1);
        Limites(3) = Number_Of_Videos;
    end
    
    %Sharpness
    
    if Sharpness ==1
        [ Training_Data_Sharpness,Test_Data_Sharpness,Training_MOS_Sharpness,Test_MOS_Sharpness] = ...
            divide_videos_randomly(strcat(commonName_DataMat,'Sharpness.mat'),........
            strcat(commonName_MOSMat,'Sharpness.mat'),...
            VideosTraining_PerDistortion);
        %Obteniendo el valor promedio para un video, Se promedian los 50 valores y queda un solo feature
        %vector per video.
        Training_Data_Sharpness_Averaged= squeeze(mean(Training_Data_Sharpness,2));
        Test_Data_Sharpness_Averaged    =   squeeze(mean(Test_Data_Sharpness,2));
        
        
        
        %Uniendo las matrices de todas las distorsiones
        TrainingData_AveragedFeaturesPerVideo =...
            [TrainingData_AveragedFeaturesPerVideo;Training_Data_Sharpness_Averaged];
        
        TestData_AveragedFeaturesPerVideo =...
            [TestData_AveragedFeaturesPerVideo;Test_Data_Sharpness_Averaged];
        
        TrainingMOS_AveragedFeaturesPerVideo =...
            [TrainingMOS_AveragedFeaturesPerVideo;Training_MOS_Sharpness];
        
        TestMOS_AveragedFeaturesPerVideo =...
            [TestMOS_AveragedFeaturesPerVideo;Test_MOS_Sharpness];
        
  PCA_Data= [TrainingData_AveragedFeaturesPerVideo; TestData_AveragedFeaturesPerVideo];
        Labels(Number_Of_Videos+1:size(PCA_Data,1),1)=4;
        Number_Of_Videos=size(PCA_Data,1);
        Limites(4) = Number_Of_Videos;
    end
    
    
    %Exposure
    
    if Exposure ==1
        [ Training_Data_Exposure,Test_Data_Exposure,Training_MOS_Exposure,Test_MOS_Exposure] = ...
            divide_videos_randomly(strcat(commonName_DataMat,'Exposure.mat'),...
            strcat(commonName_MOSMat,'Exposure.mat'),...
            VideosTraining_PerDistortion);
        
        %Obteniendo el valor promedio para un video, Se promedian los 50 valores y queda un solo feature
        %vector per video.
        Training_Data_Exposure_Averaged= squeeze(mean(Training_Data_Exposure,2));
        Test_Data_Exposure_Averaged    =   squeeze(mean(Test_Data_Exposure,2));
        
        
        
        %Uniendo las matrices de todas las distorsiones
        TrainingData_AveragedFeaturesPerVideo =...
            [TrainingData_AveragedFeaturesPerVideo;Training_Data_Exposure_Averaged];
        
        TestData_AveragedFeaturesPerVideo =...
            [TestData_AveragedFeaturesPerVideo;Test_Data_Exposure_Averaged];
        
        TrainingMOS_AveragedFeaturesPerVideo =...
            [TrainingMOS_AveragedFeaturesPerVideo;Training_MOS_Exposure];
        
        TestMOS_AveragedFeaturesPerVideo =...
            [TestMOS_AveragedFeaturesPerVideo;Test_MOS_Exposure];
        
        PCA_Data= [TrainingData_AveragedFeaturesPerVideo; TestData_AveragedFeaturesPerVideo];
        Labels(Number_Of_Videos+1:size(PCA_Data,1),1)=5;
        Number_Of_Videos=size(PCA_Data,1);
        Limites(5) = Number_Of_Videos;
    end
    
    
    %Color
    if Color ==1
        [ Training_Data_Color,Test_Data_Color,Training_MOS_Color,Test_MOS_Color] = ...
            divide_videos_randomly(strcat(commonName_DataMat,'Color.mat'),strcat(commonName_MOSMat,'Color.mat'),...
            VideosTraining_PerDistortion);
        %Obteniendo el valor promedio para un video, Se promedian los 50 valores y queda un solo feature
        %vector per video.
        Training_Data_Color_Averaged= squeeze(mean(Training_Data_Color,2));
        Test_Data_Color_Averaged    =   squeeze(mean(Test_Data_Color,2));
        
        
        
        %Uniendo las matrices de todas las distorsiones
        TrainingData_AveragedFeaturesPerVideo =...
            [TrainingData_AveragedFeaturesPerVideo;Training_Data_Color_Averaged];
        
        TestData_AveragedFeaturesPerVideo =...
            [TestData_AveragedFeaturesPerVideo;Test_Data_Color_Averaged];
        
        TrainingMOS_AveragedFeaturesPerVideo =...
            [TrainingMOS_AveragedFeaturesPerVideo;Training_MOS_Color];
        
        TestMOS_AveragedFeaturesPerVideo =...
            [TestMOS_AveragedFeaturesPerVideo;Test_MOS_Color];
        
        PCA_Data= [TrainingData_AveragedFeaturesPerVideo; TestData_AveragedFeaturesPerVideo];
        Labels(Number_Of_Videos+1:size(PCA_Data,1),1)=6;
        Number_Of_Videos=size(PCA_Data,1);
        Limites(6) = Number_Of_Videos;
    end
    
    
    
    
    
%% calculating PCA
close all
%Aqui se puede definir el numero de componentes PCA que se van a calcular


disp('calculating PCA');
[coeff,score,latent,tsquared,explained] = pca(PCA_Data,'NumComponents',Number_Of_Components);



%Plotting Stabilization
figure
scatter(score(1:Limites(1),dimension1),score(1:Limites(1),dimension2),'MarkerFaceColor',[1 1 0])

h=xlabel('1st Principal Component') %or h=get(gca,'xlabel')
set(h, 'FontSize', 20) 
h=ylabel('2nd Principal Component') %or h=get(gca,'xlabel')
set(h, 'FontSize', 20) 
axis equal
hold on
grid on
%plotting focus
scatter(score(Limites(1)+1:Limites(2),dimension1),score(Limites(1)+1:Limites(2),dimension2),...
    'MarkerFaceColor',[0 0 1])
%plotting Artifacts
scatter(score(Limites(2)+1:Limites(3),dimension1),score(Limites(2)+1:Limites(3),dimension2),...
    'MarkerFaceColor',[1 0 0])

%plotting Sharpness
scatter(score(Limites(3)+1:Limites(4),dimension1),score(Limites(3)+1:Limites(4),dimension2),...
    'MarkerFaceColor',[ 0.9412    0.0745    0.7098])

%plotting Exposure
scatter(score(Limites(4)+1:Limites(5),dimension1),score(Limites(4)+1:Limites(5),dimension2),...
    'MarkerFaceColor',[0 .5 .5])


%plotting Color
scatter(score(Limites(5)+1:Limites(6),dimension1),score(Limites(5)+1:Limites(6),dimension2),...
    'MarkerFaceColor',[0 1 1])


title (['PCA 2D (dimensions= ',num2str(dimension1),', ',num2str(dimension2),') fc6 YCbCr 16 Frames Averaged'],'FontSize',22);
lgd=legend({'Stabilization', 'Focus','Artifacts', 'Sharpness', 'Exposure', 'Color'})
lgd.FontSize = 20;

toc


