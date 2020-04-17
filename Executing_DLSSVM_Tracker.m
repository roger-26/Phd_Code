clc;
close all
clear all
addpath('C:\Dropbox\git') 

path_video = ...
'C:\Users\DeepLearning_PUJ\Downloads\DSVD_test_Sequences\049ExFo_OutFIG_FQ_C3'
[filepath,video,ext] = fileparts(path_video); %extract the video name
%% Reading GT from a txt file
fileID = fopen(strcat(path_video,'\groundtruth_rect.txt'),'r');
A = textscan(fileID,'%f %f %f %f','Delimiter',',');
fclose(fileID);
GT(:,1)=A{1,1};
GT(:,2)=A{1,2};
GT(:,3)=A{1,3};
GT(:,4)=A{1,4};
Bounding_Box_Initial = GT(1,:)
length_sequence = size(GT,1);
%% Execution of tracker DLSSVM
%executing tracker without scale change
% [res, outv] = tracker(strcat(path_video,'\img'),'jpg',true,Bounding_Box_Initial);

%version with scale adapting
res= tracker_scale(strcat(path_video,'\img'),'jpg',true,Bounding_Box_Initial,1,length_sequence,0);
%% performance measures
BB_tracker = res.res;
name_video = video;
resolution_plot =0.01;
[AUC1, successRate] = success_plot(GT,BB_tracker,name_video,resolution_plot)

hold on;

plot(successRate,0.01:0.01:1,'r','LineWidth',3)
legend('with scaling','No scale');

