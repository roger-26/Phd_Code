%% Calculando TSNE
tic
clc;
close all;
clear all;

%Camera1
% train_X = load('Features_C1_NormalizedVideos_AllDistortions.mat');

%% DEFINING USER PARAMETERS
%Remember add to path the folder 'code' in javeriana directory
train_X = load('Features_C3D_Qualcomm_averaged_AllDistortions.mat');
train_labels= load('labels_Features_C3D_Qualcomm_averaged_AllDistortions.mat')
limite_clase1= 87;%ExFo
limite_clase2= 177;% Exposure
limite_clase3= 52; %Focus
limite_clase4=47; %Pristine
Camera ='2';
no_dims = 2;
initial_dims = 30; %default 30
perplexity = 30;    %default 30

X=train_X.All_data;
labels=train_labels.labels;
% Set parameters
%% TSNE

% Run tSNE
mappedX = tsne(X, labels, no_dims, initial_dims, perplexity);
% Plot results
gscatter(mappedX(:,1), mappedX(:,2), labels);
title (['tsne Normalized Videos Camera ',Camera,' perplexity=',num2str(perplexity), ' PCA =',num2str(initial_dims)],'FontSize',22);
lgd=legend('ExFo','Exposure','Focus','Pristine')
lgd.FontSize = 24;
toc


%% PCA 3D, all classes
[coeff,score,latent,tsquared,explained] = pca(X);
% scatter3(score(:,1),score(:,2),score(:,3))
% axis equal

figure
scatter3(score(1:limite_clase1,1),score(1:limite_clase1,2),score(1:limite_clase1,3),'MarkerFaceColor',[0 .75 .75])
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
hold on
acumulado=limite_clase1
scatter3(score(acumulado+1:acumulado+limite_clase2,1),score(acumulado+1:acumulado+limite_clase2,2),score(acumulado+1:acumulado+limite_clase2,3),'MarkerFaceColor',[.5 .5 .05])
acumulado=acumulado+limite_clase2
scatter3(score(acumulado+1:acumulado+limite_clase3,1),score(acumulado+1:acumulado+limite_clase3,2),score(acumulado+1:acumulado+limite_clase3,3),'MarkerFaceColor',[.75 0 .25])
acumulado=acumulado+limite_clase3
scatter3(score(acumulado+1:acumulado+limite_clase4,1),score(acumulado+1:acumulado+limite_clase4,2),score(acumulado+1:acumulado+limite_clase4,3),'MarkerFaceColor',[0 .5 .5])
title (['PCA Normalized Videos Camera ',Camera],'FontSize',22);
lgd=legend('ExFo','Exposure','Focus','Pristine')
lgd.FontSize = 24;


%% PCA 2D all classes
figure
scatter(score(1:limite_clase1,1),score(1:limite_clase1,2),'MarkerFaceColor',[0 .75 .75])
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
hold on
acumulado=limite_clase1
scatter(score(acumulado+1:acumulado+limite_clase2,1),score(acumulado+1:acumulado+limite_clase2,2),'MarkerFaceColor',[.5 .5 .05])
acumulado=acumulado+limite_clase2
scatter(score(acumulado+1:acumulado+limite_clase3,1),score(acumulado+1:acumulado+limite_clase3,2),'MarkerFaceColor',[.75 0 .25])
acumulado=acumulado+limite_clase3
scatter(score(acumulado+1:acumulado+limite_clase4,1),score(acumulado+1:acumulado+limite_clase4,2),'MarkerFaceColor',[0 .5 .5])
title (['PCA 2D Normalized Videos Camera ',Camera],'FontSize',22);
lgd=legend('ExFo','Exposure','Focus','Pristine')
lgd.FontSize = 24;

%% PCA pristine vs distortions
figure
limit_AllDistortions_joined= limite_clase1+limite_clase2+limite_clase3
scatter3(score(1:limit_AllDistortions_joined,1),score(1:limit_AllDistortions_joined,2),score(1:limit_AllDistortions_joined,3),'MarkerFaceColor',[0 .75 .75])
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
zlabel('3rd Principal Component')
hold on
scatter3(score(limit_AllDistortions_joined:end,1),score(limit_AllDistortions_joined:end,2),score(limit_AllDistortions_joined:end,3),'MarkerFaceColor',[.5 .5 .05])
title (['PCA Normalized Videos Camera ',Camera,' Pristine vs Distortions'],'FontSize',22);
lgd=legend('All distortions','Pristine')
lgd.FontSize = 24;



%% PCA 2D pristine vs distortions
figure
scatter(score(1:limit_AllDistortions_joined,1),score(1:limit_AllDistortions_joined,2),'MarkerFaceColor',[0 .75 .75])
axis equal
xlabel('1st Principal Component')
ylabel('2nd Principal Component')
hold on
acumulado=limite_clase1
scatter(score(limit_AllDistortions_joined:end,1),score(limit_AllDistortions_joined:end,2),'MarkerFaceColor',[.5 .5 .05])
title (['PCA 2D Normalized Videos Camera ',Camera,', Pristine Vs All distortions'],'FontSize',22);
lgd=legend({'All distortions','Pristine'},'Location','northwest')
lgd.FontSize = 24;