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

name_MAT_file_data_total='fc6_Qualcomm_and_Pristine_AllVideos_NoAverage_ZNorm.mat';
file_labels='labels_Features_C3D_Qualcomm_OpponFind7.mat';


train_X = load(name_MAT_file_data_total)
train_labels= load(file_labels)

%averaged features
% limite_clase1= 35;%Color
% limite_clase2= 31;% Exposure
% limite_clase3= 33; %Focus
% limite_clase4=33; %Sharpness
% limite_clase5=33;%stabilization
% limite_clase6=33;%artifacts

%all features
% limite_clase1= 970;%Color
% limite_clase2= 866;% Exposure
% limite_clase3= 898; %Focus
% limite_clase4=928; %Sharpness
% limite_clase5=923;%stabilization
% limite_clase6=974;%artifacts


%OpponFind
limite_clase1= ;%Color
limite_clase2= 866;% Exposure
limite_clase3= 898; %Focus
limite_clase4=928; %Sharpness
limite_clase5=923;%stabilization
limite_clase6=974;%artifacts


no_dims = 2; %Number of dimensions to plot TSNE
initial_dims = 50; %default 30, number of PCA components prior TSNE
perplexity = 85;    %default 30

X=train_X.All_data;
labels=train_labels.labels;
% Set parameters
%% TSNE
disp('calculating TSNE');
% Run tSNE
mappedX = tsne(X,'Algorithm','exact','NumDimensions', no_dims,'NumPCAComponents',...
    initial_dims,'Perplexity', perplexity,'NumPrint',5);
% Plot results
gscatter(mappedX(:,1), mappedX(:,2), labels);
title (['tsne Qualcomm Videos with perplexity=',num2str(perplexity),...
    ' PCA =',num2str(initial_dims)],'FontSize',22);
lgd=legend({'Color','Exposure','Focus','Sharpness','Stabilization','Artifacts'})
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

title (['PCA Qualcomm All Videos'],'FontSize',22);
lgd=legend({'Color','Exposure','Focus','Sharpness','Stabilization','Artifacts'})
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
scatter(score(acumulado+1:acumulado+limite_clase2,1),score(acumulado+1:acumulado+limite_clase2,2),...
    'MarkerFaceColor',[.5 .5 .05])
acumulado=acumulado+limite_clase2
scatter(score(acumulado+1:acumulado+limite_clase3,1),score(acumulado+1:acumulado+limite_clase3,2),...
    'MarkerFaceColor',[.75 0 .25])
acumulado=acumulado+limite_clase3
scatter(score(acumulado+1:acumulado+limite_clase4,1),score(acumulado+1:acumulado+limite_clase4,2),...
    'MarkerFaceColor',[0 .5 .5])

acumulado=acumulado+limite_clase4
scatter(score(acumulado+1:acumulado+limite_clase5,1),score(acumulado+1:acumulado+limite_clase5,2),...
    'MarkerFaceColor',[0.250 .15 .5])

acumulado=acumulado+limite_clase5
scatter(score(acumulado+1:acumulado+limite_clase6,1),score(acumulado+1:acumulado+limite_clase6,2),...
    'MarkerFaceColor',[0.99 .75 .5])


title (['PCA 2D Qualcomm All Videos'],'FontSize',22);
lgd=legend({'Color','Exposure','Focus','Sharpness','Stabilization','Artifacts'})
lgd.FontSize = 24;
toc