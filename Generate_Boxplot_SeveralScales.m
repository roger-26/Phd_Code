%codigo usado para extraer boxplot de los experimentos con escala original
%y escalas reducidas del tracker AlphaRephine, en los 140 videos
%seleccionados de set1385K
%Date 25 june 2021

close all;
scale_1_2=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_2_AlphaRefine.csv');
original_scale=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/FHD_AlphaRefine.csv'); 
scale_1_4=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_4_AlphaRefine.csv');
scale_1_5=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_5_AlphaRefine.csv');
scale_1_6=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_6_AlphaRefine.csv');
scale_1_8=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_8_AlphaRefine.csv');
scale_1_10=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_10_AlphaRefine.csv');
scale_1_12=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_12_AlphaRefine.csv');
scale_1_15=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_15_AlphaRefine.csv');
scale_1_16=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_16_AlphaRefine.csv');
scale_1_20=load...
    ('C:\Dropbox\Javeriana\current_work\tracker_prediction\VariacionResolucion_ImpactoTracker\Results\Time_Results/1_20_AlphaRefine.csv');

subplot(431)
boxplot(original_scale)
title(['FHD, median ',num2str(median(original_scale))]);
axis([0.9,1.1,25,65])

subplot(432)
boxplot(scale_1_2)
title(['scale 1-2, median ',num2str(median(scale_1_2))]);
axis([0.9,1.1,25,65])

subplot(433)
boxplot(scale_1_4)
title(['scale 1-4, median ',num2str(median(scale_1_4))]);
axis([0.9,1.1,25,65])

subplot(434)
boxplot(scale_1_5)
title(['scale 1-5, median ',num2str(median(scale_1_5))]);
axis([0.9,1.1,25,65])

subplot(435)
boxplot(scale_1_6)
title(['scale 1-6, median ',num2str(median(scale_1_6))]);
axis([0.9,1.1,25,65])

subplot(436)
boxplot(scale_1_8)
title(['scale 1-8, median ',num2str(median(scale_1_8))]);
axis([0.9,1.1,25,65])

subplot(437)
boxplot(scale_1_10)
title(['scale 1-10, median ',num2str(median(scale_1_10))]);
axis([0.9,1.1,25,65])

subplot(438)
boxplot(scale_1_12)
title(['scale 1-12, median ',num2str(median(scale_1_12))]);
axis([0.9,1.1,25,65])

subplot(439)
boxplot(scale_1_15)
title(['scale 1-15, median ',num2str(median(scale_1_15))]);
axis([0.9,1.1,25,65])

subplot(4,3,10)
boxplot(scale_1_16)
title(['scale 1-16, median ',num2str(median(scale_1_15))]);
axis([0.9,1.1,25,65])

subplot(4,3,11)
boxplot(scale_1_20)
title(['scale 1-20, median ',num2str(median(scale_1_20))]);
axis([0.9,1.1,25,65])