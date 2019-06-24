clc;
close all;
clear all;

%Este código entrena un SVR con los videos de QUALCOMM-LIVE dataset. Usamos una función que
%previamente genera y ordena cada uno de los videos por distorsión, de manera aleatoria dejando 28
%videos para entrenamiento y el resto para prueba. Esto se ejecuta en cada una de las iteracciones
%del servidor. No se guardan archivos .mat, solo se leen los que se tienen guardados con las
%caracteristicas extraidas de C3D. Se pueden activar o desactivar distorsiones en los parámetros de
%entrada, si se quiere desactivar se le coloca un cero. Si se quiere probar el funcionamiento del
%regresor, se le puede ingresar como conjunto de prueba el mismo conjunto de entrenamiento, esto se
%hace colocando en 1 Test_Same_training. La matriz de entrenamiento se va haciendo grande a medida
%que se generan los vectores por video aleatorio para cada distorsion, esta se une a la matriz que
%tiene todos los videos ya anteriormente conseguidos.

%This code only uses one video per scene. In this way, there 36 videos for training and 18 videos
%for test.

%Añadiendo a la ruta la carpeta donde se encuentran los datos
% addpath('C:\Dropbox\Ubuntu\Features_fc6_Avance8Frames_YCbCr\Features_Per_Distortion_1Matrix_DataMOS_UniqueScene');
addpath('C:\Dropbox\Ubuntu\Features_fc6_Avance8Frames_YCbCr\Features_Per_Distortion_1Matrix_DataMOS');
addpath('C:\Dropbox\git');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Test_Same_Training= 0
Number_Iterations=100;
VideosTraining_PerDistortion= 28; %el número de videos que se usara para Training por cada distorsion

%Si se quiere entrenar con todos los videos de los 4 devices per scene, debe cambiarse el nombre
%correspondiente del .mat que contiene the C3D features

Stabilization   =1;
Focus           =1;
Artifacts       =1;
Sharpness       =1;
Exposure        =0;
Color           =0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
%Obteniendo los conjuntos de training and test for all distortions.

for iteration=1:Number_Iterations
    %Stabilization
    tic
    TrainingData_50FeaturesPerVideo=[];
    TestData_50FeaturesPerVideo =[];
    TrainingMOS_50FeaturesPerVideo=[];
    TestMOS_50FeaturesPerVideo =[];
    if Stabilization ==1
        [Training_Data_Stabilization,Test_Data_Stabilization,Training_MOS_Stabilization,...
            Test_MOS_Stabilization] = ...
            divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Stabilization.mat',...
            'MOS_fc6_Overlap8_YCbCr_Stabilization.mat',VideosTraining_PerDistortion);
        
        %En estos ciclos for es que se extraen cada una de las caracteristicas de los videos de
        %entrenamiento seleccionados y se forma una solo matriz con ellas, que se une a la matriz de
        %entrenamiento. Ademas se replica el MOS para cada una de las caracteristicas de los videos,
        %de esta
        %manera todas las C3D feature vector de un mismo video van a tener el mismo MOS.
        for i=1:size(Training_Data_Stabilization,1)
            indice= 1+(50*(i-1));
            Training_Data_Stabilization_50Vectors(indice:indice+49,:)=...
                squeeze(Training_Data_Stabilization(i,:,:));
            Training_MOS_Stabilization_50Vectors(indice:indice+49,1)=Training_MOS_Stabilization(i);
        end
        
        for i=1:size(Test_Data_Stabilization,1)
            indice= 1+(50*(i-1));
            Test_Data_Stabilization_50Vectors(indice:indice+49,:)=...
                squeeze(Test_Data_Stabilization(i,:,:));
            Test_MOS_Stabilization_50Vectors(indice:indice+49,1)=Test_MOS_Stabilization(i);
        end
        
        TrainingData_50FeaturesPerVideo =...
            [Training_Data_Stabilization_50Vectors];
        
        TestData_50FeaturesPerVideo =...
            [Test_Data_Stabilization_50Vectors];
        
        TrainingMOS_50FeaturesPerVideo = ...
            [Training_MOS_Stabilization_50Vectors];
        
        TestMOS_50FeaturesPerVideo =...
            [Test_MOS_Stabilization_50Vectors];
    end
    %Focus
    if Focus ==1
        [ Training_Data_Focus,Test_Data_Focus,Training_MOS_Focus,Test_MOS_Focus] = ...
            divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_focus.mat',...
            'MOS_fc6_Overlap8_YCbCr_focus.mat',VideosTraining_PerDistortion);
        
        for i=1:size(Training_Data_Focus,1)
            indice= 1+(50*(i-1));
            Training_Data_Focus_50Vectors(indice:indice+49,:)=squeeze(Training_Data_Focus(i,:,:));
            Training_MOS_Focus_50Vectors(indice:indice+49,1)=Training_MOS_Focus(i);
        end
        
        for i=1:size(Test_Data_Focus,1)
            indice= 1+(50*(i-1));
            Test_Data_Focus_50Vectors(indice:indice+49,:)=squeeze(Test_Data_Focus(i,:,:));
            Test_MOS_Focus_50Vectors(indice:indice+49,1)=Test_MOS_Focus(i);
        end
        
        
        
        %Uniendo las matrices de todas las distorsiones
        TrainingData_50FeaturesPerVideo =...
            [TrainingData_50FeaturesPerVideo;Training_Data_Focus_50Vectors];
        
        TestData_50FeaturesPerVideo =...
            [TestData_50FeaturesPerVideo;Test_Data_Focus_50Vectors];
        
        TrainingMOS_50FeaturesPerVideo =...
            [TrainingMOS_50FeaturesPerVideo;Training_MOS_Focus_50Vectors];
        
        TestMOS_50FeaturesPerVideo =...
            [TestMOS_50FeaturesPerVideo;Test_MOS_Focus_50Vectors];
    end
    
    %artifacts
    
    if Artifacts ==1
        [ Training_Data_Artifacts,Test_Data_Artifacts,Training_MOS_Artifacts,Test_MOS_Artifacts] = ...
            divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Artifacts.mat',...
            'MOS_fc6_Overlap8_YCbCr_Artifacts.mat',VideosTraining_PerDistortion);
        
        for i=1:size(Training_Data_Artifacts,1)
            indice= 1+(50*(i-1));
            Training_Data_Artifacts_50Vectors(indice:indice+49,:)=...
                squeeze(Training_Data_Artifacts(i,:,:));
            Training_MOS_Artifacts_50Vectors(indice:indice+49,1)=Training_MOS_Artifacts(i);
        end
        
        for i=1:size(Test_Data_Artifacts,1)
            indice= 1+(50*(i-1));
            Test_Data_Artifacts_50Vectors(indice:indice+49,:)=squeeze(Test_Data_Artifacts(i,:,:));
            Test_MOS_Artifacts_50Vectors(indice:indice+49,1)=Test_MOS_Artifacts(i);
        end
        
        
        %Uniendo las matrices de todas las distorsiones
        TrainingData_50FeaturesPerVideo =...
            [TrainingData_50FeaturesPerVideo;Training_Data_Artifacts_50Vectors];
        
        TestData_50FeaturesPerVideo =...
            [TestData_50FeaturesPerVideo;Test_Data_Artifacts_50Vectors];
        
        TrainingMOS_50FeaturesPerVideo =...
            [TrainingMOS_50FeaturesPerVideo;Training_MOS_Artifacts_50Vectors];
        
        TestMOS_50FeaturesPerVideo =...
            [TestMOS_50FeaturesPerVideo;Test_MOS_Artifacts_50Vectors];
    end
    
    
    
    %Sharpness
    
    if Sharpness ==1
        [ Training_Data_Sharpness,Test_Data_Sharpness,Training_MOS_Sharpness,Test_MOS_Sharpness] = ...
            divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Sharpness.mat',...
            'MOS_fc6_Overlap8_YCbCr_Sharpness.mat',VideosTraining_PerDistortion);
        
        for i=1:size(Training_Data_Sharpness,1)
            indice= 1+(50*(i-1));
            Training_Data_Sharpness_50Vectors(indice:indice+49,:)=...
                squeeze(Training_Data_Sharpness(i,:,:));
            Training_MOS_Sharpness_50Vectors(indice:indice+49,1)=Training_MOS_Sharpness(i);
        end
        
        for i=1:size(Test_Data_Sharpness,1)
            indice= 1+(50*(i-1));
            Test_Data_Sharpness_50Vectors(indice:indice+49,:)=squeeze(Test_Data_Sharpness(i,:,:));
            Test_MOS_Sharpness_50Vectors(indice:indice+49,1)=Test_MOS_Sharpness(i);
        end
        
        
        %Uniendo las matrices de todas las distorsiones
        TrainingData_50FeaturesPerVideo =...
            [TrainingData_50FeaturesPerVideo;Training_Data_Sharpness_50Vectors];
        
        TestData_50FeaturesPerVideo =...
            [TestData_50FeaturesPerVideo;Test_Data_Sharpness_50Vectors];
        
        TrainingMOS_50FeaturesPerVideo =...
            [TrainingMOS_50FeaturesPerVideo;Training_MOS_Sharpness_50Vectors];
        
        TestMOS_50FeaturesPerVideo =...
            [TestMOS_50FeaturesPerVideo;Test_MOS_Sharpness_50Vectors];
        
    end
    
    
    %Exposure
    
    if Exposure ==1
        [ Training_Data_Exposure,Test_Data_Exposure,Training_MOS_Exposure,Test_MOS_Exposure] = ...
            divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Sharpness_UniqueScene.mat',...
            'MOS_fc6_Overlap8_YCbCr_Sharpness_UniqueScene.mat',VideosTraining_PerDistortion);
        
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
    end
    
    
    %Color
    if Color ==1
        [ Training_Data_Color,Test_Data_Color,Training_MOS_Color,Test_MOS_Color] = ...
            divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Sharpness_UniqueScene.mat',...
            'MOS_fc6_Overlap8_YCbCr_Sharpness_UniqueScene.mat',VideosTraining_PerDistortion);
        
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
    end
    
    %% TRAINING SVR
    %tiene configuracion ya para no mostrar la grafica luego de cada iteration 'Showplots' false
    Mdl=fitrsvm(TrainingData_50FeaturesPerVideo,TrainingMOS_50FeaturesPerVideo,'Standardize',false,...
        'OptimizeHyperparameters',...
        {'BoxConstraint', 'Epsilon', 'KernelFunction'},...
        'CacheSize','maximal',...
        'HyperparameterOptimizationOptions',struct('UseParallel',1,'MaxObjectiveEvaluations',10,...
        'ShowPlots',false));
    if Test_Same_Training== 1
        %To test with all distortions
        TestData_AveragedFeaturesPerVideo=TrainingData_AveragedFeaturesPerVideo;
        TestMOS_AveragedFeaturesPerVideo= TrainingMOS_AveragedFeaturesPerVideo;
    end
    
    yfit= predict(Mdl,TestData_50FeaturesPerVideo);
    
    R = corrcoef(yfit,TestMOS_50FeaturesPerVideo);
    Pearson(iteration)=R(1,2)
    Spearman(iteration)=corr(yfit,TestMOS_50FeaturesPerVideo,'Type','Spearman')
    iteration;
    fprintf('Iteration %d\n',iteration);
    toc
end
toc
fprintf('Pearson = %.4f +- %.4f\nSpearman = %.4f +- %.4f\n',...
    nanmedian(Spearman),nanstd(Spearman),nanmedian(Pearson),nanstd(Pearson));
toc



%  Exposure

%Color
