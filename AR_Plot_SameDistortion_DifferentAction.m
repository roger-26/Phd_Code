clc
close all
clear all

%red -- DSST
% blue  MCCT
% green ECO


%  o  prawling
%  ^  Person running
%  h  Passing Out
%  d  Leaving Package Person
%%
%solo para que la leyenda salga en negro
plot(-1, 0,'ok','LineWidth',6)
hold on
plot(-1, 0,'^k','LineWidth',6)
plot(-1, 0,'hk','LineWidth',6)
plot(-1, 0,'dk','LineWidth',6)


%ECO 
plot(0.6494, 0.2831,'og','LineWidth',6)
hold on
plot(0.4541, 0.0352,'^g','LineWidth',6)
plot(1, 0.4999,'hg','LineWidth',6)
plot(0.604, 0.216,'dg','LineWidth',6)

axis([0.08 1.01 0 0.7])
set(gca,'FontSize',22)
title ('Exposure time distortion with different activity','FontSize',30,'FontWeight','bold')
hold on
grid minor
xlabel('Robustness','FontSize',30,'FontWeight','bold');
ylabel ('Accuracy','FontSize',30,'FontWeight','bold');

%DSST 
plot(0.8059, 0.3689,'or','LineWidth',6)
plot(0.2062, 0.035,'^r','LineWidth',6)
plot(1, 0.5233,'hr','LineWidth',6)
plot(1, 0.4359,'dr','LineWidth',6)

%MCCT 
plot(0.8059, 0.025,'ob','LineWidth',6)
plot(0.4541, 0.0374,'^b','LineWidth',6)
plot(0.5738, 0.1996,'hb','LineWidth',6)
plot(1, 0.5604,'db','LineWidth',6)

%CCOT
plot(0.6494, 0.0221,'o','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(0.4541, 0.0349,'^','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(0.7575, 0.0281,'h','Color',[102/255 0/255 102/255],'LineWidth',6)
plot(1, 0.5014,'d','Color',[102/255 0/255 102/255],'LineWidth',6)


% plot(0.6494, 0.0221,'ok','LineWidth',6)
% plot(0.4541, 0.0349,'^k','LineWidth',6)
% plot(0.7575, 0.0281,'hk','LineWidth',6)
% plot(1, 0.5014,'dk','LineWidth',6)

%DeepSTRCF
plot(0.8059, 0.2888,'om','LineWidth',6)
plot(0.4541, 0.0352,'^m','LineWidth',6)
plot(0.3799, 0.3964,'hm','LineWidth',6)
plot(1, 0.4823,'dm','LineWidth',6)

%LADCF
plot(0.6494, 0.0248,'oc','LineWidth',6)
plot(0.2062, 0.0355,'^c','LineWidth',6)
plot(0.7575, 0.0328,'hc','LineWidth',6)
plot(1, 0.4119,'dc','LineWidth',6)

%VITAL
plot(0.5234, 0.2258,'o','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(0.4541, 0.0413,'^','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(0.7575, 0.0289,'h','Color',[255/255 165/255 0/255],'LineWidth',6)
plot(1, 0.32,'d','Color',[255/255 165/255 0/255],'LineWidth',6)



text(0.5,0.68,'DSST','Color','red','FontSize',24)
text(0.5,0.65,'ECO','Color','green','FontSize',24)
text(0.5,0.62,'MCCT','Color','blue','FontSize',24)
text(0.5,0.59,'CCOT','Color',[102/255 0/255 102/255],'FontSize',24)
text(0.5,0.56,'DeepSTRCF','Color','magenta','FontSize',24)
text(0.5,0.53,'VITAL','Color',[255/255 165/255 0/255],'FontSize',24)
text(0.5,0.50,'LADCF','Color','cyan','FontSize',24)


lgd=legend ({'Prowling', 'Person running', 'Passing out','Leaving Package'});
lgd.FontSize = 24;
set(lgd,'location','best')
