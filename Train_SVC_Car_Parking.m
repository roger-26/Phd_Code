%Roger Gomez Nieto - train SVC with images busy or free lot parking
% october 7 - 2019
clc;
clear all;
close all;

%Reading data
folder = '/home/javeriana/carpeta_roger/librerias/caffe/matlab/demo/';

fullFileName = fullfile(folder, 'features_all.mat');
storedStructure = load(fullFileName);

A_Busy = storedStructure.features_all{1,1}';
A_free = storedStructure.features_all{1,2}';
B_Busy = storedStructure.features_all{1,3}';
B_Free = storedStructure.features_all{1,4}';

%% Training SVM
SVMModel = fitcsvm(X,Y,'KernelFunction','rbf',...
    'Standardize',true,'ClassNames',{'busy','free'});