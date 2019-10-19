tic
clc;
close all;
clear all;

img = imread('cameraman.tif');

img2= imread('C:\Users\DeepLearning_PUJ\Downloads\VideoBLIINDS_Code_MicheleSaad\DSVD_test_Sequences\001Pri_IndPW_FQ_C4\img\0001.jpg');
tic
[featureVector,hogVisualization] = extractHOGFeatures(img2);
toc

figure;
imshow(img2); 
hold on;
plot(hogVisualization);
toc