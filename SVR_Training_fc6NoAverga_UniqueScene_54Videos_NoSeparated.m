clc;
close all;
clear all;
tic

%Roger GOmez Nieto  
%Created  May 9, 2019



%Este c�digo realiza el entrenamiento SVR para predecir los valores de los
%MOS de Live, usando the C3D features of layer fc6. Se introducen de manera aleatorio observaciones
%de un mismo video tanto en el conjunto Test como en el conjunto Training. 

% rng('default') %para reproducibilidad de los kernels
%cargando la matriz de datos.
FileName   = 'fc6_UniqueScene_Allvideos_54.mat';
FolderName = ...
    'C:\Dropbox\Javeriana\current_work\Features_fc6_QualcommDataset_AVIUncompressed\SVR_Sets';
File       = fullfile(FolderName, FileName);
data_C3D_All_Videos_path=load(File);   %


FileName_MOS   = 'MOS_fc6_UniqueScene_Allvideos_54.mat';
MOS_data_struct_path       = fullfile(FolderName, FileName_MOS);
load(MOS_data_struct_path);   %

MOS_Biased=MOS_fc6;

RAW_data=data_C3D_All_Videos_path.data;
% data_C3D_All_Videos =zscore(RAW_data);
data_C3D_All_Videos=normalize(RAW_data,'zscore');


%_________________________________
Training_Percentage=80;%__________
Number_Iterations=100;
Test_Same_Training=0; % Si esta en 1 se prueba con el mismo training set
Use_Fitted_Parameters=0;
%____________________________________

aux3=size(data_C3D_All_Videos);
Number_Observations=aux3(1);

for iteration=1:Number_Iterations
    rng('shuffle')
    Random_Numbers=randperm(Number_Observations);
    for i=1:Number_Observations
        random_index=Random_Numbers(i);
        % El contador global es para que sume los videos de otros videos que
        % estaban antes de esa distorsion
        DATA_fc6_UniqueScene_NoAver_random(i,:) = data_C3D_All_Videos(random_index,:) ;
        MOS_fc6_UniqueScene_NoAver_random(i)=MOS_Biased(random_index);
        %     data_Random(indice_actual,:)=data_C3D_All_Videos(current_position,:);
        %     MOS_Random(i)=MOS_Biased(current_position);
    end
    
    %     disp('creating test and training sets');
    %Obtaining videos per each distortion for training
    
    Observations_For_Training=floor((Training_Percentage/100)*Number_Observations);
    %     fprintf('For training we are using %d videos from each distortion\n',aux5)
    training_counter=1;
    test_counter=1;
    for i=1:Number_Observations
        if i <=Observations_For_Training
            Training_Data(training_counter,:)= DATA_fc6_UniqueScene_NoAver_random(i,:);
            MOS_Training(training_counter,:)=MOS_fc6_UniqueScene_NoAver_random(i);
            training_counter=training_counter+1;
        else
            Test_Data(test_counter,:)= DATA_fc6_UniqueScene_NoAver_random(i,:);
            MOS_Test(test_counter,:)=MOS_fc6_UniqueScene_NoAver_random(i);
            test_counter=test_counter+1;
        end
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
    Convergence_Status= Mdl.ConvergenceInfo.Converged
    
    %Computing the resubstitution mean squared error for the model.
    lStd = resubLoss(Mdl)
    %Calculating the number of iterations
    iter=Mdl.NumIterations
    %     fprintf('Model converge= %d, \n resubstitution mean squared error = %d \n Iterations= %d \n',Convergence_Status,...
    %  lStd,iter);
    if Test_Same_Training== 1
        %To test with all distortions
        Test_Data=Training_Data;
        MOS_Test= MOS_Training;
        disp('Testing with training dataset');
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
toc