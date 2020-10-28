clc;
close all;
DLSSVM_AUC={results_ADVSD.DLSSVM_AUC};
TLVQM_LC_aux={results_ADVSD.TLVQM_LC_AUC};
TLVQM_HC_aux={results_ADVSD.TLVQM_HC_AUC};
TLVQM_aux={results_ADVSD.TLVQM_AUC};
DLSSVM=cell2mat(DLSSVM_AUC);
TLVQM_LC = cell2mat(TLVQM_LC_aux);
TLVQM_HC = cell2mat(TLVQM_HC_aux);
TLVQM = cell2mat(TLVQM_aux);
plot(sort(DLSSVM));
hold on;
plot (sort(TLVQM_LC));
plot (sort(TLVQM_HC));
plot (sort(TLVQM));
DLSSVM_AUC_Total=trapz(sort(DLSSVM))
TLVQM_LC_AUC = trapz(sort(TLVQM_LC));
TLVQM_HC_AUC = trapz(sort(TLVQM_HC));
TLVQM_AUC = trapz(sort(TLVQM));
legend('DLSSVM','TLVQM_LC','TLVQM_HC','TLVQM');
grid minor;
title(['DLSSVM= ',num2str(DLSSVM_AUC_Total),' TLVQMLC=',num2str(TLVQM_LC_AUC),' TLVQMHC=',num2str(TLVQM_HC_AUC)...
    ' TLVQM=',num2str(TLVQM_AUC)]);
axis([0 4475 0 0.85]);
xlabel('Number of Video');
ylabel('AUC');