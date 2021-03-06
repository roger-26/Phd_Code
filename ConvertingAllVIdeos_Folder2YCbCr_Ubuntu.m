clc;
close all;
clear all;
tic
%This code converts all AVI files in one folder to YCbCr format. Must be executed in the folder where
%you want to save the videos in MSCN Format. This save the videos in format uncompressed AVI
%Roger Gomez Nieto - Created: June 14 2019
Folder_Containing_Videos = ...
    '/media/javeriana/TOSHIBA_2TB/Dataset/LIVE-Qualcomm/Artifacts/'; 
cd '/media/javeriana/TOSHIBA_2TB/Dataset/LIVE-Qualcomm/Artifacts/'
%Fetching all names from AVI files in folder
Videos_Inside_Folder = dir('*.avi');
cd '/media/javeriana/VISION_EXT/Datasets/LIVE-Qualcomm_ycbcr/Artifacts/'
addpath('/home/javeriana/roger_gomez/Phd_Code/')
%THis is the folder where are the videos in AVI Format. This can be different to folder to save MSCN
%videos 


Number_Of_Videos = length(Videos_Inside_Folder)
for i=1: Number_Of_Videos
    tic
    Current_Video_to_Process=    Videos_Inside_Folder(i).name
    [successful_conversion]=avi2ycbcr(Current_Video_to_Process,Folder_Containing_Videos)
    i
    toc
end
toc