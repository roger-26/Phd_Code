clc;
close all;
clear all;

%Este c�digo entrena un SVR con los videos de QUALCOMM-LIVE dataset. Usamos una funci�n que
%previamente genera y ordena cada uno de los videos por distorsi�n, de manera aleatoria dejando 28
%videos para entrenamiento y el resto para prueba. Esto se ejecuta en cada una de las iteracciones
%del servidor. No se guardan archivos .mat, solo se leen los que se tienen guardados con las
%caracteristicas extraidas de C3D. Se pueden activar o desactivar distorsiones en los par�metros de
%entrada, si se quiere desactivar se le coloca un cero. Si se quiere probar el funcionamiento del
%regresor, se le puede ingresar como conjunto de prueba el mismo conjunto de entrenamiento, esto se
%hace colocando en 1 Test_Same_training. La matriz de entrenamiento se va haciendo grande a medida
%que se generan los vectores por video aleatorio para cada distorsion, esta se une a la matriz que
%tiene todos los videos ya anteriormente conseguidos. 

%A�adiendo a la ruta la carpeta donde se encuentran los datos
% addpath('C:\Dropbox\Ubuntu\Features_fc6_Avance8Frames_YCbCr\Features_Per_Distortion_1Matrix_DataMOS');
addpath('/home/javeriana/Dropbox/Ubuntu/Features_fc6_Avance8Frames_YCbCr/Features_Per_Distortion_1Matrix_DataMOS/');

addpath('/home/javeriana/roger_gomez/Phd_Code/');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Test_Same_Training= 0
Number_Iterations=1000;

Stabilization   =0;
Focus           =1;
Artifacts       =0;
Sharpness       =0;
Exposure        =0;
Color           =0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
%Obteniendo los conjuntos de training and test for all distortions.
for iteration=1:Number_Iterations
    %Stabilization
    tic
    [ Training_Data_Stabilization,Test_Data_Stabilization,Training_MOS_Stabilization,Test_MOS_Stabilization] = ...
    divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Stabilization.mat','MOS_fc6_Overlap8_YCbCr_Stabilization.mat',28);
    
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
    
    %Focus
    if Focus ==1
        [ Training_Data_Focus,Test_Data_Focus,Training_MOS_Focus,Test_MOS_Focus] = ...
            divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_focus.mat','MOS_fc6_Overlap8_YCbCr_focus.mat',28);
        
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
    end
    
    %artifacts
    
     if Artifacts ==1
        [ Training_Data_Artifacts,Test_Data_Artifacts,Training_MOS_Artifacts,Test_MOS_Artifacts] = ...
        divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Artifacts.mat','MOS_fc6_Overlap8_YCbCr_Artifacts.mat',28);
        
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
     end
    
    %Sharpness
    
      if Sharpness ==1
        [ Training_Data_Sharpness,Test_Data_Sharpness,Training_MOS_Sharpness,Test_MOS_Sharpness] = ...
        divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Sharpness.mat','MOS_fc6_Overlap8_YCbCr_Sharpness.mat',28);
        
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
      end
    
     
    %Exposure
    
        if Exposure ==1
        [ Training_Data_Exposure,Test_Data_Exposure,Training_MOS_Exposure,Test_MOS_Exposure] = ...
        divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Sharpness.mat','MOS_fc6_Overlap8_YCbCr_Sharpness.mat',28);
        
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
        divide_videos_randomly('DATA_fc6_Overlap8_YCbCr_Sharpness.mat','MOS_fc6_Overlap8_YCbCr_Sharpness.mat',28);
        
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
    Mdl=fitrsvm(TrainingData_AveragedFeaturesPerVideo,TrainingMOS_AveragedFeaturesPerVideo,'Standardize',false,...
        'OptimizeHyperparameters',...
        {'BoxConstraint', 'Epsilon', 'KernelFunction'},...
        'CacheSize','maximal',...
        'HyperparameterOptimizationOptions',struct('UseParallel',1,'MaxObjectiveEvaluations',10,'ShowPlots',false));
    if Test_Same_Training== 1
        %To test with all distortions
        TestData_AveragedFeaturesPerVideo=TrainingData_AveragedFeaturesPerVideo;
        TestMOS_AveragedFeaturesPerVideo= TrainingMOS_AveragedFeaturesPerVideo;
    end
    
    yfit= predict(Mdl,TestData_AveragedFeaturesPerVideo);
    
    R = corrcoef(yfit,TestMOS_AveragedFeaturesPerVideo);
    Pearson(iteration)=R(1,2)
    Spearman(iteration)=corr(yfit,TestMOS_AveragedFeaturesPerVideo,'Type','Spearman')
    iteration;
    fprintf('Iteration %d\n',iteration);
    toc
end
toc
fprintf('\nPearson = %.4f +- %.4f\nSpearman = %.4f +- %.4f\n',...
    nanmedian(Spearman),nanstd(Spearman),nanmedian(Pearson),nanstd(Pearson));
toc

