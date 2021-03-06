clc;
close all;
clear all;

%Este c�digo realiza el entrenamiento SVR para predecir los valores de los
%MOS de Live, usando the C3D features of layer fc6.

% rng('default') %para reproducibilidad de los kernels
%cargando la matriz de datos.
FileName   = 'SVR_data_Qualcomm_Ordered.mat';
FolderName = ...
'C:\Dropbox\Javeriana\current_work\Features_fc6_QualcommDataset_AVIUncompressed\AveragedFeatures_Alldistortions_PerName';
File       = fullfile(FolderName, FileName);
data_C3D_All_Videos_path=load(File);   %


FileName_MOS   = 'qualcommSubjectiveData.mat';
FolderName_MOS = 'C:\Dropbox\Javeriana\current_work';
MOS_data_struct_path       = fullfile(FolderName_MOS, FileName_MOS);
load(MOS_data_struct_path);   %

MOS_Biased=qualcommSubjectiveData.unBiasedMOS;
RAW_data=data_C3D_All_Videos_path.data;


data_C3D_All_Videos = ...
    zscore(RAW_data);

% maximum_number = max(RAW_data(:));
% data_scaled= RAW_data./maximum_number;
% % max(data_scaled(:))
% data_C3D_All_Videos = ...
% reshape(zscore(data_scaled(:)),size(data_scaled,1),size(data_scaled,2));

% Aqui los datos se escalan entre 0 y 1 primero, y luego se hace mean=0 y std=1, despues de
% esto el valor maximo ya cambia (aprox 19).

% max(data_C3D_All_Videos(:))
% std(data_C3D_All_Videos(:))
% mean(data_C3D_All_Videos(:))

Dist_Limits=[36 35 34 34 34 35];
%_________________________________
Training_Percentage=80;%__________
Number_Iterations=10;
Test_Same_Training=0;
%____________________________________

for iteration=1:Number_Iterations
    contador_global=0;
    for distortion_to_random=1:6
        Number_Videos_Per_Distortion = Dist_Limits(distortion_to_random);
        Random_Numbers=randperm(Number_Videos_Per_Distortion);
        for i=1:Number_Videos_Per_Distortion
            random_index=contador_global+ Random_Numbers(i);
            % El contador global es para que sume los videos de otros videos que
            % estaban antes de esa distorsion
            Data_PerDistortion_Random(i+contador_global,:) = data_C3D_All_Videos(random_index,:) ;
            MOS_PerDistortion(i+contador_global)=MOS_Biased(random_index);
            %     data_Random(indice_actual,:)=data_C3D_All_Videos(current_position,:);
            %     MOS_Random(i)=MOS_Biased(current_position);
        end
        contador_global=contador_global+Number_Videos_Per_Distortion;
    end
    %     disp('creating test and training sets');
    %Obtaining videos per each distortion for training
    
    aux5=floor((Training_Percentage/100)*34);
    %     fprintf('For training we are using %d videos from each distortion\n',aux5)
    training_counter=1;
    test_counter=1;
    contador_global=0;
    for current_distortion=1:6
        Number_Videos_Per_Distortion = Dist_Limits(current_distortion);
        for i=1:Number_Videos_Per_Distortion
            if i <=aux5
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
        'HyperparameterOptimizationOptions',struct('UseParallel',1,'MaxObjectiveEvaluations',10));
    
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