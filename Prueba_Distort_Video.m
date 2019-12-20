clc;
close all;
clear all;

Path_Input = '/media/javeriana/HDD_4TB/AppDrivenTracker/videos70/';
Path_Output = '/home/javeriana/Downloads/';
Name_video = 'video21.mp4';
Distortion = 'gaussian';
Level= 'low';

Distort_Video(Path_Input, Path_Output, Name_video, Distortion, Level)