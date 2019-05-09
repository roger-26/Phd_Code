%% Calculando TSNE
tic
clc;
close all;
clear all;

%Camera1
% train_X = load('Features_C1_NormalizedVideos_AllDistortions.mat');

%% DEFINING USER PARAMETERS
%Remember add to path the folder 'code' in javeriana directory

% name_MAT_file_data_total='Features_C3D_Qualcomm_averaged_AllDistortions.mat';
device_name='Note4';
name_MAT_file_data_total='Features_C3D_Qualcomm_Note4.mat';
file_labels='labels_Features_C3D_Qualcomm_Note4.mat';

auxiliar2=strcat('Qualcomm Videos, device=',device_name);

train_X = load(name_MAT_file_data_total)
train_labels= load(file_labels)

%OpponFind
% limite_clase1= 139;    %Artifacts
% limite_clase2= 168; % Color
% limite_clase3= 112; %Exposure
% limite_clase4= 140;  %Focus
% limite_clase5=  84;  %Sharpness
% limite_clase6= 112;  %Stabilization

%GS5
% limite_clase1= 56;    %Artifacts
% limite_clase2= 84; % Color
% limite_clase3= 84; %Exposure
% limite_clase4= 94;  %Focus
% limite_clase5= 140;  %Sharpness
% limite_clase6= 112;  %Stabilization

% %GS6
% limite_clase1= 224;    %Artifacts
% limite_clase2= 168; % Color
% limite_clase3= 140; %Exposure
% limite_clase4= 168;  %Focus
% limite_clase5= 84;  %Sharpness
% limite_clase6= 112;  %Stabilization

%HTCOneVX
% limite_clase1= 164;    %Artifacts
% limite_clase2= 136; % Color
% limite_clase3= 55; %Exposure
% limite_clase4= 105;  %Focus
% limite_clase5= 60;  %Sharpness
% limite_clase6= 111;  %Stabilization

%iphone5 Este lo dejamos de ultimo porque hay que modificar mucho
% limite_clase1= 164;    %Artifacts
% limite_clase2= 136; % Color
% limite_clase3= 55; %Exposure
% limite_clase4= 105;  %Focus
% limite_clase5= 60;  %Sharpness
% limite_clase6= 111;  %Stabilization

%LGG2
% limite_clase1= 168;  %Artifacts
% limite_clase2= 168;  %Color
% limite_clase3= 112;  %Exposure
% limite_clase4= 140;  %Focus
% limite_clase5= 56;   %Sharpness
% limite_clase6= 112;  %Stabilization

%Nokia
limite_clase1= 28;  %Artifacts
limite_clase2= 56;  %Color
limite_clase3= 28;  %Exposure
limite_clase4= 56;  %Focus
limite_clase5= 84;   %Sharpness
limite_clase6= 84;  %Stabilization

%Note4
limite_clase1= 28;  %Artifacts
limite_clase2= 56;  %Color
limite_clase3= 28;  %Exposure
limite_clase4= 56;  %Focus
limite_clase5= 84;   %Sharpness
limite_clase6= 84;  %Stabilization


no_dims = 2; %Number of dimensions to plot TSNE
initial_dims = 2000; %default 30, number of PCA components prior TSNE
perplexity = 160;    %default 30

X=train_X.All_data;
labels=train_labels.labels;
[number_points y1]=size(X)
% Set parameters
%% TSNE
disp('calculating TSNE');
% Run tSNE
mappedX = tsne(X,'Algorithm','exact','NumDimensions', no_dims,'NumPCAComponents',...
    initial_dims,'Perplexity', perplexity,'NumPrint',5);
% Plot results
gscatter(mappedX(:,1), mappedX(:,2), labels);
title (['tsne ',auxiliar2,' device, with perplexity=',num2str(perplexity),...
    ' PCA =',num2str(initial_dims), ', ',num2str(number_points),' points'],'FontSize',24);
lgd=legend({'Artifacts','Color','Exposure','Focus','Sharpness','Stabilization'})
lgd.FontSize = 24;
grid minor
%% PCA 3D, all classes
disp('calculating PCA 3D');
[coeff,score,latent,tsquared,explained] = pca(X);
% scatter3(score(:,1),score(:,2),score(:,3))
% axis equal

figure
scatter3(score(1:limite_clase1,1),score(1:limite_clase1,2),score(1:limite_clase1,3),...
    'MarkerFaceColor',[0 .75 .75])


h=xlabel('1st Principal Component') %or h=get(gca,'xlabel')
set(h, 'FontSize', 20) 
h=ylabel('2nd Principal Component') %or h=get(gca,'xlabel')
set(h, 'FontSize', 20) 
h=zlabel('3rd Principal Component') %or h=get(gca,'xlabel')
set(h, 'FontSize', 20) 
axis equal
hold on

acumulado=limite_clase1
scatter3(score(acumulado+1:acumulado+limite_clase2,1),score(acumulado+1:acumulado+limite_clase2,2),...
    score(acumulado+1:acumulado+limite_clase2,3),'MarkerFaceColor',[.5 .5 .05])

acumulado=acumulado+limite_clase2
scatter3(score(acumulado+1:acumulado+limite_clase3,1),score(acumulado+1:acumulado+limite_clase3,2),...
    score(acumulado+1:acumulado+limite_clase3,3),'MarkerFaceColor',[.75 0 .25])

acumulado=acumulado+limite_clase3
scatter3(score(acumulado+1:acumulado+limite_clase4,1),score(acumulado+1:acumulado+limite_clase4,2),...
    score(acumulado+1:acumulado+limite_clase4,3),'MarkerFaceColor',[0 .5 .5])

acumulado=acumulado+limite_clase4
scatter3(score(acumulado+1:acumulado+limite_clase5,1),score(acumulado+1:acumulado+limite_clase5,2),...
    score(acumulado+1:acumulado+limite_clase5,3),'MarkerFaceColor',[0.25 .15 .5])

acumulado=acumulado+limite_clase5
scatter3(score(acumulado+1:acumulado+limite_clase6,1),score(acumulado+1:acumulado+limite_clase6,2),...
    score(acumulado+1:acumulado+limite_clase6,3),'MarkerFaceColor',[0.99 .75 .5])

title (['PCA 3-D ',auxiliar2,', ',num2str(number_points),' points'],'FontSize',24);
% title (['PCA Qualcomm All Videos'],'FontSize',22);
lgd=legend({'Artifacts','Color','Exposure','Focus','Sharpness','Stabilization'})
%lgd=legend({'Color','Exposure','Focus','Sharpness','Stabilization','Artifacts'})
lgd.FontSize = 24;

%% PCA 2D all classes
disp('calculating PCA 2D');
figure
scatter(score(1:limite_clase1,1),score(1:limite_clase1,2),'MarkerFaceColor',[0 .75 .75])

h=xlabel('1st Principal Component') %or h=get(gca,'xlabel')
set(h, 'FontSize', 20) 
h=ylabel('2nd Principal Component') %or h=get(gca,'xlabel')
set(h, 'FontSize', 20) 
axis equal
hold on

acumulado=limite_clase1
scatter(score(acumulado+1:acumulado+limite_clase2,1),score(acumulado+1:acumulado+...
    limite_clase2,2),...
    'MarkerFaceColor',[.5 .5 .05])
acumulado=acumulado+limite_clase2
scatter(score(acumulado+1:acumulado+limite_clase3,1),score(acumulado+1:acumulado+...
    limite_clase3,2),...
    'MarkerFaceColor',[.75 0 .25])
acumulado=acumulado+limite_clase3
scatter(score(acumulado+1:acumulado+limite_clase4,1),score(acumulado+1:acumulado+...
    limite_clase4,2),...
    'MarkerFaceColor',[0 .5 .5])

acumulado=acumulado+limite_clase4
scatter(score(acumulado+1:acumulado+limite_clase5,1),score(acumulado+1:acumulado+...
    limite_clase5,2),...
    'MarkerFaceColor',[0.250 .15 .5])

acumulado=acumulado+limite_clase5
scatter(score(acumulado+1:acumulado+limite_clase6,1),score(acumulado+1:acumulado+...
    limite_clase6,2),...
    'MarkerFaceColor',[0.99 .75 .5])

title (['PCA 2-D ',auxiliar2,', ',num2str(number_points),' points'],'FontSize',24);
lgd=legend({'Artifacts','Color','Exposure','Focus','Sharpness','Stabilization'})
lgd.FontSize = 24;
toc