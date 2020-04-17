clc;
close all
% ExFo_OutFIG_FQ_C3_049.robustness= results.robustness;
% ExFo_OutFIG_FQ_C3_049.accuracy= results.accuracy;
% 
% 
% 
% Exp_OutRK_FQ_C4_046.robustness= results.robustness;
% Exp_OutRK_FQ_C4_046.accuracy= results.accuracy;


%red        ExFo
% blue      Focus
% green     pristine
%naranja      Exp

%o Ind
%^ Out



plot(-1, 0,'ok','LineWidth',6)
hold on
plot(-1, 0,'^k','LineWidth',6)

%001Pri_IndPW_FQ_C4
plot(1, 0.5187,'og','LineWidth',6)
%049ExFo_OutFIG_FQ_C3_results
plot(0.7192, 0.0587,'^r','LineWidth',6)
%046Exp_OutRK_FQ_C4_results
plot(0.1113, 0.0471,'^','Color',[255/255 165/255 0/255],'LineWidth',6)
%043Exp_OutFIG_FQ_C3_results
plot(0.8797, 0.1624,'^','Color',[255/255 165/255 0/255],'LineWidth',6)
%041Pri_OutRK_FQ_C4_results
plot(1, 0.6065,'^g','LineWidth',6)
%034Fo_IndPW_MQ_C4_results
plot(1, 0.5902,'ob','LineWidth',6)
%020ExFo_IndPW_FQ_C3_results
plot(0.6303, 0.3364,'or','LineWidth',6)
%009Exp_IndLPP_FQ_C4_results
plot(1, 0.4673,'o','Color',[255/255 165/255 0/255],'LineWidth',6)
%008Exp_IndPO_FQ_C4_results
plot(1, 0.3004,'o','Color',[255/255 165/255 0/255],'LineWidth',6)
%007Exp_IndPR_FQ_C4_results
plot(1, 0.4369,'o','Color',[255/255 165/255 0/255],'LineWidth',6)
%006Exp_IndPW_FQ_C4_results
plot(1, 0.5818,'o','Color',[255/255 165/255 0/255],'LineWidth',6)
%005Pri_IndPO_FQ_C4_results
plot(1, 0.5046,'og','LineWidth',6)
%004Pri_IndPR_FQ_C4_results
plot(0.2147, 0.1153,'og','LineWidth',6)
%003Pri_IndLPP_FQ_C4_results
plot(1, 0.3994,'og','LineWidth',6)


axis([0 1.01 0 1])
set(gca,'FontSize',22)
title ('Performance of DLSSVM tracker in videos with in-capture distortions','FontSize',30,'FontWeight','bold')
grid minor
xlabel('Robustness','FontSize',30,'FontWeight','bold');
ylabel ('Accuracy','FontSize',30,'FontWeight','bold');

text(0.7,0.8,'ExFo','Color','red','FontSize',24)
text(0.5,0.65,'Pristine','Color','green','FontSize',24)
text(0.5,0.62,'Focus','Color','blue','FontSize',24)
text(0.5,0.59,'Exposure','Color',[255/255 165/255 0/255],'FontSize',24)


lgd=legend ({'Indoor','Outdoor'});
lgd.FontSize = 24;
set(lgd,'location','best')