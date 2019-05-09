clc
close all
clear all

%red        DSST
% blue      MCCT
% green     ECO
%black      CCOT k
%magenta    DeepSTRCF m
%cyan     LADCF c


%  o  pristine
%  ^  ExFo
%  h  exposure
%  d  Focus
%%
plot(-1, 0,'ok','LineWidth',6)
hold on
plot(-1, 0,'^k','LineWidth',6)
plot(-1, 0,'hk','LineWidth',6)
plot(-1, 0,'dk','LineWidth',6)

%pristine indoor
plot(1, 0.5716,'og','LineWidth',6)
plot(0.7386, 0.2619,'dg','LineWidth',6)
plot(0.8503, 0.4208,'^g','LineWidth',6)
plot(0.6494, 0.2831,'hg','LineWidth',6)
axis([0.08 1.01 0 0.7])
set(gca,'FontSize',22)
title ('INDOOR','FontSize',30,'FontWeight','bold')


hold on
grid minor
xlabel('Robustness','FontSize',30,'FontWeight','bold');
ylabel ('Accuracy','FontSize',30,'FontWeight','bold');

%DSST
plot(0.6857, 0.209,'or','LineWidth',6)
plot(0.6303,0.0953,'^r','LineWidth',6)
plot(0.8059,0.3689,'hr','LineWidth',6)
plot(0.4029,0.1538,'dr','LineWidth',6)

%MCCT
plot(1, 0.6349,'ob','LineWidth',6)
plot(0.5004,0.1033,'^b','LineWidth',6)
plot(0.8059,0.025,'hb','LineWidth',6)
plot(0.5455,0.1881,'db','LineWidth',6)

%CCOT
plot(1, 0.6138,'o','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(0.7939,0.112,'^','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(0.6494,0.0221,'h','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(1,0.6273,'d','Color',[102/255 0/255 102/255],'LineWidth',6)

%DeepSTRCF
plot(1, 0.5896,'om','LineWidth',6)
plot(0.7939,0.1426,'^m','LineWidth',6)
plot(0.8059,0.02888,'hm','LineWidth',6)
plot(1,0.6333,'dm','LineWidth',6)


%LADCF
plot(1, 0.5601,'oc','LineWidth',6)
plot(0.5004,0.2069,'^c','LineWidth',6)
plot(0.6494,0.0248,'hc','LineWidth',6)
plot(0.5455,0.2074,'dc','LineWidth',6)

%VITAL
plot(1, 0.4902,'o','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(0.6303,0.2258,'^','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(0.5234,0.0248,'h','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(1,0.5097,'d','Color',[255/255 165/255 0/255],'LineWidth',6)



text(0.5,0.68,'DSST','Color','red','FontSize',24)
text(0.5,0.65,'ECO','Color','green','FontSize',24)
text(0.5,0.62,'MCCT','Color','blue','FontSize',24)
text(0.5,0.59,'CCOT','Color',[102/255 0/255 102/255],'FontSize',24)
text(0.5,0.56,'DeepSTRCF','Color','magenta','FontSize',24)
text(0.5,0.53,'VITAL','Color',[255/255 165/255 0/255],'FontSize',24)
text(0.5,0.50,'LADCF','Color','cyan','FontSize',24)


lgd=legend ({'Pristine', 'Focus', 'ExFo','Exposure'});
lgd.FontSize = 28;
set(lgd,'location','best')
