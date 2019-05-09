clc;
close all;
clear all;

%Entreno con los 54 videos (1 por scene) usando default parameters of MATLAB. 
FileName   = 'Data_Videos_UniqueScene_Qualcomm.mat';
FolderName = ...
'C:\Dropbox\Javeriana\current_work\Features_fc6_QualcommDataset_AVIUncompressed\AveragedFeatures_Alldistortions_PerScene\AllFeatures_ReadySVR_Training';
File       = fullfile(FolderName, FileName);
data_C3D_All_Videos_path=load(File);   %


FileName_MOS   = 'MOS_Videos_UniqueScene_Qualcomm.mat';
MOS_data_struct_path       = fullfile(FolderName, FileName_MOS);
load(MOS_data_struct_path);   %

MOS_Biased=MOS_Videos_Folder;
RAW_data=data_C3D_All_Videos_path.data;


% data_C3D_All_Videos = ...
%     zscore(RAW_data);

% maximum_number = max(RAW_data(:));
data_C3D_All_Videos= normalize(RAW_data,'range');

% reshape(zscore(data_scaled(:)),size(data_scaled,1),size(data_scaled,2));

% Aqui los datos se escalan entre 0 y 1 primero, y luego se hace mean=0 y std=1, despues de
% esto el valor maximo ya cambia (aprox 19).
min(data_C3D_All_Videos(:))
max(data_C3D_All_Videos(:))
std(data_C3D_All_Videos(:))
mean(data_C3D_All_Videos(:))

Number_VidesPerDistortion_AllVideosUniqueScene=[9 9 10 8 9 9];
Minimum_Number_Videos_InDistortion= min(Number_VidesPerDistortion_AllVideosUniqueScene(:));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%_________________________________
Training_Percentage=80;%__________
Number_Iterations=1000;
Test_Same_Training=0;
Use_Fitted_Parameters=0;


%____________________________________
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iteration=1:Number_Iterations
    contador_global=0;
    for distortion_to_random=1:6
        Number_Videos_Per_Distortion = Number_VidesPerDistortion_AllVideosUniqueScene(distortion_to_random);
        rng('shuffle')
        Random_Numbers=randperm(Number_Videos_Per_Distortion)
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
    
    aux5=floor((Training_Percentage/100)*Minimum_Number_Videos_InDistortion);
    %     fprintf('For training we are using %d videos from each distortion\n',aux5)
    training_counter=1;
    test_counter=1;
    contador_global=0;
    for current_distortion=1:6
        Number_Videos_Per_Distortion = Number_VidesPerDistortion_AllVideosUniqueScene(current_distortion);
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
    if Use_Fitted_Parameters==1
    Mdl = fitrsvm(Training_Data,MOS_Training,'Standardize',false,...
        'BoxConstraint',Box_Constraint, 'KernelFunction',Kernel_Function,'Epsilon',Epsilon_,...
        'CacheSize','maximal');
        disp('using fitted parameters');
    else
        Mdl = fitrsvm(Training_Data,MOS_Training);
    end
    
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
    MOS_Test
    R = corrcoef(yfit,MOS_Test);
    Pearson(iteration)=R(1,2);
    Spearman(iteration)=corr(yfit,MOS_Test,'Type','Spearman');
    iteration;
    fprintf('Iteration %d\n',iteration);
end
%I usa
fprintf('Spearman = %.4f +- %.4f \n Pearson = %.4f +- %.4f\n',...
    nanmedian(Spearman),nanstd(Spearman),nanmedian(Pearson),nanstd(Pearson));