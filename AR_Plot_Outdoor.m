clc
close all
clear all
%graficando los resultados para OUTDOOR

%red        DSST
% blue      MCCT
% green     ECO
%black      CCOT k
%magenta    DeepSTRCF m
%cyan     LADCF c

%  o  pristine
%  ^  ExFo
%  h  exposure
%%
plot(-1, 0,'ok','LineWidth',6)
hold on
plot(-1, 0,'^k','LineWidth',6)
plot(-1, 0,'hk','LineWidth',6)
%ECO
plot(0.8219, 0.6198,'og','LineWidth',6)
plot(0.6099, 0.0701,'^g','LineWidth',6)
plot(0.0872, 0.0475,'hg','LineWidth',6)
axis([0.08 1.01 0 0.7])
set(gca,'FontSize',22)
title ('Outdoor environment with exposure and ExFo distortions','FontSize',30,'FontWeight','bold')
hold on
grid minor
xlabel('Robustness','FontSize',30,'FontWeight','bold');
ylabel ('Accuracy','FontSize',30,'FontWeight','bold');

%DSST
plot(0.5553, 0.0332,'or','LineWidth',6)
plot(0.5172, 0.0793,'^r','LineWidth',6)
plot(0.1113,0.0583,'hr','LineWidth',6)
%MCCT
plot(0.8219, 0.5211,'ob','LineWidth',6)
plot(0.848, 0.2459,'^b','LineWidth',6)
plot(0.2314,0.0639,'hb','LineWidth',6)
% CCOT
plot(1, 0.5995,'o','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(0.5172, 0.0822,'^','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(0.1814, 0.0517,'h','Color',[102/255 0/255 102/255],'LineWidth',6)
% DeepSTRCF
plot(1,0.595,'om','LineWidth',6)
plot(0.7192,0.0662,'hm','LineWidth',6)
plot(0.2314,0.065,'^m','LineWidth',6)
% LADCF
plot(0.8219,0.0831,'oc','LineWidth',6)
plot(0.4386,0.0292,'hc','LineWidth',6)
plot(0.2954,0.0607,'^c','LineWidth',6)
%VITAL
plot(1, 0.5986,'o','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(0.5172, 0.0622,'^','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(0.2954, 0.068,'h','Color',[255/255 165/255 0/255],'LineWidth',6)


text(0.5,0.68,'DSST','Color','red','FontSize',24)
text(0.5,0.65,'ECO','Color','green','FontSize',24)
text(0.5,0.62,'MCCT','Color','blue','FontSize',24)
text(0.5,0.59,'CCOT','Color',[102/255 0/255 102/255],'FontSize',24)
text(0.5,0.56,'DeepSTRCF','Color','magenta','FontSize',24)
text(0.5,0.53,'VITAL','Color',[255/255 165/255 0/255],'FontSize',24)
text(0.5,0.50,'LADCF','Color','cyan','FontSize',24)


lgd=legend ({'Pristine', 'ExFo','Exposure'});
lgd.FontSize = 24;
set(lgd,'location','best')