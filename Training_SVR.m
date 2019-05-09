clc;
close all;
clear all;

%Este código realiza el entrenamiento SVR para predecir los valores de los
%MOS de Live, usando the C3D features of layer fc6. 

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

Percentage_Training=80;
MOS_Biased=qualcommSubjectiveData.unBiasedMOS;
data_C3D_All_Videos=data_C3D_All_Videos_path.data;

%% training SVR
% table1=table(data_C3D_All_Videos,MOS_Biased);
for i1=1:1000
Training=ceil(208*(Percentage_Training/100));
% Testing=120;
Random_Vector=randperm(208);

for i=1:208
    current_position=Random_Vector(i);
    data_Random(i,:)=data_C3D_All_Videos(current_position,:);
    MOS_Random(i)=MOS_Biased(current_position);
end

Training_data = data_Random(1:Training,:);
Training_MOS = MOS_Random(1:Training);

Test_data = data_Random(Training+1:end,:);
Test_MOS = MOS_Random(Training+1:end);

% Test_data=   Training_data;
% Test_MOS = Training_MOS;


% Mdl = fitrlinear(Training_data,Training_MOS);
Mdl = fitrsvm(Training_data,Training_MOS);



%Genera 1 si el modelo converge
% Convergence_Status= Mdl.ConvergenceInfo.Converged;

%Computing the resubstitution mean squared error for the model.
% lStd = resubLoss(Mdl);

%Calculating the number of iterations
% iter=Mdl.NumIterations;



yfit= predict(Mdl,Test_data);
R = corrcoef(yfit,Test_MOS');
Spearman=corr(yfit,Test_MOS','Type','Spearman');
% YFit = predict(Mdl,table1);                                
% scatter(data_C3D_All_Videos,MOS_Biased);                                                   
% hold on                                                
% plot(data_C3D_All_Videos,YFit,'r.')
Spearman_various(i1)=Spearman;
Pearson_various(i1)=R(1,2);
i1
end
median(Spearman_various)
median(Pearson_various)
std(Spearman_various)
std(Pearson_various)