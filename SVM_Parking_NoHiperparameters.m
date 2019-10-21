%Roger Gomez Nieto - train SVC with images busy or free lot parking
% october 7 - 2019
clc;
clear all;
close all;
tic
%Reading data
folder = '/home/javeriana/carpeta_roger/librerias/caffe/matlab/demo/';

fullFileName = fullfile(folder, 'features_all.mat');
storedStructure = load(fullFileName);

A_Busy = storedStructure.features_all{1,1}';%3600*4096
A_free = storedStructure.features_all{1,2}';%2550*4096
B_Busy = storedStructure.features_all{1,3}';%4750*4096
B_free = storedStructure.features_all{1,4}';%1600*4096

%uno las matrices de cada conjunto, para que A sea training y B testing
Training_Set    = [A_Busy;A_free];
Test_Set        = [B_Busy;B_free];

%creo una variable tipo celda para guardar las etiquetas
%1 - busy     2 - free
labels_training = zeros(size(Training_Set,1),1);
labels_set      = zeros(size(Test_Set,1),1);
labels_training(1:3600)=1;
labels_training(3601:end)=0;
%
labels_set(1:4750)=1;
labels_set(4751:end)=2;
%% Training SVM
SVMModel = fitcsvm(Training_Set,labels_training,... 
    'KernelFunction','rbf',...
    'KernelScale','auto','Standardize',true,'ClassNames',[1,2]);

%% graficando los resultados de SUport Vectors
sv = SVMModel.SupportVectors;
figure
gscatter(Training_Set(:,1),Training_Set(:,2),labels_training)
hold on
plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)
legend('busy','free','Support Vector')
hold off

%% Generando los coeficientes de correlacion

results = predict(SVMModel,Test_Set);
coeficiente_preliminar = corrcoef(results, labels_set);
Pearson=coeficiente_preliminar(1,2)
results_busy = results(1:3600,:);
results_free = results(3601:end,:);
%1 - busy     2 - free
errors_busy = sum(results_busy(:)==2);
errorpercentage_free = sum(results_free(:)==1);

%disp( 'the free class have an error = ',num2str(final_error_Free));
final_error_claseB = errors_busy / size(A_Busy,1)
final_error_Free = errorpercentage_free / size(A_free,1)
message1 = sprintf('the free class have an error = %d',final_error_Free); 
disp(message1);


toc