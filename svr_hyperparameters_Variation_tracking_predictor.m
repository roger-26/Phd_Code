function [accval] = svr_hyperparameters_Variation_tracking_predictor()

%el objetivo de esta función es repetir la variación de los hyperparametros
%del svr que se usa para tracking prediction, y asi encontrar la mediana y
%su std
R = cell(13,1);
cd 'C:\Dropbox\Javeriana\current_work\tracker_prediction'
R{1} = load('DLSSVM/results_videos_pristine_high.mat');
R{1}.c3dendfile = '.mat';
R{2} = load('DLSSVM/results_videos_blur_high.mat');
R{2}.c3dendfile = '_blur_high.mat';
R{3} = load('DLSSVM/results_videos_blur_medium.mat');
R{3}.c3dendfile = '_blur_medium.mat';
R{4} = load('DLSSVM/results_videos_blur_low.mat');
R{4}.c3dendfile = '_blur_low.mat';
R{5} = load('DLSSVM/results_videos_gaussian_high.mat');
R{5}.c3dendfile = '_gaussian_high.mat';
R{6} = load('DLSSVM/results_videos_gaussian_medium.mat');
R{6}.c3dendfile = '_gaussian_medium.mat';
R{7} = load('DLSSVM/results_videos_gaussian_low.mat');
R{7}.c3dendfile = '_gaussian_low.mat';
R{8} = load('DLSSVM/results_videos_mpeg4_high.mat');
R{8}.c3dendfile = '_high_MPEG4.mat';
R{9} = load('DLSSVM/results_videos_mpeg4_medium.mat');
R{9}.c3dendfile = '_medium_MPEG4.mat';
R{10} = load('DLSSVM/results_videos_mpeg4_low.mat');
R{10}.c3dendfile = '_low_MPEG4.mat';
R{11} = load('DLSSVM/results_videos_saltpepper_high.mat');
R{11}.c3dendfile = '_sp_high.mat';
R{12} = load('DLSSVM/results_videos_saltpepper_medium.mat');
R{12}.c3dendfile = '_sp_medium.mat';
R{13} = load('DLSSVM/results_videos_saltpepper_low.mat');
R{13}.c3dendfile = '_sp_low.mat';
nR = length(R);
foldername = 'C3D';
nvideos = 70;
y = zeros(nR*nvideos,1);
X = zeros(nR*nvideos,4096);
for jj = 1:nR
    for ii = 1:nvideos
        try
            F = load([foldername '/video' num2str(ii) R{jj}.c3dendfile]);
            Fv = mean(F.Feature_vect,1);
            X(nvideos*(jj-1)+ii,:) = Fv;
            y(nvideos*(jj-1)+ii) = R{jj}.auc_per(ii);
        catch
            X(nvideos*(jj-1)+ii,:) = nan;
            y(nvideos*(jj-1)+ii) = nan;
        end
    end
end

% Wr = randn(4096,3);
ind = 1:length(y);
ind(isnan(y))=[];
Xo = X;
feat = size(X,2);
feat_p = 128;
A = randn(feat,feat_p);

%Eliminando los NAN
[row, col] = find(isnan(X(:,1)));
y(row)=[];
X(any(isnan(X), 2), :) = [];
%% Implementación Original
% Aqui Jose reduce a 128 features.
X = X*A;
% X = X(ind,:);%ind va hasta 907 videos  creo que esto es para quitar los  NaN
% y = y(ind);
%% Calculating PCA
% [coeff,scoreTrain,~,~,explained,mu] = pca(X);
% sum_explained = 0;
% idx = 0;
% while sum_explained < 99
%     idx = idx + 1;
%     sum_explained = sum_explained + explained(idx);
% end
% idx
% scoreTrain95 = scoreTrain(:,1:idx);
% % Con las primeras 45 componentes tenemos el 95% de toda la variabilidad
% % X1 = pca(X);
% X=scoreTrain95;

%Con el 99% de la variabilidad se mejoran los resultados



%% TSNE
% no_dims = 200; %Number of dimensions to plot TSNE
% initial_dims = 0; %default 30, number of PCA components prior TSNE
% %Larger perplexity causes tsne to use more points as nearest neighbors. Use a larger value of Perplexity for a large
% %dataset. Typical Perplexity values are from 5 to 50.
% perplexity = 160;    %default 30
%
%
% % Set parameters
% disp('calculating TSNE');
% % Run tSNE
% mappedX = tsne(X,'Algorithm','exact','NumDimensions', no_dims,'NumPCAComponents',...
%     initial_dims,'Perplexity', perplexity,'NumPrint',5);
% X=mappedX;

%% Kernel PCA
% idx = isnan(sum(X,2)) ;
% X(idx,:) = [];
%
% data_out = kernelpca_tutorial(X',512);
% X=data_out';
%%
nobj = length(y);
ntr = round(0.6*nobj);
nval = round(0.2*nobj);
ntest = nobj-ntr-nval;
ind = randperm(nobj);
indtrain = ind(1:ntr);
indval = ind((ntr+1):(ntr+nval));
indtest = ind((ntr+nval+1):end);
Xr_train = X(indtrain,:); % *Wr;
Xr_val = X(indval,:);
Xr_test = X(indtest,:); % *Wr;
Yr_train = y(indtrain); % *Wr;
Yr_val = y(indval);
Yr_test = y(indtest); % *Wr;
[~,strain] = sort(Yr_train,'ascend');
[~,sval] = sort(Yr_val,'ascend');
[~,stest] = sort(Yr_test,'ascend');
Xr_train = Xr_train(strain,:);
Xr_val = Xr_val(sval,:);
Xr_test = Xr_test(stest,:);
Yr_train = Yr_train(strain);
Yr_val = Yr_val(sval);
Yr_test = Yr_test(stest);
indtrain = indtrain(strain);
indval = indtrain(sval);
indtest = indtest(stest);
% mdl = fitlm(Xr_train,y(indtrain));
% mdl = fitrsvm(Xr_train,Yr_train,'KernelFunction','rbf','KernelScale',1000);

%% Optimizando hiperparametros del regresor - Roger

mdl = fitrsvm(Xr_train,Yr_train,'Standardize',...
    false,...
    'OptimizeHyperparameters',...
    {'BoxConstraint', 'Epsilon', 'KernelFunction'},...
    'CacheSize','maximal',...
    'HyperparameterOptimizationOptions',struct('UseParallel',1,'MaxObjectiveEvaluations',350,...
    'ShowPlots',false));
%%
ypredval = predict(mdl,Xr_val);
ypredtrain = predict(mdl,Xr_train);

figure
subplot(1,2,1)
hold on
plot(ypredtrain,'r')
plot(Yr_train)
hold off
legend({'Prediction','AUC DLSSVM'},'Location','southeast')
title('Training')

subplot(1,2,2)
hold on
plot(ypredval,'r')
plot(y(indtest))
hold off
legend({'Prediction','AUC DLSSVM'},'Location','southeast')
title('Validation')

lt1 = Yr_train(round(ntr/3));
lt2 = Yr_train(round(ntr*2/3));
Yc_train = (Yr_train>lt1).*(Yr_train<=lt2)+(Yr_train>lt2).*2.*ones(ntr,1);
Yc_val = (Yr_val>lt1).*(Yr_val<=lt2)+(Yr_val>lt2).*2.*ones(nval,1);
Yc_test = (Yr_test>lt1).*(Yr_test<=lt2)+(Yr_test>lt2).*2.*ones(ntest,1);

% mdlc = fitrsvm(Xr_train,Yc_train,'KernelFunction','rbf','KernelScale',50);
mdlc = fitrsvm(Xr_train,Yc_train,'KernelFunction','rbf','KernelScale',50);
ycpredval = predict(mdlc,Xr_val);
lv1 = ycpredval(round(nval/3));
lv2 = ycpredval(round(nval*2/3));
ycpredval = (ycpredval>lv1).*(ycpredval<=lv2)+(ycpredval>lv2).*2.*ones(nval,1);

ycpredtrain = predict(mdlc,Xr_train);

figure
subplot(1,2,1)
hold on
plot(ycpredtrain,'r')
plot(Yc_train)
hold off
legend({'Prediction','AUC DLSSVM'},'Location','southeast')
title('Training')

subplot(1,2,2)
hold on
plot(ycpredval,'r')
plot(Yc_val)
hold off
legend({'Prediction','AUC DLSSVM'},'Location','southeast')
title('Test')


accval= sum(ycpredval==Yc_val)/nval;
disp(['Accuracy: ' num2str(accval)])

%  Fit svm


end
