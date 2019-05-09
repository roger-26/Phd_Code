clc
close all
clear all

%red        DSST
% blue      MCCT
% green     ECO
%black      CCOT k
%magenta    DeepSTRCF m
%cyan     LADCF c
%orange VITAL 

%  o  prowling
%  ^  Person running
%  h  Passing Out
%  d  Leaving Package Person
%%
%ECO 
plot(-1, 0,'ok','LineWidth',6)
hold on
plot(-1, 0,'^k','LineWidth',6)
plot(-1, 0,'hk','LineWidth',6)
plot(-1, 0,'dk','LineWidth',6)


plot(1, 0.5716,'o','Color',[255/255 165/255 0/255]','LineWidth',6)
plot(1, 0.3582,'^g','LineWidth',6)
plot(1, 0.5298,'hg','LineWidth',6)
plot(1, 0.4642,'dg','LineWidth',6)

axis([0.08 1.01 0 0.7])
set(gca,'FontSize',22)
title ('Pristine videos with different activities','FontSize',30,'FontWeight','bold')

grid minor

xlabel('Robustness','FontSize',30,'FontWeight','bold');
ylabel ('Accuracy','FontSize',30,'FontWeight','bold');


%DSST 
plot(0.6857, 0.209,'or','LineWidth',6)
plot(0.2147, 0.0389,'^r','LineWidth',6)
plot(1, 0.5221,'hr','LineWidth',6)
plot(0.7925, 0.1812,'dr','LineWidth',6)

%MCCT 
plot(1, 0.6349,'ob','LineWidth',6)
plot(1, 0.4085,'^b','LineWidth',6)
plot(1, 0.5664,'hb','LineWidth',6)
plot(1, 0.431,'db','LineWidth',6)

%CCOT

plot(1, 0.6138,'o','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(0.4634, 0.0481,'^','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(1, 0.501,'h','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(1, 0.3901,'d','Color',[102/255 0/255 102/255],'LineWidth',6)

%DeepSTRCF
plot(1, 0.5896,'om','LineWidth',6)
plot(0.3916, 0.0475,'^m','LineWidth',6)
plot(1, 0.4979,'hm','LineWidth',6)
plot(1, 0.3756,'dm','LineWidth',6)

%LADCF
plot(1, 0.5601,'oc','LineWidth',6)
plot(0.2147, 0.049,'^c','LineWidth',6)
plot(1, 0.523,'hc','LineWidth',6)
plot(1, 0.3756,'dc','LineWidth',6)

%VITAL

plot(1, 05083,'o','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(1, 0.4293,'^','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(1, 0.6108,'h','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(1, 0.2962,'d','Color',[255/255 165/255 0/255],'LineWidth',6)



text(0.5,0.68,'DSST','Color','red','FontSize',24)
text(0.5,0.65,'ECO','Color','green','FontSize',24)
text(0.5,0.62,'MCCT','Color','blue','FontSize',24)
text(0.5,0.59,'CCOT','Color',[102/255 0/255 102/255],'FontSize',24)
text(0.5,0.56,'DeepSTRCF','Color','magenta','FontSize',24)
text(0.5,0.53,'VITAL','Color',[255/255 165/255 0/255],'FontSize',24)
text(0.5,0.50,'LADCF','Color','cyan','FontSize',24)


lgd=legend ({'Prowling', 'Person running', 'Passing out','Leaving Package'});
lgd.FontSize = 28;
set(lgd,'location','best')

% rect = [0.1, 0.25, .99, .9];
% set(lgd, 'Position', rect)
