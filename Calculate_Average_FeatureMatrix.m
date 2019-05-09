clc;
close all;
clear all;

%Author: Roger Gomez Nieto
%Date> 28 March 2019
%This code calculate the average of a matrix and save this average as .mat
name='1022_QCOMSoccer2_OppoFind7_VID20150510130154';
loading_data= load(strcat(name,'.mat'));
feature_matrix=loading_data.Feature_vect;
average_features= mean(feature_matrix);
name_average=strcat(name,'_average.mat');
save(name_average,'average_features')
