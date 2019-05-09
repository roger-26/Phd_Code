clc;
close all;
clear all;

%Este codigo realiza el entrenamiento SVR para predecir los valores de los
%MOS de Live, usando the C3D features of layer fc6.

% rng('default') %para reproducibilidad de los kernels
%cargando la matriz de datos.
FileName   = 'Data_Videos_UniqueScene_Qualcomm.mat';
FolderName = ...
    'C:\Dropbox\Javeriana\current_work\Features_fc6_QualcommDataset_AVIUncompressed\AveragedFeatures_Alldistortions_PerScene\AllFeatures_ReadySVR_Training';
File       = fullfile(FolderName, FileName);
data_C3D_All_Videos_path=load(File);   %


FileName_MOS   = 'MOS_Videos_UniqueScene_Qualcomm.mat';
MOS_data_struct_path       = fullfile(FolderName, FileName_MOS);
load(MOS_data_struct_path);   %

MOS_UnBiased=MOS_Videos_Folder;
RAW_data=data_C3D_All_Videos_path.data;


data_C3D_All_Videos = ...
    zscore(RAW_data);

Number_VidesPerDistortion_AllVideosUniqueScene=[9 9 10 8 9 9];

VideosPerDistortion_GoingTo_ValidationSet=3;
Validation_Data_Dataset= [data_C3D_All_Videos(1:VideosPerDistortion_GoingTo_ValidationSet,:);...
    data_C3D_All_Videos(10:10+VideosPerDistortion_GoingTo_ValidationSet-1,:);...
    data_C3D_All_Videos(19:19+VideosPerDistortion_GoingTo_ValidationSet-1,:);...
    data_C3D_All_Videos(29:29+VideosPerDistortion_GoingTo_ValidationSet-1,:);...
    data_C3D_All_Videos(37:37+VideosPerDistortion_GoingTo_ValidationSet-1,:);...
    data_C3D_All_Videos(46:46+VideosPerDistortion_GoingTo_ValidationSet-1,:)];

Training_Data_Dataset= [data_C3D_All_Videos(VideosPerDistortion_GoingTo_ValidationSet+1:9,:);...
    data_C3D_All_Videos(10+VideosPerDistortion_GoingTo_ValidationSet:18,:);...
    data_C3D_All_Videos(19+VideosPerDistortion_GoingTo_ValidationSet:28,:);...
    data_C3D_All_Videos(29+VideosPerDistortion_GoingTo_ValidationSet:36,:);...
    data_C3D_All_Videos(37+VideosPerDistortion_GoingTo_ValidationSet:45,:);...
    data_C3D_All_Videos(46+VideosPerDistortion_GoingTo_ValidationSet:end,:)];

Training_MOS_Dataset= [MOS_UnBiased(VideosPerDistortion_GoingTo_ValidationSet+1:9),...
    MOS_UnBiased(10+VideosPerDistortion_GoingTo_ValidationSet:18),...
    MOS_UnBiased(19+VideosPerDistortion_GoingTo_ValidationSet:28),...
    MOS_UnBiased(29+VideosPerDistortion_GoingTo_ValidationSet:36),...
    MOS_UnBiased(37+VideosPerDistortion_GoingTo_ValidationSet:45),...
    MOS_UnBiased(46+VideosPerDistortion_GoingTo_ValidationSet:end)];

Validation_MOS_Dataset= [MOS_UnBiased(1:VideosPerDistortion_GoingTo_ValidationSet),...
    MOS_UnBiased(10:10+VideosPerDistortion_GoingTo_ValidationSet-1),...
    MOS_UnBiased(19:19+VideosPerDistortion_GoingTo_ValidationSet-1),...
    MOS_UnBiased(29:29+VideosPerDistortion_GoingTo_ValidationSet-1),...
    MOS_UnBiased(37:37+VideosPerDistortion_GoingTo_ValidationSet-1),...
    MOS_UnBiased(46:46+VideosPerDistortion_GoingTo_ValidationSet-1),]
Minimum_Number_Videos_InDistortion= 3;

save('Data_UniqueScene_Training_36Vid_Qualcomm','Training_Data_Dataset')
save('MOS_UniqueScene_Training_36Vid_Qualcomm','Training_MOS_Dataset')
%_________________________________
Training_Percentage=80;%__________
Number_Iterations=50;
Test_Same_Training=0;%Se coloca en 1 si se quiere volver a probar con el mismo Training set
%____________________________________
Number_Videos_Per_Distortion = VideosPerDistortion_GoingTo_ValidationSet;%3
for iteration=1:Number_Iterations
    contador_global=0;
    for distortion_to_random=1:6
        
        Random_Numbers=randperm(Number_Videos_Per_Distortion);
        for i=1:Number_Videos_Per_Distortion
            random_index=contador_global+ Random_Numbers(i);
            % El contador global es para que sume los videos de otros videos que
            % estaban antes de esa distorsion
            Data_PerDistortion_Random(i+contador_global,:) = Validation_Data_Dataset(random_index,:) ;
            MOS_PerDistortion(i+contador_global)=Validation_MOS_Dataset(random_index);
            %     data_Random(indice_actual,:)=data_C3D_All_Videos(current_position,:);
            %     MOS_Random(i)=MOS_Biased(current_position);
        end
        contador_global=contador_global+Number_Videos_Per_Distortion;
    end
    %     disp('creating test and training sets');
    %Obtaining videos per each distortion for training
    
    Videos_Used_In_Training=floor((Training_Percentage/100)*Minimum_Number_Videos_InDistortion);
    fprintf('For training we are using %d videos from each distortion\n',Videos_Used_In_Training)
    training_counter=1;
    test_counter=1;
    contador_global=0;
    for current_distortion=1:6
        for i=1:Number_Videos_Per_Distortion
            if i <=Videos_Used_In_Training
                Training_Data(training_counter,:)= Data_PerDistortion_Random(i+contador_global,:);
                MOS_Training(training_counter,:)=MOS_PerDistortion(i+contador_global);
                training_counter=training_counter+1;
            else
                Test_Data(test_counter,:)= Data_PerDistortion_Random(i+contador_global,:);
                MOS_Test(test_counter,:)=MOS_PerDistortion(i+contador_global);
                test_counter=test_counter+1;
            end
        end
        contador_global=contador_global+Number_Videos_Per_Distortion;
    end
    %     disp('training...');
    size_test_set=size(Test_Data);
    size_training_set=size(Training_Data);
    %     fprintf('training videos= %d,   Test Videos = %d \n',size(Training_Data),size_test_set(1));
    
    rng default
    Mdl = fitrsvm(Training_Data,MOS_Training,'Standardize',false,...
        'OptimizeHyperparameters',...
        {'BoxConstraint', 'Epsilon', 'KernelFunction'},...
        'CacheSize','maximal',...
        'HyperparameterOptimizationOptions',struct(...
        'UseParallel',1,'MaxObjectiveEvaluations',50,'ShowPlots',false));
    
    %Genera 1 si el modelo converge
    Convergence_Status= Mdl.ConvergenceInfo.Converged;
    
    %Computing the resubstitution mean squared error for the model.
    lStd = resubLoss(Mdl);
    %Calculating the number of iterations
    iter=Mdl.NumIterations;
    %     fprintf('Model converge= %d, \n resubstitution mean squared error = %d \n Iterations= %d \n',Convergence_Status,...
    %  lStd,iter);
    if Test_Same_Training== 1
        %To test with all distortions
        Test_Data=Training_Data;
        MOS_Test= MOS_Training;
    end
    
    %To test the distortion 1
    %     Test_Data=Test_Data(1:9,:);
    %     MOS_Test= MOS_Test(1:9);
    
    
    yfit= predict(Mdl,Test_Data);
    
    R = corrcoef(yfit,MOS_Test);
    Pearson(iteration)=R(1,2)
    Spearman(iteration)=corr(yfit,MOS_Test,'Type','Spearman')
    iteration;
    fprintf('Iteration %d\n',iteration);
end
%I usa
fprintf('Spearman = %.4f +- %.4f \n Pearson = %.4f +- %.4f\n',...
    nanmedian(Spearman),nanstd(Spearman),nanmedian(Pearson),nanstd(Pearson));