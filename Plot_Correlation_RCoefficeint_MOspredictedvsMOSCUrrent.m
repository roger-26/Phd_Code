clc;
clear all;
close all;
load('plcc81.mat');

data_Correlationtogether=[TestMOS_AveragedFeaturesPerVideo yfit];

% ans2= corrplot(data_Correlationtogether,'testR','on','rows','pairwise','varNames',...
%      {'MOSDataset','MOSPredicted'},'alpha',0.01)

scatter(TestMOS_AveragedFeaturesPerVideo, yfit,100,'LineWidth',2.5)
grid
set(gca,'FontSize',20)
axis([20 75 20 75])
xlabel('Ground Truth MOS','FontSize',28);
ylabel('predicted MOS','FontSize',28);
h = lsline;
set(h(1),'color','r','LineStyle','--','LineWidth',1.5)
text(60,50,'R^{2} =0.6567','Color','black','FontSize',28)

% ax = gca;
% outerpos = ax.OuterPosition;
% ti = ax.TightInset; 
% left = outerpos(1) + ti(1);
% bottom = outerpos(2) + ti(2);
% ax_width = outerpos(3)-0.2;
% ax_height = outerpos(4)-0.2 ;
% ax.Position = [left bottom ax_width ax_height];