clc;
close all;
clear all;

%This code extract V-BLIINDS features of all mp4 videos in one folder
%Author: Roger Gomez Nieto
%email: rogergomez@ieee.org
%date:  october 21, 2019



cd '/media/javeriana/HDD_4TB/datasets/LIVEVQCPrerelease/LIVEVQCPrerelease/'
%Fetching all names from AVI files in folder
Videos_Inside_Folder = dir('*.mp4');

for i = 1: size(Videos_Inside_Folder,1)/3
    set_name{i} =   Videos_Inside_Folder(i).name;
    set_name2{i} =  Videos_Inside_Folder(i+195).name;
    set_name3{i} =  Videos_Inside_Folder(i+380).name;
end

%guardando los conjuntos de datos para procesarlos de manera separada. 
FilePath='/media/javeriana/HDD_4TB/datasets/LIVEVQCPrerelease/LIVEVQCPrerelease/set1.txt'
fid = fopen(FilePath,'w');
CT = set_name;
fprintf(fid,'%s\n', CT{:});
fclose(fid)

FilePath='/media/javeriana/HDD_4TB/datasets/LIVEVQCPrerelease/LIVEVQCPrerelease/set2.txt'
fid = fopen(FilePath,'w');
CT = set_name2;
fprintf(fid,'%s\n', CT{:});
fclose(fid)


FilePath='/media/javeriana/HDD_4TB/datasets/LIVEVQCPrerelease/LIVEVQCPrerelease/set3.csv'
fid = fopen(FilePath,'w');
CT = set_name3;
fprintf(fid,'%s\n', CT{:});
fclose(fid)